import 'package:ystfamily/src/features/history/model/history_order.dart';

abstract class HistoryRepository {
  Future<List<HistoryOrder>> getHistoryOrder(
      {required OrderStatus orderStatus});
}

enum OrderStatus {
  pending(value: "PENDING"),
  confirmed(value: "CONFIRMED"),
  ongoing(value: "ONGOING"),
  complete(value: "COMPLETE"),
  reschedule(value: "RESCHEDULE"),
  cancelled(value: "CANCELLED");

  final String value;
  const OrderStatus({required this.value});
}
