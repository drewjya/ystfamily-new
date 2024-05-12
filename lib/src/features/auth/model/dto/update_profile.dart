// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:image_picker/image_picker.dart';

class UpdateProfileDTO {
  final String nama;
  final String phoneNumber;
  final String gender;
  final XFile? profilePicture;
  UpdateProfileDTO({
    required this.nama,
    required this.phoneNumber,
    required this.gender,
    this.profilePicture,
  });

  Map<String, XFile>? getProfilePictureMap() {
    return profilePicture != null ? {"file": profilePicture!} : null;
  }

  Map<String, String> getBody() {
    var body = <String, String>{};

    body['name'] = nama;
    body['phoneNumber'] = phoneNumber;
     body['gender'] = gender;

    return body;
  }

  @override
  String toString() {
    return 'UpdateProfileDTO(nama: $nama, phoneNumber: $phoneNumber, gender: $gender, profilePicture: $profilePicture)';
  }

  @override
  bool operator ==(covariant UpdateProfileDTO other) {
    if (identical(this, other)) return true;

    return other.nama == nama &&
        other.phoneNumber == phoneNumber &&
        other.gender == gender &&
        other.profilePicture == profilePicture;
  }

  @override
  int get hashCode {
    return nama.hashCode ^
        phoneNumber.hashCode ^
        gender.hashCode ^
        profilePicture.hashCode;
  }
}
