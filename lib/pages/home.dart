import 'package:app/pages/courier/home/courier_home.dart';
import 'package:app/pages/sme/profile/edit_profile.dart';
import 'package:app/pages/sme/home/sme_home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../data/profile_data.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String errorMessage = "";
  bool isError = false;

  int? accountType;

  _selectAccountType() async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: const Text(
            "You have not set up your profile. Please select account type to proceed..."),
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        actions: [
          MaterialButton(
            onPressed: () => Navigator.of(context).pop(1),
            child: Text("SME"),
          ),
          MaterialButton(
            onPressed: () => Navigator.of(context).pop(2),
            child: Text("Courier"),
          ),
          MaterialButton(
            onPressed: () => Navigator.of(context).pop(0),
            child: Text("Logout"),
          ),
        ],
      ),
    );
  }

  Future _getAccountType() async {
    var accountType = "";
    var uid = FirebaseAuth.instance.currentUser?.uid;
    var profile =
        await FirebaseFirestore.instance.collection("profiles").doc(uid).get();
    if (profile.exists) {
      var profileObj = Profile.fromMap(profile.data()!);
      accountType = profileObj.accountType ?? "";
    } else {
      var res = await _selectAccountType();
      accountType = res == 1
          ? "sme"
          : res == 2
              ? "courier"
              : "";
    }
    print("Account type:");
    print(accountType);
    switch (accountType) {
      case "sme":
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const SMEHomePage(),
          ),
        );
        break;
      case "courier":
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                "Your Account is not verified yet, you will not be able to accept any delivery"),
          ),
        );
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const CourierHome(),
          ),
        );
        break;
      default:
        await FirebaseAuth.instance.signOut();
    }
  }

  @override
  void initState() {
    _getAccountType();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
