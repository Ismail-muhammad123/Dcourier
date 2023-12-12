import 'package:app/data/delivery_data.dart';
import 'package:app/pages/sme/tracking/tracking_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TrackingPage extends StatefulWidget {
  const TrackingPage({super.key});

  @override
  State<TrackingPage> createState() => _TrackingPageState();
}

class _TrackingPageState extends State<TrackingPage> {
  var uid = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tracking"),
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back_ios),
          ),
        ),
      ),
      body: Center(
        child: FutureBuilder(
          future: FirebaseFirestore.instance
              .collection("jobs")
              .where("sender_id", isEqualTo: uid)
              .get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      "images/tracking.png",
                      height: 250,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("You can track the status of your items here"),
                  )
                ],
              );
            }
            var data = snapshot.data!.docs.map(
              (e) {
                var d = Delivery.fromMap(
                  e.data(),
                );
                d.id = e.id;
                return d;
              },
            );
            return ListView(
              children: data
                  .map(
                    (e) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        surfaceTintColor: Colors.white,
                        color: Colors.white,
                        child: ListTile(
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => TrackingDetail(
                                delivery: e,
                              ),
                            ),
                          ),
                          trailing: Container(
                            height: 20,
                            width: 20,
                            decoration: BoxDecoration(
                              color: e.status == "delivered" ||
                                      e.status == "recieved"
                                  ? Colors.green
                                  : e.status == "canceled"
                                      ? Colors.red
                                      : e.status == "enroute"
                                          ? Colors.orange
                                          : Colors.grey,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          title: Text("Delivery to ${e.recieverName ?? '-'}"),
                          subtitle: Wrap(
                            spacing: 12.0,
                            children: [
                              Text(
                                DateFormat.yMMMEd()
                                    .format(e.pickupTime!.toDate()),
                                style: const TextStyle(color: Colors.grey),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            );
          },
        ),
      ),
    );
  }
}
