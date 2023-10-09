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
  bool _isPicked = false;
  bool _isRecieved = false;
  JobRequest? _courierRequest;
  Profile? _courierProfile;

  var SendMoneyfunc = FirebaseFunctions.instance.httpsCallable("send_money");
  var getBalancefunc =
      FirebaseFunctions.instance.httpsCallable("get_wallet_balance");

  Future<double> _getWalletBalance() async {
    var transactions = await FirebaseFirestore.instance
        .collection("wallet_transactions")
        .where("owner", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();
    double balance = 0;
    for (var i in transactions.docs) {
      balance = balance +
          ((i.data()['credit_amoun'] ?? 0) as double) -
          ((i.data()['debit_amount'] ?? 0) as double);
    }
    return balance;
  }

  _make_payment() async {
    var walletBalance = await getBalancefunc.call();

    var balance = walletBalance.data;
    // var balance = await _getWalletBalance();

    if (balance >= widget.delivery.amount!) {
      var res = await SendMoneyfunc.call({
        "reciever_id": _courierProfile!.id,
        "amount": widget.delivery.id,
      });

      if (res.data == 1) {
        await FirebaseFirestore.instance
            .collection('jobs')
            .doc(widget.delivery.id)
            .update({
          "courier_id": _courierProfile!.id,
          "status": "paid",
        });

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PaymentSuccess(
              amount: (widget.delivery.amount ?? 0.0) as double,
              recieverName: widget.delivery.recieverName ?? "",
              recieverPhone: widget.delivery.recieverPhoneNumber ?? "",
            ),
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
      if (r == 1) {
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const Wallet(),
          ),
        );
      }
      return;
    }
  }

  _deleteDelevery() async {
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
      await FirebaseFirestore.instance
          .collection("jobs")
          .doc(delv.id)
          .update({"status": "canceled"});
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
      floatingActionButton: widget.delivery.status == "paid" ||
              widget.delivery.status == "delivered"
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
                  onPressed: _make_payment,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          border:
                                              Border.all(color: accentColor),
                                          color: delivery.status == "paid"
                                              ? accentColor
                                              : Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(20),
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
                                          border:
                                              Border.all(color: accentColor),
                                          color: delivery.status == "enroute"
                                              ? accentColor
                                              : Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(20),
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
                                          border:
                                              Border.all(color: accentColor),
                                          color: delivery.status == "delivered"
                                              ? accentColor
                                              : Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(20),
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
                                  )
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
                            : SizedBox(),
                      ],
                    ),
                    _courierRequest != null && _courierProfile != null
                        ? Card(
                            color: Colors.white,
                            surfaceTintColor: Colors.white,
                            shadowColor: accentColor,
                            child: ListTile(
                              // onTap:
                              //     _isLoading ? null : () => _createRequest(profile),
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
                                              onPressed: _courierRequest!
                                                          .status ==
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
                                              onPressed: _courierRequest!
                                                          .status ==
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
                                                  Icon(
                                                      FontAwesomeIcons.message),
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
                                        color: _courierRequest!.status ==
                                                "rejected"
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
                              leading: _courierProfile!.profilePicture ==
                                          null ||
                                      _courierProfile!.profilePicture!.isEmpty
                                  ? null
                                  : FutureBuilder<Uint8List?>(
                                      future: FirebaseStorage.instance
                                          .ref()
                                          .child(
                                              _courierProfile!.profilePicture!)
                                          .getData(),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData &&
                                            snapshot.data!.isNotEmpty) {
                                          var data = snapshot.data;

                                          return Container(
                                            height: 50,
                                            width: 50,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                              border: Border.all(
                                                  color: Colors.grey),
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
                          )
                        : const SizedBox(),
                    _courierRequest == null || _courierProfile == null
                        ? const SizedBox()
                        : Padding(
                            padding: const EdgeInsets.symmetric(vertical: 18.0),
                            child: SizedBox(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: widget.delivery.courierId != null &&
                                        widget.delivery.courierId ==
                                            _courierProfile!.id
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
                                                future: FirebaseFirestore
                                                    .instance
                                                    .collection("jobs")
                                                    .doc(widget.delivery.id)
                                                    .get(),
                                                builder: (context, snapshot) {
                                                  if (snapshot
                                                          .connectionState ==
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
                                                    value: status ==
                                                            "enroute" ||
                                                        status == "delivered",
                                                    onChanged: status !=
                                                                "enroute" &&
                                                            status !=
                                                                "delivered"
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
          }),
    );
  }
}
