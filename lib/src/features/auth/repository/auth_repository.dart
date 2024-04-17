import 'package:ystfamily/src/features/auth/model/dto/login_dto.dart';
import 'package:ystfamily/src/features/auth/model/dto/register_dto.dart';
import 'package:ystfamily/src/features/auth/model/dto/update_profile.dart';
import 'package:ystfamily/src/features/auth/model/user.dart';

abstract class AuthRepository {
  Future<User> getProfile();
  Future<void> logout();
  Future<User> login({required LoginDTO params});
  Future<User> register({required RegisterDTO params});
  Future<void> refreshSession();
  Future<void> sendTokenFirebase({required String token});
  Future<String> verifyOtp({required String otp});
  Future<User> updateProfile({required UpdateProfileDTO params});
  Future<void> changePassword({required String oldPassword, required String newPassword});

  Future<String> requestForgetPassword({required String email});
  Future<String> forgetPassword({required String email, required String otp, required String newPassword});

}
