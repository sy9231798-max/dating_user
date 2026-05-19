class ProfileSetupDetailModel {
  ProfileSetupDetailModel({
    required this.firstName,
    required this.lastName,
    required this.hobby,
    required this.dob,
    required this.gender,
    required this.state,
    required this.city,
  });

  final String firstName;
  final String lastName;
  final List<String> hobby;
  final String dob;
  final String gender;
  final String state;
  final String city;

  ProfileSetupDetailModel copyWith({
    String? firstName,
    String? lastName,
    List<String>? hobby,
    String? dob,
    String? gender,
    String? state,
    String? city,
  }) {
    return ProfileSetupDetailModel(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      hobby: hobby ?? this.hobby,
      dob: dob ?? this.dob,
      gender: gender ?? this.gender,
      state: state ?? this.state,
      city: city ?? this.city,
    );
  }

  factory ProfileSetupDetailModel.fromJson(Map<String, dynamic> json){
    return ProfileSetupDetailModel(
      firstName: json["first_name"] ?? "",
      lastName: json["last_name"] ?? "",
      hobby: json["hobby"] == null ? [] : List<String>.from(json["hobby"]!.map((x) => x)),
      dob: json["dob"] ?? "",
      gender: json["gender"] ?? "",
      state: json["state"] ?? "",
      city: json["city"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "first_name": firstName,
    "last_name": lastName,
    "hobby": hobby.map((x) => x).toList(),
    "dob": dob,
    "gender": gender,
    "state": state,
    "city": city,
  };

  @override
  String toString(){
    return "$firstName, $lastName, $hobby, $dob, $gender, $state, $city, ";
  }
}
