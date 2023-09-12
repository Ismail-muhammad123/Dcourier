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

  List<Widget> _navPages = [
    HomeTab(),
    OrdersTab(),
    AccountTab(),
  ];

  _changeNab(int index) => setState(() => _selectedIndex = index);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
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
      body: SafeArea(
        child: Center(child: _navPages[_selectedIndex]),
      ),
    );
  }
}
