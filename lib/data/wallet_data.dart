class Wallet {
  String? accountNumber;
  String? accountName;
  String? bankName;
  String? status;

  Wallet({
    this.accountNumber,
    this.accountName,
    this.bankName,
    this.status,
  });

  factory Wallet.fromMap(Map<String, dynamic> data) {
    return Wallet(
      accountNumber: data['account_number'],
      accountName: data['account_name'],
      bankName: data['bank_name'],
      status: data['status'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'account_number': accountNumber,
      'account_name': accountName,
      'bank_name': bankName,
      'status': status,
    };
  }
}
