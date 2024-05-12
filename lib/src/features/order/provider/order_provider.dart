// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ystfamily/src/core/core.dart';
import 'package:ystfamily/src/features/order/model/order_dto.dart';
import 'package:ystfamily/src/features/order/repository/order_repository_impl.dart';

class ImageWr {
  final Uint8List file;
  final String name;
  ImageWr({
    required this.file,
    required this.name,
  });
}

class OrderNotifier extends AsyncNotifier<String> {
  @override
  FutureOr<String> build() {
    return '';
  }

  postOrder({required OrderDto body}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
        () => ref.read(orderRepositoryProvider).postOrder(order: body));
  }

  postBuktiOrder({required int orderId, required XFile file}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => ref
        .read(orderRepositoryProvider)
        .postBuktiPembayaranMobile(orderId: orderId, file: file));
  }
}

final orderProvider = AsyncNotifierProvider<OrderNotifier, String>(
  () => OrderNotifier(),
);
