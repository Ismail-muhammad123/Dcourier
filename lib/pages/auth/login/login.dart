import 'package:app/constants.dart';
import 'package:app/pages/auth/reset_password.dart';
import 'package:app/pages/courier/home/courier_home.dart';
import 'package:app/pages/sme/home/sme_home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _showPassword = false;
  bool failed = false;
  bool _loading = false;
  String _errorMessage = "";
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  _login() async {
    setState(() => _loading = true);
    try {
      var u = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      print(e.message);
      print(e.code);
      setState(() => _errorMessage = e.message!);
    }
    setState(() => _loading = false);
  }

  // _registerWithPhoneNumber() async {
  //   await _auth.verifyPhoneNumber(
  //     verificationCompleted: (phoneAuthCredential) {},
  //     verificationFailed: (error) {},
  //     codeSent: (verificationId, forceResendingToken) {},
  //     codeAutoRetrievalTimeout: (verificationId) {},
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: SingleChildScrollView(
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    Image.asset("images/login.png"),
                    Row(
                      children: [
                        Text(
                          "Login",
                          style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.w900,
                            fontSize: 30,
                          ),
                        ),
                      ],
                    ),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        label: Text("Email"),
                        prefixIcon: Icon(
                          Icons.person,
                          size: 30,
                        ),
                      ),
                    ),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: !_showPassword,
                      decoration: InputDecoration(
                        label: const Text("Password"),
                        prefixIcon: const Icon(
                          Icons.lock,
                          size: 30,
                        ),
                        suffix: IconButton(
                          onPressed: () =>
                              setState(() => _showPassword = !_showPassword),
                          icon: Icon(
                            _showPassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                        ),
                      ),
                    ),
                    Text(
                      _errorMessage,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.red),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const ResetPasswordPage(),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "Forgot password?",
                              style: TextStyle(color: primaryColor),
                            ),
                          ],
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
                              onPressed: _login,
                              minWidth: double.maxFinite,
                              height: 50,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              color: accentColor,
                              child: const Text("Login"),
                            ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "New to DCourier?",
                              style: TextStyle(color: Colors.blueAccent),
                            ),
                            Text(
                              "Register",
                              style: TextStyle(color: primaryColor),
                            ),
                          ],
                        ),
                      ),
                    )
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
