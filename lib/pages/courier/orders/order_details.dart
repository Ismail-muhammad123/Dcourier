import 'dart:typed_data';

import 'package:app/constants.dart';
import 'package:app/data/delivery_data.dart';
import 'package:app/data/job_request_data.dart';
import 'package:app/data/profile_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderDetails extends StatefulWidget {
  final Delivery delivery;
  final JobRequest request;
  const OrderDetails({
    super.key,
    required this.delivery,
    required this.request,
  });

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  Profile? _sender;
  bool _loading = false;

  _getSenderProfile() async {
    var p = await FirebaseFirestore.instance
        .collection("profiles")
        .doc(widget.delivery.senderId)
        .get();
    if (p.exists) {
      setState(() => _sender = Profile.fromMap(p.data()!));
    }
  }

  _rejectRequest() async {
    setState(() => _loading = true);
    var reqID = widget.request.id;
    await FirebaseFirestore.instance
        .collection("request")
        .doc(reqID)
        .update({"status": "rejected"});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Request Rejected"),
      ),
    );
    setState(() => _loading = false);
    Navigator.of(context).pop();
  }

  _acceptRequest() async {
    var reqID = widget.request.id;
    setState(() => _loading = true);
    await FirebaseFirestore.instance.collection("request").doc(reqID).update({
      "status": "accepted",
      "accepted": true,
      "accepted_at": Timestamp.now(),
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Request Accepted"),
      ),
    );
    setState(() => _loading = false);
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    _getSenderProfile();
    super.initState();
  }

  // final requestFuture = FirebaseFirestore.instance.collection('jobs').doc(widget.delivery.id).get();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Order Details"),
        centerTitle: true,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.85,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      Column(
                        children: [
                          Text(
                            "Sender:",
                            style: TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Container(
                            height: 3,
                            width: 50,
                            decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                _sender == null
                    ? const SizedBox()
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          title: Text(
                            _sender!.fullName ?? "",
                            style: TextStyle(
                              color: accentColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 18.0,
                            ),
                          ),
                          isThreeLine: true,
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _sender!.phoneNumber ?? '',
                                style: TextStyle(
                                  color: accentColor,
                                ),
                              ),
                              _sender!.phoneNumber == null ||
                                      _sender!.phoneNumber!.isEmpty
                                  ? const SizedBox()
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        MaterialButton(
                                          onPressed: () async {
                                            final Uri smsLaunchUri = Uri(
                                              scheme: 'tel',
                                              path:
                                                  "+234${_sender!.phoneNumber!.startsWith("0") ? _sender!.phoneNumber!.substring(1) : _sender!.phoneNumber}",
                                            );
                                            if (!await launchUrl(
                                                smsLaunchUri)) {
                                              throw Exception(
                                                  'Could not launch phone number');
                                            }
                                          },
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
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
                                                  "+234${_sender!.phoneNumber!.startsWith("0") ? _sender!.phoneNumber!.substring(1) : _sender!.phoneNumber}",
                                            );
                                            if (!await launchUrl(
                                                smsLaunchUri)) {
                                              throw Exception(
                                                  'Could not launch smsUrl');
                                            }
                                          },
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
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
                          leading: FutureBuilder<Uint8List?>(
                            future: FirebaseStorage.instance
                                .ref()
                                .child(_sender!.profilePicture!)
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
                            },
                          ),
                        ),
                      ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      Column(
                        children: [
                          Text(
                            "Delivery Information:",
                            style: TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Container(
                            height: 3,
                            width: 140,
                            decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.location_pin,
                        color: Colors.green,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Pickup Location",
                            style: TextStyle(
                              color: primaryColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            widget.delivery.pickupAddress ?? "-",
                            style: TextStyle(
                              color: accentColor,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 200,
                    child: Divider(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.location_pin,
                        color: Colors.red,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Destination",
                            style: TextStyle(
                              color: primaryColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            widget.delivery.deliveryAddress ?? "-",
                            style: TextStyle(
                              color: accentColor,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Reciever",
                            style: TextStyle(
                              color: primaryColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            widget.delivery.recieverName ?? "-",
                            style: TextStyle(
                              color: accentColor,
                            ),
                          ),
                          Text(
                            widget.delivery.recieverPhoneNumber != null &&
                                    widget.delivery.recieverPhoneNumber!
                                        .isNotEmpty
                                ? widget.delivery.recieverPhoneNumber!
                                : "no phone number",
                            style: TextStyle(
                              color: accentColor,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      MaterialButton(
                        onPressed: widget.delivery.recieverPhoneNumber !=
                                    null &&
                                widget.delivery.recieverPhoneNumber!.isNotEmpty
                            ? () async {
                                final Uri smsLaunchUri = Uri(
                                  scheme: 'tel',
                                  path:
                                      "+234${widget.delivery.recieverPhoneNumber!.startsWith("0") ? widget.delivery.recieverPhoneNumber!.substring(1) : widget.delivery.recieverPhoneNumber!}",
                                );
                                if (!await launchUrl(smsLaunchUri)) {
                                  throw Exception(
                                      'Could not launch phone number');
                                }
                              }
                            : null,
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
                        onPressed: widget.delivery.recieverPhoneNumber !=
                                    null &&
                                widget.delivery.recieverPhoneNumber!.isNotEmpty
                            ? () async {
                                final Uri smsLaunchUri = Uri(
                                  scheme: 'sms',
                                  path:
                                      "+234${widget.delivery.recieverPhoneNumber!.startsWith("0") ? widget.delivery.recieverPhoneNumber!.substring(1) : widget.delivery.recieverPhoneNumber!}",
                                );
                                if (!await launchUrl(smsLaunchUri)) {
                                  throw Exception('Could not launch smsUrl');
                                }
                              }
                            : null,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        color: tartiaryColor,
                        child: const Icon(FontAwesomeIcons.message),
                      ),
                    ],
                  ),
                ),
                _loading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          MaterialButton(
                            onPressed: _rejectRequest,
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(color: Colors.red),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            height: 50,
                            minWidth: 150,
                            child: const Text(
                              "Reject",
                              style: TextStyle(
                                color: Colors.red,
                              ),
                            ),
                          ),
                          MaterialButton(
                            onPressed: _acceptRequest,
                            color: accentColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            height: 50,
                            minWidth: 150,
                            child: const Text(
                              "Accept",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          )
                        ],
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
