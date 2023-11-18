import 'package:app/pages/base.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';

// import 'app_state.dart';
// import 'firebase_options.dart';
// import 'logged_in_view.dart';
// import 'logged_out_view.dart';

AndroidMapRenderer mapRenderer = AndroidMapRenderer.platformDefault;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final GoogleMapsFlutterPlatform mapsImplementation =
      GoogleMapsFlutterPlatform.instance;
  if (mapsImplementation is GoogleMapsFlutterAndroid) {
    // mapRenderer = await mapsImplementation
    //     .initializeWithRenderer(AndroidMapRenderer.latest);
  }

//   // TODO remove this and fix the values at firebase.json file
//   const String localIp = "0.0.0.0";
//   if (kDebugMode) {
//     try {
//       // FirebaseFirestore.instance.useFirestoreEmulator('192.168.43.220', 8080);
//       // FirebaseFunctions.instance.useFunctionsEmulator('192.168.43.220', 5001);
//       // await FirebaseAuth.instance.useAuthEmulator('192.168.43.220', 9099);

//       FirebaseStorage.instance.useStorageEmulator(localIp, 9199);
//       FirebaseFirestore.instance.settings = const Settings(
//         host: "$localIp:8080",
//         sslEnabled: false,
//         persistenceEnabled: false,
//       );
//       await FirebaseAuth.instance.useAuthEmulator("localIp", 9099);
//       FirebaseFunctions.instance.useFunctionsEmulator("localIp", 5001);

// // await FirebaseStorage.instance.useEmulator(
// //   host: localIp,
// //   port: 9199,
// // );
//     } catch (e) {
//       // ignore: avoid_print
//       print(e);
//     }
//   }

  runApp(const DcourierApp());
}

class DcourierApp extends StatelessWidget {
  const DcourierApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DCourier Mobile App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(
      const Duration(seconds: 2),
      () => Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const BasePage(),
        ),
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.maxFinite,
      width: double.maxFinite,
      color: primaryColor,
      alignment: Alignment.center,
      child: Image.asset("images/logo.png"),
    );
  }
}
