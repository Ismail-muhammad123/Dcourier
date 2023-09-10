import 'package:app/constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CourierList extends StatefulWidget {
  const CourierList({super.key});

  @override
  State<CourierList> createState() => CourierListState();
}

class CourierListState extends State<CourierList> {
  bool _mapMode = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Available Couriers"),
        centerTitle: true,
        elevation: 8,
        surfaceTintColor: Colors.white,
        backgroundColor: tartiaryColor,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(_mapMode ? Icons.list : Icons.location_on),
          ),
        ],
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Card(
              color: Colors.white,
              surfaceTintColor: Colors.white,
              child: ListTile(
                title: Text("John doe"),
                subtitle: Text("080123456789, Kano State"),
                leading: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: const Icon(Icons.person),
                ),
                trailing: Icon(FontAwesomeIcons.message),
              ),
            )
          ],
        ),
      ),
    );
  }
}
