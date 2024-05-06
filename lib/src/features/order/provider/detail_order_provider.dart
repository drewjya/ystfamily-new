import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:ystfamily/src/features/order/model/order_detail.dart';
import 'package:ystfamily/src/features/order/repository/order_repository_impl.dart';

part 'detail_order_provider.g.dart';

@riverpod
class DetailOrder extends _$DetailOrder {
  @override
  FutureOr<OrderDetail> build(int id) {
    return ref.read(orderRepositoryProvider).getDetailOrder(orderId: id);
  }
}
