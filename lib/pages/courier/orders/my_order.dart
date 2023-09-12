import 'package:flutter/material.dart';

import 'order_list.dart';


class MyOrders extends StatefulWidget {
  const MyOrders({super.key});

  @override
  State<MyOrders> createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  bool _isEmpty = false;
  @override
  Widget build(BuildContext context) {
    return _isEmpty ? Image.asset("images/no_event.png") : const OrderList();
  }
}
