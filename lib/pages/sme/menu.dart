import 'dart:typed_data';

import 'package:app/constants.dart';
import 'package:app/data/profile_data.dart';
import 'package:app/pages/sme/activities/activities.dart';
import 'package:app/pages/sme/profile/edit_profile.dart';
import 'package:app/pages/sme/support/support.dart';
import 'package:app/widgets/buttons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import './tracking/tracking.dart';
import '../wallet/wallet_home.dart';
import 'menu_tiles.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => MenuState();
}

class MenuState extends State<Menu> {
  Profile? myProfile;

  Uint8List? profileImage;

  _getProfile() async {
    var uid = FirebaseAuth.instance.currentUser!.uid;
    Uint8List? img;
    var user =
        await FirebaseFirestore.instance.collection("profiles").doc(uid).get();
    var profile = Profile.fromMap(user.data()!);
    if (profile.profilePicture != null && profile.profilePicture!.isNotEmpty) {
      img = await FirebaseStorage.instance
          .ref()
          .child(profile.profilePicture!)
          .getData();
    }
    if (mounted) {
      setState(() {
        profileImage = img;
        myProfile = profile;
      });
    }
  }

  @override
  void initState() {
    _getProfile();
    super.initState();
  }

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
          "Menu",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: accentColor,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              children: [
                Container(
                  height: 150,
                  width: 150,
                  decoration: BoxDecoration(
                    image: profileImage == null
                        ? null
                        : DecorationImage(
                            image: MemoryImage(profileImage!),
                          ),
                    color: tartiaryColor,
                    borderRadius: BorderRadius.circular(75),
                  ),
                  alignment: Alignment.bottomCenter,
                  child: profileImage == null
                      ? const Icon(
                          Icons.person,
                          size: 150,
                        )
                      : null,
                ),
                Text(
                  myProfile != null ? myProfile!.fullName! : "",
                  style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
                Text(FirebaseAuth.instance.currentUser!.email ?? ""),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 150,
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const EditProfileForm(),
                        ),
                      ),
                      child: const GradientDecoratedContainer(
                        child: Text(
                          "Edit Profile",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Divider(),
                MenuTile(
                  title: "Tracking",
                  leading: Icons.timelapse,
                  trailing: Icons.arrow_right,
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const TrackingPage(),
                    ),
                  ),
                ),
                Divider(),
                MenuTile(
                  title: "Wallet",
                  leading: Icons.wallet,
                  trailing: Icons.arrow_right,
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const Wallet(),
                    ),
                  ),
                ),
                Divider(),
                MenuTile(
                  title: "Activities",
                  leading: Icons.history,
                  trailing: Icons.arrow_right,
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const ActivitiesPage(),
                    ),
                  ),
                ),
                const Divider(),
                MenuTile(
                  title: "Support",
                  leading: Icons.help_rounded,
                  trailing: Icons.arrow_right,
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const SupportPage(),
                    ),
                  ),
                ),
                const Divider(),
                MenuTile(
                  title: "Logout",
                  leading: Icons.logout,
                  trailing: Icons.arrow_right,
                  onTap: () async {
                    var res = await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        backgroundColor: Colors.white,
                        surfaceTintColor: Colors.white,
                        content: const Text(
                          "logout?",
                          textAlign: TextAlign.center,
                        ),
                        actionsAlignment: MainAxisAlignment.spaceEvenly,
                        actions: [
                          MaterialButton(
                            onPressed: () => Navigator.of(context).pop(0),
                            color: tartiaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text("No"),
                          ),
                          MaterialButton(
                            onPressed: () => Navigator.of(context).pop(1),
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: const BorderSide(
                                color: Colors.red,
                                width: 1,
                              ),
                            ),
                            child: const Text(
                              "Yes",
                              style: TextStyle(
                                color: Colors.red,
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                    if (res == 1) {
                      await FirebaseAuth.instance.signOut();
                      Navigator.of(context)
                          .popUntil((route) => route.isFirst == true);
                    }
                  },
                ),
                Divider(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
