import 'package:app/data/job_request_data.dart';
import 'package:app/pages/courier/orders/order_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../data/delivery_data.dart';

class DeliveryRequestsList extends StatefulWidget {
  final List<JobRequest> requests;
  const DeliveryRequestsList({
    super.key,
    required this.requests,
  });

  @override
  State<DeliveryRequestsList> createState() => DeliveryRequestsListState();
}

class DeliveryRequestsListState extends State<DeliveryRequestsList> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: widget.requests
          .map(
            (e) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: DeliveryRequestTile(
                request: e,
              ),
            ),
          )
          .toList(),
    );
  }
}

class DeliveryRequestTile extends StatefulWidget {
  final JobRequest request;
  const DeliveryRequestTile({
    required this.request,
    super.key,
  });

  @override
  State<DeliveryRequestTile> createState() => _DeliveryRequestTileState();
}

class _DeliveryRequestTileState extends State<DeliveryRequestTile> {
  Delivery? _delivery;
  _getDelivery() async {
    var d = await FirebaseFirestore.instance
        .collection('jobs')
        .doc(widget.request.jobID)
        .get();
    if (d.exists) {
      if (mounted) {
        setState(() => _delivery = Delivery.fromMap(d.data()!));
      }
    }
  }

  @override
  void initState() {
    _getDelivery();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _delivery != null
        ? Card(
            borderOnForeground: true,
            surfaceTintColor: Colors.white,
            elevation: 8,
            color: Colors.white,
            child: ListTile(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => OrderDetails(
                    delivery: _delivery!,
                    request: widget.request,
                  ),
                ),
              ),
              title: Text("From: ${_delivery!.pickupAddress ?? ''}"),
              leading: const Icon(Icons.person),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("To: ${_delivery!.deliveryAddress ?? ''}"),
                  Row(
                    children: [
                      Text(
                        widget.request.appliedAt != null
                            ? DateFormat.yMMMEd()
                                .add_jm()
                                .format(widget.request.appliedAt!.toDate())
                            : "",
                      ),
                      const Spacer(),
                      Text(widget.request.status ?? ""),
                    ],
                  ),
                ],
              ),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
          )
        : const Center(
            child: Text("-"),
          );
  }
}
