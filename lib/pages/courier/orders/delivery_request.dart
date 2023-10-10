import 'package:app/data/job_request_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';
import 'order_list.dart';

class OrderRequest extends StatefulWidget {
  const OrderRequest({super.key});

  @override
  State<OrderRequest> createState() => OrderRequestState();
}

class OrderRequestState extends State<OrderRequest> {
  final Stream<QuerySnapshot<Map<String, dynamic>>> _getRequests =
      FirebaseFirestore.instance
          .collection("request")
          .where(
            "courier_id",
            isEqualTo: FirebaseAuth.instance.currentUser!.uid,
          )
          .where(
            "status",
            isEqualTo: "requested",
          )
          .snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: _getRequests,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(color: primaryColor),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("images/no_orders.png"),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Sorry! nothing yet.",
                  style: TextStyle(
                    color: accentColor,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "We will notify you or new order request.",
                ),
              )
            ],
          );
        }
        return DeliveryRequestsList(
          requests: snapshot.data!.docs
              .map(
                (e) {
                  var j = JobRequest.fromMap(
                    e.data(),
                  );
                  j.id = e.id;
                  return j;
                },
              )
              .where((element) => element.status == "requested")
              .toList(),
        );
      },
    );
  }
}
