// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class OrderDetailModel {
  final String orderId;
  final int id;
  final String orderTime;
  final String orderStatus;
  final String guestGender;
  final String therapistGender;
  final String? therapist;
  final String cabang;
  final String cabangPhone;
  final String guestPhone;
  final int cabangId;
  final int durasi;
  final UserSimple user;
  final List<OrderDetailData> orderDetail;
  final int totalPrice;
  final String createdAt;
  final String? picture;
  final String? confirmationTime;
  OrderDetailModel({
    required this.orderId,
    required this.id,
    required this.orderTime,
    required this.orderStatus,
    required this.guestGender,
    required this.therapistGender,
    this.therapist,
    required this.cabang,
    required this.cabangPhone,
    required this.guestPhone,
    required this.cabangId,
    required this.durasi,
    required this.user,
    required this.orderDetail,
    required this.totalPrice,
    required this.createdAt,
    this.picture,
    this.confirmationTime,
  });

  OrderDetailModel copyWith({
    String? createdAt,
    String? picture,
    String? confirmationTime,
    String? orderId,
    int? id,
    String? orderTime,
    String? cabangPhone,
    String? guestPhone,
    String? orderStatus,
    String? guestGender,
    String? therapistGender,
    String? cabang,
    int? cabangId,
    int? durasi,
    String? therapist,
    UserSimple? user,
    List<OrderDetailData>? orderDetail,
    int? totalPrice,
  }) {
    return OrderDetailModel(
      createdAt: createdAt ?? this.createdAt,
      picture: picture ?? this.picture,
      confirmationTime: confirmationTime ?? this.confirmationTime,
      therapist: therapist ?? this.therapist,
      cabangPhone: cabangPhone ?? this.cabangPhone,
      guestPhone: guestPhone ?? this.guestPhone,
      orderId: orderId ?? this.orderId,
      id: id ?? this.id,
      orderTime: orderTime ?? this.orderTime,
      orderStatus: orderStatus ?? this.orderStatus,
      guestGender: guestGender ?? this.guestGender,
      therapistGender: therapistGender ?? this.therapistGender,
      cabang: cabang ?? this.cabang,
      cabangId: cabangId ?? this.cabangId,
      durasi: durasi ?? this.durasi,
      user: user ?? this.user,
      orderDetail: orderDetail ?? this.orderDetail,
      totalPrice: totalPrice ?? this.totalPrice,
    );
  }

  factory OrderDetailModel.fromMap(Map<String, dynamic> map) {
    return OrderDetailModel(
      createdAt: map['createdAt'] as String,
      confirmationTime: map['confirmationTime'] as String?,
      picture: map['picture'] as String?,
      orderId: map['orderId'] as String,
      id: map['id'] as int,
      cabangPhone: map['cabangPhone'] as String,
      guestPhone: map['guestPhone'] as String,
      orderTime: map['orderTime'] as String,
      orderStatus: map['orderStatus'] as String,
      guestGender: map['guestGender'] as String,
      therapistGender: map['therapistGender'] as String,
      cabang: map['cabang'] as String,
      therapist: map['therapist'],
      cabangId: map['cabangId'] as int,
      durasi: map['durasi'] as int,
      user: UserSimple.fromMap(map['user'] as Map<String, dynamic>),
      orderDetail: List<OrderDetailData>.from(
        (map['orderDetail'] as List)
            .cast<Map<String, dynamic>>()
            .map<OrderDetailData>(
              (x) => OrderDetailData.fromMap(x),
            ),
      ),
      totalPrice: map['totalPrice'] as int,
    );
  }

  factory OrderDetailModel.fromJson(String source) =>
      OrderDetailModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'OrderDetail(orderId: $orderId, id: $id, orderTime: $orderTime, orderStatus: $orderStatus, guestGender: $guestGender, therapistGender: $therapistGender, cabang: $cabang, cabangId: $cabangId, durasi: $durasi, user: $user, orderDetail: $orderDetail, totalPrice: $totalPrice, createdAt: $createdAt, picture: $picture, confirmationTime: $confirmationTime)';
  }

  @override
  bool operator ==(covariant OrderDetailModel other) {
    if (identical(this, other)) return true;

    return other.orderId == orderId &&
        other.id == id &&
        other.confirmationTime == confirmationTime &&
        other.picture == picture &&
        other.createdAt == createdAt &&
        other.orderTime == orderTime &&
        other.orderStatus == orderStatus &&
        other.guestGender == guestGender &&
        other.therapistGender == therapistGender &&
        other.cabang == cabang &&
        other.cabangId == cabangId &&
        other.durasi == durasi &&
        other.user == user &&
        listEquals(other.orderDetail, orderDetail) &&
        other.totalPrice == totalPrice;
  }

  @override
  int get hashCode {
    return orderId.hashCode ^
        id.hashCode ^
        orderTime.hashCode ^
        orderStatus.hashCode ^
        guestGender.hashCode ^
        therapistGender.hashCode ^
        cabang.hashCode ^
        cabangId.hashCode ^
        durasi.hashCode ^
        confirmationTime.hashCode ^
        picture.hashCode ^
        createdAt.hashCode ^
        user.hashCode ^
        orderDetail.hashCode ^
        totalPrice.hashCode;
  }
}

class UserSimple {
  final String name;
  final String email;
  final int id;
  final String? gender;
  UserSimple({
    required this.name,
    required this.email,
    required this.id,
    required this.gender,
  });

  UserSimple copyWith({
    String? name,
    String? email,
    int? id,
    String? gender,
  }) {
    return UserSimple(
      name: name ?? this.name,
      email: email ?? this.email,
      id: id ?? this.id,
      gender: gender ?? this.gender,
    );
  }

  factory UserSimple.fromMap(Map<String, dynamic> map) {
    return UserSimple(
      name: map['name'] as String,
      email: map['email'] as String,
      id: map['id'] as int,
      gender: map["gender"],
    );
  }

  factory UserSimple.fromJson(String source) =>
      UserSimple.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserSimple(name: $name, email: $email, id: $id, gender: $gender)';
  }

  @override
  bool operator ==(covariant UserSimple other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.email == email &&
        other.id == id &&
        other.gender == gender;
  }

  @override
  int get hashCode {
    return name.hashCode ^ email.hashCode ^ id.hashCode ^ gender.hashCode;
  }
}

class OrderDetailData {
  final int duration;
  final String nama;
  final int price;
  OrderDetailData({
    required this.duration,
    required this.nama,
    required this.price,
  });

  OrderDetailData copyWith({
    int? duration,
    String? nama,
    int? price,
  }) {
    return OrderDetailData(
      duration: duration ?? this.duration,
      nama: nama ?? this.nama,
      price: price ?? this.price,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'duration': duration,
      'nama': nama,
      'price': price,
    };
  }

  factory OrderDetailData.fromMap(Map<String, dynamic> map) {
    return OrderDetailData(
      duration: map['duration'] as int,
      nama: map['nama'] as String,
      price: map['price'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderDetailData.fromJson(String source) =>
      OrderDetailData.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'OrderDetailData(duration: $duration, nama: $nama, price: $price)';

  @override
  bool operator ==(covariant OrderDetailData other) {
    if (identical(this, other)) return true;

    return other.duration == duration &&
        other.nama == nama &&
        other.price == price;
  }

  @override
  int get hashCode => duration.hashCode ^ nama.hashCode ^ price.hashCode;
}
