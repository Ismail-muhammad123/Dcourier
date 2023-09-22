import 'package:cloud_firestore/cloud_firestore.dart';

class Payment {
  String? deliveryId;
  String? amount;
  String? courierId;
  String? senderId;
  Timestamp? time;
  String? status;
  String? paymentReferance;
  String? description;

  Payment({
    this.deliveryId,
    this.amount,
    this.courierId,
    this.senderId,
    this.time,
    this.status,
    this.paymentReferance,
    this.description,
  });

  factory Payment.fromMap(Map<String, dynamic> data) {
    return Payment(
      deliveryId: data['delivery_id'],
      amount: data['amount'],
      courierId: data['courier_id'],
      senderId: data['sender_id'],
      time: data['time'],
      status: data['status'],
      paymentReferance: data['payment_referance'],
      description: data['description'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'delivery_id': deliveryId,
      'amount': amount,
      'courier_id': courierId,
      'sender_id': senderId,
      'time': time,
      'status': status,
      'payment_referance': paymentReferance,
      'description': description,
    };
  }
}
