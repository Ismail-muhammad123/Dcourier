import 'package:app/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ActivitiesPage extends StatefulWidget {
  const ActivitiesPage({super.key});

  @override
  State<ActivitiesPage> createState() => _ActivitiesPageState();
}

class _ActivitiesPageState extends State<ActivitiesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tartiaryColor,
      appBar: AppBar(
        title: const Text("Activities"),
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back_ios),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          top: 20.0,
          left: 20.0,
          right: 20.0,
        ),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  "History",
                  style: TextStyle(
                    color: accentColor,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Flexible(
              child: Container(
                margin: EdgeInsets.zero,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                ),
                child: FutureBuilder(
                  future:
                      FirebaseFirestore.instance.collection("activities").get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (!snapshot.hasData) {
                      return const Center(child: Text("Not found"));
                    }
                    return ListView(
                      children: snapshot.data!.docs
                          .map(
                            (e) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      offset: const Offset(4, 4),
                                      blurRadius: 12.0,
                                    )
                                  ],
                                ),
                                child: ListTile(
                                  title: Text(
                                    e.data()['activity'],
                                    style: TextStyle(color: accentColor),
                                  ),
                                  subtitle: Text(
                                    e.data()['time'].toString(),
                                    style: const TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
