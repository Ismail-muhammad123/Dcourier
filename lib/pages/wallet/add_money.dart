import 'package:app/widgets/buttons.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'checkout_webview_page.dart';

class AddMoneyPage extends StatefulWidget {
  final num? balance;
  const AddMoneyPage({
    super.key,
    required this.balance,
  });

  @override
  State<AddMoneyPage> createState() => _AddMoneyPageState();
}

class _AddMoneyPageState extends State<AddMoneyPage> {
  bool _isLoading = false;
  final TextEditingController amountController = TextEditingController();
  var chargeFunction =
      FirebaseFunctions.instance.httpsCallable("initiateCharge");

  _initiateCrediting() async {
    setState(() {
      _isLoading = true;
    });
    var amount = double.parse(
      amountController.text.isEmpty ? '0' : amountController.text,
    );

    var res =
        await chargeFunction.call<Map<String, dynamic>>({"amount": amount});
    print(res.data['status']);
    if (res.data['status'] == 'success') {
      var url = res.data['url'][0];
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => CheckoutWebView(url: url),
        ),
      );
    }
    // print(res.data);
    setState(() {
      _isLoading = false;
    });
    // await showDialog(
    //           context: context,
    //           builder: (context) => AlertDialog(
    //             content: const Text(
    //               "You have successfully credited you account with N1,500",
    //             ),
    //             actions: [
    //               MaterialButton(
    //                 onPressed: () => Navigator.of(context).pop(),
    //                 color: accentColor,
    //                 shape: RoundedRectangleBorder(
    //                   borderRadius: BorderRadius.circular(20),
    //                 ),
    //                 child: const Text("Okay"),
    //               ),
    //             ],
    //           ),
    //         );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Money"),
        centerTitle: true,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 227, 227, 227),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(18.0),
        child: MaterialButton(
          onPressed: _isLoading
              ? null
              : () async {
                  // Navigator.of(context).pop();
                  await _initiateCrediting();
                },
          child: GradientDecoratedContainer(
            child: _isLoading
                ? const CircularProgressIndicator()
                : const Text(
                    "Proceed",
                    style: TextStyle(color: Colors.white),
                  ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text("Wallet Balance:"),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextFormField(
                  enabled: false,
                  initialValue: NumberFormat.currency(symbol: "NGN ")
                      .format(widget.balance ?? 0),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text("Amount to add:"),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextFormField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
