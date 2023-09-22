import 'package:cloud_firestore/cloud_firestore.dart';

class WalletCashOutRquest {
  num? amount;
  Timestamp? time;
  String? walletId;
  String? accountNumber;
  String? accountName;
  String? bankName;
  String? status;
  String? rejectionReason;

  WalletCashOutRquest({
    this.amount,
    this.time,
    this.walletId,
    this.accountNumber,
    this.accountName,
    this.bankName,
    this.status,
    this.rejectionReason,
  });

  factory WalletCashOutRquest.fromMap(Map<String, dynamic> data) {
    return WalletCashOutRquest(
      amount: data['amount'],
      time: data['time'],
      walletId: data['wallet_id'],
      accountNumber: data['account_number'],
      accountName: data['account_name'],
      bankName: data['bank_name'],
      status: data['status'],
      rejectionReason: data['rejection_reason'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'time': time,
      'wallet_id': walletId,
      'account_number': accountNumber,
      'account_name': accountName,
      'bank_name': bankName,
      'status': status,
      'rejection_reason': rejectionReason,
    };
  }
}
