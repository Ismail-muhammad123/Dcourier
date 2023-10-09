import 'package:app/data/delivery_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'order_list.dart';

class DeliveryHistory extends StatefulWidget {
  const DeliveryHistory({super.key});

  @override
  State<DeliveryHistory> createState() => Delivery_HistoryState();
}

class Delivery_HistoryState extends State<DeliveryHistory> {
  final ordersInstance = FirebaseFirestore.instance.collection("jobs").where(
        "courier_id",
        isEqualTo: FirebaseAuth.instance.currentUser!.uid,
      );
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
      future: ordersInstance.get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Image.asset("images/no_event.png");
        }
        var deliveries = snapshot.data!.docs.map(
          (e) => Delivery.fromMap(e.data()),
        );
        return ListView(
          children: deliveries
              .map(
                (e) => DeliveryHistoryTile(delivery: e),
              )
              .toList(),
        );
      },
    );
  }
}

class DeliveryHistoryTile extends StatefulWidget {
  final Delivery delivery;
  const DeliveryHistoryTile({required this.delivery, super.key});

  @override
  State<DeliveryHistoryTile> createState() => _DeliveryHistoryTileState();
}

class _DeliveryHistoryTileState extends State<DeliveryHistoryTile> {
  @override
  Widget build(BuildContext context) {
    return const ListTile();
  }
}
