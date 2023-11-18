# Welcome to Cloud Functions for Firebase for Python!
# To get started, simply uncomment the below code or create your own.
# Deploy with `firebase deploy`

from firebase_functions import https_fn
from firebase_admin import initialize_app, db, firestore
from typing import Any
import json, datetime

initialize_app()
#
#
# @https_fn.on_request()
# def on_request_example(req: https_fn.Request) -> https_fn.Response:
#     return https_fn.Response("Hello world!")

# @https_fn.on_call()
# def getWalletBalance(req: https_fn.CallableRequest)-> Any:
#     uid = req.auth.uid

#     var transactions = db.reference("transactions").child().



@https_fn.on_call()
def sendMoney(req: https_fn.CallableRequest) -> Any:
    try:
        uid = req.auth.uid
        recipient = req.data['to']
        amount = req.data['amount']

    except Exception as e:
        # Re-throwing the error as an HttpsError so that the client gets
        # the error details.
        raise https_fn.HttpsError(code=https_fn.FunctionsErrorCode.UNKNOWN,
                                  message="reciever and amount are required",
                                  details=e)

    try:
        firestore_firebase = firestore.firestore.Client()

        batch = firestore_firebase.batch()

        ref = firestore_firebase.collection("transactions")

        sender_transaction = {
            'owner': uid,
            'debit_amount': amount,
            'credit_amount': 0,
            'time': datetime.datetime.now(),
            'description': "payment for delivery"
        }
            
        reciever_transaction = {
            'owner': recipient,
            'debit_amount': 0,
            'credit_amount': amount,
            'time': datetime.datetime.now(),
            'description': "payment for delivery"
        }

        
        batch.create(ref, sender_transaction)
        batch.create(ref, reciever_transaction)

        batch.commit()
        return https_fn.Response(1)
    
    except Exception as e:
        raise https_fn.HttpsError(code=https_fn.FunctionsErrorCode.UNKNOWN,
                                  message="Unable to send money",
                                  details=e) 
 


