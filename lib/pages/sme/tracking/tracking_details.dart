import 'package:app/constants.dart';
import 'package:app/pages/sme/tracking/payment_success.dart';
import 'package:app/widgets/buttons.dart';
import 'package:flutter/material.dart';

class TrackingDetail extends StatefulWidget {
  const TrackingDetail({super.key});

  @override
  State<TrackingDetail> createState() => _TrackingDetailState();
}

class _TrackingDetailState extends State<TrackingDetail> {
  bool _isPicked = false;
  bool _isRecieved = false;

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
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SizedBox(
        width: 250,
        child: MaterialButton(
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const PaymentSuccess(),
            ),
          ),
          child: const GradientDecoratedContainer(
            child: Text(
              "Proceed to payment",
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
                          width: 500,
                          height: 2,
                          color: accentColor,
                        ),
                      ),
                      SizedBox(
                        width: 500,
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
                                    color:
                                        _isPicked ? accentColor : Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Icon(Icons.check),
                                ),
                                const Text("Picked")
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
                                Text("En route")
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
                                Text("Delivered"),
                              ],
                            ),
                            Column(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: accentColor),
                                    color: _isRecieved
                                        ? accentColor
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Icon(Icons.check),
                                ),
                                Text("Recieved"),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    const Flexible(
                      child: Text(
                        "Confirm if item is recieved at the destination",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Checkbox(
                      activeColor: accentColor,
                      value: _isRecieved,
                      onChanged: (v) => setState(
                        () {
                          _isRecieved = v as bool;
                        },
                      ),
                    )
                  ],
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
