import 'dart:typed_data';

import 'package:app/data/kyc_data.dart';
import 'package:app/data/profile_data.dart';
import 'package:app/data/wallet_data.dart';
import 'package:app/pages/auth/register/verification.dart';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../constants.dart';
import '../../camera_image.dart';

class CourierRegistrationPage extends StatefulWidget {
  const CourierRegistrationPage({super.key});

  @override
  State<CourierRegistrationPage> createState() =>
      CourierRegistrationPageState();
}

class CourierRegistrationPageState extends State<CourierRegistrationPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _vehiclePlateNumberController =
      TextEditingController();
  final TextEditingController _bankNameController = TextEditingController();
  final TextEditingController _accountNameController = TextEditingController();
  final TextEditingController _accountNumberController =
      TextEditingController();
  final TextEditingController _bvnController = TextEditingController();

  int tabIndex = 0;
  bool loading = false;
  Uint8List? _passport;
  Uint8List? _IDFront;
  Uint8List? _IDBack;

  String _idType = "NIN";
  String _vehicleType = "trycycle";

  final db = FirebaseFirestore.instance;

  Future<Uint8List?> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    var image = await showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: const Icon(Icons.photo_library),
                    title: const Text('Photo Gallery'),
                    onTap: () async {
                      final XFile? i =
                          await picker.pickImage(source: ImageSource.gallery);
                      Navigator.of(context).pop(i);
                    }),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Camera'),
                  onTap: () async {
                    // final XFile? i =
                    //     await picker.pickImage(source: ImageSource.camera);
                    var cam = await availableCameras();

                    final XFile? img = await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            CameraImageCapturePage(camera: cam),
                      ),
                    );
                    Navigator.of(context).pop(img);
                  },
                ),
              ],
            ),
          );
        });

    if (image != null) {
      return await image.readAsBytes();
    } else {
      return null;
    }
  }

  _pickPassport() async {
    var pic = await _pickImage();
    if (pic != null) {
      setState(() => _passport = pic);
    }
  }

  _pickIDFront() async {
    var pic = await _pickImage();
    if (pic != null) {
      setState(() => _IDFront = pic);
    }
  }

  _pickIDBack() async {
    var pic = await _pickImage();
    if (pic != null) {
      setState(() => _IDBack = pic);
    }
  }

  _submit() async {
    setState(() => loading = true);
    // await Future.delayed(const Duration(seconds: 5));
    // await showDialog(
    //   context: context,
    //   builder: (context) => AlertDialog(
    //     content: Text(
    //         "Your account has been created and KYC information has be uploaded successfully. An OTP has been sent to your phone number."),
    //     actions: [
    //       MaterialButton(
    //         onPressed: () => Navigator.of(context).pop(),
    //         child: Text(
    //           "OK",
    //           style: TextStyle(color: Colors.white),
    //         ),
    //         shape:
    //             RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    //         height: 35,
    //         color: accentColor,
    //         minWidth: 80,
    //       )
    //     ],
    //   ),
    // );

    // CREATE USER

    if (_nameController.text.trim().isEmpty ||
        _phoneNumberController.text.trim().isEmpty ||
        _emailController.text.trim().isEmpty ||
        _addressController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "personal details not complete",
            style: TextStyle(color: Colors.red),
          ),
        ),
      );
      return;
    }

    try {
      var user = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim());

      final batch = db.batch();

      // add profile to batch
      var profileObj = Profile(
        accountType: "courier",
        address: _addressController.text.trim(),
        fullName: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phoneNumber: _phoneNumberController.text.trim(),
        dateJoined: Timestamp.now(),
        profilePicture: "passports/sme/${user.user!.uid}.jpg",
        vehicleType: _vehicleType,
      );

      var profileRef = db.collection("profiles").doc(user.user!.uid);
      batch.set(profileRef, profileObj.toMap());

      // add KYC batch
      var kyc = KYC(
          idType: _idType,
          dateFiled: Timestamp.now(),
          bvn: _bvnController.text.trim(),
          accountName: _accountNameController.text.trim(),
          accountNumber: _accountNumberController.text.trim(),
          bankName: _bankNameController.text.trim(),
          vehiclePlateNumber: _vehiclePlateNumberController.text.trim(),
          idPictureFront: "kyc/id/${user.user!.uid}_front.png",
          idPictureBack: "kyc/id/${user.user!.uid}_back.png",
          passportPicture: "kyc/passports/${user.user!.uid}.jpg");

      var kycRef = db.collection("kyc").doc(user.user!.uid);
      batch.set(kycRef, kyc.toMap());

      // add Wallet batch
      var wallet = Wallet(
        accountName: _accountNameController.text.trim(),
        accountNumber: _accountNumberController.text.trim(),
        bankName: _bankNameController.text.trim(),
        status: "active",
      );
      var walletRef = db.collection("kyc").doc(user.user!.uid);
      batch.set(walletRef, wallet.toMap());

      // Commit the batch
      await batch.commit();

      // UPLOAD Prfile picture
      if (_passport != null) {
        var profilePicUploadTask = FirebaseStorage.instance
            .ref()
            .child("passports/sme/${user.user!.uid}.jpg")
            .putData(_passport!);
        await profilePicUploadTask.whenComplete(() => null);
      } else {
        throw Exception();
      }

      // UPLOAD ID Front Picture picture
      if (_IDFront != null) {
        var idFrontPicUploadTask = FirebaseStorage.instance
            .ref()
            .child("kyc/id/${user.user!.uid}_front.png")
            .putData(_IDFront!);
        await idFrontPicUploadTask.whenComplete(() => null);
      } else {
        throw Exception();
      }
      // UPLOAD ID Back Picture picture
      if (_IDBack != null) {
        var idBackPicUploadTask = FirebaseStorage.instance
            .ref()
            .child("kyc/id/${user.user!.uid}_back.png")
            .putData(_IDBack!);
        await idBackPicUploadTask.whenComplete(() => null);
      } else {
        throw Exception();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Unable to create an account, Please check all fields again",
            style: TextStyle(color: Colors.red),
          ),
        ),
      );
      return;
    }

    if (mounted) {
      setState(() => loading = false);
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneNumberController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _vehiclePlateNumberController.dispose();
    _bankNameController.dispose();
    _accountNameController.dispose();
    _accountNumberController.dispose();
    _bvnController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> tabs = [
      Column(
        children: [
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              label: Text("Full Name"),
            ),
          ),
          TextFormField(
            controller: _phoneNumberController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              label: const Text("Phone Number"),
              focusColor: accentColor,
            ),
          ),
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              label: Text("Email"),
            ),
          ),
          TextFormField(
            controller: _addressController,
            decoration: const InputDecoration(
              label: Text("Address"),
            ),
          ),
          TextFormField(
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              label: Text("Password"),
            ),
          ),
          TextFormField(
            controller: _confirmPasswordController,
            obscureText: true,
            decoration: const InputDecoration(
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
          GestureDetector(
            onTap: _pickPassport,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  image: _passport != null
                      ? DecorationImage(
                          image: MemoryImage(_passport!),
                          fit: BoxFit.fill,
                        )
                      : null,
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
                child: _passport != null
                    ? const Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 30,
                      )
                    : SizedBox(
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
                OptionBadge(
                  label: "National ID",
                  isSelected: _idType == "NIN",
                  onTap: () => setState(() => _idType = "NIN"),
                ),
                OptionBadge(
                  label: "Voter's Card",
                  isSelected: _idType == "PVC",
                  onTap: () => setState(() => _idType = "PVC"),
                ),
                OptionBadge(
                  label: "Driver's License",
                  isSelected: _idType == "DL",
                  onTap: () => setState(() => _idType = "DL"),
                ),
              ],
            ),
          ),
          const SizedBox(
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
                GestureDetector(
                  onTap: _pickIDFront,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        image: _IDFront != null
                            ? DecorationImage(
                                image: MemoryImage(_IDFront!),
                              )
                            : null,
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
                      child: _IDFront != null
                          ? null
                          : SizedBox(
                              height: 80,
                              width: 100,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
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
                ),
                GestureDetector(
                  onTap: _pickIDBack,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        image: _IDBack != null
                            ? DecorationImage(
                                image: MemoryImage(_IDBack!),
                              )
                            : null,
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
                      child: _IDBack != null
                          ? null
                          : SizedBox(
                              height: 80,
                              width: 100,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
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
                ),
              ],
            ),
          ),
          const SizedBox(
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
                OptionBadge(
                  leading: Image.asset(
                    "images/scooter.png",
                    height: 20,
                    width: 20,
                  ),
                  label: "Motocycle",
                  isSelected: _vehicleType == "bike",
                  onTap: () => setState(() => _vehicleType = "bike"),
                ),
                OptionBadge(
                  leading: Image.asset(
                    "images/rickshaw.png",
                    height: 20,
                    width: 20,
                  ),
                  label: "Tri-cycle",
                  isSelected: _vehicleType == "tricycle",
                  onTap: () => setState(() => _vehicleType = "tricycle"),
                ),
                OptionBadge(
                  leading: Image.asset(
                    "images/truck.png",
                    height: 20,
                    width: 20,
                  ),
                  label: "Pick-up Van",
                  isSelected: _vehicleType == "truck",
                  onTap: () => setState(() => _vehicleType = "truck"),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _vehiclePlateNumberController,
              decoration: const InputDecoration(
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
          const SizedBox(
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
            controller: _bankNameController,
            decoration: const InputDecoration(
              label: Text("Bank Name"),
            ),
          ),
          TextFormField(
            controller: _accountNumberController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              label: const Text("Account Number"),
              focusColor: accentColor,
            ),
          ),
          TextFormField(
            controller: _accountNameController,
            decoration: InputDecoration(
              label: const Text("Account Name"),
              focusColor: accentColor,
            ),
          ),
          TextFormField(
            controller: _bvnController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              label: Text("BVN"),
            ),
          ),
        ],
      ),
    ];
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
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
                              mainAxisAlignment: MainAxisAlignment.center,
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
                              mainAxisAlignment: MainAxisAlignment.center,
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
              const SizedBox(
                height: 60,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OptionBadge extends StatelessWidget {
  final Function() onTap;
  final String label;
  final bool isSelected;
  final Widget? leading;
  const OptionBadge({
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.leading,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? accentColor : tartiaryColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              leading != null ? leading! : const SizedBox(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  label,
                  style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
