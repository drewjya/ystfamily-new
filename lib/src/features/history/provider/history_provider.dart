import 'dart:async';

import 'package:ystfamily/src/core/core.dart';
import 'package:ystfamily/src/features/history/model/history_order.dart';
import 'package:ystfamily/src/features/history/repository/history_repository.dart';
import 'package:ystfamily/src/features/history/repository/history_repository_impl.dart';

final orderStatusProvider = StateProvider<OrderStatus>((ref) {
  return OrderStatus.pending;
});

class HistoryNotifier extends AsyncNotifier<List<HistoryOrder>> {
  @override
  FutureOr<List<HistoryOrder>> build() {
    final filter = ref.watch(orderStatusProvider);
    return ref.read(historyRepositoryProvider).getHistoryOrder(
          orderStatus: filter,
        );
  }
}

final historyProvider =
    AsyncNotifierProvider<HistoryNotifier, List<HistoryOrder>>(
        HistoryNotifier.new);
