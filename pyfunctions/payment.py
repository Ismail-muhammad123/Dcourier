from constants import *
import requests


def checkout(chargeID, userID, amount, name, email, phoneNumber):
    verification_url = PAYMENT_CALLBACK_URL

    url = PAYMENT_GATEAWAY_URL
    secret_key = PAYMENT_GATEAWAY_SECRET_KEY

    headers = {"Authorization": f"Bearer {secret_key}"}

    data = {
        "reference": chargeID,
        "user_id": userID,
        "email": email,
        "amount": amount * 100,
        "currency": "NGN",
        # "callback_url": verification_url,
        "metadata": {
            "charge_id": chargeID,
            "customer": {"email": email, "phone_number": phoneNumber, "name": name},
        },
    }
    res = requests.post(url, headers=headers, json=data)
    response = res.json()
    print(response["status"])
    print(response)
    if response["status"] == True:
        return (response["data"]["authorization_url"], True)
    else:
        # pprint(response)
        return (None, False)


def verify_payment(request_data):
    headers = {"Authorization": f"Bearer {PAYMENT_GATEAWAY_SECRET_KEY}"}

    tx_ref = request_data["trxref"]
    response = requests.get(PAYMENT_VERIFICATION_URL + tx_ref, headers=headers)
    # print(response.status_code)
    if response.status_code == 200:
        res = response.json()
        status = res["data"]["log"]["success"]
        # print(status)
        if status:
            return (True, res["data"])

    return (False, res["data"])


