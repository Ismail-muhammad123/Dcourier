# Welcome to Cloud Functions for Firebase for Python!
# To get started, simply uncomment the below code or create your own.
# Deploy with `firebase deploy`

import firebase_functions
from firebase_functions import https_fn
from firebase_admin import initialize_app, db, firestore
from typing import Any
import json, datetime
import uuid
import payment

initialize_app()
firebase_functions.options.set_global_options(max_instances=10)


@https_fn.on_call()
def release_delivery_payment(req: https_fn.CallableRequest):
    try:
        uid = req.auth.uid
        delivery_id = req.data["delivery_id"]

    except Exception as e:
        # Re-throwing the error as an HttpsError so that the client gets
        # the error details.
        raise https_fn.HttpsError(
            code=https_fn.FunctionsErrorCode.UNKNOWN,
            message="reciever and amount are required",
            details=e,
        )

    try:
        firestore_firebase = firestore.firestore.Client()

        delivery = firestore_firebase.collection("jobs").document(delivery_id).get()

        batch = firestore_firebase.batch()

        ref = firestore_firebase.collection("transactions")

        sender_transaction = {
            "uid": uid,
            "debit_amount": delivery["amount"],
            "credit_amount": 0,
            "time": datetime.datetime.now(),
            "description": f"payment for delivery ref:{delivery_id}",
        }

        reciever_transaction = {
            "uid": delivery["courier_id"],
            "debit_amount": 0,
            "credit_amount": delivery["amount"],
            "time": datetime.datetime.now(),
            "description": f"payment for delivery ref:{delivery_id}",
        }

        batch.create(ref, sender_transaction)
        batch.create(ref, reciever_transaction)

        batch.commit()
        return https_fn.Response(1)

    except Exception as e:
        raise https_fn.HttpsError(
            code=https_fn.FunctionsErrorCode.UNKNOWN,
            message="Unable to settle payment",
            details=e,
        )


@https_fn.on_call()
def initiate_charge(req: https_fn.CallableRequest):
    randomChargeUUD = uuid.uuid4()
    try:
        uid = req.auth.uid
        amount = req.data["amount"]

    except Exception as e:
        raise https_fn.HttpsError(
            code=https_fn.FunctionsErrorCode.UNKNOWN,
            message="user detailes could not be found",
            details=e,
        )

    try:
        firestore_firebase = firestore.firestore.Client()

        profile = (
            firestore_firebase.collection("profiles").where("uid", "==", uid).get()
        )

        userProfile = profile[0]
        res = payment.checkout(
            randomChargeUUD,
            uid,
            amount,
            userProfile["full_name"],
            userProfile["email"],
            userProfile["phone_number"],
        )

        if not res[-1]:
            raise https_fn.HttpsError(
                code=https_fn.FunctionsErrorCode.UNKNOWN,
                message="Unable to collect payment",
            )

        chargeObject = {
            "uid": uid,
            "amount": amount,
            "initiated_at": datetime.datetime.now().timestamp(),
            "status": "pending",
        }

        firestore_firebase.collection("charge").add(chargeObject)

        return https_fn.Response(json.dumps({"status": "success", "url": res[0]}))

    except Exception as checkoutException:
        raise https_fn.HttpsError(
            code=https_fn.FunctionsErrorCode.UNKNOWN,
            message="failed to fetch user profile",
            details=checkoutException,
        )


@https_fn.on_request()
def verify_charge(req: https_fn.Request):
    request_data = req.data
    try:
        firestore_firebase = firestore.firestore.Client()
        status, data = payment.verify_payment(request_data)
        userInfo = data["customer"]

        chargeObject = firestore_firebase.collection("charge").document(
            userInfo["user_id"]
        )

        if status:
            chargeObject.update(
                {
                    "verified_at": datetime.datetime.now().timestamp(),
                    "status": "success",
                }
            )

            return https_fn.Response(json.dumps({"ssuccess": True}))
        else:
            chargeObject.update(
                {
                    "verified_at": datetime.datetime.now().timestamp(),
                    "status": "failed",
                }
            )

            return https_fn.Response(json.dumps({"ssuccess": False}))

    except Exception as verificationErr:
        raise https_fn.HttpsError(
            code=https_fn.FunctionsErrorCode.UNKNOWN,
            message="failed to verify payment",
            details=verificationErr,
        )


@https_fn.on_call()
def approve_chashout(req: https_fn.CallableRequest):
    try:
        uid = req.auth.uid
        ref = req.data["checkout_id"]
        amount = req.data["amount"]

        firestore_firebase = firestore.firestore.Client()
        payout_request = firestore_firebase.collection("checkouts").document(ref)
        # user_wallet_transactions = (
        #     firestore_firebase.collection("wallet_transactions")
        #     .where("uid", "==", uid)
        #     .get()
        # )
        # wallet_balance = 0
        # for i in user_wallet_transactions:
        #     wallet_balance = wallet_balance + i["credit_amount"] - i["debit_amount"]

        # if wallet_balance >= amount:

        firestore_firebase.collection("wallet_transactions").add(
            {
                "credit_amount": 0,
                "debit_amount": amount,
                "description": f"Withdrawal of NGN{amount}",
                "time": datetime.datetime.now().timestamp(),
            }
        )

        payout_request.update(
            {
                "status": "sent",
                "time_sent": datetime.datetime.now().timestamp(),
            }
        )

        return https_fn.Response(json.dumps({"status": "success"}))

    except Exception as e:
        return https_fn.Response(json.dumps({"status": "failed"}))
