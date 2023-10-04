import 'package:app/constants.dart';
import 'package:app/pages/base.dart';
import 'package:app/pages/courier/perfomance/performance.dart';
import 'package:app/pages/courier/profile/edit_profile.dart';
import 'package:app/pages/sme/support/support.dart';
import 'package:app/pages/wallet/wallet_home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AccountTab extends StatefulWidget {
  const AccountTab({super.key});

  @override
  State<AccountTab> createState() => AccountTabState();
}

class AccountTabState extends State<AccountTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                alignment: Alignment.center,
                height: 250,
                width: double.maxFinite,
                decoration: BoxDecoration(
                  color: accentColor,
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(25),
                  ),
                ),
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Container(
                      height: 60,
                      width: 60,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 3),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Icon(
                        Icons.person,
                        size: 50,
                        color: Colors.white,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Hi, Ahmad abdullahi",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            "098765345678",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Container(
                padding: const EdgeInsets.all(30),
                width: double.maxFinite,
                height: MediaQuery.of(context).size.height - 280,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(30)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      offset: const Offset(4, 4),
                      blurRadius: 12.0,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Flexible(
                      child: GridView.count(
                        crossAxisCount: 2,
                        childAspectRatio: 1,
                        mainAxisSpacing: 30,
                        crossAxisSpacing: 30,
                        scrollDirection: Axis.vertical,
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const EditProfileForm(),
                              ),
                            ),
                            child: Card(
                              elevation: 8.0,
                              color: Colors.white,
                              surfaceTintColor: Colors.white,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(Icons.person,
                                      size: 50, color: accentColor),
                                  Text(
                                    "My Profile",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: accentColor),
                                  )
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const Wallet(),
                              ),
                            ),
                            child: Card(
                              elevation: 8.0,
                              color: Colors.white,
                              surfaceTintColor: Colors.white,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(Icons.wallet,
                                      size: 50, color: accentColor),
                                  Text(
                                    "Wallet",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: accentColor),
                                  )
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const SupportPage(),
                              ),
                            ),
                            child: Card(
                              elevation: 8.0,
                              color: Colors.white,
                              surfaceTintColor: Colors.white,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.help,
                                    size: 50,
                                    color: accentColor,
                                  ),
                                  Text(
                                    "Support",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: accentColor),
                                  )
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const Performance(),
                              ),
                            ),
                            child: Card(
                              elevation: 8.0,
                              color: Colors.white,
                              surfaceTintColor: Colors.white,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.speed,
                                    size: 50,
                                    color: accentColor,
                                  ),
                                  Text(
                                    "Performance",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: accentColor),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        int? res = await showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => AlertDialog(
                            backgroundColor: Colors.white,
                            surfaceTintColor: Colors.white,
                            content: const Text(
                              "logout?",
                              textAlign: TextAlign.center,
                            ),
                            actionsAlignment: MainAxisAlignment.spaceEvenly,
                            actions: [
                              MaterialButton(
                                onPressed: () => Navigator.of(context).pop(0),
                                color: accentColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Text(
                                  "No",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              MaterialButton(
                                onPressed: () => Navigator.of(context).pop(1),
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  side: const BorderSide(
                                    color: Colors.red,
                                    width: 1,
                                  ),
                                ),
                                child: const Text(
                                  "Yes",
                                  style: TextStyle(
                                    color: Colors.red,
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                        if (res == 1) {
                          await FirebaseAuth.instance.signOut();
                          // Navigator.of(context).pop();

                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => const BasePage(),
                            ),
                          );
                        }
                      },
                      child: const Card(
                        elevation: 8.0,
                        color: Colors.white,
                        surfaceTintColor: Colors.white,
                        child: SizedBox(
                          height: 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.logout,
                                size: 20,
                                color: Colors.red,
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                "Logout",
                                textAlign: TextAlign.center,
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
