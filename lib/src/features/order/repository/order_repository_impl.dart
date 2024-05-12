// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ystfamily/src/core/api/api_path.dart';
import 'package:ystfamily/src/core/api/api_request.dart';
import 'package:ystfamily/src/features/auth/view/register_screen.dart';
import 'package:ystfamily/src/features/order/model/order_detail.dart';
import 'package:ystfamily/src/features/order/model/order_dto.dart';
import 'package:ystfamily/src/features/order/model/preview_order.dart';
import 'package:ystfamily/src/features/order/model/therapist.dart';
import 'package:ystfamily/src/features/order/model/therapist_detail.dart';
import 'package:ystfamily/src/features/order/model/time_slot.dart';
import 'package:ystfamily/src/features/order/model/treatment_model.dart';
import 'package:ystfamily/src/features/order/repository/order_repository.dart';

part 'order_repository_impl.g.dart';

class OrderRepositoryImpl implements OrderRepository {
  final ApiRequest request;
  OrderRepositoryImpl({
    required this.request,
  });

  @override
  Future<OrderDetail> getDetailOrder({required int orderId}) async {
    final res = await request.get(
        url: OrderPath.orderDetail(orderId), isAuth: true, isRefresh: false);
    return OrderDetail.fromMap(res.data);
  }

  @override
  Future<String> postBuktiPembayaranMobile(
      {required int orderId, required XFile file}) async {
    final res = await request.postWithImage(
        url: OrderPath.orderInsertBukti(orderId),
        bodyImage: {"file": file},
        isAuth: true,
        isRefresh: false);
    return '${res.data}';
  }

  @override
  Future<TimeSlot> getTimeSlot(
      {required int cabangId,
      required String tanggal,
      required int? therapistId}) async {
    final res = await request.get(
        url: TherapistPath.timeSlot(
            therapistId: therapistId, date: tanggal, cabangId: cabangId));
    return TimeSlot.fromMap(res.data);
  }

  @override
  Future<List<TreatmentCabang>> getTreatmentCabang(
      {required int cabangId}) async {
    final res = await request.get(
        url: CabangPath.getTreatmentByCabang(cabangId), isAuth: true);

    final ret = ((res.data as List)).cast<Map<String, dynamic>>().map((e) {
      final treatment = TreatmentCabang.fromMap(e);
      return treatment;
    }).toList();
    return ret;
  }

  @override
  Future<List<Therapist>> queryTherapist({
    required String name,
    required Gender gender,
    required int cabangId,
  }) async {
    final req = await request.get(
        url: TherapistPath.queryTherapist(
            gender: gender.nama, namaTherapist: name, cabangId: cabangId));
    return (req.data as List)
        .map((e) => Therapist.fromMap(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<TherapistDetail> getTherapistDetail({required int therapistId}) async {
    final req =
        await request.get(url: "${TherapistPath.therapistDetail}$therapistId");
    return TherapistDetail.fromMap(req.data);
  }

  @override
  Future<OrderPreviewModel> previewOrder({required OrderDto order}) async {
    final res = await request.post(
      url: OrderPath.previewOrder,
      body: order.toMap(),
      isAuth: true,
      isRefresh: false,
    );
    return OrderPreviewModel.fromMap(res.data);
  }

  @override
  Future<String> postOrder({required OrderDto order}) async {
    final res = await request.post(
      url: OrderPath.orderInsert,
      body: order.toMap(),
      isAuth: true,
      isRefresh: false,
    );
    return res.message;
  }
}

@riverpod
OrderRepository orderRepository(OrderRepositoryRef ref) {
  return OrderRepositoryImpl(request: ref.watch(requestProvider));
}
