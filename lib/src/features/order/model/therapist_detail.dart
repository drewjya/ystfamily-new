// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:ystfamily/src/features/order/model/treatment_model.dart';

class TherapistDetail {
  final int id;
  final String name;
  final List<Treatment> therapistTreatment;
  TherapistDetail({
    required this.id,
    required this.name,
    required this.therapistTreatment,
  });

  TherapistDetail copyWith({
    int? id,
    String? name,
    List<Treatment>? therapistTreatment,
  }) {
    return TherapistDetail(
      id: id ?? this.id,
      name: name ?? this.name,
      therapistTreatment: therapistTreatment ?? this.therapistTreatment,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'therapistTreatment': therapistTreatment.map((x) => x.toMap()).toList(),
    };
  }

  factory TherapistDetail.fromMap(Map<String, dynamic> map) {
    log("${map.keys}");
    return TherapistDetail(
      id: map['id'] as int,
      name: map['nama'] as String,
      therapistTreatment: List<Treatment>.from(
        (map['therapistTreatment'] as List).map<Treatment>(
          (x) => Treatment.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory TherapistDetail.fromJson(String source) =>
      TherapistDetail.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'TherapistDetail(id: $id, name: $name, therapistTreatment: $therapistTreatment)';

  @override
  bool operator ==(covariant TherapistDetail other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other.id == id &&
        other.name == name &&
        listEquals(other.therapistTreatment, therapistTreatment);
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ therapistTreatment.hashCode;
}
