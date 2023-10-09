import 'package:flutter/material.dart';
import 'history.dart';
import 'delivery_request.dart';

class OrdersTab extends StatefulWidget {
  const OrdersTab({super.key});

  @override
  State<OrdersTab> createState() => _OrdersTabState();
}

class _OrdersTabState extends State<OrdersTab> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          leading: null,
          bottom: const TabBar(
            tabs: [
              Tab(
                text: "Requests",
              ),
              Tab(
                text: "History",
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            Center(
              child: OrderRequest(),
            ),
            Center(
              child: DeliveryHistory(),
            ),
          ],
        ),
      ),
    );
  }
}
