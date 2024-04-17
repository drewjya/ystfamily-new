// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:ystfamily/src/features/order/order.dart';
import 'package:ystfamily/src/features/order/view/order_screen.dart';

bool happyHour({required Therapist therapist, required DateTime date, required String selectedHour, required Treatment? previousTreatment}) {
  if (therapist.happyStartDay == null || therapist.happyStartTime == null || therapist.happyEndDay == null || therapist.happyEndTime == null) return false;
  final happyStartDay = therapist.happyStartDay!;
  final happyEndDay = therapist.happyEndDay!;
  final dateWeek = date.weekday;
  if (!(happyStartDay <= dateWeek || dateWeek <= happyEndDay)) return false;
  final happyStartTime = therapist.happyStartTime!;
  final happyEndTime = therapist.happyEndTime!;

  var hour = DateTime.parse("2022-01-07 $selectedHour");
  if (previousTreatment != null) {
    hour = DateTime.parse("2022-01-07 ${addIntervalToTime(selectedHour, previousTreatment.duration)}");
    selectedHour = addIntervalToTime(selectedHour, previousTreatment.duration);
  }
  final happyStartHour = DateTime.parse("2022-01-07 $happyStartTime");
  final happyEndHour = DateTime.parse("2022-01-07 $happyEndTime");
  final val = (hour.isAfter(happyStartHour) || hour.isAtSameMomentAs(happyStartHour)) && (hour.isBefore(happyEndHour) || hour.isAtSameMomentAs(happyEndHour));
  log("HappYDAT $val $selectedHour");
  return val;
}

String totalPrice({
  required ValueNotifier<Map<int, Treatment>> treatment,
  required ValueNotifier<Map<int, AdditionalTreatment>> additional,
  required Therapist therapist,
  required ValueNotifier<DateTime?> date,
  required ValueNotifier<String?> hour,
}) {
  final totalAdditional = additional.value.values.fold(0, (previousValue, element) => element.price + previousValue);
  final totalTreatment = treatment.value.values.fold(0, (previousValue, element) {
    if (element.happyHourPrice != null && happyHour(therapist: therapist, date: date.value!, selectedHour: hour.value!, previousTreatment: previousValue == 0 ? null : element)) {
      return element.happyHourPrice! + previousValue;
    }
    return element.price + previousValue;
  });
  return formatCurrency.format(totalAdditional + totalTreatment);
}

int totalDuration({
  required ValueNotifier<Map<int, Treatment>> treatment,
  required ValueNotifier<Map<int, AdditionalTreatment>> additional,
}) {
  final totalAdditional = additional.value.values.fold(0, (previousValue, element) => element.duration + previousValue);
  final totalTreatment = treatment.value.values.fold(0, (previousValue, element) => element.duration + previousValue);
  return totalAdditional + totalTreatment;
}

class Therapist {
  final int? therapistId;
  final String kode;
  final bool male;
  final int cabangId;
  final int? happyStartDay;
  final String? happyStartTime;
  final int? happyEndDay;
  final String? happyEndTime;
  final List<AdditionalTreatment> additionalTreatmentData;
  final List<Treatment> treatmentData;
  final List<String> availableTimeSlots;
  Therapist({
    required this.therapistId,
    required this.kode,
    required this.male,
    required this.cabangId,
    this.happyStartDay,
    this.happyStartTime,
    this.happyEndDay,
    this.happyEndTime,
    required this.additionalTreatmentData,
    required this.treatmentData,
    required this.availableTimeSlots,
  });

  Therapist copyWith({
    int? therapistId,
    String? kode,
    bool? male,
    int? cabangId,
    int? happyStartDay,
    String? happyStartTime,
    int? happyEndDay,
    String? happyEndTime,
    List<AdditionalTreatment>? additionalTreatmentData,
    List<Treatment>? treatmentData,
    List<String>? availableTimeSlots,
  }) {
    return Therapist(
      therapistId: therapistId ?? this.therapistId,
      kode: kode ?? this.kode,
      male: male ?? this.male,
      cabangId: cabangId ?? this.cabangId,
      happyStartDay: happyStartDay ?? this.happyStartDay,
      happyStartTime: happyStartTime ?? this.happyStartTime,
      happyEndDay: happyEndDay ?? this.happyEndDay,
      happyEndTime: happyEndTime ?? this.happyEndTime,
      additionalTreatmentData: additionalTreatmentData ?? this.additionalTreatmentData,
      treatmentData: treatmentData ?? this.treatmentData,
      availableTimeSlots: availableTimeSlots ?? this.availableTimeSlots,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'therapistId': therapistId,
      'kode': kode,
      'male': male,
      'cabangId': cabangId,
      'happyStartDay': happyStartDay,
      'happyStartTime': happyStartTime,
      'happyEndDay': happyEndDay,
      'happyEndTime': happyEndTime,
      'additionalTreatmentData': additionalTreatmentData.map((x) => x.toMap()).toList(),
      'treatmentData': treatmentData.map((x) => x.toMap()).toList(),
      'availableTimeSlots': availableTimeSlots,
    };
  }

  String toJson() => json.encode(toMap());

  factory Therapist.fromJson(String source) => Therapist.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Therapist(therapistId: $therapistId, kode: $kode, male: $male, cabangId: $cabangId, happyStartDay: $happyStartDay, happyStartTime: $happyStartTime, happyEndDay: $happyEndDay, happyEndTime: $happyEndTime, additionalTreatmentData: $additionalTreatmentData, treatmentData: $treatmentData, availableTimeSlots: $availableTimeSlots)';
  }

  @override
  bool operator ==(covariant Therapist other) {
    if (identical(this, other)) return true;

    return other.therapistId == therapistId &&
        other.kode == kode &&
        other.male == male &&
        other.cabangId == cabangId &&
        other.happyStartDay == happyStartDay &&
        other.happyStartTime == happyStartTime &&
        other.happyEndDay == happyEndDay &&
        other.happyEndTime == happyEndTime &&
        listEquals(other.additionalTreatmentData, additionalTreatmentData) &&
        listEquals(other.treatmentData, treatmentData) &&
        listEquals(other.availableTimeSlots, availableTimeSlots);
  }

  @override
  int get hashCode {
    return therapistId.hashCode ^
        kode.hashCode ^
        male.hashCode ^
        cabangId.hashCode ^
        happyStartDay.hashCode ^
        happyStartTime.hashCode ^
        happyEndDay.hashCode ^
        happyEndTime.hashCode ^
        additionalTreatmentData.hashCode ^
        treatmentData.hashCode ^
        availableTimeSlots.hashCode;
  }

  factory Therapist.fromMap(Map<String, dynamic> map) {
    return Therapist(
      therapistId: map['therapist_id'] as int?,
      kode: map['kode'],
      male: map['male'],
      cabangId: map['cabang_id'],
      happyStartDay: map['happy_start_day'],
      happyStartTime: map['happy_start_time'],
      happyEndDay: map['happy_end_day'],
      happyEndTime: map['happy_end_time'],
      additionalTreatmentData: (map['additional_treatment_data'] as List)
          .map(
            (x) => AdditionalTreatment.fromMap(x as Map<String, dynamic>),
          )
          .toList(),
      treatmentData: (map['treatment_data'] as List)
          .map(
            (x) => Treatment.fromMap(x as Map<String, dynamic>),
          )
          .toList(),
      availableTimeSlots: (map['available_time_slots'] as List).cast<String>(),
    );
  }
}

class AdditionalTreatment {
  final int additionalTreatmentId;
  final String nama;
  final int duration;
  final int price;
  AdditionalTreatment({
    required this.additionalTreatmentId,
    required this.nama,
    required this.duration,
    required this.price,
  });

  AdditionalTreatment copyWith({
    int? additionalTreatmentId,
    String? nama,
    int? duration,
    int? price,
  }) {
    return AdditionalTreatment(
      additionalTreatmentId: additionalTreatmentId ?? this.additionalTreatmentId,
      nama: nama ?? this.nama,
      duration: duration ?? this.duration,
      price: price ?? this.price,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'additionalTreatmentId': additionalTreatmentId,
      'nama': nama,
      'duration': duration,
      'price': price,
    };
  }

  factory AdditionalTreatment.fromMap(Map<String, dynamic> map) {
    return AdditionalTreatment(
      additionalTreatmentId: map['additional_treatment_id'],
      nama: map['nama'],
      duration: map['duration'].toInt(),
      price: map['price'].toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory AdditionalTreatment.fromJson(String source) => AdditionalTreatment.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'AdditionalTreatment(additionalTreatmentId: $additionalTreatmentId, nama: $nama, duration: $duration, price: $price)';
  }

  @override
  bool operator ==(covariant AdditionalTreatment other) {
    if (identical(this, other)) return true;

    return other.additionalTreatmentId == additionalTreatmentId && other.nama == nama && other.duration == duration && other.price == price;
  }

  @override
  int get hashCode {
    return additionalTreatmentId.hashCode ^ nama.hashCode ^ duration.hashCode ^ price.hashCode;
  }
}

class Treatment {
  final int treatmentId;
  final String nama;
  final int duration;
  final int price;
  final int? happyHourPrice;
  Treatment({
    required this.treatmentId,
    required this.nama,
    required this.duration,
    required this.price,
    this.happyHourPrice,
  });

  Treatment copyWith({
    int? treatmentId,
    String? nama,
    int? duration,
    int? price,
    int? happyHourPrice,
  }) {
    return Treatment(
      treatmentId: treatmentId ?? this.treatmentId,
      nama: nama ?? this.nama,
      duration: duration ?? this.duration,
      price: price ?? this.price,
      happyHourPrice: happyHourPrice ?? this.happyHourPrice,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'treatmentId': treatmentId,
      'nama': nama,
      'duration': duration,
      'price': price,
      'happyHourPrice': happyHourPrice,
    };
  }

  factory Treatment.fromMap(Map<String, dynamic> map) {
    return Treatment(
      treatmentId: map['treatment_id'],
      nama: map['nama'],
      duration: map['duration'],
      price: map['price'],
      happyHourPrice: map['happy_hour_price'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Treatment.fromJson(String source) => Treatment.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Treatment(treatmentId: $treatmentId, nama: $nama, duration: $duration, price: $price, happyHourPrice: $happyHourPrice)';
  }

  @override
  bool operator ==(covariant Treatment other) {
    if (identical(this, other)) return true;

    return other.treatmentId == treatmentId && other.nama == nama && other.duration == duration && other.price == price && other.happyHourPrice == happyHourPrice;
  }

  @override
  int get hashCode {
    return treatmentId.hashCode ^ nama.hashCode ^ duration.hashCode ^ price.hashCode ^ happyHourPrice.hashCode;
  }
}
