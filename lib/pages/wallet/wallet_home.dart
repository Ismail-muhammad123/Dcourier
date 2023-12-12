import 'package:app/constants.dart';
import 'package:app/data/wallet_data.dart';
import 'package:app/data/wallet_transactions_history.dart';
import 'package:app/pages/wallet/add_money.dart';
import 'package:app/pages/wallet/withdraw.dart';
import 'package:app/widgets/buttons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WalletHome extends StatefulWidget {
  const WalletHome({super.key});

  @override
  State<WalletHome> createState() => _WalletHomeState();
}

class _WalletHomeState extends State<WalletHome> {
  final TextEditingController _bankNameController = TextEditingController();
  final TextEditingController _accountNameController = TextEditingController();
  final TextEditingController _accountNumberController =
      TextEditingController();

  var uid = FirebaseAuth.instance.currentUser!.uid;

  bool _balanceVisible = true;
  double _availableBalance = 0;

  Wallet? _wallet;

  _getWallet() async {
    var wallet =
        await FirebaseFirestore.instance.collection("wallets").doc(uid).get();
    if (wallet.exists) {
      setState(() {
        _wallet = Wallet.fromMap(wallet.data()!);
      });
    } else {
      setState(() {
        _wallet = Wallet(accountName: "", accountNumber: "", bankName: '');
      });
    }
  }

  _getWalletBalance() async {
    var transactions = await FirebaseFirestore.instance
        .collection("wallet_transactions")
        .where("uid", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();
    double balance = 0;
    for (var i in transactions.docs) {
      balance = balance +
          (i.data()['credit_amount'] ?? 0) -
          (i.data()['debit_amount'] ?? 0);
    }
    // var walletBalance = await getBalancefunc.call<num>();
    // var balance = walletBalance.data;
    print("balance: $balance");

    setState(() {
      _availableBalance = balance;
    });
  }

  _addBank() async {
    if (_wallet != null) {
      _bankNameController.text = _wallet!.bankName!;
      _accountNameController.text = _wallet!.accountName!;
      _accountNumberController.text = _wallet!.accountNumber!;
    }
    await showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        child: SizedBox(
          height: 400,
          child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              future: FirebaseFirestore.instance
                  .collection("wallets")
                  .doc(uid)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (!snapshot.hasData) {
                  return const Center(
                    child: Text("Wallet not found"),
                  );
                }
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextFormField(
                        controller: _bankNameController,
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
                        controller: _accountNumberController,
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
                        controller: _accountNameController,
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
                        onPressed: _wallet == null
                            ? null
                            : () async {
                                var w = Wallet(
                                  accountName: _accountNameController.text,
                                  accountNumber: _accountNumberController.text,
                                  bankName: _bankNameController.text,
                                  status: _wallet!.status ?? "",
                                );
                                await FirebaseFirestore.instance
                                    .collection('wallets')
                                    .doc(uid)
                                    .set(w.toMap());
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        "Your bank account has been successfully addedto your wallet"),
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
                );
              }),
        ),
      ),
    );
  }

  @override
  void initState() {
    _getWallet();
    _getWalletBalance();
    super.initState();
  }

  @override
  void dispose() {
    _bankNameController.dispose();
    _accountNameController.dispose();
    _accountNumberController.dispose();
    super.dispose();
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
      backgroundColor: const Color.fromARGB(255, 227, 227, 227),
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
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Text(
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
                          _balanceVisible
                              ? NumberFormat("###,###,###.0#", "en_US")
                                  .format(_availableBalance)
                              : "* * * *",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => AddMoneyPage(
                                  balance: _availableBalance,
                                ),
                              ),
                            );
                            _getWalletBalance();
                          },
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
                                  Icons.money,
                                  color: Colors.white,
                                ),
                              ),
                              const Text(
                                "Add Money",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => WithdrawMoneyPage(
                                  balance: _availableBalance,
                                ),
                              ),
                            );
                            _getWalletBalance();
                          },
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
              padding: const EdgeInsets.all(6.0),
              child: Row(
                children: [
                  const Text(
                    "Linked Bank Account: ",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12.0,
                    ),
                  ),
                  const SizedBox(
                    width: 6,
                  ),
                  Text(_wallet != null ? _wallet!.accountNumber ?? '' : ""),
                  const Spacer(),
                  GestureDetector(
                    onTap: () async {
                      var res = await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          backgroundColor: Colors.white,
                          surfaceTintColor: Colors.white,
                          content: const Text("Remove bank account?"),
                          actionsAlignment: MainAxisAlignment.spaceEvenly,
                          actions: [
                            MaterialButton(
                              onPressed: () => Navigator.of(context).pop(1),
                              color: accentColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text("Yes"),
                            ),
                            MaterialButton(
                              onPressed: () => Navigator.of(context).pop(0),
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: const BorderSide(
                                  color: Colors.red,
                                ),
                              ),
                              child: const Text(
                                "Cancel",
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                      if (res == 1) {
                        var w = Wallet(
                            accountName: "",
                            accountNumber: "",
                            bankName: "",
                            status: _wallet!.status);

                        await FirebaseFirestore.instance
                            .collection('wallets')
                            .doc(uid)
                            .update(w.toMap());
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Account Details removed"),
                          ),
                        );
                      }
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
                  child: FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection("wallet_transactions")
                        .where("uid", isEqualTo: uid)
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (!snapshot.hasData) {
                        return const Center(
                          child: Text("an error has occured"),
                        );
                      }
                      List<WalletTransactions> data = snapshot.data!.docs
                          .map(
                            (e) => WalletTransactions.fromMap(e.data()),
                          )
                          .toList();
                      data.sort((a, b) => b.time!.compareTo(a.time!));
                      return ListView(
                        children: data
                            .map(
                              (e) => Card(
                                color: Colors.white,
                                surfaceTintColor: Colors.white,
                                child: ListTile(
                                  title: Text((e.creditAmount!).toDouble() > 0.0
                                      ? "Credit"
                                      : "Debit"),
                                  subtitle: Text(
                                    DateFormat.yMMMEd().add_jm().format(
                                          e.time!.toDate(),
                                        ),
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                  trailing: Text(
                                    e.description ??
                                        "${e.creditAmount! > 0 ? 'Credited' : 'Debited'} N ${e.creditAmount! > 0 ? e.creditAmount : e.debitAmount}",
                                    style: TextStyle(
                                      color: e.debitAmount! > e.creditAmount!
                                          ? Colors.red
                                          : Colors.green,
                                    ),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      );
                    },
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
