import 'package:app/constants.dart';
import 'package:app/data/delivery_data.dart';
import 'package:app/pages/sme/available_couriers.dart';
import 'package:app/pages/sme/tracking/payment_success.dart';
import 'package:app/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:cloud_functions/cloud_functions.dart';

class TrackingDetail extends StatefulWidget {
  final Delivery delivery;
  const TrackingDetail({required this.delivery, super.key});

  @override
  State<TrackingDetail> createState() => _TrackingDetailState();
}

class _TrackingDetailState extends State<TrackingDetail> {
  bool _isPicked = false;
  bool _isRecieved = false;

  // Firebase`Function functions = FirebaseFunction.instance;

  _make_payment() async {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const PaymentSuccess(),
      ),
    );
  }

  _deleteDelevery() async {}

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
        actions: widget.delivery.courierId == null
            ? [
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: _deleteDelevery,
                ),
              ]
            : null,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SizedBox(
        width: 250,
        child: MaterialButton(
          onPressed: widget.delivery.courierId == null
              ? () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          CourierList(delivery: widget.delivery),
                    ),
                  )
              : _make_payment,
          child: GradientDecoratedContainer(
            child: Text(
              widget.delivery.courierId != null
                  ? "Proceed to payment"
                  : "Find a Courier",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
      body: Padding(
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
                                    color: Colors.white,
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
                                    color: Colors.white,
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
                                    color: Colors.white,
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
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 18.0),
                child: SizedBox(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: widget.delivery.courierId != null
                        ? [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                color: accentColor,
                                surfaceTintColor: accentColor,
                                child: const ListTile(
                                  leading: Icon(
                                    Icons.person,
                                    color: Colors.white,
                                  ),
                                  title: Text(
                                    "Ahmad Abdullahi",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  subtitle: Text(
                                    "075789065678",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
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
                                  Checkbox(
                                    activeColor: accentColor,
                                    value: _isPicked,
                                    onChanged: (v) => setState(
                                      () {
                                        _isPicked = v as bool;
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ]
                        : [
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
                                    child: const Icon(
                                      Icons.timelapse,
                                      size: 35,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                const Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Icon(
                                    Icons.error,
                                    color: Colors.red,
                                  ),
                                )
                              ],
                            ),
                            const Text("Payment pending"),
                            const Text(
                              "You have are not connected to a courier yet!",
                              style: TextStyle(
                                color: Colors.redAccent,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Delivery fee:",
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                    Text(
                      "N800",
                      style: TextStyle(
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
      ),
    );
  }
}
