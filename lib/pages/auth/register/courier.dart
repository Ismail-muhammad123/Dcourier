import 'package:app/pages/auth/register/verification.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';

class CourierRegistrationPage extends StatefulWidget {
  const CourierRegistrationPage({super.key});

  @override
  State<CourierRegistrationPage> createState() => CourierRegistrationPageState();
}

class CourierRegistrationPageState extends State<CourierRegistrationPage> {
  int tabIndex = 0;
  bool loading = false;

  _submit() async {
    setState(() => loading = true);
    await Future.delayed(const Duration(seconds: 5));
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(
            "Your account has been created and KYC information has be uploaded successfully. An OTP has been sent to your phone number."),
        actions: [
          MaterialButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              "OK",
              style: TextStyle(color: Colors.white),
            ),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            height: 35,
            color: accentColor,
            minWidth: 80,
          )
        ],
      ),
    );

    setState(() => loading = false);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const VerificationPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> tabs = [
      Column(
        children: [
          TextFormField(
            decoration: InputDecoration(
              label: Text("Full Name"),
            ),
          ),
          TextFormField(
            decoration: InputDecoration(
              label: Text("Phone Number"),
              focusColor: accentColor,
            ),
          ),
          TextFormField(
            decoration: InputDecoration(
              label: Text("Email"),
            ),
          ),
          TextFormField(
            decoration: InputDecoration(
              label: Text("Address"),
            ),
          ),
          TextFormField(
            decoration: InputDecoration(
              label: Text("Password"),
            ),
          ),
          TextFormField(
            decoration: InputDecoration(
              label: Text("Confirm Password"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text(
                  "Upload passport",
                  style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    offset: const Offset(2, 2),
                    blurRadius: 5.0,
                  ),
                ],
              ),
              child: SizedBox(
                height: 80,
                width: 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(
                      Icons.camera_alt_outlined,
                      color: tartiaryColor,
                      size: 30,
                    ),
                    const Text("Passport"),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text(
                  "Choose ID Type",
                  style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: tartiaryColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text("National ID"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: accentColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "Voter's Card",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: tartiaryColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text("Driver's License"),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 8.0,
              left: 8.0,
            ),
            child: Row(
              children: [
                Text(
                  "Upload ID Proof",
                  style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Text(
                  "Make sure the coners of your ID are visible.",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          offset: const Offset(2, 2),
                          blurRadius: 5.0,
                        ),
                      ],
                    ),
                    child: SizedBox(
                      height: 80,
                      width: 100,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(
                            Icons.camera_alt_outlined,
                            color: tartiaryColor,
                            size: 30,
                          ),
                          const Text("Front"),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          offset: const Offset(2, 2),
                          blurRadius: 5.0,
                        ),
                      ],
                    ),
                    child: SizedBox(
                      height: 80,
                      width: 100,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(
                            Icons.camera_alt_outlined,
                            color: tartiaryColor,
                            size: 30,
                          ),
                          const Text("Back"),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text(
                  "Choose vehicle Type",
                  style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: tartiaryColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Image.asset(
                          "images/scooter.png",
                          height: 20,
                          width: 20,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text("Motorcycle")
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: accentColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Image.asset(
                          "images/rickshaw.png",
                          height: 20,
                          width: 20,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text("Tri-cycle")
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: tartiaryColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Image.asset(
                          "images/truck.png",
                          height: 20,
                          width: 20,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text("Pick-up van")
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              decoration: InputDecoration(
                label: Text("Vehicle plate number"),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Row(
              children: [
                Text(
                  "insert vehicle plate number",
                  style: TextStyle(
                    color: Colors.grey.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
      Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text(
                  "Enter Bank Details",
                  style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          TextFormField(
            decoration: InputDecoration(
              label: Text("Bank Name"),
            ),
          ),
          TextFormField(
            decoration: InputDecoration(
              label: Text("Account Number"),
              focusColor: accentColor,
            ),
          ),
          TextFormField(
            decoration: InputDecoration(
              label: const Text("Account Name"),
              focusColor: accentColor,
            ),
          ),
          TextFormField(
            decoration: const InputDecoration(
              label: Text("BVN"),
            ),
          ),
        ],
      ),
    ];
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              Text(
                "Create Your Account".toUpperCase(),
                style: const TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Row(
                children: [
                  Flexible(
                    child: Column(
                      children: [
                        const Text("personal details"),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 5,
                            width: double.maxFinite,
                            decoration: BoxDecoration(
                              color: tartiaryColor,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Flexible(
                    child: Column(
                      children: [
                        const Text("ID Proof"),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 5,
                            width: double.maxFinite,
                            decoration: BoxDecoration(
                              color: tabIndex == 1 || tabIndex == 2
                                  ? tartiaryColor
                                  : Colors.grey,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Flexible(
                    child: Column(
                      children: [
                        const Text("Bank details"),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 5,
                            width: double.maxFinite,
                            decoration: BoxDecoration(
                              color:
                                  tabIndex == 2 ? tartiaryColor : Colors.grey,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              Flexible(
                child: SingleChildScrollView(
                  child: tabs[tabIndex],
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: loading
                    ? Center(
                        child: CircularProgressIndicator(
                          color: accentColor,
                        ),
                      )
                    : Row(
                        children: [
                          tabIndex != 0
                              ? MaterialButton(
                                  onPressed: () => setState(() => tabIndex--),
                                  color: accentColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  height: 50,
                                  child: const Icon(
                                    Icons.arrow_back,
                                    color: Colors.white,
                                    size: 25,
                                  ),
                                )
                              : const SizedBox(),
                          const SizedBox(
                            width: 10,
                          ),
                          Flexible(
                            child: tabIndex < 2
                                ? MaterialButton(
                                    onPressed: () => setState(() => tabIndex++),
                                    color: accentColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    height: 50,
                                    child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Next",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Icon(
                                          Icons.arrow_forward,
                                          color: Colors.white,
                                          size: 25,
                                        ),
                                      ],
                                    ),
                                  )
                                : MaterialButton(
                                    onPressed: _submit,
                                    color: accentColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    height: 50,
                                    child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Submit",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
