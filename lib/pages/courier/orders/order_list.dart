import 'package:app/pages/courier/orders/order_details.dart';
import 'package:flutter/material.dart';

class OrderList extends StatefulWidget {
  const OrderList({super.key});

  @override
  State<OrderList> createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            borderOnForeground: true,
            surfaceTintColor: Colors.white,
            color: Colors.white,
            child: ListTile(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const OrderDetails(),
                ),
              ),
              title: Text("Ahmad Abdullahi"),
              leading: Icon(Icons.person),
              subtitle: Row(
                children: [
                  Icon(Icons.location_pin),
                  Text("kano state"),
                  Spacer(),
                  Text("pending..."),
                ],
              ),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
          ),
        ),
      ],
    );
  }
}
