import 'package:app/constants.dart';
import 'package:app/pages/sme/activities/activities.dart';
import 'package:app/pages/sme/profile/edit_profile.dart';
import 'package:app/pages/sme/support/support.dart';
import 'package:app/widgets/buttons.dart';
import 'package:flutter/material.dart';
import '../pages/sme/tracking.dart/tracking.dart';
import 'menu_tiles.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => MenuState();
}

class MenuState extends State<Menu> {
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
                    color: tartiaryColor,
                    borderRadius: BorderRadius.circular(40),
                  ),
                  alignment: Alignment.bottomCenter,
                  child: const Icon(
                    Icons.person,
                    size: 150,
                  ),
                ),
                Text(
                  "Musab",
                  style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
                const Text("testmail@mail.mail"),
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
                      builder: (context) => const TrackingPage(),
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
                Divider(),
                MenuTile(
                  title: "Logout",
                  leading: Icons.logout,
                  trailing: Icons.arrow_right,
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const TrackingPage(),
                    ),
                  ),
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
