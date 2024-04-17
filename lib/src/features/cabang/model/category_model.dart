// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CategoryTreatment {
  final int id;
  final String nama;
  final String? description;

  CategoryTreatment({
    required this.id,
    required this.nama,
    required this.description,
  });

  CategoryTreatment copyWith({
    int? id,
    String? nama,
    String? description,
  }) {
    return CategoryTreatment(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'nama': nama,
      'description': description,
    };
  }

  factory CategoryTreatment.fromMap(Map<String, dynamic> map) {
    return CategoryTreatment(
      id: map['category_id'] as int,
      nama: map['nama'] as String,
      description:
          map['description'] != null ? map['description'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CategoryTreatment.fromJson(String source) =>
      CategoryTreatment.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'CategoryTreatment(id: $id, nama: $nama, description: $description)';

  @override
  bool operator ==(covariant CategoryTreatment other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.nama == nama &&
        other.description == description;
  }

  @override
  int get hashCode => id.hashCode ^ nama.hashCode ^ description.hashCode;
}
