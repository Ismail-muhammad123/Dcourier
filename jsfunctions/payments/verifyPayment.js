import axios from "axios";
import {
  PAYMENT_API_PUBLIC_KEY,
  PAYMENT_GATEAWAY_SECRET_KEY,
  PAYMENT_GATEAWAY_URL,
  PAYMENT_VERIFICATION_URL,
  PAYMENT_CALLBACK_URL,
} from "./constants.js";

export default async function verifyPayment(requestData) {
  const headers = { Authorization: `Bearer ${PAYMENT_GATEAWAY_SECRET_KEY}` };

  try {
    const txRef = requestData.trxref;
    var res = await axios
      .get(`${PAYMENT_VERIFICATION_URL}${txRef}`, {
        headers,
      })
      .then((response) => {
        if (response.status === 200) {
          const res = response.data;
          const status = res.data.log.success;

          if (status) {
            return [true, res.data];
          }
        }

        return [false, response.data];
      })
      .catch((err) => {
        return [false, err];
      });
    return res;
  } catch (error) {
    console.error(error);
    return [false, error];
  }
}
