class PaymentHistoryModel {
  PaymentHistoryModel({
    required this.id,
    required this.userId,
    required this.accountNumber,
    required this.bankName,
    required this.amount,
    required this.paymentStatus,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final int userId;
  final String accountNumber;
  final String bankName;
  final num amount;
  final String paymentStatus;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  PaymentHistoryModel copyWith({
    int? id,
    int? userId,
    String? accountNumber,
    String? bankName,
    num? amount,
    String? paymentStatus,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PaymentHistoryModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      accountNumber: accountNumber ?? this.accountNumber,
      bankName: bankName ?? this.bankName,
      amount: amount ?? this.amount,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory PaymentHistoryModel.fromJson(Map<String, dynamic> json){
    return PaymentHistoryModel(
      id: json["id"] ?? 0,
      userId: json["user_id"] ?? 0,
      accountNumber: json["account_number"] ?? "",
      bankName: json["bank_name"] ?? "",
      amount: json["amount"] ?? 0,
      paymentStatus: json["payment_status"] ?? "",
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "account_number": accountNumber,
    "bank_name": bankName,
    "amount": amount,
    "payment_status": paymentStatus,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };

  @override
  String toString(){
    return "$id, $userId, $accountNumber, $bankName, $amount, $paymentStatus, $createdAt, $updatedAt, ";
  }
}
