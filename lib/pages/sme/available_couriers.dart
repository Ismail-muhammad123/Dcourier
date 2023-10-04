import 'dart:typed_data';
import 'package:app/constants.dart';
import 'package:app/data/delivery_data.dart';
import 'package:app/data/profile_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CourierList extends StatefulWidget {
  final Delivery delivery;
  const CourierList({
    required this.delivery,
    super.key,
  });

  @override
  State<CourierList> createState() => CourierListState();
}

class CourierListState extends State<CourierList> {
  Stream<QuerySnapshot<Map<String, dynamic>>> _getAvailableCouriers() {
    return FirebaseFirestore.instance
        .collection('profiles')
        .where('account_type', isEqualTo: "courier")
        .where('verified', isEqualTo: true)
        .where('vehicle_type', isEqualTo: widget.delivery.vehicleType)
        .where("available", isEqualTo: true)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Available Couriers"),
        centerTitle: true,
        elevation: 8,
        surfaceTintColor: Colors.white,
        backgroundColor: tartiaryColor,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: null,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator(
                  color: primaryColor,
                );
              }
              if (!snapshot.hasData) {
                return const Text("waiting for Couriers...");
              }
              var data =
                  snapshot.data!.docs.map((e) => Profile.fromMap(e.data()));
              return ListView(
                children: data
                    .map(
                      (profile) => Card(
                        color: Colors.white,
                        surfaceTintColor: Colors.white,
                        child: ListTile(
                          title: Text(profile.fullName ?? ""),
                          subtitle: Text(profile.phoneNumber ?? ''),
                          leading: FutureBuilder<Uint8List?>(
                              future: FirebaseStorage.instance
                                  .ref()
                                  .child(profile.profilePicture!)
                                  .getData(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData &&
                                    snapshot.data!.isNotEmpty) {
                                  var data = snapshot.data;

                                  return Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                      border: Border.all(color: Colors.grey),
                                      image: DecorationImage(
                                        image: MemoryImage(data!),
                                      ),
                                    ),
                                  );
                                }
                                return const Icon(Icons.person);
                              }),
                          trailing: const Icon(FontAwesomeIcons.message),
                        ),
                      ),
                    )
                    .toList(),
              );
            },
          ),
        ),
      ),
    );
  }
}
