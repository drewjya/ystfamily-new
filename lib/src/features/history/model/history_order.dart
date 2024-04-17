// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class HistoryOrder {
  final int orderId;
  final String orderNumber;
  final int orderNameCount;
  final String orderName;
  final String cabangNama;
  final int totalPrice;
  final String status;
  final String orderDate;
  final String orderStartTime;
  HistoryOrder({
    required this.orderId,
    required this.orderNumber,
    required this.orderNameCount,
    required this.orderName,
    required this.cabangNama,
    required this.totalPrice,
    required this.status,
    required this.orderDate,
    required this.orderStartTime,
  });

  HistoryOrder copyWith({
    int? orderId,
    String? orderNumber,
    int? orderNameCount,
    String? orderName,
    String? cabangNama,
    int? totalPrice,
    String? status,
    String? orderDate,
    String? orderStartTime,
  }) {
    return HistoryOrder(
      orderId: orderId ?? this.orderId,
      orderNumber: orderNumber ?? this.orderNumber,
      orderNameCount: orderNameCount ?? this.orderNameCount,
      orderName: orderName ?? this.orderName,
      cabangNama: cabangNama ?? this.cabangNama,
      totalPrice: totalPrice ?? this.totalPrice,
      status: status ?? this.status,
      orderDate: orderDate ?? this.orderDate,
      orderStartTime: orderStartTime ?? this.orderStartTime,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'orderId': orderId,
      'orderNumber': orderNumber,
      'orderNameCount': orderNameCount,
      'orderName': orderName,
      'cabangNama': cabangNama,
      'totalPrice': totalPrice,
      'status': status,
      'orderDate': orderDate,
      'orderStartTime': orderStartTime,
    };
  }

  String toJson() => json.encode(toMap());

  factory HistoryOrder.fromJson(String source) => HistoryOrder.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'HistoryOrder(orderId: $orderId, orderNumber: $orderNumber, orderNameCount: $orderNameCount, orderName: $orderName, cabangNama: $cabangNama, totalPrice: $totalPrice, status: $status, orderDate: $orderDate, orderStartTime: $orderStartTime)';
  }

  @override
  bool operator ==(covariant HistoryOrder other) {
    if (identical(this, other)) return true;

    return other.orderId == orderId &&
        other.orderNumber == orderNumber &&
        other.orderNameCount == orderNameCount &&
        other.orderName == orderName &&
        other.cabangNama == cabangNama &&
        other.totalPrice == totalPrice &&
        other.status == status &&
        other.orderDate == orderDate &&
        other.orderStartTime == orderStartTime;
  }

  @override
  int get hashCode {
    return orderId.hashCode ^
        orderNumber.hashCode ^
        orderNameCount.hashCode ^
        orderName.hashCode ^
        cabangNama.hashCode ^
        totalPrice.hashCode ^
        status.hashCode ^
        orderDate.hashCode ^
        orderStartTime.hashCode;
  }

  factory HistoryOrder.fromMap(Map<String, dynamic> map) {
    return HistoryOrder(
      orderId: map['order_id'],
      orderNumber: map['order_number'],
      orderNameCount: map['order_name_count'],
      orderName: map['order_name'],
      cabangNama: map['cabang_nama'],
      totalPrice: map['total_price'],
      status: map['status'],
      orderDate: map['order_date'],
      orderStartTime: map['order_start_time'],
    );
  }
}
