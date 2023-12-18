import 'package:app/constants.dart';
import 'package:app/data/delivery_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import '../menu.dart';
import 'package:flutter/material.dart';
import '../../../widgets/buttons.dart';
import '../available_couriers.dart';
import '../notifications/notifications.dart';
import 'location_selector_map.dart';
// import 'package:intl/intl.dart';

class SMEHomePage extends StatefulWidget {
  const SMEHomePage({super.key});

  @override
  State<SMEHomePage> createState() => _SMEHomePageState();
}

class _SMEHomePageState extends State<SMEHomePage> {
  var firestoreInctance = FirebaseFirestore.instance;

  var _size = "small";
  String _vehicleType = 'bike';
  var _pickUpTime = Timestamp.now();
  num amount = 0;

  bool _loading = false;

  final TextEditingController _pickupAddressController =
      TextEditingController();
  final TextEditingController _deliveryAddressController =
      TextEditingController();
  final TextEditingController _recieverNameController = TextEditingController();
  final TextEditingController _recieverPhoneNumberController =
      TextEditingController();

  String pickupAddress = "";
  LatLng? pickupPosition;

  var now = TimeOfDay.now();

  Future<Map<String, dynamic>?> _getLocation() async {
    Map<String, dynamic>? addr = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const LocationsMap(),
      ),
    );
    return addr;
  }

  Future<void> _updateAmount() async {
    setState(() => amount = 0);
    var pricing = await FirebaseFirestore.instance
        .collection('pricing')
        .where("size", isEqualTo: _size)
        .get();
    setState(() {
      amount = pricing.docs.first.data()[_vehicleType] ?? 0;
    });
  }

  Future<void> _createDeliveryJob() async {
    if (amount == 0) {
      await showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          surfaceTintColor: Colors.white,
          backgroundColor: Colors.white,
          icon: Icon(
            Icons.error,
          ),
          iconColor: Colors.redAccent,
          content: Text(
            "Could not load price, try changing the vehicle, or size, or refresh the price",
            textAlign: TextAlign.center,
          ),
        ),
      );
      return;
    }
    if ((pickupAddress.isEmpty && pickupPosition == null) ||
        _deliveryAddressController.text.trim().isEmpty ||
        _recieverNameController.text.trim().isEmpty ||
        _recieverPhoneNumberController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("All fields are required"),
        ),
      );
      return;
    }
    setState(() => _loading = true);

    var uid = FirebaseAuth.instance.currentUser!.uid;

    var job = Delivery(
      itemType: _size,
      vehicleType: _vehicleType,
      pickupAddress: pickupAddress,
      pickupCoodinate: pickupPosition != null
          ? "${pickupPosition!.latitude},${pickupPosition!.longitude}"
          : null,
      pickupTime: _pickUpTime,
      recieverName: _recieverNameController.text.trim(),
      recieverPhoneNumber: _recieverPhoneNumberController.text.trim(),
      deliveryAddress: _deliveryAddressController.text.trim(),
      senderId: uid,
      status: "pending",
      amount: amount.toDouble(),
    );

    // var batch = firestoreInctance.batch();

    var j = await firestoreInctance.collection("jobs").add(job.toMap());
    // var j = firestoreInctance.collection("jobs").doc();
    // batch.set(j, job.toMap());

    // var req = JobRequest(
    //   jobID: "jobID",
    //   creatorID: FirebaseAuth.instance.currentUser!.uid,
    //   appliedAt: Timestamp.now(),
    //   status: "requested",
    // );
    // var r = firestoreInctance.collection("r").doc();
    // batch.set(r, job.toMap());

    // await batch.commit();

    job.id = j.id;

    // show snack bar message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("New Delivery Job Created"),
      ),
    ); 

    setState(() => _loading = false);

    // navigate to the job applications page
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CourierList(
          delivery: job,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var thickTextStyle = TextStyle(
      color: accentColor,
      fontWeight: FontWeight.w600,
      fontSize: 16,
    );
    final localizations = MaterialLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        shadowColor: Colors.white,
        leading: IconButton(
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const Menu(),
            ),
          ),
          icon: const Icon(
            Icons.menu,
            size: 30,
          ),
        ),
        title: Column(
          children: [
            const Text("Send"),
            Container(
              color: primaryColor,
              width: 50,
              height: 3,
            )
          ],
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.location_pin),
          ),
          IconButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const NotificationsPage(),
              ),
            ),
            icon: const Icon(Icons.notifications),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    "From",
                    style: thickTextStyle,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 14.0,
                ),
                child: GestureDetector(
                  onTap: () async {
                    Map<String, dynamic>? addr = await _getLocation();
                    if (addr != null) {
                      setState(() {
                        if (addr['position'] != null) {
                          pickupPosition = addr['posiotion'];
                        }
                        pickupAddress = (addr['address'] as String).isNotEmpty
                            ? addr['address']
                            : "${(addr['position'] as LatLng).latitude}, ${(addr['position'] as LatLng).longitude}";
                      });
                    }
                  },
                  child: Container(
                    // width: 300,
                    decoration: BoxDecoration(
                      border: Border.all(color: tartiaryColor, width: 2),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: double.maxFinite,
                      height: 40,
                      child: Row(
                        children: [
                          const Icon(Icons.location_pin),
                          Text(
                            pickupAddress.isEmpty
                                ? "Select Pick-up Address"
                                : pickupAddress,
                          ),
                          const Spacer(),
                          const Icon(Icons.arrow_forward_ios),
                        ],
                      ),
                    ),
                    // child: TextFormField(
                    //   controller: _pickupAddressController,
                    //   keyboardType: TextInputType.streetAddress,
                    //   decoration: InputDecoration(
                    //     fillColor: tartiaryColor,
                    //     prefixIcon: const Icon(Icons.phone),
                    //     label: const Text("Enter pick-up address"),
                    //     border: InputBorder.none,
                    //   ),
                    // ),
                  ),
                ),
              ),
              Row(
                children: [
                  Text(
                    "To",
                    style: thickTextStyle,
                  ),
                ],
              ),
              // Container(
              //   width: 300,
              //   padding: const EdgeInsets.all(10),
              //   decoration: BoxDecoration(
              //     border: Border.all(color: tartiaryColor, width: 2),
              //     borderRadius: BorderRadius.circular(15),
              //   ),
              //   child: const Row(
              //     children: [
              //       Icon(Icons.location_pin),
              //       Text("Select Destination Address"),
              //       Spacer(),
              //       Icon(Icons.arrow_forward_ios),
              //     ],
              //   ),
              // ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: tartiaryColor, width: 2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: TextFormField(
                    controller: _deliveryAddressController,
                    keyboardType: TextInputType.streetAddress,
                    decoration: const InputDecoration(
                      label: Text("Enter Destination Address"),
                      prefixIcon: Icon(Icons.person),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: tartiaryColor, width: 2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: TextFormField(
                    controller: _recieverNameController,
                    decoration: const InputDecoration(
                      label: Text("Enter Reciever's Name"),
                      prefixIcon: Icon(Icons.person),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: tartiaryColor, width: 2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: TextFormField(
                    controller: _recieverPhoneNumberController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      fillColor: tartiaryColor,
                      prefixIcon: const Icon(Icons.phone),
                      label: const Text("Enter Reciever's Phone Number"),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    Text(
                      "Pick-up",
                      style: thickTextStyle,
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  const Text("Time:"),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () async {
                          var time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          var t = time ?? now;
                          var today = DateTime.now();
                          var d = DateTime(today.year, today.month, today.day,
                              t.hour, t.minute);
                          setState(() {
                            now = t;
                            _pickUpTime = Timestamp.fromDate(d);
                          });
                        },
                        child: Container(
                          width: double.maxFinite,
                          height: 40,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(),
                          ),
                          child: Text(
                            localizations.formatTimeOfDay(now),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    Text(
                      "Select Item Size",
                      style: thickTextStyle,
                    ),
                  ],
                ),
              ),
              Wrap(
                spacing: 8.0,
                children: ["Small", "Medium", "Large"]
                    .map(
                      (e) => GestureDetector(
                        onTap: () {
                          setState(() => _size = e.toLowerCase());
                          _updateAmount();
                        },
                        child: Container(
                          width: 80,
                          height: 40,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: e.toLowerCase() == _size.toLowerCase()
                                ? accentColor
                                : Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(),
                          ),
                          child: Text(
                            e,
                            style: TextStyle(
                                color: e.toLowerCase() == _size.toLowerCase()
                                    ? Colors.white
                                    : Colors.black),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    Text(
                      "Ride Type",
                      style: thickTextStyle,
                    ),
                  ],
                ),
              ),
              Wrap(
                spacing: 16.0,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() => _vehicleType = "bike");
                      _updateAmount();
                    },
                    child: Container(
                      width: 60,
                      height: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: _vehicleType == 'bike'
                              ? accentColor
                              : Colors.grey,
                          width: _vehicleType == 'bike' ? 3 : 2,
                        ),
                      ),
                      child: Image.asset(
                        "images/scooter.png",
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() => _vehicleType = "trycyle");
                      _updateAmount();
                    },
                    child: Container(
                      width: 60,
                      height: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: _vehicleType == "trycyle"
                              ? accentColor
                              : Colors.grey,
                          width: _vehicleType == "trycyle" ? 3 : 2,
                        ),
                      ),
                      child: Image.asset(
                        "images/rickshaw.png",
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() => _vehicleType = "truck");
                      _updateAmount();
                    },
                    child: Container(
                      width: 60,
                      height: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: _vehicleType == "truck"
                              ? accentColor
                              : Colors.grey,
                          width: _vehicleType == "truck" ? 3 : 2,
                        ),
                      ),
                      child: Image.asset("images/truck.png"),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Total Estimated Price:"),
                    const Spacer(),
                    IconButton(
                      onPressed: () => _updateAmount(),
                      icon: const Icon(Icons.refresh),
                    ),
                    Text(
                      NumberFormat.currency(symbol: 'NGN ').format(amount),
                      style: thickTextStyle.copyWith(color: primaryColor),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: _loading ? null : _createDeliveryJob,
                  child: _loading
                      ? CircularProgressIndicator(
                          color: primaryColor,
                        )
                      : const GradientDecoratedContainer(
                          child: Text(
                            "Find Rider",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
