import 'package:app/constants.dart';
import 'package:app/data/profile_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  late GoogleMapController mapController;
  final LatLng _center = const LatLng(12.000000, 8.516667);

  void _onMapCreated(GoogleMapController controller) {
    setState(() => mapController = controller);
    // mapController.complete();
  }

  _updateAvailability(bool val) async {
    var uid = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection("profiles")
        .doc(uid)
        .update({'available': val});
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: GoogleMap(
            zoomControlsEnabled: false,
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            fortyFiveDegreeImageryEnabled: true,
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 11.0,
            ),
            onMapCreated: _onMapCreated,
          ),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: GestureDetector(
              onTap: () => Scaffold.of(context).openDrawer(),
              child: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      offset: const Offset(4, 4),
                      blurRadius: 12.0,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.menu,
                  size: 30,
                ),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 60,
            width: double.maxFinite,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  blurRadius: 12.0,
                  offset: const Offset(-4, -4),
                ),
              ],
            ),
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Availability status",
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
                StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                    stream: FirebaseFirestore.instance
                        .collection("profiles")
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData ||
                          !snapshot.data!.exists ||
                          snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      return Switch(
                        activeColor: primaryColor,
                        inactiveThumbColor: accentColor,
                        activeTrackColor: accentColor,
                        inactiveTrackColor: tartiaryColor,
                        value: snapshot.data!.data()!['available'],
                        onChanged: _updateAvailability,
                      );
                    }),
              ],
            ),
          ),
        )
      ],
    );
  }
}
