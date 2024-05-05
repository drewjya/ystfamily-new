// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:developer';

import 'package:collection/collection.dart';

class HistoryOrder {
  final String orderId;
  final int id;
  final Information cabang;
  final String orderTime;
  final String createdAt;
  final String orderStatus;
  final List<TreatmentInformation> orderDetails;
  HistoryOrder({
    required this.orderId,
    required this.id,
    required this.cabang,
    required this.orderTime,
    required this.createdAt,
    required this.orderStatus,
    required this.orderDetails,
  });

  HistoryOrder copyWith({
    String? orderId,
    int? id,
    Information? cabang,
    String? orderTime,
    String? createdAt,
    String? orderStatus,
    List<TreatmentInformation>? orderDetails,
  }) {
    return HistoryOrder(
      orderId: orderId ?? this.orderId,
      id: id ?? this.id,
      cabang: cabang ?? this.cabang,
      orderTime: orderTime ?? this.orderTime,
      createdAt: createdAt ?? this.createdAt,
      orderStatus: orderStatus ?? this.orderStatus,
      orderDetails: orderDetails ?? this.orderDetails,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'orderId': orderId,
      'id': id,
      'cabang': cabang.toMap(),
      'orderTime': orderTime,
      'createdAt': createdAt,
      'orderStatus': orderStatus,
      'orderDetails': orderDetails.map((x) => x.toMap()).toList(),
    };
  }

  factory HistoryOrder.fromMap(Map<String, dynamic> map) {
    return HistoryOrder(
      orderId: map['orderId'] as String,
      id: map['id'] as int,
      cabang: Information.fromMap(map['cabang'] as Map<String, dynamic>),
      orderTime: map['orderTime'] as String,
      createdAt: map['createdAt'] as String,
      orderStatus: map['orderStatus'] as String,
      orderDetails: List<TreatmentInformation>.from(
        (map['orderDetails'] as List)
            .cast<Map<String, dynamic>>()
            .map<TreatmentInformation>(
              (x) => TreatmentInformation.fromMap(x),
            ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory HistoryOrder.fromJson(String source) =>
      HistoryOrder.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'HistoryOrder(orderId: $orderId, id: $id, cabang: $cabang, orderTime: $orderTime, createdAt: $createdAt, orderStatus: $orderStatus, orderDetails: $orderDetails)';
  }

  @override
  bool operator ==(covariant HistoryOrder other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other.orderId == orderId &&
        other.id == id &&
        other.cabang == cabang &&
        other.orderTime == orderTime &&
        other.createdAt == createdAt &&
        other.orderStatus == orderStatus &&
        listEquals(other.orderDetails, orderDetails);
  }

  @override
  int get hashCode {
    return orderId.hashCode ^
        id.hashCode ^
        cabang.hashCode ^
        orderTime.hashCode ^
        createdAt.hashCode ^
        orderStatus.hashCode ^
        orderDetails.hashCode;
  }
}

class Information {
  final int id;
  final String nama;
  const Information({
    required this.id,
    required this.nama,
  });

  Information copyWith({
    int? id,
    String? nama,
  }) {
    return Information(
      id: id ?? this.id,
      nama: nama ?? this.nama,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'nama': nama,
    };
  }

  factory Information.fromMap(Map<String, dynamic> map) {
    return Information(
      id: map['id'] as int,
      nama: map['nama'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Information.fromJson(String source) =>
      Information.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Information(id: $id, nama: $nama)';

  @override
  bool operator ==(covariant Information other) {
    if (identical(this, other)) return true;

    return other.id == id && other.nama == nama;
  }

  @override
  int get hashCode => id.hashCode ^ nama.hashCode;
}

class TreatmentInformation extends Information {
  final Information category;
  TreatmentInformation({
    required this.category,
    required super.id,
    required super.nama,
  });

  @override
  TreatmentInformation copyWith({
    Information? category,
    int? id,
    String? nama,
  }) {
    return TreatmentInformation(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      category: category ?? this.category,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'category': category.toMap(),
      'nama': nama,
      'id': id,
    };
  }

  factory TreatmentInformation.fromMap(Map<String, dynamic> map) {
    log("${map.keys}: ${map.values}");
    final data = map['treatment'];
    return TreatmentInformation(
      category: Information.fromMap(data['category'] as Map<String, dynamic>),
      id: data['id'] as int,
      nama: data['nama'] as String,
    );
  }

  @override
  String toJson() => json.encode(toMap());

  factory TreatmentInformation.fromJson(String source) =>
      TreatmentInformation.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'TreatmentInformation(category: $category)';

  @override
  bool operator ==(covariant TreatmentInformation other) {
    if (identical(this, other)) return true;

    return other.id == id && other.nama == nama && other.category == category;
  }

  @override
  int get hashCode => id.hashCode ^ nama.hashCode ^ category.hashCode;
}
