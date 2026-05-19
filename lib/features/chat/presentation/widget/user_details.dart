
class UserDetails {
  final int id;
  final String name;
  final String email;
  final String phoneNumber;
  final String gender;
  final String address;
  final String city;
  final String state;
  final String dateOfBirth;
  final String createdAt;
  final String updatedAt;

  UserDetails({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.gender,
    required this.address,
    required this.city,
    required this.state,
    required this.dateOfBirth,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return UserDetails(
      id: json['id'] ?? -1,
      name: json['name'] ?? "",
      email: json['email'] ?? "",
      phoneNumber: json['phone_number'] ?? "",
      gender: json['gender'] ?? "",
      address: json['address'] ?? "",
      city: json['city'] ?? "",
      state: json['state'] ?? "",
      dateOfBirth: json['date_of_birth'] ?? "",
      createdAt: json['created_at'] ?? "",
      updatedAt: json['updated_at'] ?? "",
    );
  }

  factory UserDetails.empty() {
    return UserDetails(
      id: -1,
      name: "",
      email: "",
      phoneNumber: "",
      gender: "",
      address: "",
      city: "",
      state: "",
      dateOfBirth: "",
      createdAt: "",
      updatedAt: "",
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['phone_number'] = phoneNumber;
    data['gender'] = gender;
    data['address'] = address;
    data['city'] = city;
    data['state'] = state;
    data['date_of_birth'] = dateOfBirth;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
