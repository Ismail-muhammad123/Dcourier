import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  bool _loading = false;
  bool _submited = false;
  bool _success = true;
  String _message = "";
  _resetPassword() async {
    setState(() {
      _loading = true;
    });
    // await Future.delayed(const Duration(seconds: 3));
    FirebaseAuth.instance
        .sendPasswordResetEmail(email: _emailController.text)
        .then((value) {
      setState(() {
        _message = "A password reset link has been sent to your email";
        _loading = false;
        _submited = true;
        _success = true;
      });
    }).onError((error, stackTrace) {
      print(error);
      setState(() {
        _message = "A password reset failed, check the email and try again";
        _loading = false;
        _submited = true;
        _success = false;
      });
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.8,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Image.asset("images/login.png"),
                    ),
                    Row(
                      children: [
                        Text(
                          "Reset Password",
                          style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.w900,
                            fontSize: 30,
                          ),
                        ),
                      ],
                    ),
                    _message.isNotEmpty
                        ? Container(
                            color: tartiaryColor,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                _message,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  color: _success
                                      ? Colors.black
                                      : Colors.redAccent,
                                ),
                              ),
                            ),
                          )
                        : const SizedBox(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          label: Text("Enter your email here"),
                          prefixIcon: Icon(Icons.email),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: _loading
                          ? CircularProgressIndicator(
                              color: primaryColor,
                            )
                          : MaterialButton(
                              onPressed: _submited
                                  ? () => Navigator.of(context).pop()
                                  : _resetPassword,
                              minWidth: double.maxFinite,
                              height: 50,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              color: accentColor,
                              child: Text(
                                _submited ? "Back to Login" : "Submit",
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
