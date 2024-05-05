import 'dart:convert';

class Cabang {
  final int id;
  final String alamat;
  final String closeHour;
  final String nama;
  final String openHour;
  final String phoneNumber;
  final String? picture;
  Cabang({
    required this.id,
    required this.alamat,
    required this.closeHour,
    required this.nama,
    required this.openHour,
    required this.phoneNumber,
    required this.picture,
  });

  Cabang copyWith({
    int? id,
    String? alamat,
    String? closeHour,
    String? nama,
    String? openHour,
    String? phoneNumber,
    String? picture,
  }) {
    return Cabang(
      id: id ?? this.id,
      alamat: alamat ?? this.alamat,
      closeHour: closeHour ?? this.closeHour,
      nama: nama ?? this.nama,
      openHour: openHour ?? this.openHour,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      picture: picture ?? this.picture,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'alamat': alamat,
      'closeHour': closeHour,
      'nama': nama,
      'openHour': openHour,
      'phoneNumber': phoneNumber,
      'picture': picture,
    };
  }

  factory Cabang.fromMap(Map<String, dynamic> map) {
    return Cabang(
      id: map['id'] as int,
      alamat: map['alamat'] as String,
      closeHour: map['closeHour'] as String,
      nama: map['nama'] as String,
      openHour: map['openHour'] as String,
      phoneNumber: map['phoneNumber'] as String,
      picture: map['picture'] as String?,
    );
  }

  String toJson() => json.encode(toMap());

  factory Cabang.fromJson(String source) =>
      Cabang.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Cabang(id: $id, alamat: $alamat, closeHour: $closeHour, nama: $nama, openHour: $openHour, phoneNumber: $phoneNumber, picture: $picture)';
  }

  @override
  bool operator ==(covariant Cabang other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.alamat == alamat &&
        other.closeHour == closeHour &&
        other.nama == nama &&
        other.openHour == openHour &&
        other.phoneNumber == phoneNumber &&
        other.picture == picture;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        alamat.hashCode ^
        closeHour.hashCode ^
        nama.hashCode ^
        openHour.hashCode ^
        phoneNumber.hashCode ^
        picture.hashCode;
  }
}
