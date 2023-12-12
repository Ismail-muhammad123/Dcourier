import 'package:cloud_firestore/cloud_firestore.dart';

class Delivery {
  String? id;
  String? itemType;
  String? vehicleType;
  String? pickupAddress;
  String? pickupCoodinate;
  Timestamp? pickupTime;
  String? recieverName;
  String? recieverPhoneNumber;
  String? deliveryAddress;
  List? deliveryCoodinate;
  String? remark;
  num? amount;
  String? status;
  String? senderId;
  String? courierId;

  Timestamp? pickUtAt;
  Timestamp? deliveredAt;
  String? pickUpImage;
  String? deliveredImage;

  Delivery({
    this.id,
    this.itemType,
    this.vehicleType,
    this.pickupAddress,
    this.pickupCoodinate,
    this.pickupTime,
    this.deliveryAddress,
    this.deliveryCoodinate,
    this.recieverName,
    this.recieverPhoneNumber,
    this.remark,
    this.amount,
    this.status,
    this.senderId,
    this.courierId,
    this.pickUtAt,
    this.deliveredAt,
    this.pickUpImage,
    this.deliveredImage,
  });
  factory Delivery.fromMap(Map<String, dynamic> data) {
    return Delivery(
      itemType: data['item_type'],
      vehicleType: data['vehicle_type'],
      pickupAddress: data['pickup_address'],
      pickupCoodinate: data['pickup_coodinate'],
      pickupTime: data['pickup_time'],
      deliveryAddress: data['delivery_address'],
      deliveryCoodinate: data['delivery_coodinate'],
      recieverName: data['reciever_name'],
      recieverPhoneNumber: data['reciever_phone_number'],
      remark: data['remark'],
      amount: data['amount'],
      status: data['status'],
      senderId: data['sender_id'],
      courierId: data['courier_id'],
      pickUtAt: data['pickUt_at'],
      deliveredAt: data['delivered_at'],
      pickUpImage: data['pickUp_image'],
      deliveredImage: data['delivered_image'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'item_type': itemType,
      'vehicle_type': vehicleType,
      'pickup_address': pickupAddress,
      'pickup_coodinate': pickupCoodinate,
      'pickup_time': pickupTime,
      'reciever_name': recieverName,
      'delivery_address': deliveryAddress,
      'delivery_coodinate': deliveryCoodinate,
      'reciever_phone_number': recieverPhoneNumber,
      'remark': remark,
      'amount': amount,
      'status': status,
      'sender_id': senderId,
      'courier_id': courierId,
      'pickUt_at': pickUtAt,
      'delivered_at': deliveredAt,
      'pickUp_image': pickUpImage,
      'delivered_image': deliveredImage,
    };
  }
}
