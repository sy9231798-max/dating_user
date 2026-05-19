class CallHistoryModel {
  CallHistoryModel({
    required this.id,
    required this.callerId,
    required this.user,
    required this.duration,
    required this.createdAt,
  });

  final int id;
  final int callerId;
  final User? user;
  final num duration;
  final DateTime? createdAt;

  CallHistoryModel copyWith({
    int? id,
    int? callerId,
    User? user,
    num? duration,
    DateTime? createdAt,
  }) {
    return CallHistoryModel(
      id: id ?? this.id,
      callerId: callerId ?? this.callerId,
      user: user ?? this.user,
      duration: duration ?? this.duration,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory CallHistoryModel.fromJson(Map<String, dynamic> json){
    return CallHistoryModel(
      id: json["id"] ?? 0,
      callerId: json["caller_id"] ?? 0,
      user: json["user"] == null ? null : User.fromJson(json["user"]),
      duration: json["duration"] ?? 0,
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "caller_id": callerId,
    "user": user?.toJson(),
    "duration": duration,
    "created_at": createdAt?.toIso8601String(),
  };

  @override
  String toString(){
    return "$id, $callerId, $user, $duration, $createdAt, ";
  }
}

class User {
  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.profilePicture,
  });

  final int id;
  final String firstName;
  final String lastName;
  final String profilePicture;

  User copyWith({
    int? id,
    String? firstName,
    String? lastName,
    String? profilePicture,
  }) {
    return User(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      profilePicture: profilePicture ?? this.profilePicture,
    );
  }

  factory User.fromJson(Map<String, dynamic> json){
    return User(
      id: json["id"] ?? 0,
      firstName: json["first_name"] ?? "",
      lastName: json["last_name"] ?? "",
      profilePicture: json["profile_picture"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "first_name": firstName,
    "last_name": lastName,
    "profile_picture": profilePicture,
  };

  @override
  String toString(){
    return "$id, $firstName, $lastName, $profilePicture, ";
  }
}
