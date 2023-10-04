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

  void _onMapCreated(GoogleMapController controller) {
    setState(() => mapController = controller);
    // mapController.complete();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GoogleMap(
        // mapType: MapType.hybrid,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 1.0,
        ),
        onMapCreated: _onMapCreated,
      ),
    );
  }
}
