import 'package:cloud_firestore/cloud_firestore.dart';

class Profile {
  String? id;
  String? address;
  String? fullName;
  String? email;
  String? phoneNumber;
  String? profilePicture;
  String? accountType;
  Timestamp? dateJoined;
  bool available;
  bool verified;
  String? vehicleType;

  Profile({
    this.id,
    this.accountType,
    this.address,
    this.fullName,
    this.email,
    this.phoneNumber,
    this.profilePicture,
    this.dateJoined,
    this.vehicleType,
    this.verified = false,
    this.available = false,
  });

  factory Profile.fromMap(Map<String, dynamic> data) {
    return Profile(
      address: data["address"],
      accountType: data["account_type"],
      fullName: data["full_name"],
      email: data["email"],
      phoneNumber: data["phone_number"],
      profilePicture: data["profile_picture"],
      vehicleType: data["vehicle_type"],
      dateJoined: data["date_joined"],
      verified: data["verified"] ?? false,
      available: data["available"] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "account_type": accountType,
      "address": address,
      "full_name": fullName,
      "email": email,
      "phone_number": phoneNumber,
      "profile_picture": profilePicture,
      "vehicle_type": vehicleType,
      "date_joined": dateJoined,
      "verified": verified,
      "available": available,
    };
  }
}
