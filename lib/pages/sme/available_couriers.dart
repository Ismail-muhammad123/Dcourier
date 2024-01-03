import 'dart:typed_data';
import 'package:app/constants.dart';
import 'package:app/data/delivery_data.dart';
import 'package:app/data/job_request_data.dart';
import 'package:app/data/profile_data.dart';
import 'package:app/pages/sme/tracking/tracking_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

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
  bool _isLoading = false;

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
            stream: FirebaseFirestore.instance
                .collection('profiles')
                .where('account_type', isEqualTo: "courier")
                .where('verified', isEqualTo: true)
                .where('vehicle_type', isEqualTo: widget.delivery.vehicleType)
                .where("available", isEqualTo: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator(
                  color: primaryColor,
                );
              }
              if (!snapshot.hasData) {
                return const Text("waiting for Couriers...");
              }
              var data = snapshot.data!.docs.map((e) {
                var p = Profile.fromMap(e.data());
                p.id = e.id;
                return p;
              });

              return ListView(
                children: data
                    .map(
                      (profile) => AvailableCourierCard(
                        delivery: widget.delivery,
                        profile: profile,
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

class AvailableCourierCard extends StatefulWidget {
  final Profile profile;
  final Delivery delivery;
  const AvailableCourierCard({
    super.key,
    required this.profile,
    required this.delivery,
  });

  @override
  State<AvailableCourierCard> createState() => _AvailableCourierCardState();
}

class _AvailableCourierCardState extends State<AvailableCourierCard> {
  bool _isLoading = false;

  Uint8List? profilePicture;

  _getProfilePicture() {
    FirebaseStorage.instance
        .ref()
        .child(widget.profile.profilePicture!)
        .getData()
        .then((value) => setState(() => profilePicture = value))
        .onError((error, stackTrace) => print("profile picture not found"));
  }

  _createRequest(Profile courier) async {
    setState(() => _isLoading = true);

    var uid = FirebaseAuth.instance.currentUser!.uid;
    var prevReq = await FirebaseFirestore.instance
        .collection("requests")
        .where("job_id", isEqualTo: widget.delivery.id)
        .get();
    if (prevReq.docs.isNotEmpty) {
      for (var r in prevReq.docs) {
        await FirebaseFirestore.instance
            .collection("requests")
            .doc(r.id)
            .delete();
      }
    }
    var req = JobRequest(
      jobID: widget.delivery.id!,
      creatorID: uid,
      courierId: courier.id!,
      status: "requested",
      appliedAt: Timestamp.now(),
    );
    await FirebaseFirestore.instance.collection("request").add(req.toMap());
    await FirebaseFirestore.instance
        .collection("jobs")
        .doc(widget.delivery.id!)
        .update({"status": "processing"});
    var delv = widget.delivery;
    delv.status = 'processing';
    setState(() => _isLoading = false);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => TrackingDetail(
          delivery: delv,
        ),
      ),
    );
  }

  @override
  void initState() {
    _getProfilePicture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Profile profile = widget.profile;
    return Card(
      color: Colors.white,
      surfaceTintColor: Colors.white,
      child: ListTile(
        leading: profile.profilePicture == null
            ? null
            : Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: Colors.grey),
                  image: profilePicture != null
                      ? DecorationImage(
                          image: MemoryImage(profilePicture!),
                        )
                      : null,
                ),
                child: profilePicture == null ? const Icon(Icons.person) : null,
              ),
        onTap: _isLoading ? null : () => _createRequest(profile),
        title: Text(profile.fullName ?? ""),
        isThreeLine: true,
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(profile.phoneNumber ?? ''),
            profile.phoneNumber == null || profile.phoneNumber!.isEmpty
                ? const SizedBox()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MaterialButton(
                        onPressed: () async {
                          final Uri smsLaunchUri = Uri(
                            scheme: 'tel',
                            path:
                                "+234${profile.phoneNumber!.startsWith("0") ? profile.phoneNumber!.substring(1) : profile.phoneNumber}",
                          );
                          if (!await launchUrl(smsLaunchUri)) {
                            throw Exception('Could not launch phone number');
                          }
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        color: tartiaryColor,
                        child: const Row(
                          children: [
                            Icon(Icons.call),
                            SizedBox(
                              width: 10.0,
                            ),
                            Text("Call"),
                          ],
                        ),
                      ),
                      MaterialButton(
                        onPressed: () async {
                          final Uri smsLaunchUri = Uri(
                            scheme: 'sms',
                            path:
                                "+234${profile.phoneNumber!.startsWith("0") ? profile.phoneNumber!.substring(1) : profile.phoneNumber}",
                          );
                          if (!await launchUrl(smsLaunchUri)) {
                            throw Exception('Could not launch smsUrl');
                          }
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        color: tartiaryColor,
                        child: const Row(
                          children: [
                            Icon(FontAwesomeIcons.message),
                            SizedBox(
                              width: 10.0,
                            ),
                            Text("Message"),
                          ],
                        ),
                      ),
                    ],
                  )
          ],
        ),
      ),
    );
  }
}
