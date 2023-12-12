import 'package:app/constants.dart';
import 'package:app/data/wallet_data.dart';
import 'package:app/data/withdrawal_requests.dart';
import 'package:app/widgets/buttons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WithdrawMoneyPage extends StatefulWidget {
  final num balance;
  const WithdrawMoneyPage({
    super.key,
    required this.balance,
  });

  @override
  State<WithdrawMoneyPage> createState() => _WithdrawMoneyPageState();
}

class _WithdrawMoneyPageState extends State<WithdrawMoneyPage> {
  final TextEditingController _amountController = TextEditingController();
  Wallet? _wallet;
  var uid = FirebaseAuth.instance.currentUser!.uid;

  _getWallet() async {
    var wallet =
        await FirebaseFirestore.instance.collection("wallets").doc(uid).get();
    if (wallet.exists) {
      setState(() {
        _wallet = Wallet.fromMap(wallet.data()!);
      });
    }
  }

  _requestWithdraw() async {
    var uid = FirebaseAuth.instance.currentUser!.uid;

    var amount = double.parse(
        _amountController.text.isEmpty ? "0" : _amountController.text);
    if (amount > widget.balance) {
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: const Text(
            "You do not have enought balance in your wallet to withraw this amount.",
          ),
          actions: [
            MaterialButton(
              onPressed: () => Navigator.of(context).pop(),
              color: accentColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text("Okay"),
            ),
          ],
        ),
      );
      return;
    }

    if (_wallet!.accountName!.isEmpty ||
        _wallet!.accountNumber!.isEmpty ||
        _wallet!.bankName!.isEmpty) {
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: const Text(
            "You have not provided your bank information, Please Make sure you do so.",
          ),
          actions: [
            MaterialButton(
              onPressed: () => Navigator.of(context).pop(),
              color: accentColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text("Okay"),
            ),
          ],
        ),
      );
      return;
    }

    var req = WalletCashOutRquest(
      amount: amount,
      time: Timestamp.now(),
      status: "requested",
      walletId: uid,
      accountName: _wallet!.accountName!,
      accountNumber: _wallet!.accountNumber,
      bankName: _wallet!.bankName,
    );

    var batch = FirebaseFirestore.instance.batch();

    batch.set(
      FirebaseFirestore.instance.collection("withdrawal_requests").doc(),
      req.toMap(),
    );

    batch.set(FirebaseFirestore.instance.collection("activities").doc(), {
      "uid": uid,
      "activity": "Requested withrawal of $amount",
      "time": Timestamp.now(),
    });

    await batch.commit();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: const Text(
          "Your request to withdraw money from you wallet has been recieved and is being processed.",
        ),
        actions: [
          MaterialButton(
            onPressed: () => Navigator.of(context).pop(),
            color: accentColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text("Okay"),
          ),
        ],
      ),
    );
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _getWallet();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Withdraw Money"),
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
      floatingActionButton: widget.balance < 100.0 || _wallet == null
          ? null
          : Padding(
              padding: const EdgeInsets.all(18.0),
              child: MaterialButton(
                onPressed: _requestWithdraw,
                child: const GradientDecoratedContainer(
                  child: Text(
                    "Proceed to withdraw",
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
                  initialValue:
                      "N ${NumberFormat("###.0#", "en_US").format(widget.balance)}",
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text("Amount to Withdraw:"),
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
                  controller: _amountController,
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
