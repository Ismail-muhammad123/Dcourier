import 'package:app/widgets/buttons.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';

class EditProfileForm extends StatefulWidget {
  const EditProfileForm({super.key});

  @override
  State<EditProfileForm> createState() => _EditProfileFormState();
}

class _EditProfileFormState extends State<EditProfileForm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 30,
          ),
        ),
        title: Text(
          "Edit Profile",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: accentColor,
          ),
        ),
        centerTitle: true,
      ),
      floatingActionButton: SizedBox(
        width: 150,
        child: MaterialButton(
          height: 50,
          onPressed: () {},
          color: accentColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: const Text(
            "Send",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 150,
                      width: 150,
                      decoration: BoxDecoration(
                        color: tartiaryColor,
                        borderRadius: BorderRadius.circular(40),
                      ),
                      alignment: Alignment.bottomCenter,
                      child: const Icon(
                        Icons.person,
                        size: 150,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: accentColor,
                      ),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.edit,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const Text("testmail@mail.mail"),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: const InputDecoration(
                    label: Text("Full Name"),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    label: Text("Phone number"),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: const InputDecoration(
                    label: Text("Address"),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 16.0,
                  horizontal: 8.0,
                ),
                child: Row(
                  children: [
                    Text(
                      "Joined:",
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      "January 13, 2023",
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
