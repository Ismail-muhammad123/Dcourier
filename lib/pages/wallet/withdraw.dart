import 'package:app/constants.dart';
import 'package:app/data/wallet_data.dart';
import 'package:app/data/withdrawal_requests.dart';
import 'package:app/widgets/buttons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WithdrawMoneyPage extends StatefulWidget {
  const WithdrawMoneyPage({super.key});

  @override
  State<WithdrawMoneyPage> createState() => _WithdrawMoneyPageState();
}

class _WithdrawMoneyPageState extends State<WithdrawMoneyPage> {
  final TextEditingController _amountController = TextEditingController();
  double _availableBalance = 0.0;
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

  _getWalletBalance() async {
    var transactions = await FirebaseFirestore.instance
        .collection("wallet_transactions")
        .where("owner", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();
    double balance = 0;
    for (var i in transactions.docs) {
      balance = balance +
          (i.data()['credit_amoun'] ?? 0) -
          (i.data()['debit_amount'] ?? 0);
    }
    // var walletBalance = await getBalancefunc.call<num>();
    // var balance = walletBalance.data;
    // print("balance: $balance");
    setState(() {
      _availableBalance = balance;
    });
  }

  _requestWithdraw() async {
    var uid = FirebaseAuth.instance.currentUser!.uid;

    var amount = double.parse(_amountController.text);
    if (amount > _availableBalance) {
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
    var req = WalletCashOutRquest(
        amount: amount,
        time: Timestamp.now(),
        status: "requested",
        walletId: uid,
        accountName: _wallet!.accountName!,
        accountNumber: _wallet!.accountNumber,
        bankName: _wallet!.bankName);
      
    var batch = FirebaseFirestore.instance.batch();

    batch.set(FirebaseFirestore.instance
        .collection("withdrawal_requests").doc(), req.toMap()!); 
    
    
    
    batch.set(FirebaseFirestore.instance
        .collection("activities").doc(), {
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
    _getWalletBalance();
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
      floatingActionButton: _availableBalance < 100.0 || _wallet == null
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
                      "N ${NumberFormat("###.0#", "en_US").format(_availableBalance)}",
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
                  initialValue: "1,000.00",
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
