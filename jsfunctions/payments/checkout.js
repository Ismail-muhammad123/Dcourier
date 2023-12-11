import axios from "axios";
import {
  PAYMENT_GATEAWAY_SECRET_KEY,
  PAYMENT_GATEAWAY_URL,
} from "./constants.js";

export default async function checkout(
  chargeID,
  userID,
  amount,
  name,
  email,
  phoneNumber
) {
  // const verificationUrl = PAYMENT_CALLBACK_URL;
  const url = PAYMENT_GATEAWAY_URL;
  const secretKey = PAYMENT_GATEAWAY_SECRET_KEY;

  const headers = { Authorization: `Bearer ${secretKey}` };

  const data = {
    reference: chargeID,
    user_id: userID,
    email: email,
    amount: amount * 100,
    currency: "NGN",
    // callback_url: verificationUrl,
    metadata: {
      charge_id: chargeID,
      customer: { email: email, phone_number: phoneNumber, name: name },
    },
  };

  return axios
    .post(url, data, { headers })
    .then((response) => {
      // console.log(response.data.status);
      // console.log(response.data);
      if (response.data.status === true) {
        // console.log(response.data.data.authorization_url);
        return [response.data.data.authorization_url, true];
      } else {
        // console.log(response.data);
        return [null, false];
      }
    })
    .catch((error) => {
      console.error(error);
      return [null, false];
    });
}
