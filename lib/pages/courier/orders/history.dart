import 'package:app/data/delivery_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DeliveryHistory extends StatefulWidget {
  const DeliveryHistory({super.key});

  @override
  State<DeliveryHistory> createState() => DeliveryHistoryState();
}

class DeliveryHistoryState extends State<DeliveryHistory> {
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
        var deliveries = snapshot.data!.docs
            .map(
              (e) => Delivery.fromMap(e.data()),
            )
            .where((element) =>
                element.status == "delivered" || element.status == "recieved");
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
    return Card(
      borderOnForeground: true,
      surfaceTintColor: Colors.white,
      elevation: 8,
      color: Colors.white,
      child: ListTile(
        // onTap: () => Navigator.of(context).push(
        //   MaterialPageRoute(
        //     builder: (context) => OrderDetails(
        //       delivery: _delivery!,
        //     ),
        //   ),
        // ),
        title: Text("From: ${widget.delivery.pickupAddress ?? ''}"),
        leading: const Icon(Icons.person),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("To: ${widget.delivery.deliveryAddress ?? ''}"),
            Row(
              children: [
                Text(
                  widget.delivery.deliveredAt != null
                      ? DateFormat.yMMMEd()
                          .add_jm()
                          .format(widget.delivery.deliveredAt!.toDate())
                      : "",
                ),
                const Spacer(),
                Text(widget.delivery.status ?? ""),
              ],
            ),
          ],
        ),
        trailing: Icon(
          Icons.check,
          color: Colors.green,
        ),
      ),
    );
  }
}
