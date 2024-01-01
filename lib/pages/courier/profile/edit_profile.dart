import 'dart:typed_data';
import 'package:app/data/profile_data.dart';
import 'package:app/pages/camera_image.dart';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../../constants.dart';

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
    if (mounted) {
      setState(() {
        myProfile = profile;
      });
    }
    if (profile.profilePicture != null && profile.profilePicture!.isNotEmpty) {
      FirebaseStorage.instance
          .ref()
          .child(profile.profilePicture!)
          .getData()
          .then((value) {
        if (mounted) {
          setState(() => image = value);
        }
      }).onError((error, stackTrace) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Profile Picture not found!"),
          ),
        );
      });
    }
  }

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

  Future getImage() async {
    var img = await _pickImage();

    if (img != null) {
      setState(() {
        image = img;
      });
    }
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
      const SnackBar(
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
                  "Save",
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
                        image: image != null
                            ? DecorationImage(
                                image: MemoryImage(image!),
                              )
                            : null,
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
                      onTap: _uploading ? null : getImage,
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: accentColor,
                        ),
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.edit,
                          color: _uploading ? Colors.grey : Colors.white,
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
                  decoration: const InputDecoration(
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
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 16.0,
                  horizontal: 8.0,
                ),
                child: Row(
                  children: [
                    const Text(
                      "Joined:",
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      myProfile != null
                          ? DateFormat.yMMMEd().format(
                              myProfile!.dateJoined!.toDate(),
                            )
                          : "",
                      style: const TextStyle(fontStyle: FontStyle.italic),
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
