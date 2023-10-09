import 'package:app/constants.dart';
import 'package:app/data/delivery_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Performance extends StatefulWidget {
  const Performance({super.key});

  @override
  State<Performance> createState() => _PerformanceState();
}

class _PerformanceState extends State<Performance> {
  final ordersInstance = FirebaseFirestore.instance.collection("jobs").where(
        "courier_id",
        isEqualTo: FirebaseAuth.instance.currentUser!.uid,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: tartiaryColor,
        surfaceTintColor: tartiaryColor,
        title: const Text("Performance"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
            future: ordersInstance.get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (!snapshot.hasData) {
                return const Center(
                  child: Text("No orders yet"),
                );
              }

              var data = snapshot.data!.docs.map(
                (e) => Delivery.fromMap(e.data()),
              );
              var all = data.length;
              var completed =
                  data.where((element) => element.status == "delivered").length;
              var uncompleted = all - completed;

              return GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 8.0,
                crossAxisSpacing: 8.0,
                children: [
                  Card(
                    color: Colors.white,
                    surfaceTintColor: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          all.toString(),
                          style: const TextStyle(
                            fontSize: 24.0,
                          ),
                        ),
                        const Text("Total Orders"),
                      ],
                    ),
                  ),
                  Card(
                    color: Colors.white,
                    surfaceTintColor: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          completed.toString(),
                          style: const TextStyle(
                            fontSize: 24.0,
                          ),
                        ),
                        const Text("Completed Orders"),
                      ],
                    ),
                  ),
                  Card(
                    color: Colors.white,
                    surfaceTintColor: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          uncompleted.toString(),
                          style: const TextStyle(
                            fontSize: 24.0,
                          ),
                        ),
                        const Text("Uncompleted Orders"),
                      ],
                    ),
                  ),
                ],
              );
            }),
      ),
    );
  }
}
