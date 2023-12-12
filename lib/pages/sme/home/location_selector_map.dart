import 'package:app/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class LocationsMap extends StatefulWidget {
  const LocationsMap({super.key});

  @override
  State<LocationsMap> createState() => _LocationsMapState();
}

class _LocationsMapState extends State<LocationsMap> {
  String address = "";
  LatLng? coodinate;
  Set<Marker>? _markers;
  late GoogleMapController mapController;
  final TextEditingController _addressController = TextEditingController();

  bool sateliteMode = false;

  final LatLng _center = const LatLng(12.000000, 8.516667);

  void _onMapCreated(GoogleMapController controller) {
    setState(() => mapController = controller);
    // mapController.complete();
  }

  Future<Position> _getMyLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location `services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error(
          'Location services are disabled. Please Open Your device location');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error(
            'Location permissions are denied. Location permission need to be enabled.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions. Location permission need to be enabled.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  _gotoMyLocation() async {
    var pos = await _getMyLocation();
    _gotoLocation(pos);
    var marker = Marker(
      markerId: const MarkerId("pick-up-location"),
      position: LatLng(
        pos.latitude,
        pos.longitude,
      ),
    );
    setState(() {
      if (_markers != null) {
        _markers!.clear();
        _markers!.add(
          marker,
        );
      } else {
        _markers = {
          marker,
        };
      }
    });
  }

  _returnAddress() {
    Navigator.of(context).pop(
      {
        "position": _markers != null && _markers!.isNotEmpty
            ? _markers!.first.position
            : null,
        "address": _addressController.text,
      },
    );
  }

  _gotoLocation(Position pos) async {
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        // on below line we have given positions of Location 5
        CameraPosition(
          target: LatLng(pos.latitude, pos.longitude),
          zoom: 20,
        ),
      ),
    );
    setState(() {});
  }

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: tartiaryColor,
        backgroundColor: tartiaryColor,
        title: const Text("Pick Address"),
        centerTitle: true,
        actions: [
          DropdownButton(
            value: sateliteMode,
            items: const [
              DropdownMenuItem(
                value: true,
                child: Text("Satelite"),
              ),
              DropdownMenuItem(
                value: false,
                child: Text("normal"),
              ),
            ],
            onChanged: (val) => setState(() => sateliteMode = val as bool),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "my_location",
            onPressed: _gotoMyLocation,
            backgroundColor: Colors.white,
            child: const Icon(Icons.my_location),
          ),
          const SizedBox(
            height: 10,
          ),
          FloatingActionButton(
            heroTag: "return",
            onPressed: _returnAddress,
            backgroundColor: tartiaryColor,
            child: const Icon(Icons.check),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.maxFinite,
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Flexible(
                        child: InkWell(
                          onTap: _gotoMyLocation,
                          child: Container(
                            height: 50,
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: const Row(
                              children: [
                                Text("My Location"),
                                Spacer(),
                                Icon(Icons.my_location),
                              ],
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          if (_markers != null) {
                            setState(() {
                              _markers!.clear();
                            });
                          }
                        },
                        icon: const Icon(Icons.clear),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Flexible(
                        child: TextFormField(
                          controller: _addressController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: primaryColor),
                            ),
                            label: const Text("Address"),
                            hintText: "Enter address here",
                            hintStyle: const TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: _returnAddress,
                        icon: const Icon(Icons.check),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            child: GoogleMap(
              markers: _markers ?? <Marker>{},
              zoomControlsEnabled: false,
              myLocationButtonEnabled: true,
              myLocationEnabled: true,
              fortyFiveDegreeImageryEnabled: true,
              mapType: sateliteMode ? MapType.satellite : MapType.normal,
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 10.0,
              ),
              onTap: (pos) => setState(() {
                _markers = {
                  Marker(
                    markerId: const MarkerId("Pick Up location"),
                    position: pos,
                  )
                };
                coodinate = pos;
              }),
              onMapCreated: _onMapCreated,
            ),
          ),
        ],
      ),
    );
  }
}
