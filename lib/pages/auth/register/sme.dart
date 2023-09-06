import 'package:app/pages/auth/login/login.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';

class SMERegistrationPage extends StatefulWidget {
  const SMERegistrationPage({super.key});

  @override
  State<SMERegistrationPage> createState() => _SMERegistrationPageState();
}

class _SMERegistrationPageState extends State<SMERegistrationPage> {
  bool _showPassword = false;
  bool _loading = false;

  _login() async {}
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
                    decoration: const InputDecoration(
                      label: Text("Full Name"),
                      prefixIcon: Icon(
                        Icons.person,
                        size: 30,
                      ),
                    ),
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      label: Text("Email"),
                      prefixIcon: Icon(
                        Icons.person,
                        size: 30,
                      ),
                    ),
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      label: Text("Phone Number"),
                      prefixIcon: Icon(
                        Icons.person,
                        size: 30,
                      ),
                    ),
                  ),
                  TextFormField(
                    obscureText: !_showPassword,
                    decoration: const InputDecoration(
                      label: Text("Password"),
                      prefixIcon: Icon(
                        Icons.lock,
                        size: 30,
                      ),
                    ),
                  ),
                  TextFormField(
                    obscureText: !_showPassword,
                    decoration: const InputDecoration(
                      label: Text("Confirm Password"),
                      prefixIcon: Icon(
                        Icons.lock,
                        size: 30,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: _loading
                        ? CircularProgressIndicator(
                            color: primaryColor,
                          )
                        : MaterialButton(
                            onPressed: _login,
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
