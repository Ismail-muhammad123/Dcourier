import 'dart:convert';
import 'dart:typed_data';

import 'package:app/constants.dart';
import 'package:app/data/delivery_data.dart';
import 'package:app/data/job_request_data.dart';
import 'package:app/data/profile_data.dart';
import 'package:app/pages/sme/available_couriers.dart';
import 'package:app/pages/sme/tracking/payment_success.dart';
import 'package:app/pages/wallet/wallet_home.dart';
import 'package:app/widgets/buttons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class TrackingDetail extends StatefulWidget {
  final Delivery delivery;
  const TrackingDetail({required this.delivery, super.key});

  @override
  State<TrackingDetail> createState() => _TrackingDetailState();
}

class _TrackingDetailState extends State<TrackingDetail> {
  JobRequest? _courierRequest;
  Profile? _courierProfile;
  bool _isLoading = false;

  Uint8List? courierProfilePicture;

  var approveCourierFunction =
      FirebaseFunctions.instance.httpsCallable("acceptCourierForDelivery");
  var releaseDeliveryPayment =
      FirebaseFunctions.instance.httpsCallable("releaseDeliveryPayment");
  // var getBalancefunc =
  //     FirebaseFunctions.instance.httpsCallable("getWalletBalance");

  Future<double> _getWalletBalance() async {
    var transactions = await FirebaseFirestore.instance
        .collection("wallet_transactions")
        .where("uid", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();
    double balance = 0;
    for (var i in transactions.docs) {
      balance = balance +
          (i.data()['credit_amount'] ?? 0) -
          (i.data()['debit_amount'] ?? 0);
    }
    // var walletBalance = await getBalancefunc.call<num>();
    // var balance = walletBalance.data;
    // print("balance: $balance");
    return balance;
  }

  // Future<int?> _sendPayment(String to, double amount) async {

  // }

  _markAsDeivered() async {
    String deliveryId = widget.delivery.id!;
    setState(() => _isLoading = true);

    try {
      var res = await releaseDeliveryPayment
          .call<Map<String, dynamic>>({"delivery_id": deliveryId});
      if (res.data['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Delivery status updated to Recieverd"),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text("Delivery status update failed, please try again later"),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text("Delivery status update failed, please try again later"),
        ),
      );
    }
    setState(() => _isLoading = false);
  }

  _makePayment() async {
    setState(() => _isLoading = true);
    try {
      var balance = await _getWalletBalance();

      if (balance >= widget.delivery.amount!) {
        var res = await approveCourierFunction.call<Map<String, dynamic>>({
          // "to": _courierProfile!.id!,
          "delivery_id": widget.delivery.id,
        });

        if (res.data["status"] == "success") {
          var batch = FirebaseFirestore.instance.batch();
          batch.update(
              FirebaseFirestore.instance
                  .collection('jobs')
                  .doc(widget.delivery.id),
              {
                "courier_id": _courierProfile!.id,
                "status": "paid",
              });

          batch.set(
            FirebaseFirestore.instance.collection("activities").doc(),
            {
              "uid": FirebaseAuth.instance.currentUser!.uid,
              "activity": "You made a payment of ${widget.delivery.amount}",
              "time": Timestamp.now(),
            },
          );

          await batch.commit();

          setState(() {
            _isLoading = false;
          });

          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => PaymentSuccess(
                amount: widget.delivery.amount!,
                recieverName: widget.delivery.recieverName ?? "",
                recieverPhone: widget.delivery.recieverPhoneNumber ?? "",
              ),
            ),
          );
        } else {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Unable complete this process!"),
            ),
          );
        }
      } else {
        var r = await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Insufficient Wallet balance"),
            icon: Icon(Icons.error),
            content: Text(
                "You do not have enough balance in your wallet to make this payment, please credit your wallet to procees."),
            actions: [
              MaterialButton(
                onPressed: () => Navigator.of(context).pop(0),
                color: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text("Cancel"),
              ),
              MaterialButton(
                onPressed: () => Navigator.of(context).pop(1),
                color: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text("Open Wallet"),
              )
            ],
          ),
        );
        setState(() => _isLoading = false);

        if (r == 1) {
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const WalletHome(),
            ),
          );
        }
        return;
      }
    } catch (e) {
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Error accesing wallet"),
          icon: const Icon(Icons.error),
          content: const Text(
              "We could not process your payment at the moment, please try again later"),
          actions: [
            MaterialButton(
              onPressed: () => Navigator.of(context).pop(1),
              color: Colors.grey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text("Okay"),
            )
          ],
        ),
      );
      setState(() => _isLoading = false);
    }
  }

  _deleteDelevery() async {
    var batch = FirebaseFirestore.instance.batch();

    var delv = await FirebaseFirestore.instance
        .collection("jobs")
        .doc(widget.delivery.id)
        .get();
    if (delv.exists) {
      var req = await FirebaseFirestore.instance
          .collection("requests")
          .where("job_id", isEqualTo: delv.id)
          .get();

      if (req.docs.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection("requests")
            .doc(req.docs.first.id)
            .delete();
      }
      batch.update(FirebaseFirestore.instance.collection("jobs").doc(delv.id),
          {"status": "canceled"});

      batch.set(FirebaseFirestore.instance.collection("activities").doc(), {
        "uid": FirebaseAuth.instance.currentUser!.uid,
        "activity": "Canceled a transaction",
        "time": Timestamp.now(),
      });

      await batch.commit();

      Navigator.of(context).pop();
    }
  }

  _getCourier() async {
    var delv = await FirebaseFirestore.instance
        .collection("request")
        .where("job_id", isEqualTo: widget.delivery.id)
        .get();
    if (delv.docs.isNotEmpty) {
      var d = delv.docs.first;
      var req = JobRequest.fromMap(d.data());
      req.id = d.id;
      var courier = await FirebaseFirestore.instance
          .collection("profiles")
          .doc(d.data()['courier_id'])
          .get();
      var p = Profile.fromMap(courier.data()!);
      FirebaseStorage.instance
          .ref()
          .child(p.profilePicture!)
          .getData()
          .then(
            (value) => setState(() => courierProfilePicture = value!),
          )
          .onError((error, stackTrace) {
        print("no profile picture");
      });
      p.id = courier.id;
      setState(() {
        if (courier.exists) {
          _courierProfile = p;
        }
        _courierRequest = req;
      });
    }
  }

  @override
  void initState() {
    _getCourier();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back_ios),
          ),
        ),
        title: Text("Delivery to ${widget.delivery.recieverName ?? ''}"),
        centerTitle: true,
        actions: widget.delivery.status == "canceled"
            ? null
            : widget.delivery.courierId == null
                ? [
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: _deleteDelevery,
                    ),
                  ]
                : null,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _isLoading
          ? const CircularProgressIndicator()
          : widget.delivery.status == "paid" ||
                  widget.delivery.status == "delivered" ||
                  widget.delivery.status == 'recieved'
              ? null
              : _courierRequest == null || _courierRequest!.status != "accepted"
                  ? MaterialButton(
                      onPressed: () => Navigator.of(context)
                          .push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  CourierList(delivery: widget.delivery),
                            ),
                          )
                          .then((value) => setState(() {})),
                      child: const GradientDecoratedContainer(
                        child: Text(
                          "Find a Courier",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                  : MaterialButton(
                      onPressed: _makePayment,
                      child: const GradientDecoratedContainer(
                        child: Text(
                          "Proceed to payment",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: FirebaseFirestore.instance
            .collection("jobs")
            .doc(widget.delivery.id)
            .get(),
        builder: (context, deliverySnapshot) {
          if (deliverySnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!deliverySnapshot.hasData) {
            return const Center(
              child: Text("Delivery information not found"),
            );
          }
          var delivery = Delivery.fromMap(deliverySnapshot.data!.data()!);
          delivery.id = deliverySnapshot.data!.id;
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Stack(
                        children: [
                          Positioned(
                            top: 20,
                            child: Container(
                              width: 280,
                              height: 2,
                              color: accentColor,
                            ),
                          ),
                          SizedBox(
                            width: 320,
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        border: Border.all(color: accentColor),
                                        color: delivery.status == "paid" ||
                                                delivery.status == "enroute" ||
                                                delivery.status ==
                                                    "delivered" ||
                                                delivery.status == "recieved"
                                            ? accentColor
                                            : Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: const Icon(Icons.check),
                                    ),
                                    const Text("Paid"),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        border: Border.all(color: accentColor),
                                        color: delivery.status == "enroute" ||
                                                delivery.status ==
                                                    "delivered" ||
                                                delivery.status == "recieved"
                                            ? accentColor
                                            : Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: const Icon(Icons.check),
                                    ),
                                    const Text("En route")
                                  ],
                                ),
                                Column(
                                  children: [
                                    Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        border: Border.all(color: accentColor),
                                        color: delivery.status == "delivered" ||
                                                delivery.status == "recieved"
                                            ? accentColor
                                            : Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: const Icon(Icons.check),
                                    ),
                                    const Text("Delivered"),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Container(
                              width: 60,
                              height: 60,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: tartiaryColor,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Icon(
                                delivery.status == 'canceled'
                                    ? Icons.clear
                                    : delivery.status != "delivered"
                                        ? Icons.timelapse
                                        : Icons.check,
                                size: 35,
                                color: delivery.status != "delivered"
                                    ? delivery.status == "canceled"
                                        ? Colors.red
                                        : Colors.white
                                    : Colors.green,
                              ),
                            ),
                          ),
                          delivery.status != "pending" &&
                                  delivery.status != "canceled"
                              ? const SizedBox()
                              : const Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Icon(
                                    Icons.error,
                                    color: Colors.red,
                                  ),
                                ),
                        ],
                      ),
                      Text("Delivery ${delivery.status}"),
                      delivery.status == 'pending'
                          ? const Text(
                              "You have are not connected to a courier yet!",
                              style: TextStyle(
                                color: Colors.redAccent,
                                fontStyle: FontStyle.italic,
                              ),
                            )
                          : const SizedBox(),
                    ],
                  ),
                  _courierRequest != null && _courierProfile != null
                      ? Card(
                          color: Colors.white,
                          surfaceTintColor: Colors.white,
                          shadowColor: accentColor,
                          child: ListTile(
                            title: Text(_courierProfile!.fullName ?? ""),
                            isThreeLine: true,
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(_courierProfile!.phoneNumber ?? ''),
                                _courierProfile!.phoneNumber == null ||
                                        _courierProfile!.phoneNumber!.isEmpty
                                    ? const SizedBox()
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          MaterialButton(
                                            onPressed:
                                                _courierRequest!.status ==
                                                        "rejected"
                                                    ? null
                                                    : () async {
                                                        final Uri smsLaunchUri =
                                                            Uri(
                                                          scheme: 'tel',
                                                          path:
                                                              "+234${_courierProfile!.phoneNumber!.startsWith("0") ? _courierProfile!.phoneNumber!.substring(1) : _courierProfile!.phoneNumber}",
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
                                            onPressed:
                                                _courierRequest!.status ==
                                                        "rejected"
                                                    ? null
                                                    : () async {
                                                        final Uri smsLaunchUri =
                                                            Uri(
                                                          scheme: 'sms',
                                                          path:
                                                              "+234${_courierProfile!.phoneNumber!.startsWith("0") ? _courierProfile!.phoneNumber!.substring(1) : _courierProfile!.phoneNumber}",
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
                                      ),
                                const Divider(),
                                Center(
                                  child: Text(
                                    _courierRequest!.status ?? "...",
                                    style: TextStyle(
                                      color:
                                          _courierRequest!.status == "rejected"
                                              ? Colors.red
                                              : _courierRequest!.status ==
                                                      "accepted"
                                                  ? Colors.green
                                                  : accentColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            leading: _courierProfile!.profilePicture == null ||
                                    _courierProfile!.profilePicture!.isEmpty ||
                                    courierProfilePicture == null
                                ? const Icon(Icons.person)
                                : Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                      border: Border.all(color: Colors.grey),
                                      image: DecorationImage(
                                        image:
                                            MemoryImage(courierProfilePicture!),
                                      ),
                                    ),
                                  ),
                          ),
                        )
                      : const SizedBox(),
                  _courierRequest == null || _courierProfile == null
                      ? const SizedBox()
                      : Padding(
                          padding: const EdgeInsets.symmetric(vertical: 18.0),
                          child: SizedBox(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: widget.delivery.courierId != null
                                  ? [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            const Flexible(
                                              child: Text(
                                                "Confirm if item is recieved by the courier",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                            FutureBuilder<
                                                DocumentSnapshot<
                                                    Map<String, dynamic>>>(
                                              future: FirebaseFirestore.instance
                                                  .collection("jobs")
                                                  .doc(widget.delivery.id)
                                                  .get(),
                                              builder: (context, snapshot) {
                                                if (snapshot.connectionState ==
                                                    ConnectionState.waiting) {
                                                  return const Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  );
                                                }
                                                if (!snapshot.hasData) {
                                                  return const Text(
                                                    "error",
                                                    style: TextStyle(
                                                        color: Colors.red),
                                                  );
                                                }
                                                var status = snapshot.data!
                                                    .data()!['status'];
                                                return Checkbox(
                                                  activeColor: accentColor,
                                                  value: status == "enroute" ||
                                                      status == "delivered" ||
                                                      status == 'recieved',
                                                  // onChanged: status !=
                                                  //             "enroute" &&
                                                  //         status !=
                                                  //             "delivered" &&
                                                  //         status != 'recieved'
                                                  onChanged: status == 'paid'
                                                      ? (v) async {
                                                          if (v!) {
                                                            await FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    "jobs")
                                                                .doc(widget
                                                                    .delivery
                                                                    .id)
                                                                .update({
                                                              "status":
                                                                  "enroute"
                                                            });
                                                            setState(() {});
                                                          }
                                                        }
                                                      : null,
                                                );
                                              },
                                            )
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            const Flexible(
                                              child: Text(
                                                "Delivery Recieved? ",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                            FutureBuilder<
                                                DocumentSnapshot<
                                                    Map<String, dynamic>>>(
                                              future: FirebaseFirestore.instance
                                                  .collection("jobs")
                                                  .doc(widget.delivery.id)
                                                  .get(),
                                              builder: (context, snapshot) {
                                                if (snapshot.connectionState ==
                                                    ConnectionState.waiting) {
                                                  return const Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  );
                                                }
                                                if (!snapshot.hasData) {
                                                  return const Text(
                                                    "error",
                                                    style: TextStyle(
                                                        color: Colors.red),
                                                  );
                                                }
                                                var status = snapshot.data!
                                                    .data()!['status'];
                                                return Checkbox(
                                                  activeColor: accentColor,
                                                  value: status == "recieved",
                                                  onChanged:
                                                      status == "delivered"
                                                          ? (v) async {
                                                              if (v!) {
                                                                await _markAsDeivered();
                                                              }
                                                            }
                                                          : null,
                                                );
                                              },
                                            )
                                          ],
                                        ),
                                      ),
                                    ]
                                  : [],
                            ),
                          ),
                        ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Delivery fee:",
                          style: TextStyle(
                            fontSize: 18.0,
                          ),
                        ),
                        Text(
                          "N ${widget.delivery.amount ?? '0'}",
                          style: const TextStyle(
                            fontSize: 22.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
