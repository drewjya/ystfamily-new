import 'package:ystfamily/src/features/history/model/history_order.dart';

abstract class HistoryRepository {
  Future<List<HistoryOrder>> getHistoryOrder(
      {required int orderStatus, required int limit, required int offset});
}
