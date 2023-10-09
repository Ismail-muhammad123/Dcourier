import 'package:app/constants.dart';
import 'package:app/pages/courier/account/account_tab.dart';
import 'package:app/pages/courier/home/home_tab.dart';
import 'package:flutter/material.dart';
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
        backgroundColor: Color(0xFFFFFF).withOpacity(0.8),
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
                              "Order List",
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
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
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
                          ),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CircleAvatar(
                                  child: Icon(Icons.person),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Ahmad Abullahi",
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
                                        "096578864334",
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
                                        "Na'ibawa",
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
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 8.0,
        items: [
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
