import 'dart:async';

import 'package:ystfamily/src/core/core.dart';
import 'package:ystfamily/src/features/history/model/filter_model.dart';
import 'package:ystfamily/src/features/history/model/history_order.dart';
import 'package:ystfamily/src/features/history/repository/history_repository_impl.dart';

enum FilterHistory {
  reshedule('Reshedule', 5),
  pending('Pending', 1),
  completed('Completed', 4),
  confirmed('Confirmed', 3),
  canceled('Canceled', 2);

  final String name;
  final int value;
  const FilterHistory(this.name, this.value);
}

class FilterNotifier extends Notifier<FilterValue> {
  @override
  FilterValue build() {
    return const FilterValue(limit: 10, offset: 0, filter: FilterHistory.confirmed);
  }

  void changeFilter({
    FilterHistory? filter,
    int? limit,
    int? offset,
  }) {
    state = state.copyWith(
      filter: filter,
      limit: limit,
      offset: offset,
    );
  }
}

final filterProvider = NotifierProvider<FilterNotifier, FilterValue>(FilterNotifier.new);

class HistoryNotifier extends AsyncNotifier<List<HistoryOrder>> {
  @override
  FutureOr<List<HistoryOrder>> build() {
    final filter = ref.watch(filterProvider);
    return ref.read(historyRepositoryProvider).getHistoryOrder(
          orderStatus: filter.filter.value,
          limit: filter.limit,
          offset: filter.offset,
        );
  }

  Future<AsyncValue<List<HistoryOrder>>> filter({FilterHistory filter = FilterHistory.confirmed}) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() => ref.read(historyRepositoryProvider).getHistoryOrder(
          orderStatus: filter.value,
          limit: 10,
          offset: 0,
        ));
    return state;
  }
}

final historyProvider = AsyncNotifierProvider<HistoryNotifier, List<HistoryOrder>>(HistoryNotifier.new);
