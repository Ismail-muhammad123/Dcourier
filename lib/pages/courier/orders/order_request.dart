import 'package:flutter/material.dart';

import '../../../constants.dart';
import 'order_list.dart';



class OrderRequest extends StatefulWidget {
  const OrderRequest({super.key});

  @override
  State<OrderRequest> createState() => OrderRequestState();
}

class OrderRequestState extends State<OrderRequest> {
  bool _isEmpty = false;
  @override
  Widget build(BuildContext context) {
    return _isEmpty
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("images/no_orders.png"),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Sorry! nothing yet.",
                  style: TextStyle(
                    color: accentColor,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "We will notify you or new order request.",
                ),
              )
            ],
          )
        : OrderList();
  }
}
