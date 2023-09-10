import 'package:app/constants.dart';
import 'package:app/pages/wallet/add_money.dart';
import 'package:app/pages/wallet/withdraw.dart';
import 'package:app/widgets/buttons.dart';
import 'package:flutter/material.dart';

class Wallet extends StatefulWidget {
  const Wallet({super.key});

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  bool _balanceVisible = true;
  _addBank() async {
    await showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        child: SizedBox(
          height: 400,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    label: const Text("Bank Name"),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: accentColor),
                    ),
                    fillColor: tartiaryColor,
                    focusColor: accentColor,
                  ),
                ),
                TextFormField(
                  decoration: InputDecoration(
                    label: const Text("Account Number"),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: accentColor),
                    ),
                    fillColor: tartiaryColor,
                    focusColor: accentColor,
                  ),
                ),
                TextFormField(
                  decoration: InputDecoration(
                    label: const Text("Account Name"),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: accentColor),
                    ),
                    fillColor: tartiaryColor,
                    focusColor: accentColor,
                  ),
                ),
                MaterialButton(
                  onPressed: () async {
                    await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        surfaceTintColor: Colors.white,
                        backgroundColor: Colors.white,
                        title: const Text("Congratulations"),
                        content: const Text(
                            "Your bank account has been successfully addedto your wallet"),
                        actions: [
                          MaterialButton(
                            onPressed: () => Navigator.of(context).pop(),
                            color: accentColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              "Okay",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                    Navigator.of(context).pop();
                  },
                  child: const GradientDecoratedContainer(
                    child: Text(
                      "Add bank Account",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          "Wallet",
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      backgroundColor: Color.fromARGB(255, 227, 227, 227),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 200,
                width: double.maxFinite,
                decoration: BoxDecoration(
                  color: accentColor,
                  borderRadius: BorderRadius.circular(30),
                ),
                alignment: Alignment.center,
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "Available Balance:",
                          style: TextStyle(
                            color: Colors.white70,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => setState(
                              () => _balanceVisible = !_balanceVisible),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              _balanceVisible
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.white70,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          _balanceVisible ? "N15,000.00" : "* * * *",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const AddMoneyPage(),
                            ),
                          ),
                          child: Column(
                            children: [
                              Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: tartiaryColor,
                                ),
                                alignment: Alignment.center,
                                child: Icon(
                                  Icons.money,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                "Add Money",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const WithdrawMoneyPage(),
                            ),
                          ),
                          child: Column(
                            children: [
                              Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: tartiaryColor,
                                ),
                                alignment: Alignment.center,
                                child: const Icon(
                                  Icons.remove,
                                  color: Colors.white,
                                ),
                              ),
                              const Text(
                                "Withraw",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: _addBank,
                          child: Column(
                            children: [
                              Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: tartiaryColor,
                                ),
                                alignment: Alignment.center,
                                child: const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ),
                              ),
                              const Text(
                                "Add Bank",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: tartiaryColor,
              ),
              padding: EdgeInsets.all(6.0),
              child: Row(
                children: [
                  Text(
                    "Linked Bank Account: ",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12.0,
                    ),
                  ),
                  SizedBox(
                    width: 6,
                  ),
                  Text("754234567"),
                  Spacer(),
                  GestureDetector(
                    onTap: () async {
                      var res = await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          backgroundColor: Colors.white,
                          surfaceTintColor: Colors.white,
                          content: Text("Remove bank account?"),
                          actionsAlignment: MainAxisAlignment.spaceEvenly,
                          actions: [
                            MaterialButton(
                              onPressed: () => Navigator.of(context).pop(1),
                              color: accentColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text("Okay"),
                            ),
                            MaterialButton(
                              onPressed: () => Navigator.of(context).pop(0),
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: BorderSide(
                                  color: Colors.red,
                                ),
                              ),
                              child: Text(
                                "Cancel",
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    child: const Text(
                      "remove",
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: _addBank,
                    child: const Text(
                      "edit",
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(
                left: 8.0,
                right: 8.0,
                top: 4.0,
              ),
              child: Row(
                children: [
                  Text(
                    "Transactions History",
                    style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListView(
                    children: [
                      Card(
                        color: Colors.white,
                        surfaceTintColor: Colors.white,
                        child: ListTile(
                          title: Text("Credit"),
                          subtitle: Text(
                            "28-12-2023",
                            style: TextStyle(color: Colors.grey),
                          ),
                          trailing: Text(
                            "+ N1,000",
                            style: TextStyle(
                              color: Colors.green,
                            ),
                          ),
                        ),
                      ),
                      Card(
                        color: Colors.white,
                        surfaceTintColor: Colors.white,
                        child: ListTile(
                          title: Text("Delivery paid"),
                          subtitle: Text(
                            "28-12-2023",
                            style: TextStyle(color: Colors.grey),
                          ),
                          trailing: Text(
                            "- N1,000",
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
