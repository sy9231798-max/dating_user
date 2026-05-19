import 'package:dating_user/core/common_model/user_model.dart';
import 'package:logger/logger.dart';

class UserProfileStatus {
  UserProfileStatus({
    required this.userData,
    required this.additionImage,
    required this.token,
    required this.errorCode,
    required this.step1ErrorMessage,
    required this.step2ErrorMessage,
    required this.step3ErrorMessage,
    required this.reference,
  });

  final UserProfileStatusData? userData;
  final List<AdditionImage> additionImage;
  final String token;
  final String reference;
  final num errorCode;
  final String step1ErrorMessage;
  final String step2ErrorMessage;
  final String step3ErrorMessage;

  UserProfileStatus copyWith({
    UserProfileStatusData? userData,
    List<AdditionImage>? additionImage,
    String? token,
    String? reference,
    num? errorCode,
    String? step1ErrorMessage,
    String? step2ErrorMessage,
    String? step3ErrorMessage,
  }) {
    return UserProfileStatus(
      userData: userData ?? this.userData,
      additionImage: additionImage ?? this.additionImage,
      token: token ?? this.token,
      errorCode: errorCode ?? this.errorCode,
      step1ErrorMessage: step1ErrorMessage ?? this.step1ErrorMessage,
      step2ErrorMessage: step2ErrorMessage ?? this.step2ErrorMessage,
      step3ErrorMessage: step3ErrorMessage ?? this.step3ErrorMessage,
      reference: reference ?? this.reference,
    );
  }

  factory UserProfileStatus.fromJson(Map<String, dynamic> json) {

    return UserProfileStatus(
      userData: json["user_data"] == null
          ? null
          : UserProfileStatusData.fromJson(json["user_data"]),
      additionImage: json["addition_image"] == null
          ? []
          : List<AdditionImage>.from(
              json["addition_image"]!.map((x) => AdditionImage.fromJson(x)),
            ),
      token: json["token"] ?? "",
      errorCode: json["error_code"] ?? 0,
      step1ErrorMessage: json["step1_error_message"] ?? "",
      step2ErrorMessage: json["step2_error_message"] ?? "",
      step3ErrorMessage: json["step3_error_message"] ?? "",
      reference: json["reference"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "user_data": userData?.toJson(),
    "addition_image": additionImage.map((x) => x.toJson()).toList(),
    "token": token,
    "error_code": errorCode,
    "reference": reference,
    "step1_error_message": step1ErrorMessage,
    "step2_error_message": step2ErrorMessage,
    "step3_error_message": step3ErrorMessage,
  };

  @override
  String toString() {
    return "$userData, $additionImage, $token, $errorCode, $step1ErrorMessage, $step2ErrorMessage, $step3ErrorMessage, ";
  }
}

class UserProfileStatusData {
  UserProfileStatusData({
    required this.gender,
    required this.lastName,
    required this.hobby,
    required this.accountType,
    required this.firstName,
    required this.state,
    required this.updatedAt,
    required this.email,
    required this.city,
    required this.isActive,
    required this.phoneNumber,
    required this.id,
    required this.profilePicture,
    required this.createdAt,
    required this.videoPicture,
    required this.step1Error,
    required this.step2Error,
    required this.step3Error,
    required this.dob,
  });

  final String gender;
  final String step3Error;
  final String lastName;
  final List<String> hobby;
  final String accountType;
  final String firstName;
  final String state;
  final DateTime? updatedAt;
  final String email;
  final String city;
  final bool isActive;
  final String phoneNumber;
  final int id;
  final String profilePicture;
  final DateTime? createdAt;
  final String videoPicture;
  final String step1Error;
  final String dob;
  final String step2Error;

  UserProfileStatusData copyWith({
    String? gender,
    String? step3Error,
    String? lastName,
    List<String>? hobby,
    String? accountType,
    String? firstName,
    String? state,
    DateTime? updatedAt,
    String? email,
    String? city,
    bool? isActive,
    String? phoneNumber,
    int? id,
    String? profilePicture,
    DateTime? createdAt,
    String? videoPicture,
    String? step1Error,
    String? dob,
    String? step2Error,
  }) {
    return UserProfileStatusData(
      gender: gender ?? this.gender,
      step3Error: step3Error ?? this.step3Error,
      lastName: lastName ?? this.lastName,
      hobby: hobby ?? this.hobby,
      accountType: accountType ?? this.accountType,
      firstName: firstName ?? this.firstName,
      state: state ?? this.state,
      updatedAt: updatedAt ?? this.updatedAt,
      email: email ?? this.email,
      city: city ?? this.city,
      isActive: isActive ?? this.isActive,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      id: id ?? this.id,
      profilePicture: profilePicture ?? this.profilePicture,
      createdAt: createdAt ?? this.createdAt,
      videoPicture: videoPicture ?? this.videoPicture,
      step1Error: step1Error ?? this.step1Error,
      dob: dob ?? this.dob,
      step2Error: step2Error ?? this.step2Error,
    );
  }

  factory UserProfileStatusData.fromJson(Map<String, dynamic> json) {
    return UserProfileStatusData(
      gender: json["gender"] ?? "",
      step3Error: json["step_3_error"] ?? "",
      lastName: json["last_name"] ?? "",
      hobby: json["hobby"] == null
          ? []
          : List<String>.from(json["hobby"]!.map((x) => x)),
      accountType: json["account_type"] ?? "",
      firstName: json["first_name"] ?? "",
      state: json["state"] ?? "",
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
      email: json["email"] ?? "",
      city: json["city"] ?? "",
      isActive: json["is_active"] ?? false,
      phoneNumber: json["phone_number"] ?? "",
      id: json["id"] ?? 0,
      profilePicture: json["profile_picture"] ?? "",
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      videoPicture: json["video_picture"] ?? "",
      step1Error: json["step_1_error"] ?? "",
      dob: json["dob"] ?? "",
      step2Error: json["step_2_error"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "gender": gender,
    "step_3_error": step3Error,
    "last_name": lastName,
    "hobby": hobby.map((x) => x).toList(),
    "account_type": accountType,
    "first_name": firstName,
    "state": state,
    "updated_at": updatedAt?.toIso8601String(),
    "email": email,
    "city": city,
    "is_active": isActive,
    "phone_number": phoneNumber,
    "id": id,
    "profile_picture": profilePicture,
    "created_at": createdAt?.toIso8601String(),
    "video_picture": videoPicture,
    "step_1_error": step1Error,
    "dob": dob,
    "step_2_error": step2Error,
  };

  String get fullName => "$firstName $lastName";

  @override
  String toString() {
    return "$gender, $step3Error, $lastName, $hobby, $accountType, $firstName, $state, $updatedAt, $email, $city, $isActive, $phoneNumber, $id, $profilePicture, $createdAt, $videoPicture, $step1Error, $dob, $step2Error, ";
  }
}
