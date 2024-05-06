import 'dart:convert';

class HistoryOrder {
  final String orderId;
  final int id;
  final int countOrder;
  final String cabang;
  final String orderTime;
  final String createdAt;
  final String orderStatus;
  final int totalPrice;
  final String orderName;
  HistoryOrder({
    required this.orderId,
    required this.id,
    required this.countOrder,
    required this.cabang,
    required this.orderTime,
    required this.createdAt,
    required this.orderStatus,
    required this.totalPrice,
    required this.orderName,
  });

  HistoryOrder copyWith({
    String? orderId,
    int? id,
    int? countOrder,
    String? cabang,
    String? orderTime,
    String? createdAt,
    String? orderStatus,
    int? totalPrice,
    String? orderName,
  }) {
    return HistoryOrder(
      orderId: orderId ?? this.orderId,
      id: id ?? this.id,
      countOrder: countOrder ?? this.countOrder,
      cabang: cabang ?? this.cabang,
      orderTime: orderTime ?? this.orderTime,
      createdAt: createdAt ?? this.createdAt,
      orderStatus: orderStatus ?? this.orderStatus,
      totalPrice: totalPrice ?? this.totalPrice,
      orderName: orderName ?? this.orderName,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'orderId': orderId,
      'id': id,
      'countOrder': countOrder,
      'cabang': cabang,
      'orderTime': orderTime,
      'createdAt': createdAt,
      'orderStatus': orderStatus,
      'totalPrice': totalPrice,
      'orderName': orderName,
    };
  }

  factory HistoryOrder.fromMap(Map<String, dynamic> map) {
    return HistoryOrder(
      orderId: map['orderId'] as String,
      id: map['id'].toInt() as int,
      countOrder: map['countOrder'].toInt() as int,
      cabang: map['cabang'] as String,
      orderTime: map['orderTime'] as String,
      createdAt: map['createdAt'] as String,
      orderStatus: map['orderStatus'] as String,
      totalPrice: map['totalPrice'].toInt() as int,
      orderName: map['orderName'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory HistoryOrder.fromJson(String source) => HistoryOrder.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'HistoryOrder(orderId: $orderId, id: $id, countOrder: $countOrder, cabang: $cabang, orderTime: $orderTime, createdAt: $createdAt, orderStatus: $orderStatus, totalPrice: $totalPrice, orderName: $orderName)';
  }

  @override
  bool operator ==(covariant HistoryOrder other) {
    if (identical(this, other)) return true;
  
    return 
      other.orderId == orderId &&
      other.id == id &&
      other.countOrder == countOrder &&
      other.cabang == cabang &&
      other.orderTime == orderTime &&
      other.createdAt == createdAt &&
      other.orderStatus == orderStatus &&
      other.totalPrice == totalPrice &&
      other.orderName == orderName;
  }

  @override
  int get hashCode {
    return orderId.hashCode ^
      id.hashCode ^
      countOrder.hashCode ^
      cabang.hashCode ^
      orderTime.hashCode ^
      createdAt.hashCode ^
      orderStatus.hashCode ^
      totalPrice.hashCode ^
      orderName.hashCode;
  }
}