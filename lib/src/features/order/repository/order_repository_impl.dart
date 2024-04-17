// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:developer';

import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ystfamily/src/core/api/api_path.dart';
import 'package:ystfamily/src/core/api/api_request.dart';
import 'package:ystfamily/src/features/order/model/detail_order.dart';
import 'package:ystfamily/src/features/order/model/order_dto.dart';
import 'package:ystfamily/src/features/order/model/therapist.dart';
import 'package:ystfamily/src/features/order/repository/order_repository.dart';

part 'order_repository_impl.g.dart';

class OrderRepositoryImpl implements OrderRepository {
  final ApiRequest request;
  OrderRepositoryImpl({
    required this.request,
  });
  @override
  Future<List<Therapist>> getTherapist(
      {required int cabangId,
      required String tanggal,
      required String gender}) async {
    String params = "?cabang_id=$cabangId&tanggal=$tanggal&gender=$gender";
    final res = await request.get(
        url: ApiPath.therapist + params, isAuth: true, isRefresh: false);
    log("${res.data}");
    return (res.data as List).map((e) => Therapist.fromMap(e)).toList();
  }

  @override
  Future<String> postOrder({required OrderDto body}) async {
    log(jsonEncode(body.toMap()));
    final res = await request.post(
        url: ApiPath.orderInsert,
        isAuth: true,
        isRefresh: false,
        body: body.toMap());
    log("$res");
    return res.data['message'] ?? "";
  }

  @override
  Future<OrderDetail> getDetailOrder({required int orderId}) async {
    final res = await request.get(
        url: ApiPath.orderDetail(orderId), isAuth: true, isRefresh: false);
    return OrderDetail.fromMap(res.data);
  }

  @override
  Future<String> postBuktiPembayaranMobile(
      {required int orderId, required XFile file}) async {
    final res = await request.postWithImage(
        url: ApiPath.orderInsertBukti,
        body: {"order_id": '$orderId'},
        bodyImage: {"bukti_transfer": file},
        isAuth: true,
        isRefresh: false);
    return '${res.data}';
  }
}

// final orderRepositoryProvider = Provider<OrderRepository>((ref) {
//   return OrderRepositoryImpl(request: ref.read(requestProvider));
// });

@riverpod
OrderRepository orderRepository(OrderRepositoryRef ref) {
  return OrderRepositoryImpl(request: ref.watch(requestProvider));
}
