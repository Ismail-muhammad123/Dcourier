// const { onRequest } = require("firebase-functions/v2/https");
// const logger = require("firebase-functions/logger");

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

import { initializeApp } from "firebase-admin/app";
// import { firestore } from "firebase-admin/firestore";
import { Firestore, getFirestore, Timestamp } from "firebase-admin/firestore";
import { https } from "firebase-functions";
import checkout from "./payments/checkout.js";
import verifyPayment from "./payments/verifyPayment.js";
import { v4 as uuidv4 } from "uuid";
import { PAYMENT_GATEAWAY_SECRET_KEY } from "./payments/constants.js";

import crypto from "crypto";

// import { setGlobalOptions } from "firebase-functions;

// Set the maximum instances to 10 for all functions
// setGlobalOptions({ maxInstances: 10 });

initializeApp();
const firestore = getFirestore();

export const approveCashout = https.onCall(async (data, context) => {
  try {
    const uid = context.auth.uid;
    const ref = data.checkout_id;
    const amount = data.amount;

    const firestoreFirebase = firestore;
    const payoutRequest = firestoreFirebase.collection("checkouts").doc(ref);

    // You can uncomment the following code if you want to fetch and calculate wallet_balance
    const userWalletTransactions = await firestoreFirebase
      .collection("wallet_transactions")
      .where("uid", "==", uid)
      .get();
    let walletBalance = 0;
    userWalletTransactions.forEach((transaction) => {
      walletBalance +=
        transaction.data().credit_amount - transaction.data().debit_amount;
    });

    if (walletBalance >= amount) {
      await firestoreFirebase.collection("wallet_transactions").add({
        credit_amount: 0,
        debit_amount: amount,
        description: `Withdrawal of NGN${amount}`,
        time: Timestamp.now(),
      });

      await payoutRequest.update({
        status: "sent",
        time_sent: Timestamp.now(),
      });

      return { status: "success" };
    } else {
      return { status: "failed" };
    }
  } catch (error) {
    console.error(error);
    return { status: "failed" };
  }
});

export const releaseDeliveryPayment = https.onCall(async (data, context) => {
  try {
    const deliveryId = data.delivery_id;

    const firestoreFirebase = firestore;
    const delivery = await firestoreFirebase
      .collection("jobs")
      .doc(deliveryId)
      .get();

    const batch = firestoreFirebase.batch();
    const transactionsRef = firestoreFirebase.collection("transactions");

    const receiverTransaction = {
      uid: delivery.data().courier_id,
      debit_amount: 0,
      credit_amount: delivery.data().amount,
      time: Timestamp.now(),
      description: `payment for delivery ref:${deliveryId}`,
    };

    batch.create(transactionsRef.doc(), receiverTransaction);

    await batch.commit();
    return { status: "success" };
  } catch (error) {
    console.error(error);
    return { status: "failed" };
  }
});

export const acceptCourierForDelivery = https.onCall(async (data, context) => {
  try {
    const uid = context.auth.uid;
    const deliveryId = String(data.delivery_id);

    // console.log(deliveryId);

    const firestoreFirebase = firestore;
    const delivery = await firestoreFirebase
      .collection("jobs")
      .doc(deliveryId)
      .get();

    // console.log(delivery);

    if (delivery.exists) {
      const transactionObj = {
        uid: uid,
        debit_amount: delivery.data().amount,
        credit_amount: 0,
        time: Timestamp.now(),
        description: `payment for delivery ref:${deliveryId}`,
      };

      firestoreFirebase.collection("transactions").add(transactionObj);
      return { status: "success" };
    } else {
      return {
        status: "failed",
        message: "delivery with given ID not found",
      };
    }
  } catch (error) {
    console.error(error);
    return { status: "failed", message: error };
  }
});

export const initiateCharge = https.onCall(async (data, context) => {
  // const randomChargeUUID = uuidv4();

  try {
    const uid = context.auth.uid;
    const amount = data.amount;

    const firestoreFirebase = firestore;
    const profile = await firestoreFirebase
      .collection("profiles")
      .doc(uid)
      .get();

    const userProfile = profile.data();

    const chargeObject = {
      uid: uid,
      amount: amount,
      initiated_at: Timestamp.now(),
      status: "pending",
    };

    var charge = await firestoreFirebase.collection("charge").add(chargeObject);

    const res = await checkout(
      charge.id,
      uid,
      amount,
      userProfile.full_name,
      userProfile.email,
      userProfile.phone_number
    );

    if (res[1] === false) {
      return { status: "failed", message: "unable to initiate payment" };
      // throw new https.HttpsError("unknown", "Unable to collect payment");
    }

    return {
      status: "success",
      url: res,
    };
  } catch (checkoutException) {
    // console.error(checkoutException);
    return { status: "failed", message: checkoutException };
    // throw new https.HttpsError(
    //   "unknown",
    //   "Failed to fetch user profile",
    //   checkoutException
    // );
  }
});

// webhook
export const verifyCharge = https.onRequest(async (req, res) => {
  const request_data = req.body;

  const hash = crypto
    .createHmac("sha512", PAYMENT_GATEAWAY_SECRET_KEY)
    .update(JSON.stringify(req.body))
    .digest("hex");

  // if request is from paystack
  if (hash == req.headers["x-paystack-signature"]) {
    // Retrieve the request's body
    const event = request_data.event;
    // Do something with event

    // CHARGE SUCCESS WEBHOOK
    if (event == "charge.success") {
      var data = request_data.data;

      const firestoreFirebase = firestore;
      // const { status, data } = verifyPayment(request_data);
      const chargeId = data.metadata.charge_id;
      const amount = data.amount / 100;

      const batch = firestoreFirebase.batch();

      const chargeObject = firestoreFirebase.collection("charge").doc(chargeId);

      const chrgOj = await chargeObject.get();
      const uid = chrgOj.data().uid;

      batch.update(chargeObject, {
        verified_at: Timestamp.now(),
        status: "success",
      });

      // await chargeObject.update();

      batch.set(firestoreFirebase.collection("wallet_transactions").doc(), {
        uid: uid,
        credit_amount: amount,
        debit_amount: 0,
        description: `Wallet Credited with NGN${amount}`,
        time: Timestamp.now(),
      });

      // await firestoreFirebase.collection("wallet_transactions").add();
      await batch.commit();
    }

    res.sendStatus(200);
  }
  res.sendStatus(404);

  // try {

  //   if (status) {
  //     await chargeObject.update({
  //       verified_at: Timestamp.now(),
  //       status: "success",
  //     });

  //     return res.status(200).json({ success: true });
  //   } else {
  //     await chargeObject.update({
  //       verified_at: Timestamp.now(),
  //       status: "failed",
  //     });

  //     return res.status(200).json({ success: false });
  //   }
  // } catch (verificationErr) {
  //   console.error(verificationErr);
  //   // throw new https.HttpsError(
  //   //   "unknown",
  //   //   "Failed to verify payment",
  //   //   verificationErr
  //   // );
  // return res.status(400).json({ success: false });
});
