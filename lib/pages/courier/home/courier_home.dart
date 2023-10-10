import 'package:app/constants.dart';
import 'package:app/data/delivery_data.dart';
import 'package:app/data/job_request_data.dart';
import 'package:app/pages/courier/account/account_tab.dart';
import 'package:app/pages/courier/home/home_tab.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../orders/order_details.dart';
import '../orders/orders_tab.dart';

class CourierHome extends StatefulWidget {
  const CourierHome({super.key});

  @override
  State<CourierHome> createState() => _CourierHomeState();
}

class _CourierHomeState extends State<CourierHome> {
  int _selectedIndex = 0;

  final List<Widget> _navPages = const [
    HomeTab(),
    OrdersTab(),
    AccountTab(),
  ];

  _changeNab(int index) => setState(() => _selectedIndex = index);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        // backgroundColor: const Color(0x00ffffff).withOpacity(0.8),
        backgroundColor: Colors.white,
        child: SafeArea(
          child: Column(
            children: [
              Container(
                height: 120,
                width: double.maxFinite,
                alignment: Alignment.bottomLeft,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: Icon(
                            Icons.clear,
                            color: primaryColor,
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconButton(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: const Text(
                              "Delivery List",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(),
              Flexible(
                child: SingleChildScrollView(
                  child: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    future: FirebaseFirestore.instance
                        .collection("jobs")
                        .where('courier_id',
                            isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (!snapshot.hasData) {
                        return const Center(
                          child: Text(
                            "error",
                            style: TextStyle(color: Colors.red),
                          ),
                        );
                      }

                      var deliveries = snapshot.data!.docs.map(
                        (e) {
                          var d = Delivery.fromMap(
                            e.data(),
                          );
                          d.id = e.id;
                          return d;
                        },
                      ).where((element) =>
                          element.status == "pending" ||
                          element.status == "processing" ||
                          element.status == "enroute");

                      if (deliveries.isEmpty) {
                        return const Center(
                          child: Text(
                            "You have no active deliveries.",
                            style: TextStyle(color: Colors.grey),
                          ),
                        );
                      }

                      return Column(
                        children: deliveries
                            .map(
                              (d) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: GestureDetector(
                                  onTap: () async {
                                    FirebaseFirestore.instance
                                        .collection('request')
                                        .where("job_id", isEqualTo: d.id)
                                        .get()
                                        .then(
                                          (value) => Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  OrderDetails(
                                                delivery: d,
                                                request: JobRequest.fromMap(
                                                  value.docs.first.data(),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(8.0),
                                    height: 100,
                                    width: double.maxFinite,
                                    decoration: BoxDecoration(
                                      border: Border(
                                        top: BorderSide(color: accentColor),
                                        bottom: BorderSide(color: accentColor),
                                        right: BorderSide(color: accentColor),
                                        left: BorderSide(
                                          color: accentColor,
                                          width: 5.0,
                                        ),
                                      ),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          blurRadius: 8.0,
                                          offset: const Offset(4, 4),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: CircleAvatar(
                                            child: Icon(Icons.route),
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "To: ${d.recieverName ?? ''}",
                                              style: TextStyle(
                                                color: primaryColor,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.phone,
                                                  color: accentColor,
                                                ),
                                                Text(
                                                  d.recieverPhoneNumber ?? "",
                                                  style: TextStyle(
                                                    color: accentColor,
                                                  ),
                                                )
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.location_pin,
                                                  color: accentColor,
                                                ),
                                                Text(
                                                  d.deliveryAddress ?? "",
                                                  style: TextStyle(
                                                    color: accentColor,
                                                  ),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
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
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 8.0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.route),
            label: "Orders",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Account",
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: accentColor,
        onTap: _changeNab,
      ),
      // bottomNavigationBar: Container(
      //   width: double.maxFinite,
      //   height: 70,
      //   alignment: Alignment.center,
      //   decoration: BoxDecoration(
      //     color: Colors.white,
      //     borderRadius: BorderRadius.vertical(
      //       top: Radius.circular(20),
      //     ),
      //   ),
      //   child: Row(
      //     crossAxisAlignment: CrossAxisAlignment.center,
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: [
      //       BottomNavItem(
      //         icon: Icon(Icons.home),
      //         label: "Home",
      //       ),
      //       BottomNavItem(
      //         icon: Icon(Icons.route),
      //         label: "Orders",
      //       ),
      //       BottomNavItem(
      //         icon: Icon(Icons.person),
      //         label: "Account",
      //       ),
      //     ],
      //   ),
      // ),
      body: SafeArea(
        child: Center(child: _navPages[_selectedIndex]),
      ),
    );
  }
}

class BottomNavItem extends StatelessWidget {
  final Icon icon;
  final String? label;
  const BottomNavItem({super.key, required this.icon, this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [icon, Text(label ?? "")],
      ),
    );
  }
}
