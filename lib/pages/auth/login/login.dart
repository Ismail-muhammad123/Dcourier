import 'package:app/constants.dart';
import 'package:app/pages/auth/reset_password.dart';
import 'package:app/pages/courier/home/courier_home.dart';
import 'package:app/pages/sme/home/sme_home.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _showPassword = false;
  bool _loading = false;

  _loginCOURIER() async {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const CourierHome(),
      ),
    );
  }

  _loginSME() async {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SMEHomePage(),
      ),
    );
  }

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
                      decoration: const InputDecoration(
                        label: Text("Email / Phone Number"),
                        prefixIcon: Icon(
                          Icons.person,
                          size: 30,
                        ),
                      ),
                    ),
                    TextFormField(
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
                              onPressed: _loginSME,
                              minWidth: double.maxFinite,
                              height: 50,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              color: accentColor,
                              child: const Text("Login SME"),
                            ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: _loading
                          ? CircularProgressIndicator(
                              color: primaryColor,
                            )
                          : MaterialButton(
                              onPressed: _loginCOURIER,
                              minWidth: double.maxFinite,
                              height: 50,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              color: accentColor,
                              child: const Text("Login COURIER"),
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
