# The Cloud Functions for Firebase SDK to create Cloud Functions and set up triggers.
from firebase_functions import firestore_fn, https_fn

# The Firebase Admin SDK to access Cloud Firestore.
from firebase_admin import initialize_app, firestore
import google.cloud.firestore
from firebase_functions import options
import json


options.set_global_options(max_instances=10)


app = initialize_app()


# functions

# 
# WALLET FUNCTIONS
@https_fn.on_call()  # callable from app
def get_wallet_balance(req: https_fn.CallableRequest) -> https_fn.Response:
    firestore_client: google.cloud.firestore.Client = firestore.client()
    uid = req.auth.uid
    try:
        # Push the new message into Cloud Firestore using the Firebase Admin SDK.
        result = firestore_client.collection("wallet_transactions").where("owner", "==", uid).get()

        balance = 0
        for v in result:
            val = v.to_dict()
            if val is not None:
                balance = balance + val['credit_amount'] - val['debit_amount']

        return https_fn.Response(json.dumps({"balance": balance}), 200)
    except:
        return https_fn.HttpsError(message="Error")




@https_fn.on_request()
def send_money(req: https_fn.Request) -> https_fn.Response:
    uid = req.authorization
    pass

@https_fn.on_request()
def create_withdraw_request(req: https_fn.Request) -> https_fn.Response:
    uid = req.authorization
    pass

@https_fn.on_request()
def accept_withdraw_request(req: https_fn.Request) -> https_fn.Response:
    uid = req.authorization
    pass

@https_fn.on_request()
def charge_card(req: https_fn.Request) -> https_fn.Response:
    pass


# ------ webhooks --------
@https_fn.on_request()
def verify_payment(req: https_fn.Request) -> https_fn.Response:
    pass





# ACCOUNT VERIFICATION (ADMINISTRATIVE)
@https_fn.on_request()
def verify_courier(req: https_fn.Request) -> https_fn.Response:
    uid = req.authorization
    pass