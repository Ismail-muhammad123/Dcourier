import 'package:cloud_firestore/cloud_firestore.dart';

class Delivery {
  String? itemType;
  String? vehicleTyle;
  String? pickupAddress;
  Timestamp? pickupTime;
  String? recieverName;
  String? remark;
  num? amount;
  String? status;
  String? senderId;
  String? courierId;

  Delivery({
    this.itemType,
    this.vehicleTyle,
    this.pickupAddress,
    this.pickupTime,
    this.recieverName,
    this.remark,
    this.amount,
    this.status,
    this.senderId,
    this.courierId,
  });
  factory Delivery.fromMap(Map<String, dynamic> data) {
    return Delivery(
      itemType: data['item_type'],
      vehicleTyle: data['vehicle_tyle'],
      pickupAddress: data['pickup_address'],
      pickupTime: data['pickup_time'],
      recieverName: data['reciever_name'],
      remark: data['remark'],
      amount: data['amount'],
      status: data['status'],
      senderId: data['sender_id'],
      courierId: data['courier_id'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'item_type': itemType,
      'vehicle_tyle': vehicleTyle,
      'pickup_address': pickupAddress,
      'pickup_time': pickupTime,
      'reciever_name': recieverName,
      'remark': remark,
      'amount': amount,
      'status': status,
      'sender_id': senderId,
      'courier_id': courierId,
    };
  }
}
