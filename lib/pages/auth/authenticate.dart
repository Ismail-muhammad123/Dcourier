import 'package:app/constants.dart';
import 'package:app/pages/auth/login/login.dart';
import 'package:app/pages/auth/onboarding.dart';
import 'package:app/pages/auth/register/courier.dart';
import 'package:app/pages/auth/register/sme.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationPage extends StatefulWidget {
  const AuthenticationPage({super.key});

  @override
  State<AuthenticationPage> createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  _checkForOnboarding() async {
    final SharedPreferences prefs = await _prefs;
    final bool isOnBoarded = prefs.getBool('onboarded') ?? false;
    if (!isOnBoarded) {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const OnBoardingPage(),
        ),
      );
      prefs.setBool('onboarded', true);
    }
  }

  @override
  void initState() {
    _checkForOnboarding();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 50,
            ),
            Image.asset(
              "images/logo.png",
              color: primaryColor,
            ),
            Image.asset("images/welcome.png"),
            const Text("Sign up as ..."),
            MaterialButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const SMERegistrationPage(),
                ),
              ),
              color: accentColor,
              height: 50,
              minWidth: 300,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                "SME",
                style: TextStyle(color: secondaryColor),
              ),
            ),
            MaterialButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const CourierRegistrationPage(),
                ),
              ),
              color: accentColor,
              height: 50,
              minWidth: 300,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                "Courier",
                style: TextStyle(color: secondaryColor),
              ),
            ),
            GestureDetector(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const LoginPage(),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account?",
                    style: TextStyle(color: accentColor),
                  ),
                  Text(
                    "Sign in",
                    style: TextStyle(color: primaryColor),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
