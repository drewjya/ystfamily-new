// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:ystfamily/src/features/history/repository/history_repository.dart';

const isProduction = false;
const baseUrl = 'https://api.ystfamily.com';
const api = '$baseUrl/api';
const image = '$baseUrl/img/';

class ApiPath {
  ApiPath();

  static final login = '$api$api/auth/login';
  static final register = '$api$api/auth/register';
  static final verifyOtp = '$api$api/auth/verify-otp';
  static final changePassword = '$api$api/auth/change-password';
  static final submitForgetPassword = '$api$api/auth/forget-password';
  static final requestForgetPasswor = '$api$api/auth/request-forget-password';
  static final profile = '$api$api/auth/profile';
  static final updateProfile = '$api$api/auth/update-profile';

  static final refreshSession = '$api$api/auth/refresh';
  static final sendTokenFirebase = '$api$api/auth/set-last-token';

  static final banner = '$api$api/banner';
  static final cabang = '$api$api/mobile/cabang?category_id=';
  static final category = '$api$api/category';
  static final orderInsert = '$api$api/order/insert';
  static final orderInsertBukti = '$api$api/order/bukti-transfer';
  static String orderHistory(int status, int limit, int offset) =>
      '$api$api/order/history/$status?limit=$limit&offset=$offset';
  static String orderDetail(int orderId) => '$api$api/order/detail/$orderId';
  static final therapist = '$api$api/mobile/therapist';

  static String notificationList(int limit, int offset) =>
      '$api$api/notification/list?limit=$limit&offset=$offset';
  static final notificaitonCount = '$api$api/notification/count';
}

class AuthPath {
  static const login = '$api/auth/login';
  static const register = '$api/auth/register';
  static confirmOtp(String otp) => '$api/auth/confirm/otp/$otp';
  static const refreshProfile = '$api/auth/refresh';
  static const changePassword = '$api/auth/change-password';
  static const forgetPassword = '$api/auth/forget-password';
  static requestForgetPassword(String email) =>
      '$api/auth/request-forget-password/$email';
  static const editProfile = '$api/auth/profile';
  static const tokenFirebase = '$api/auth/token';
}

class BannerPath {
  static const banner = '$api/banner';
}

class CategoryPath {
  static const category = '$api/category';
}

class CabangPath {
  static const cabang = '$api/cabang';
  static getCabangCategory(String categoryName) =>
      '$api/cabang/category/$categoryName';

  static getTreatmentByCabang(int cabangId) =>
      '$api/cabang-treatment/$cabangId/treatment';
}

class OrderPath {
  static orderHistory(OrderStatus status) =>
      '$api/order?status=${status.value}';
  static orderDetail(int orderId) => '$api/order/$orderId';
  static const orderInsert = '$api/order';
  static orderInsertBukti(int orderId) => '$api/order/buktiBayar/$orderId';
}

class NotificationPath {
  static const notificationList = '$api/notification';
}

class TherapistPath {
  static timeSlot(
          {required int? therapistId,
          required String date,
          required int cabangId}) =>
      '$api/therapist/timeslot/$cabangId?date=$date&therapistId=${therapistId == null ? '' : '$therapistId'}';
  static queryTherapist(
          {required int treatmentId,
          required String namaTherapist,
          required int cabangId}) =>
      '$api/therapist/query?name=$namaTherapist&cabangId=$cabangId&treatmentId=$treatmentId';
}
