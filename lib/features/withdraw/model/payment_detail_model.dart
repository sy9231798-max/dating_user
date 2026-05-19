class PaymentDetail {
  PaymentDetail({
    required this.id,
    required this.userId,
    required this.accountNumber,
    required this.bankName,
    required this.holderName,
    required this.ifscCode,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final int userId;
  final String accountNumber;
  final String bankName;
  final String holderName;
  final String ifscCode;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  PaymentDetail copyWith({
    int? id,
    int? userId,
    String? accountNumber,
    String? bankName,
    String? holderName,
    String? ifscCode,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PaymentDetail(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      accountNumber: accountNumber ?? this.accountNumber,
      bankName: bankName ?? this.bankName,
      holderName: holderName ?? this.holderName,
      ifscCode: ifscCode ?? this.ifscCode,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory PaymentDetail.fromJson(Map<String, dynamic> json){
    return PaymentDetail(
      id: json["id"] ?? 0,
      userId: json["user_id"] ?? 0,
      accountNumber: json["account_number"] ?? "",
      bankName: json["bank_name"] ?? "",
      holderName: json["holder_name"] ?? "",
      ifscCode: json["ifsc_code"] ?? "",
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "account_number": accountNumber,
    "bank_name": bankName,
    "holder_name": holderName,
    "ifsc_code": ifscCode,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };

  @override
  String toString(){
    return "$id, $userId, $accountNumber, $bankName, $holderName, $ifscCode, $createdAt, $updatedAt, ";
  }
}
