import 'package:app/constants.dart';
import 'package:app/pages/auth/register/success.dart';
import 'package:flutter/material.dart';

class VerificationPage extends StatefulWidget {
  const VerificationPage({super.key});

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  bool _loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back_ios),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset("images/verification.png"),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Text(
                    "Enter OTP",
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                children: [
                  Text("Enter the OTP sent to your phone number"),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: SizedBox(
                width: 150,
                child: TextFormField(
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                      label: Center(
                        child: Text(
                          "OTP here",
                          textAlign: TextAlign.center,
                        ),
                      ),
                      border: OutlineInputBorder()),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "resend OTP",
                style: TextStyle(
                  color: primaryColor,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: _loading
                  ? Center(
                      child: CircularProgressIndicator(color: primaryColor),
                    )
                  : MaterialButton(
                      onPressed: () async {
                        setState(() {
                          _loading = true;
                        });
                        await Future.delayed(Duration(seconds: 3));
                        setState(() {
                          _loading = false;
                        });
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => RegistrationSuccessPage(),
                          ),
                        );
                      },
                      color: accentColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      height: 50,
                      minWidth: double.maxFinite,
                      child: const Text(
                        "Send",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
            )
          ],
        ),
      ),
    );
  }
}
