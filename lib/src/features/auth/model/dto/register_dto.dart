// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class RegisterDTO {
  final String email;
  final String password;
  final String name;
  final String? phoneNumber;
  final String gender;
  RegisterDTO({
    required this.email,
    required this.password,
    required this.name,
    required this.phoneNumber,
    required this.gender,
  });

  RegisterDTO copyWith({
    String? email,
    String? password,
    String? name,
    String? phoneNumber,
    String? gender,
  }) {
    return RegisterDTO(
      email: email ?? this.email,
      password: password ?? this.password,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      gender: gender ?? this.gender,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
      'password': password,
      'name': name,
      'phoneNumber': phoneNumber,
      'gender': gender,
    };
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'RegisterDTO(email: $email, password: $password, name: $name, phoneNumber: $phoneNumber, gender: $gender)';
  }

  @override
  bool operator ==(covariant RegisterDTO other) {
    if (identical(this, other)) return true;

    return other.email == email &&
        other.password == password &&
        other.name == name &&
        other.phoneNumber == phoneNumber &&
        other.gender == gender;
  }

  @override
  int get hashCode {
    return email.hashCode ^
        password.hashCode ^
        name.hashCode ^
        phoneNumber.hashCode ^
        gender.hashCode;
  }
}
