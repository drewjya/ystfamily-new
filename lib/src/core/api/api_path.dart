// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:ystfamily/src/features/history/repository/history_repository.dart';

const isProduction = false;
// const baseUrl =  'https://api.ystfamily.com';
const baseUrl = 'http://10.0.2.2:3000';
const api = '$baseUrl/api';
const image = '$baseUrl/img/';

class AuthPath {
  static const login = '$api/auth/login';
  static const register = '$api/auth/register';
  static confirmOtp(String otp) => '$api/auth/confirm/$otp';
  static const refreshProfile = '$api/auth/refresh';
  static const changePassword = '$api/auth/change-password';
  static const forgetPassword = '$api/auth/forget-password';
  static requestForgetPassword(String email) =>
      '$api/auth/request-forget-password/$email';
  static const editProfile = '$api/auth/profile';
  static const tokenFirebase = '$api/auth/token';
  static const deleteAccount = '$api/auth';
  static const version = '$api/version';
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
  static orderHistory(OrderStatus status) {
    if (status == OrderStatus.all) {
      return '$api/order';
    }
    return '$api/order?status=${status.value}';
  }

  static orderDetail(int orderId) => '$api/order/$orderId';
  static const orderInsert = '$api/order';
  static const previewOrder = '$api/order/preview';
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
          {required String gender,
          required String namaTherapist,
          required int cabangId}) =>
      '$api/therapist/query?name=$namaTherapist&cabangId=$cabangId&gender=$gender';

  static const therapistDetail = "$api/therapist/";
}
