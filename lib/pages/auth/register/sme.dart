import 'package:app/data/profile_data.dart';
import 'package:app/pages/auth/login/login.dart';
import 'package:app/pages/auth/register/verification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';

class SMERegistrationPage extends StatefulWidget {
  const SMERegistrationPage({super.key});

  @override
  State<SMERegistrationPage> createState() => _SMERegistrationPageState();
}

class _SMERegistrationPageState extends State<SMERegistrationPage> {
  var auth = FirebaseAuth.instance;
  String errorMessage = "";
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _showPassword = false;
  bool _loading = false;

  bool codeSent = false;

  _signUp() async {
    if (_emailController.text.trim().isNotEmpty &&
        _passwordController.text.trim().isNotEmpty &&
        _phoneNumberController.text.trim().isNotEmpty) {
      setState(() => _loading = true);
      try {
        var userCred = await auth.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        var userprofile = Profile(
          email: _emailController.text.trim(),
          phoneNumber: _phoneNumberController.text.trim(),
          fullName: _nameController.text.trim(),
          accountType: "sme",
        );
        await FirebaseFirestore.instance
            .collection("profiles")
            .doc(userCred.user!.uid)
            .set(
              userprofile.toMap(),
            );

        setState(() => _loading = false);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => VerificationPage(
              credential: userCred,
              // phoneNumber: "+234${_phoneNumberController.text.trim()}",
            ),
          ),
        );
      } on FirebaseException catch (e) {
        setState(() => _loading = false);
        setState(() {
          errorMessage =
              "unable to create account with this email and password";
        });
      }
    } else {
      setState(() {
        errorMessage = "All fields are required";
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneNumberController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Image.asset("images/Signup.png"),
                  ),
                  Row(
                    children: [
                      Text(
                        "Sign Up",
                        style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.w900,
                          fontSize: 30,
                        ),
                      ),
                    ],
                  ),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      label: Text("Full Name"),
                      prefixIcon: Icon(
                        Icons.person,
                        size: 30,
                      ),
                    ),
                  ),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      label: Text("Email"),
                      prefixIcon: Icon(
                        Icons.person,
                        size: 30,
                      ),
                    ),
                  ),
                  TextFormField(
                    controller: _phoneNumberController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      prefix: Text("+234"),
                      label: Text("Phone Number"),
                      prefixIcon: Icon(
                        Icons.phone,
                        size: 30,
                      ),
                    ),
                  ),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: !_showPassword,
                    decoration: const InputDecoration(
                      label: Text("Password"),
                      prefixIcon: Icon(
                        Icons.lock,
                        size: 30,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      errorMessage,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: _loading
                        ? CircularProgressIndicator(
                            color: primaryColor,
                          )
                        : MaterialButton(
                            onPressed: _signUp,
                            minWidth: double.maxFinite,
                            height: 50,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            color: accentColor,
                            child: const Text(
                              "Sign Up",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Already have an account?",
                            style: TextStyle(color: Colors.blueAccent),
                          ),
                          Text(
                            "Sign in",
                            style: TextStyle(color: primaryColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
