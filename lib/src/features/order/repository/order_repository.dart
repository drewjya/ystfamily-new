import 'package:image_picker/image_picker.dart';
import 'package:ystfamily/src/features/order/model/order_detail.dart';
import 'package:ystfamily/src/features/order/model/preview_order.dart';
import 'package:ystfamily/src/features/order/model/therapist.dart';
import 'package:ystfamily/src/features/order/model/therapist_detail.dart';
import 'package:ystfamily/src/features/order/model/time_slot.dart';
import 'package:ystfamily/src/features/order/model/treatment_model.dart';

import '../../auth/view/register_screen.dart';
import '../model/order_dto.dart';

abstract class OrderRepository {
  Future<OrderDetailModel> getDetailOrder({required int orderId});
  Future<String> postBuktiPembayaranMobile(
      {required int orderId, required XFile file});
  Future<TimeSlot> getTimeSlot({
    required int cabangId,
    required String tanggal,
    required int? therapistId,
  });
  Future<OrderPreviewModel> previewOrder({required OrderDto order});
  Future<String> postOrder({required OrderDto order});

  Future<List<TreatmentCabang>> getTreatmentCabang({
    required int cabangId,
  });

  Future<List<Therapist>> queryTherapist(
      {required String name, required Gender gender, required int cabangId});

  Future<TherapistDetail> getTherapistDetail({required int therapistId});
}
