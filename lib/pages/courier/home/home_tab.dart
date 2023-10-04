import 'package:app/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  // // final Completer<GoogleMapController> _controller =
  // //     Completer<GoogleMapController>();
  // static const CameraPosition _kGooglePlex = CameraPosition(
  //   target: LatLng(37.42796133580664, -122.085749655962),
  //   zoom: 14.4746,
  // );
  // _complete(GoogleMapController controller){
  //   _controller.complete(controller);
  // }
  late GoogleMapController mapController;
  final LatLng _center = const LatLng(12.000000, 8.516667);
  bool _isAvailable = false; // TODO set value dynamically

  void _onMapCreated(GoogleMapController controller) {
    setState(() => mapController = controller);
    // mapController.complete();
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
                Switch(
                  activeColor: primaryColor,
                  inactiveThumbColor: accentColor,
                  activeTrackColor: accentColor,
                  inactiveTrackColor: tartiaryColor,
                  value: _isAvailable,
                  onChanged: (val) => setState(() => _isAvailable = val),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
