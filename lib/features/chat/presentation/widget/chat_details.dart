class ChatDetails {
  final int id;
  final String userId;
  final String image;
  final String message;
  final String createdAt;
  final String updatedAt;

  ChatDetails({
    required this.id,
    required this.userId,
    required this.image,
    required this.message,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ChatDetails.fromJson(Map<String, dynamic> json) {
    return ChatDetails(
      id : json['id'] ?? -1,
      userId : json['user_id'] ?? "",
      image : json['image'] ?? "",
      message : json['message'] ?? "",
      createdAt : json['created_at'] ?? "",
      updatedAt : json['updated_at'] ?? "",
    );
  }

  factory ChatDetails.empty(){
    return ChatDetails(id: -1, userId: "", image: "", message: "", createdAt: "", updatedAt: "");
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['image'] = image;
    data['message'] = message;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}