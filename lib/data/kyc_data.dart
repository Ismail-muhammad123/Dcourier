import 'package:cloud_firestore/cloud_firestore.dart';

class KYC {
  String? id;
  String? idType;
  String? idPictureFront;
  String? idPictureBack;
  Timestamp? dateFiled;
  bool? verified;

  KYC({
    this.id,
    this.idType,
    this.idPictureFront,
    this.idPictureBack,
    this.dateFiled,
    this.verified,
  });

  factory KYC.fromMap(Map<String, dynamic> data) {
    return KYC(
      idType: data['id_type'],
      idPictureFront: data['id_picture_front'],
      idPictureBack: data['id_picture_back'],
      dateFiled: data['date_filed'],
      verified: data['verified'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id_type": idType,
      "id_picture_front": idPictureFront,
      "id_picture_back": idPictureBack,
      "date_filed": dateFiled,
      "verified": verified,
    };
  }
}
