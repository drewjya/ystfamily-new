// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

extension OrderTreatmentX on List<OrderTreatment> {
  Duration get duration {
    final s = map((e) => e.durasi).sum;
    return Duration(minutes: s);
  }

  String get time {
    final s = map((e) => e.durasi).sum;

    final hour = s ~/ 60;
    final minutes = s % 60;
    if (hour == 0) {
      return "$minutes menit";
    }
    if (minutes == 0) {
      return "$hour jam";
    }
    return "$hour jam $minutes menit";
  }
}

class OrderDetail {
  final int orderId;
  final String cabangNama;
  final String tanggalTreatment;
  final String orderNumber;
  final String orderStartTime;
  final String orderEndTime;
  final String therapistNama;
  final String? buktiBayar;
  final String status;
  final String bookingTime;
  final bool confirmed;
  final List<OrderTreatment> treatments;
  final String? confirmationDate;
  OrderDetail({
    required this.orderId,
    required this.cabangNama,
    required this.tanggalTreatment,
    required this.orderNumber,
    required this.orderStartTime,
    required this.orderEndTime,
    required this.therapistNama,
    this.buktiBayar,
    required this.status,
    required this.bookingTime,
    required this.confirmed,
    required this.treatments,
    this.confirmationDate,
  });

  OrderDetail copyWith({
    int? orderId,
    String? cabangNama,
    String? tanggalTreatment,
    String? orderNumber,
    String? orderStartTime,
    String? orderEndTime,
    String? therapistNama,
    String? buktiBayar,
    String? status,
    String? bookingTime,
    bool? confirmed,
    List<OrderTreatment>? treatments,
    String? confirmationDate,
  }) {
    return OrderDetail(
      orderId: orderId ?? this.orderId,
      cabangNama: cabangNama ?? this.cabangNama,
      tanggalTreatment: tanggalTreatment ?? this.tanggalTreatment,
      orderNumber: orderNumber ?? this.orderNumber,
      orderStartTime: orderStartTime ?? this.orderStartTime,
      orderEndTime: orderEndTime ?? this.orderEndTime,
      therapistNama: therapistNama ?? this.therapistNama,
      buktiBayar: buktiBayar ?? this.buktiBayar,
      status: status ?? this.status,
      bookingTime: bookingTime ?? this.bookingTime,
      confirmed: confirmed ?? this.confirmed,
      treatments: treatments ?? this.treatments,
      confirmationDate: confirmationDate ?? this.confirmationDate,
    );
  }

  factory OrderDetail.fromJson(String source) =>
      OrderDetail.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'OrderDetail(orderId: $orderId, cabangNama: $cabangNama, tanggalTreatment: $tanggalTreatment, orderNumber: $orderNumber, orderStartTime: $orderStartTime, orderEndTime: $orderEndTime, therapistNama: $therapistNama, buktiBayar: $buktiBayar, status: $status, bookingTime: $bookingTime, confirmed: $confirmed, treatments: $treatments, confirmationDate: $confirmationDate)';
  }

  @override
  bool operator ==(covariant OrderDetail other) {
    if (identical(this, other)) return true;

    return other.orderId == orderId &&
        other.cabangNama == cabangNama &&
        other.tanggalTreatment == tanggalTreatment &&
        other.orderNumber == orderNumber &&
        other.orderStartTime == orderStartTime &&
        other.orderEndTime == orderEndTime &&
        other.therapistNama == therapistNama &&
        other.buktiBayar == buktiBayar &&
        other.status == status &&
        other.bookingTime == bookingTime &&
        other.confirmed == confirmed &&
        listEquals(other.treatments, treatments) &&
        other.confirmationDate == confirmationDate;
  }

  @override
  int get hashCode {
    return orderId.hashCode ^
        cabangNama.hashCode ^
        tanggalTreatment.hashCode ^
        orderNumber.hashCode ^
        orderStartTime.hashCode ^
        orderEndTime.hashCode ^
        therapistNama.hashCode ^
        buktiBayar.hashCode ^
        status.hashCode ^
        bookingTime.hashCode ^
        confirmed.hashCode ^
        treatments.hashCode ^
        confirmationDate.hashCode;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'orderId': orderId,
      'cabangNama': cabangNama,
      'tanggalTreatment': tanggalTreatment,
      'orderStartTime': orderStartTime,
      'orderEndTime': orderEndTime,
      'therapistNama': therapistNama,
      'buktiBayar': buktiBayar,
      'status': status,
      'bookingTime': bookingTime,
      'treatments': treatments.map((x) => x.toMap()).toList(),
      'confirmationDate': confirmationDate,
    };
  }

  factory OrderDetail.fromMap(Map<String, dynamic> map) {
    return OrderDetail(
      confirmed: map['confirmed'],
      orderNumber: map['order_number'],
      orderId: map['order_id'].toInt() as int,
      cabangNama: map['cabang_nama'] as String,
      tanggalTreatment: map['tanggal_treatment'] as String,
      orderStartTime: map['order_start_time'] as String,
      orderEndTime: map['order_end_time'] as String,
      therapistNama: map['therapist_nama'] as String,
      buktiBayar: map['bukti_bayar'],
      status: map['status'] as String,
      bookingTime: map['booking_time'] as String,
      treatments: (map['treatments'] as List)
          .map((x) => OrderTreatment.fromMap(x as Map<String, dynamic>))
          .toList(),
      confirmationDate: map['confirmation_date'],
    );
  }

  String toJson() => json.encode(toMap());
}

class OrderTreatment {
  final int durasi;
  final int price;
  final String treatmentName;
  OrderTreatment({
    required this.durasi,
    required this.price,
    required this.treatmentName,
  });

  OrderTreatment copyWith({
    int? durasi,
    int? price,
    String? treatmentName,
  }) {
    return OrderTreatment(
      durasi: durasi ?? this.durasi,
      price: price ?? this.price,
      treatmentName: treatmentName ?? this.treatmentName,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'durasi': durasi,
      'price': price,
      'treatmentName': treatmentName,
    };
  }

  factory OrderTreatment.fromMap(Map<String, dynamic> map) {
    return OrderTreatment(
      durasi: map['durasi'].toInt() as int,
      price: map['price'].toInt() as int,
      treatmentName: map['treatment_name'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderTreatment.fromJson(String source) =>
      OrderTreatment.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'OrderTreatment(durasi: $durasi, price: $price, treatment_name: $treatmentName)';

  @override
  bool operator ==(covariant OrderTreatment other) {
    if (identical(this, other)) return true;

    return other.durasi == durasi &&
        other.price == price &&
        other.treatmentName == treatmentName;
  }

  @override
  int get hashCode => durasi.hashCode ^ price.hashCode ^ treatmentName.hashCode;
}
