// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:collection/collection.dart';

class PreviewOrderDetail {
  final String nama;
  final int duration;
  final int price;
  final int treatmentId;
  PreviewOrderDetail({
    required this.nama,
    required this.duration,
    required this.price,
    required this.treatmentId,
  });

  PreviewOrderDetail copyWith({
    String? nama,
    int? duration,
    int? price,
    int? treatmentId,
  }) {
    return PreviewOrderDetail(
      nama: nama ?? this.nama,
      duration: duration ?? this.duration,
      price: price ?? this.price,
      treatmentId: treatmentId ?? this.treatmentId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'nama': nama,
      'duration': duration,
      'price': price,
      'treatmentId': treatmentId,
    };
  }

  factory PreviewOrderDetail.fromMap(Map<String, dynamic> map) {
    return PreviewOrderDetail(
      nama: map['nama'] as String,
      duration: map['duration'] as int,
      price: map['price'] as int,
      treatmentId: map['treatmentId'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory PreviewOrderDetail.fromJson(String source) =>
      PreviewOrderDetail.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PreviewOrderDetail(nama: $nama, duration: $duration, price: $price, treatmentId: $treatmentId)';
  }

  @override
  bool operator ==(covariant PreviewOrderDetail other) {
    if (identical(this, other)) return true;

    return other.nama == nama &&
        other.duration == duration &&
        other.price == price &&
        other.treatmentId == treatmentId;
  }

  @override
  int get hashCode {
    return nama.hashCode ^
        duration.hashCode ^
        price.hashCode ^
        treatmentId.hashCode;
  }
}

class OrderPreviewModel {
  final String guestGender;

  final String orderTime;
  final String therapistGender;
  final int durasi;
  final int totalPrice;

  final List<PreviewOrderDetail> orderDetails;
  OrderPreviewModel({
    required this.guestGender,
    required this.orderTime,
    required this.therapistGender,
    required this.durasi,
    required this.totalPrice,
    required this.orderDetails,
  });

  OrderPreviewModel copyWith({
    String? guestGender,
    String? orderTime,
    String? therapistGender,
    int? durasi,
    int? totalPrice,
    List<PreviewOrderDetail>? orderDetails,
  }) {
    return OrderPreviewModel(
      guestGender: guestGender ?? this.guestGender,
      orderTime: orderTime ?? this.orderTime,
      therapistGender: therapistGender ?? this.therapistGender,
      durasi: durasi ?? this.durasi,
      totalPrice: totalPrice ?? this.totalPrice,
      orderDetails: orderDetails ?? this.orderDetails,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'guestGender': guestGender,
      'orderTime': orderTime,
      'therapistGender': therapistGender,
      'durasi': durasi,
      'totalPrice': totalPrice,
      'orderDetails': orderDetails.map((x) => x.toMap()).toList(),
    };
  }

  factory OrderPreviewModel.fromMap(Map<String, dynamic> map) {
    return OrderPreviewModel(
      guestGender: map['guestGender'] as String,
      orderTime: map['orderTime'] as String,
      therapistGender: map['therapistGender'] as String,
      durasi: map['durasi'] as int,
      totalPrice: map['totalPrice'] as int,
      orderDetails: List<PreviewOrderDetail>.from(
        (map['orderDetails'] as List).map<PreviewOrderDetail>(
          (x) => PreviewOrderDetail.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderPreviewModel.fromJson(String source) =>
      OrderPreviewModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'OrderPreviewModel(guestGender: $guestGender, orderTime: $orderTime, therapistGender: $therapistGender, durasi: $durasi, totalPrice: $totalPrice, orderDetails: $orderDetails)';
  }

  @override
  bool operator ==(covariant OrderPreviewModel other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other.guestGender == guestGender &&
        other.orderTime == orderTime &&
        other.therapistGender == therapistGender &&
        other.durasi == durasi &&
        other.totalPrice == totalPrice &&
        listEquals(other.orderDetails, orderDetails);
  }

  @override
  int get hashCode {
    return guestGender.hashCode ^
        orderTime.hashCode ^
        therapistGender.hashCode ^
        durasi.hashCode ^
        totalPrice.hashCode ^
        orderDetails.hashCode;
  }
}
