class UserModel {
  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.email,
    required this.profilePicture,
    required this.videoPicture,
    required this.dob,
    required this.gender,
    required this.hobby,
    required this.state,
    required this.city,
    required this.lvl,
    required this.coins,
    required this.isPending,
    required this.score,
    required this.createdAt,
    required this.additionImages,
    required this.isActive,
  });

  final int id;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String email;
  final String profilePicture;
  final String videoPicture;
  final String dob;
  final String gender;
  final List<String> hobby;
  final String state;
  final String city;
  final num lvl;
  final num coins;
  final bool isPending;
  final num score;
  final DateTime? createdAt;
  final List<AdditionImage> additionImages;
  final bool isActive;

  String get fullName => "$firstName $lastName";

  UserModel copyWith({
    int? id,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? email,
    String? profilePicture,
    String? videoPicture,
    String? dob,
    String? gender,
    List<String>? hobby,
    String? state,
    String? city,
    num? lvl,
    num? coins,
    bool? isPending,
    num? score,
    DateTime? createdAt,
    List<AdditionImage>? additionImages,
    bool? isActive,
  }) {
    return UserModel(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      profilePicture: profilePicture ?? this.profilePicture,
      videoPicture: videoPicture ?? this.videoPicture,
      dob: dob ?? this.dob,
      gender: gender ?? this.gender,
      hobby: hobby ?? this.hobby,
      state: state ?? this.state,
      city: city ?? this.city,
      lvl: lvl ?? this.lvl,
      coins: coins ?? this.coins,
      isPending: isPending ?? this.isPending,
      score: score ?? this.score,
      createdAt: createdAt ?? this.createdAt,
      additionImages: additionImages ?? this.additionImages,
      isActive: isActive ?? this.isActive,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["id"] ?? 0,
      firstName: json["first_name"] ?? "",
      lastName: json["last_name"] ?? "",
      phoneNumber: json["phone_number"] ?? "",
      email: json["email"] ?? "",
      profilePicture: json["profile_picture"] ?? "",
      videoPicture: json["video_picture"] ?? "",
      dob: json["dob"] ?? "",
      gender: json["gender"] ?? "",
      hobby: json["hobby"] == null
          ? []
          : List<String>.from(json["hobby"]!.map((x) => x)),
      state: json["state"] ?? "",
      city: json["city"] ?? "",
      lvl: json["lvl"] ?? 0,
      coins: json["coins"] ?? 0,
      isPending: json["is_pending"] ?? false,
      score: json["score"] ?? 0,
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      additionImages: json["addition_images"] == null
          ? []
          : List<AdditionImage>.from(
              json["addition_images"]!.map((x) => AdditionImage.fromJson(x)),
            ),
      isActive: json["is_active"] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "first_name": firstName,
    "last_name": lastName,
    "phone_number": phoneNumber,
    "email": email,
    "profile_picture": profilePicture,
    "video_picture": videoPicture,
    "dob": dob,
    "gender": gender,
    "hobby": hobby.map((x) => x).toList(),
    "state": state,
    "city": city,
    "lvl": lvl,
    "coins": coins,
    "is_pending": isPending,
    "score": score,
    "created_at": createdAt?.toIso8601String(),
    "addition_images": additionImages.map((x) => x.toJson()).toList(),
    "is_active": isActive,
  };

  @override
  String toString() {
    return "$id, $firstName, $lastName, $phoneNumber, $email, $profilePicture, $videoPicture, $dob, $gender, $hobby, $state, $city, $lvl, $coins, $isPending, $score, $createdAt, $additionImages, $isActive, ";
  }
}

class AdditionImage {
  AdditionImage({
    required this.id,
    required this.imagePath,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final String imagePath;
  final int userId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  AdditionImage copyWith({
    int? id,
    String? imagePath,
    int? userId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AdditionImage(
      id: id ?? this.id,
      imagePath: imagePath ?? this.imagePath,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory AdditionImage.fromJson(Map<String, dynamic> json) {
    return AdditionImage(
      id: json["id"] ?? 0,
      imagePath: json["image_path"] ?? "",
      userId: json["user_id"] ?? 0,
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "image_path": imagePath,
    "user_id": userId,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };

  @override
  String toString() {
    return "$id, $imagePath, $userId, $createdAt, $updatedAt, ";
  }
}
