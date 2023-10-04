import 'package:cloud_firestore/cloud_firestore.dart';

class KYC {
  String? id;
  String? idType;
  String? idPictureFront;
  String? idPictureBack;

  String? bvn;
  String? accountName;
  String? accountNumber;
  String? bankName;

  String? vehiclePlateNumber;

  Timestamp? dateFiled;
  bool? verified;

  KYC({
    this.id,
    this.idType,
    this.idPictureFront,
    this.idPictureBack,
    this.dateFiled,
    this.verified,
    this.bvn,
    this.accountName,
    this.accountNumber,
    this.bankName,
    this.vehiclePlateNumber,
  });

  factory KYC.fromMap(Map<String, dynamic> data) {
    return KYC(
      idType: data['id_type'],
      idPictureFront: data['id_picture_front'],
      idPictureBack: data['id_picture_back'],
      dateFiled: data['date_filed'],
      verified: data['verified'],
      bvn: data['bvn'],
      accountName: data['account_name'],
      accountNumber: data['account_number'],
      bankName: data['bank_name'],
      vehiclePlateNumber: data['vehicle_plate_number'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id_type": idType,
      "id_picture_front": idPictureFront,
      "id_picture_back": idPictureBack,
      "date_filed": dateFiled,
      "verified": verified,
      "bvn": bvn,
      "account_name": accountName,
      "account_number": accountNumber,
      "bank_name": bankName,
      "vehicle_plate_number": vehiclePlateNumber,
    };
  }
}
