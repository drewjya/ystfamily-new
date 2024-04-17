// ignore_for_file: public_member_api_docs, sort_constructors_first
class ApiPath {
  static bool isProduction = false;
  ApiPath();

  static final _baseUrl = isProduction ? 'https://api.ystfamily.com' : 'https://api-dev.ystfamily.com';

  static final _v2 = '$_baseUrl/api/v2';
  static final login = '$_v2/auth/login';
  static final register = '$_v2/auth/register';
  static final verifyOtp = '$_v2/auth/verify-otp';
  static final changePassword = '$_v2/auth/change-password';
  static final submitForgetPassword = '$_v2/auth/forget-password';
  static final requestForgetPasswor = '$_v2/auth/request-forget-password';
  static final profile = '$_v2/auth/profile';
  static final updateProfile = '$_v2/auth/update-profile';

  static final refreshSession = '$_v2/auth/refresh';
  static final sendTokenFirebase = '$_v2/auth/set-last-token';

  static final cabang = '$_v2/mobile/cabang?category_id=';
  static final category = '$_v2/category';
  static final orderInsert = '$_v2/order/insert';
  static final orderInsertBukti = '$_v2/order/bukti-transfer';
  static String orderHistory(int status, int limit, int offset) => '$_v2/order/history/$status?limit=$limit&offset=$offset';
  static String orderDetail(int orderId) => '$_v2/order/detail/$orderId';
  static final therapist = '$_v2/mobile/therapist';

  static String notificationList(int limit, int offset) => '$_v2/notification/list?limit=$limit&offset=$offset';
  static final notificaitonCount = '$_v2/notification/count';
}
