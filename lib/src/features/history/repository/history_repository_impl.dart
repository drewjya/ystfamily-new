// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ystfamily/src/core/api/api_path.dart';
import 'package:ystfamily/src/core/api/api_request.dart';
import 'package:ystfamily/src/features/history/model/history_order.dart';
import 'package:ystfamily/src/features/history/repository/history_repository.dart';

class HistoryRepositoryImpl implements HistoryRepository {
  final ApiRequest request;
  HistoryRepositoryImpl({
    required this.request,
  });
  @override
  Future<List<HistoryOrder>> getHistoryOrder({required int orderStatus, required int limit, required int offset}) async {
    final res = await request.get(url: ApiPath.orderHistory(orderStatus, limit, offset), isAuth: true, isRefresh: false);
    return (res.data as List).cast<Map<String, dynamic>>().map((e) => HistoryOrder.fromMap(e)).toList().cast<HistoryOrder>();
  }
}

final historyRepositoryProvider = Provider<HistoryRepository>((ref) {
  return HistoryRepositoryImpl(request: ref.read(requestProvider));
});
