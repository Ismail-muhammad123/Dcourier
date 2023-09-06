import 'package:app/constants.dart';
import 'package:flutter/material.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back_ios),
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 200,
              alignment: Alignment.bottomCenter,
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(),
                ),
              ),
              child: Image.asset(
                "images/notification.png",
              ),
            ),
            Text(
              "Nothing yet!",
              style: TextStyle(
                color: accentColor,
                fontWeight: FontWeight.bold,
                fontSize: 28,
              ),
            ),
            const Text("We will notify you of incomming notifications")
          ],
        ),
      ),
    );
  }
}
