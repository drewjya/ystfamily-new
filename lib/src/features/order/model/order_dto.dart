// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

import 'package:flutter/foundation.dart';

class OrderDetailDTO {
  final int? treatmentId;
  final int? additionalTreatmentId;
  final bool additional;
  final bool happyHour;
  OrderDetailDTO._({
    this.treatmentId,
    this.additionalTreatmentId,
    required this.additional,
    required this.happyHour,
  });

  factory OrderDetailDTO.treatment({required int treatmentId, required bool happyHour}) => OrderDetailDTO._(additional: false, happyHour: happyHour, treatmentId: treatmentId);
  factory OrderDetailDTO.additional({required int additionalTreatmentId}) => OrderDetailDTO._(additional: true, happyHour: false, additionalTreatmentId: additionalTreatmentId);

  Map<String, dynamic> toMap() {
    if (additional) {
      return <String, dynamic>{
        'additional_treatment_id': additionalTreatmentId,
        'additional': additional,
        'happy_hour': happyHour,
      };
    }
    return <String, dynamic>{
      'treatment_id': treatmentId,
      'additional': additional,
      'happy_hour': happyHour,
    };
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'OrderDetailDTO(treatmentId: $treatmentId, additionalTreatmentId: $additionalTreatmentId, additional: $additional, happyHour: $happyHour)';
  }
}

class OrderDto {
  final int cabangId;
  final int therapistId;
  final String orderStartTime;
  final DateTime orderDate;
  final bool genderTherapist;
  final List<OrderDetailDTO> treatments;
  OrderDto({
    required this.cabangId,
    required this.therapistId,
    required this.orderStartTime,
    required this.orderDate,
    required this.genderTherapist,
    required this.treatments,
  });

  OrderDto copyWith({
    int? cabangId,
    int? therapistId,
    String? orderStartTime,
    DateTime? orderDate,
    bool? genderTherapist,
    List<OrderDetailDTO>? treatments,
  }) {
    return OrderDto(
      cabangId: cabangId ?? this.cabangId,
      therapistId: therapistId ?? this.therapistId,
      orderStartTime: orderStartTime ?? this.orderStartTime,
      orderDate: orderDate ?? this.orderDate,
      genderTherapist: genderTherapist ?? this.genderTherapist,
      treatments: treatments ?? this.treatments,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'cabang_id': cabangId,
      'therapist_id': therapistId,
      'order_start_time': '0001-01-01T${orderStartTime}Z',
      'order_date': removeLast0(orderDate.toIso8601String()),
      'order_detail': treatments.map((x) => x.toMap()).toList(),
      'gender_therapist': genderTherapist,
    };
  }

  String removeLast0(String data) {
    if (data.endsWith("0Z")) {
      return "${data.substring(0, data.length - 2)}Z";
    }
    return data;
  }

  @override
  String toString() {
    return 'OrderDto(cabangId: $cabangId, therapistId: $therapistId, orderStartTime: $orderStartTime, orderDate: $orderDate, genderTherapist: $genderTherapist, treatments: $treatments)';
  }

  @override
  bool operator ==(covariant OrderDto other) {
    if (identical(this, other)) return true;

    return other.cabangId == cabangId &&
        other.therapistId == therapistId &&
        other.orderStartTime == orderStartTime &&
        other.orderDate == orderDate &&
        other.genderTherapist == genderTherapist &&
        listEquals(other.treatments, treatments);
  }

  @override
  int get hashCode {
    return cabangId.hashCode ^ therapistId.hashCode ^ orderStartTime.hashCode ^ orderDate.hashCode ^ genderTherapist.hashCode ^ treatments.hashCode;
  }

  String toJson() => json.encode(toMap());
}
