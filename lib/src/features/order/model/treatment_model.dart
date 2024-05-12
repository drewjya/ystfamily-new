import 'dart:convert';

class TreatmentCabang {
  final int price;
  final int happyHourPrice;
  final Treatment treatment;

  TreatmentCabang({
    required this.price,
    required this.happyHourPrice,
    required this.treatment,
  });

  TreatmentCabang copyWith({
    int? price,
    int? happyHourPrice,
    Treatment? treatment,
  }) {
    return TreatmentCabang(
      price: price ?? this.price,
      happyHourPrice: happyHourPrice ?? this.happyHourPrice,
      treatment: treatment ?? this.treatment,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'price': price,
      'happyHourPrice': happyHourPrice,
      'treatment': treatment.toMap(),
    };
  }

  factory TreatmentCabang.fromMap(Map<String, dynamic> map) {
    return TreatmentCabang(
      price: map['price'].toInt() as int,
      happyHourPrice: map['happyHourPrice'].toInt() as int,
      treatment: Treatment.fromMap(map['treatment'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory TreatmentCabang.fromJson(String source) =>
      TreatmentCabang.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'TreatmentCabang(price: $price, happyHourPrice: $happyHourPrice, treatment: $treatment)';
  }

  @override
  bool operator ==(covariant TreatmentCabang other) {
    if (identical(this, other)) return true;

    return other.price == price &&
        other.happyHourPrice == happyHourPrice &&
        other.treatment == treatment;
  }

  @override
  int get hashCode {
    return price.hashCode ^ happyHourPrice.hashCode ^ treatment.hashCode;
  }
}

class Treatment {
  final int id;
  final int durasi;
  final String nama;
  final Category category;
  Treatment({
    required this.id,
    required this.durasi,
    required this.nama,
    required this.category,
  });

  Treatment copyWith({
    int? id,
    int? durasi,
    String? nama,
    Category? category,
  }) {
    return Treatment(
      id: id ?? this.id,
      durasi: durasi ?? this.durasi,
      nama: nama ?? this.nama,
      category: category ?? this.category,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'durasi': durasi,
      'nama': nama,
      'category': category.toMap(),
    };
  }

  factory Treatment.fromMap(Map<String, dynamic> map) {
    return Treatment(
      id: map['id'].toInt() as int,
      durasi: map['durasi'].toInt() as int,
      nama: map['nama'] as String,
      category: Category.fromMap(map['category'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory Treatment.fromJson(String source) =>
      Treatment.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Treatment(id: $id, durasi: $durasi, nama: $nama, category: $category)';
  }

  @override
  bool operator ==(covariant Treatment other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.durasi == durasi &&
        other.nama == nama &&
        other.category == category;
  }

  @override
  int get hashCode {
    return id.hashCode ^ durasi.hashCode ^ nama.hashCode ^ category.hashCode;
  }
}

class Category {
  final int id;
  final String nama;
  final bool optional;
  final bool happyHourPrice;
  Category({
    required this.id,
    required this.nama,
    required this.optional,
    required this.happyHourPrice,
  });

  Category copyWith({
    int? id,
    String? nama,
    bool? optional,
    bool? happyHourPrice,
  }) {
    return Category(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      optional: optional ?? this.optional,
      happyHourPrice: happyHourPrice ?? this.happyHourPrice,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'nama': nama,
      'optional': optional,
      'happyHourPrice': happyHourPrice,
    };
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'].toInt() as int,
      nama: map['nama'] as String,
      optional: map['optional'] as bool,
      happyHourPrice: map['happyHourPrice'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory Category.fromJson(String source) =>
      Category.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Category(id: $id, nama: $nama, optional: $optional, happyHourPrice: $happyHourPrice)';
  }

  @override
  bool operator ==(covariant Category other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.nama == nama &&
        other.optional == optional &&
        other.happyHourPrice == happyHourPrice;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        nama.hashCode ^
        optional.hashCode ^
        happyHourPrice.hashCode;
  }
}
