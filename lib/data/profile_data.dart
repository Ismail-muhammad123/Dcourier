import 'package:cloud_firestore/cloud_firestore.dart';

class Profile {
  String? id;
  String? address;
  String? fullName;
  String? email;
  String? phoneNumber;
  String? profilePicture;
  Timestamp? dateJoined;
  bool verified;

  Profile({
    this.id,
    this.address,
    this.fullName,
    this.email,
    this.phoneNumber,
    this.profilePicture,
    this.dateJoined,
    this.verified = false,
  });

  factory Profile.fromMap(Map<String, dynamic> data) {
    return Profile(
      address: data["address"],
      fullName: data["full_name"],
      email: data["email"],
      phoneNumber: data["phone_number"],
      profilePicture: data["profile_picture"],
      dateJoined: data["date_joined"],
      verified: data["verified"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "address": address,
      "full_name": fullName,
      "email": email,
      "phone_number": phoneNumber,
      "profile_picture": profilePicture,
      "date_joined": dateJoined,
      "verified": verified,
    };
  }
}
