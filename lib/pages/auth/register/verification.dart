import 'package:app/constants.dart';
import 'package:app/pages/auth/login/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VerificationPage extends StatefulWidget {
  final UserCredential credential;
  // final String phoneNumber;
  const VerificationPage({
    super.key,
    required this.credential,
    // required this.phoneNumber,
  });

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  final TextEditingController _otpController = TextEditingController();

  String errorText = "";
  var auth = FirebaseAuth.instance;
  String? verificationID;
  int? resendToken;

  // _verifyOTP() async {
  //   PhoneAuthCredential credential = PhoneAuthProvider.credential(
  //     verificationId: verificationID!,
  //     smsCode: _optController.text.trim(),
  //   );

  //   try {
  //     await widget.credential.user!.linkWithCredential(credential);
  //     await auth.signInWithCredential(credential);
  //   } on FirebaseAuthException catch (e) {
  //     switch (e.code) {
  //       case "provider-already-linked":
  //         errorText = "The provider has already been linked to the user.";
  //         break;
  //       case "invalid-credential":
  //         errorText = "The provider's credential is not valid.";
  //         break;
  //       case "credential-already-in-use":
  //         errorText =
  //             "The account corresponding to the credential already exists, "
  //             "or is already linked to a Firebase User.";
  //         break;
  //       // See the API reference for the full list of error codes.
  //       default:
  //         errorText = "Verification failed.";
  //     }
  //     // Sign the user in (or link) with the auto-generated credential
  //   }
  // }

  // _verifyNumber() async {
  //   await FirebaseAuth.instance.verifyPhoneNumber(
  //     phoneNumber: widget.phoneNumber,
  //     codeSent: (String verificationId, int? resendToken) async {
  //       setState(() {
  //         verificationID = verificationID;
  //         resendToken = resendToken;
  //       });
  //     },
  //     verificationCompleted: (PhoneAuthCredential credential) async {
  //       // ANDROID ONLY!
  //       try {
  //         await widget.credential.user!.linkWithCredential(credential);
  //         await auth.signInWithCredential(credential);
  //       } on FirebaseAuthException catch (e) {
  //         switch (e.code) {
  //           case "provider-already-linked":
  //             errorText = "The provider has already been linked to the user.";
  //             break;
  //           case "invalid-credential":
  //             errorText = "The provider's credential is not valid.";
  //             break;
  //           case "credential-already-in-use":
  //             errorText =
  //                 "The account corresponding to the credential already exists, "
  //                 "or is already linked to a Firebase User.";
  //             break;
  //           // See the API reference for the full list of error codes.
  //           default:
  //             errorText = "Verification failed.";
  //         }
  //         // Sign the user in (or link) with the auto-generated credential
  //       }
  //     },
  //     verificationFailed: (FirebaseAuthException e) {
  //       print(e.code);
  //       if (e.code == 'invalid-phone-number') {
  //         print('The provided phone number is not valid.');
  //       }
  //       // Handle other errors
  //     },
  //     codeAutoRetrievalTimeout: (String verificationId) {
  //       // Auto-resolution timed out...
  //     },
  //   );
  // }

  // @override
  // void initState() {
  //   _verifyNumber();
  //   super.initState();
  // }

  // @override
  // void dispose() {
  //   _optController.dispose();
  //   super.dispose();
  // }

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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Verification",
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Check your email inbox for verification link",
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.all(20.0),
            //   child: SizedBox(
            //     width: 150,
            //     child: TextFormField(
            //       controller: _optController,
            //       textAlign: TextAlign.center,
            //       decoration: const InputDecoration(
            //         label: Center(
            //           child: Text(
            //             "OTP here",
            //             textAlign: TextAlign.center,
            //           ),
            //         ),
            //         border: OutlineInputBorder(),
            //       ),
            //     ),
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () async {
                  await widget.credential.user!.sendEmailVerification();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Verification email sent"),
                    ),
                  );
                },
                child: Text(
                  "resend email",
                  style: TextStyle(
                    color: primaryColor,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.all(18.0),
            //   child: MaterialButton(
            //     onPressed: verificationID != null ? _verifyOTP : null,
            //     color: accentColor,
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(20),
            //     ),
            //     height: 50,
            //     minWidth: double.maxFinite,
            //     child: const Text(
            //       "Send",
            //       style: TextStyle(color: Colors.white),
            //     ),
            //   ),
            // )
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: MaterialButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const LoginPage(),
                  ),
                ),
                color: accentColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                height: 50,
                minWidth: double.maxFinite,
                child: const Text(
                  "Login",
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
