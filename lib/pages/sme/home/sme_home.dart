import 'package:app/constants.dart';
import 'package:app/widgets/menu.dart';
import 'package:flutter/material.dart';

import '../../../widgets/buttons.dart';
import '../notifications/notifications.dart';
// import 'package:intl/intl.dart';

class SMEHomePage extends StatefulWidget {
  const SMEHomePage({super.key});

  @override
  State<SMEHomePage> createState() => _SMEHomePageState();
}

class _SMEHomePageState extends State<SMEHomePage> {
  var _size = "small";
  var _rideType = 0;
  var now = TimeOfDay.now();

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
                builder: (context) => NotificationsPage(),
              ),
            ),
            icon: const Icon(Icons.notifications),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.95,
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
                  Container(
                    width: 300,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(color: tartiaryColor, width: 2),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.location_pin),
                        Text("Select Pick-up Address"),
                        Spacer(),
                        Icon(Icons.arrow_forward_ios),
                      ],
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
                  Container(
                    width: 300,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(color: tartiaryColor, width: 2),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.location_pin),
                        Text("Select Destination Address"),
                        Spacer(),
                        Icon(Icons.arrow_forward_ios),
                      ],
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
                        decoration: InputDecoration(
                          fillColor: tartiaryColor,
                          prefixIcon: const Icon(Icons.phone),
                          label: const Text("Enter Reciever's Phone Number"),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        "Pick-up",
                        style: thickTextStyle,
                      ),
                    ],
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
                              setState(() {
                                now = time ?? now;
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
                  Row(
                    children: [
                      Text(
                        "Select Item Size",
                        style: thickTextStyle,
                      ),
                    ],
                  ),
                  Wrap(
                    spacing: 8.0,
                    children: ["Small", "Medium", "Large"]
                        .map(
                          (e) => GestureDetector(
                            onTap: () =>
                                setState(() => _size = e.toLowerCase()),
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
                                    color:
                                        e.toLowerCase() == _size.toLowerCase()
                                            ? Colors.white
                                            : Colors.black),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  Row(
                    children: [
                      Text(
                        "Ride Type",
                        style: thickTextStyle,
                      ),
                    ],
                  ),
                  Wrap(
                    spacing: 16.0,
                    children: [
                      GestureDetector(
                        onTap: () => setState(() => _rideType = 0),
                        child: Container(
                          width: 60,
                          height: 40,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: _rideType == 0 ? accentColor : Colors.grey,
                              width: _rideType == 0 ? 3 : 2,
                            ),
                          ),
                          child: Image.asset(
                            "images/scooter.png",
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => setState(() => _rideType = 1),
                        child: Container(
                          width: 60,
                          height: 40,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: _rideType == 1 ? accentColor : Colors.grey,
                              width: _rideType == 1 ? 3 : 2,
                            ),
                          ),
                          child: Image.asset(
                            "images/rickshaw.png",
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => setState(() => _rideType = 2),
                        child: Container(
                          width: 60,
                          height: 40,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: _rideType == 2 ? accentColor : Colors.grey,
                              width: _rideType == 2 ? 3 : 2,
                            ),
                          ),
                          child: Image.asset("images/truck.png"),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Total Estimated Price:"),
                      Text(
                        "N1,200",
                        style: thickTextStyle.copyWith(color: primaryColor),
                      ),
                    ],
                  ),
                  GestureDetector(
                    child: GradientDecoratedContainer(
                      child: Text(
                        "Find Rider",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
