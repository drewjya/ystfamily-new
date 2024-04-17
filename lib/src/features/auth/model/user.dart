import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class User {
  final int userId;
  final int accountId;
  final String nama;
  final String gender;
  final String? phoneNumber;
  final String? profilePicture;
  final String email;
  final bool verified;
  final String role;
  User({
    required this.userId,
    required this.accountId,
    required this.nama,
    required this.gender,
    required this.phoneNumber,
    required this.profilePicture,
    required this.email,
    required this.verified,
    required this.role,
  });

  User copyWith({
    int? userId,
    int? accountId,
    String? nama,
    String? gender,
    String? phoneNumber,
    String? profilePicture,
    String? email,
    bool? verified,
    String? role,
  }) {
    return User(
      userId: userId ?? this.userId,
      accountId: accountId ?? this.accountId,
      nama: nama ?? this.nama,
      gender: gender ?? this.gender,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profilePicture: profilePicture ?? this.profilePicture,
      email: email ?? this.email,
      verified: verified ?? this.verified,
      role: role ?? this.role,
    );
  }

  @override
  String toString() {
    return 'User(userId: $userId, accountId: $accountId, nama: $nama, gender: $gender, phoneNumber: $phoneNumber, profilePicture: $profilePicture, email: $email, verified: $verified, role: $role)';
  }

  @override
  bool operator ==(covariant User other) {
    if (identical(this, other)) return true;

    return other.userId == userId &&
        other.accountId == accountId &&
        other.nama == nama &&
        other.gender == gender &&
        other.phoneNumber == phoneNumber &&
        other.profilePicture == profilePicture &&
        other.email == email &&
        other.verified == verified &&
        other.role == role;
  }

  @override
  int get hashCode {
    return userId.hashCode ^ accountId.hashCode ^ nama.hashCode ^ gender.hashCode ^ phoneNumber.hashCode ^ profilePicture.hashCode ^ email.hashCode ^ verified.hashCode ^ role.hashCode;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'accountId': accountId,
      'nama': nama,
      'gender': gender,
      'phoneNumber': phoneNumber,
      'profilePicture': profilePicture,
      'email': email,
      'verified': verified,
      'role': role,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      userId: map['user_id'],
      accountId: map['account_id'],
      nama: map['nama'],
      gender: map['gender'],
      phoneNumber: map['phone_number'],
      profilePicture: map['profile_picture'],
      email: map['email'],
      verified: map['verified'],
      role: map['role'],
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source) as Map<String, dynamic>);
}
