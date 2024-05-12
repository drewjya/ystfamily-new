// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:collection/collection.dart';

class OrderDto {
  final String orderDate;
  final String orderTime;
  final int cabangId;
  final int? therapistId;
  final String guestGender;
  final String therapistGender;
  final List<int> treatmentDetail;
  OrderDto({
    required this.orderDate,
    required this.orderTime,
    required this.cabangId,
    this.therapistId,
    required this.guestGender,
    required this.therapistGender,
    required this.treatmentDetail,
  });

  OrderDto copyWith({
    String? orderDate,
    String? orderTime,
    int? cabangId,
    int? therapistId,
    String? guestGender,
    String? therapistGender,
    List<int>? treatmentDetail,
  }) {
    return OrderDto(
      orderDate: orderDate ?? this.orderDate,
      orderTime: orderTime ?? this.orderTime,
      cabangId: cabangId ?? this.cabangId,
      therapistId: therapistId ?? this.therapistId,
      guestGender: guestGender ?? this.guestGender,
      therapistGender: therapistGender ?? this.therapistGender,
      treatmentDetail: treatmentDetail ?? this.treatmentDetail,
    );
  }

  Map<String, dynamic> toMap() {
    if (therapistId != null) {
      return <String, dynamic>{
        'orderDate': orderDate,
        'orderTime': orderTime,
        'cabangId': cabangId,
        'therapistId': therapistId,
        'guestGender': guestGender,
        'therapistGender': therapistGender,
        'treatementDetail': treatmentDetail,
      };
    }
    return <String, dynamic>{
      'orderDate': orderDate,
      'orderTime': orderTime,
      'cabangId': cabangId,
      'guestGender': guestGender,
      'therapistGender': therapistGender,
      'treatementDetail': treatmentDetail,
    };
  }

  factory OrderDto.fromMap(Map<String, dynamic> map) {
    return OrderDto(
        orderDate: map['orderDate'] as String,
        orderTime: map['orderTime'] as String,
        cabangId: map['cabangId'] as int,
        therapistId:
            map['therapistId'] != null ? map['therapistId'] as int : null,
        guestGender: map['guestGender'] as String,
        therapistGender: map['therapistGender'] as String,
        treatmentDetail: List<int>.from(
          (map['treatmentDetail'] as List<int>),
        ));
  }

  String toJson() => json.encode(toMap());

  factory OrderDto.fromJson(String source) =>
      OrderDto.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'OrderDto(orderDate: $orderDate, orderTime: $orderTime, cabangId: $cabangId, therapistId: $therapistId, guestGender: $guestGender, therapistGender: $therapistGender, treatmentDetail: $treatmentDetail)';
  }

  @override
  bool operator ==(covariant OrderDto other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other.orderDate == orderDate &&
        other.orderTime == orderTime &&
        other.cabangId == cabangId &&
        other.therapistId == therapistId &&
        other.guestGender == guestGender &&
        other.therapistGender == therapistGender &&
        listEquals(other.treatmentDetail, treatmentDetail);
  }

  @override
  int get hashCode {
    return orderDate.hashCode ^
        orderTime.hashCode ^
        cabangId.hashCode ^
        therapistId.hashCode ^
        guestGender.hashCode ^
        therapistGender.hashCode ^
        treatmentDetail.hashCode;
  }
}
