
import 'package:image_picker/image_picker.dart';
import 'package:ystfamily/src/features/order/model/order_detail.dart';

import 'package:ystfamily/src/features/order/model/order_dto.dart';
import 'package:ystfamily/src/features/order/model/therapist.dart';

abstract class OrderRepository {
  Future<List<Therapist>> getTherapist({required int cabangId, required String tanggal, required String gender});
  Future<String> postOrder({required OrderDto body});
  Future<OrderDetail> getDetailOrder({required int orderId});
  Future<String> postBuktiPembayaranMobile({required int orderId, required XFile file});
}
