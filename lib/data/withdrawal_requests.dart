import 'package:cloud_firestore/cloud_firestore.dart';

class WalletCashOutRquest {
  String? id;
  double amount;
  Timestamp timeRequested;
  Timestamp? sentAt;
  Timestamp? rejectedAt;
  String walletId;
  String accountNumber;
  String accountName;
  String bankName;
  String? status;
  String? rejectionReason;
  String userType;
  String uid;
  double balance;

  WalletCashOutRquest({
    this.id,
    required this.amount,
    required this.timeRequested,
    required this.sentAt,
    required this.rejectedAt,
    required this.walletId,
    required this.accountNumber,
    required this.accountName,
    required this.bankName,
    this.status,
    this.rejectionReason,
    required this.userType,
    required this.uid,
    required this.balance,
  });

  factory WalletCashOutRquest.fromMap(Map<String, dynamic> data) {
    return WalletCashOutRquest(
        amount: data['amount'],
        timeRequested: data['time_requested'],
        sentAt: data['sent_at'],
        rejectedAt: data['rejected_at'],
        walletId: data['wallet_id'],
        uid: data['uid'],
        balance: data['balance'],
        accountNumber: data['account_number'],
        accountName: data['account_name'],
        bankName: data['bank_name'],
        status: data['status'],
        rejectionReason: data['rejection_reason'],
        userType: data['user_type']);
  }

  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'time_requested': timeRequested,
      'sent_at': sentAt,
      'rejected_at': rejectedAt,
      'wallet_id': walletId,
      'account_number': accountNumber,
      'account_name': accountName,
      'bank_name': bankName,
      'status': status,
      'rejection_reason': rejectionReason,
      'user_type': userType,
      'uid': uid,
      'balance': balance,
    };
  }
}
