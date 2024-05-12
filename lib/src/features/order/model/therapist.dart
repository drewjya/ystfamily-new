// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Therapist {
  final int id;
  final String nama;
  final String gender;
  Therapist({
    required this.id,
    required this.nama,
    required this.gender,
  });
  

  Therapist copyWith({
    int? id,
    String? nama,
    String? gender,
  }) {
    return Therapist(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      gender: gender ?? this.gender,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'nama': nama,
      'gender': gender,
    };
  }

  factory Therapist.fromMap(Map<String, dynamic> map) {
    return Therapist(
      id: map['id'] as int,
      nama: map['nama'] as String,
      gender: map['gender'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Therapist.fromJson(String source) => Therapist.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Therapist(id: $id, nama: $nama, gender: $gender)';

  @override
  bool operator ==(covariant Therapist other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.nama == nama &&
      other.gender == gender;
  }

  @override
  int get hashCode => id.hashCode ^ nama.hashCode ^ gender.hashCode;
}
