import 'dart:convert';

class User {
  final int id;
  final String email;
  final String role;
  final String? picture;
  final String phoneNumber;
  final bool isConfirmed;
  final String gender;
  final String name;
  User({
    required this.id,
    required this.email,
    required this.role,
    this.picture,
    required this.phoneNumber,
    required this.isConfirmed,
    required this.gender,
    required this.name,
  });

  User copyWith({
    int? id,
    String? email,
    String? role,
    String? picture,
    String? phoneNumber,
    bool? isConfirmed,
    String? gender,
    String? name,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      role: role ?? this.role,
      picture: picture ?? this.picture,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      isConfirmed: isConfirmed ?? this.isConfirmed,
      gender: gender ?? this.gender,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'email': email,
      'role': role,
      'picture': picture,
      'phoneNumber': phoneNumber,
      'isConfirmed': isConfirmed,
      'gender': gender,
      'name': name,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      email: map['email'] as String,
      role: map['role'] as String,
      picture: map['picture'] as String?,
      phoneNumber: map['phoneNumber'] as String,
      isConfirmed: map['isConfirmed'] as bool,
      gender: (map['gender'] ?? "-"),
      name: (map['name'] ?? "Guest"),
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'User(id: $id, email: $email, role: $role, picture: $picture, phoneNumber: $phoneNumber, isConfirmed: $isConfirmed, gender: $gender, name: $name)';
  }

  @override
  bool operator ==(covariant User other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.email == email &&
        other.role == role &&
        other.picture == picture &&
        other.phoneNumber == phoneNumber &&
        other.isConfirmed == isConfirmed &&
        other.gender == gender &&
        other.name == name;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        email.hashCode ^
        role.hashCode ^
        picture.hashCode ^
        phoneNumber.hashCode ^
        isConfirmed.hashCode ^
        gender.hashCode ^
        name.hashCode;
  }
}
