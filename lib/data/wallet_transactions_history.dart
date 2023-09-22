import 'package:cloud_firestore/cloud_firestore.dart';

class WalletTransactions {
  num? debitAmount;
  num? creditAmount;
  Timestamp? time;
  String? description;

  WalletTransactions({
    this.debitAmount,
    this.creditAmount,
    this.time,
    this.description,
  });

  factory WalletTransactions.fromMap(Map<String, dynamic> data) {
    return WalletTransactions(
      debitAmount: data['debit_amount'],
      creditAmount: data['credit_amount'],
      time: data['time'],
      description: data['description'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'debit_amount': debitAmount,
      'credit_amount': creditAmount,
      'time': time,
      'description': description,
    };
  }
}
