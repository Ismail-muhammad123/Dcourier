import 'package:app/pages/base.dart';
import 'package:flutter/material.dart';
import 'constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';

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
