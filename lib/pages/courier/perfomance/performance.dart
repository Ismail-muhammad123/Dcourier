import 'package:app/constants.dart';
import 'package:flutter/material.dart';

class Performance extends StatefulWidget {
  const Performance({super.key});

  @override
  State<Performance> createState() => _PerformanceState();
}

class _PerformanceState extends State<Performance> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: tartiaryColor,
        surfaceTintColor: tartiaryColor,
        title: const Text("Performance"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 8.0,
          crossAxisSpacing: 8.0,
          children: [
            Card(
              color: Colors.white,
              surfaceTintColor: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "0",
                    style: TextStyle(
                      fontSize: 24.0,
                    ),
                  ),
                  Text("Total Orders"),
                ],
              ),
            ),
            Card(
              color: Colors.white,
              surfaceTintColor: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "0",
                    style: TextStyle(
                      fontSize: 24.0,
                    ),
                  ),
                  Text("Completed Orders"),
                ],
              ),
            ),
            Card(
              color: Colors.white,
              surfaceTintColor: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "0",
                    style: TextStyle(
                      fontSize: 24.0,
                    ),
                  ),
                  Text("Uncompleted Orders"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
