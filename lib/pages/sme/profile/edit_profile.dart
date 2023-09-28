import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import '../../../constants.dart';
import '../../../data/profile_data.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileForm extends StatefulWidget {
  const EditProfileForm({super.key});

  @override
  State<EditProfileForm> createState() => _EditProfileFormState();
}

class _EditProfileFormState extends State<EditProfileForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  final ImagePicker picker = ImagePicker();

  String profilePicture = "";

  Profile? myProfile;
  bool _loading = false;
  bool _uploading = false;

  Uint8List? image;

  _getProfile() async {
    var uid = FirebaseAuth.instance.currentUser!.uid;
    var user =
        await FirebaseFirestore.instance.collection("profiles").doc(uid).get();
    var profile = Profile.fromMap(user.data()!);
    _nameController.text = profile.fullName ?? "";
    _phoneNumberController.text = profile.phoneNumber ?? "";
    _addressController.text = profile.address ?? "";
    if (profile.profilePicture != null && profile.profilePicture!.isNotEmpty) {
      FirebaseStorage.instance
          .ref()
          .child(profile.profilePicture!)
          .getData()
          .then((value) => setState(() => image = value));
    }
    setState(() {
      myProfile = profile;
    });
  }

  Future getImage() async {
    final XFile? i = await picker.pickImage(source: ImageSource.gallery);

    var img = await i!.readAsBytes();

    setState(() {
      image = img;
    });
  }

  _updateProfile() async {
    setState(() => _loading = true);
    var uid = FirebaseAuth.instance.currentUser!.uid;
    var profilePic = "";
    if (image != null) {
      setState(() => _uploading = true);
      var uploadTask = FirebaseStorage.instance
          .ref()
          .child("/profile_pictures/$uid.png")
          .putData(image!);
      await uploadTask.whenComplete(() => setState(() {}));
      setState(() => _uploading = false);
      profilePic = "/profile_pictures/$uid.png";
    }

    myProfile!.profilePicture = profilePic;
    myProfile!.fullName = _nameController.text;
    myProfile!.address = _addressController.text;
    myProfile!.phoneNumber = _phoneNumberController.text;

    await FirebaseFirestore.instance
        .collection("profiles")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update(myProfile!.toMap());
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Profile Updated"),
      ),
    );
    setState(() => _loading = false);
  }

  @override
  void initState() {
    _getProfile();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
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
          onPressed: _loading ? null : _updateProfile,
          color: accentColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: _loading
              ? CircularProgressIndicator(
                  color: primaryColor,
                )
              : const Text(
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
                        image: DecorationImage(
                          image: MemoryImage(image!),
                        ),
                        color: tartiaryColor,
                        borderRadius: BorderRadius.circular(75),
                      ),
                      alignment: Alignment.bottomCenter,
                      child: image == null
                          ? const Icon(
                              Icons.person,
                              size: 150,
                            )
                          : null,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: getImage,
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
                  ),
                ],
              ),
              Text(FirebaseAuth.instance.currentUser!.email ?? ""),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    label: Text("Full Name"),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _phoneNumberController,
                  decoration: InputDecoration(
                    label: Text("Phone number"),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _addressController,
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
