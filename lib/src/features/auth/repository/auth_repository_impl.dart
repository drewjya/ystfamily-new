// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ystfamily/src/core/api/api_path.dart';
import 'package:ystfamily/src/core/api/api_request.dart';
import 'package:ystfamily/src/core/core.dart';
import 'package:ystfamily/src/core/provider/pref_const.dart';
import 'package:ystfamily/src/core/provider/pref_provider.dart';
import 'package:ystfamily/src/features/auth/model/auth_response.dart';
import 'package:ystfamily/src/features/auth/model/dto/login_dto.dart';
import 'package:ystfamily/src/features/auth/model/dto/register_dto.dart';
import 'package:ystfamily/src/features/auth/model/dto/update_profile.dart';
import 'package:ystfamily/src/features/auth/model/user.dart';
import 'package:ystfamily/src/features/auth/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final ApiRequest request;
  final SharedPreferences pref;
  AuthRepositoryImpl({
    required this.request,
    required this.pref,
  });
  @override
  Future<User> getProfile() async {
    final res = await request.get(url: ApiPath.profile, isAuth: true);

    return User.fromMap(res.data);
  }

  @override
  Future<User> login({required LoginDTO params}) async {
    final res = await request.post(
      url: ApiPath.login,
      body: params.toMap(),
      isAuth: false,
      isRefresh: false,
    );
    final data = AuthResponse.fromMap(res.data);
    await pref.setString(PrefConst.accessToken, data.session.accessToken);
    await pref.setString(PrefConst.refreshToken, data.session.refreshToken);
    return data.account;
  }

  @override
  Future<void> logout() async {
    Future.wait([pref.remove(PrefConst.accessToken), pref.remove(PrefConst.refreshToken), FirebaseMessaging.instance.deleteToken()]);
  }

  @override
  Future<void> refreshSession() async {
    final res = await request.get(url: ApiPath.refreshSession, isAuth: true, isRefresh: true);
    final data = Session.fromMap(res.data);
    await pref.setString(PrefConst.accessToken, data.accessToken);
    await pref.setString(PrefConst.refreshToken, data.refreshToken);
  }

  @override
  Future<User> register({required RegisterDTO params}) async {
    final res = await request.post(
      url: ApiPath.register,
      body: params.toMap(),
    );

    final data = AuthResponse.fromMap(res.data);
    await pref.setString(PrefConst.accessToken, data.session.accessToken);
    await pref.setString(PrefConst.refreshToken, data.session.refreshToken);
    return data.account;
  }

  @override
  Future<void> sendTokenFirebase({required String token}) async {
    try {
      await request.post(
        url: ApiPath.sendTokenFirebase,
        body: {"token": token},
        isAuth: true,
      );
    } catch (e) {
      log("message: $e");
    }
    return;
  }

  @override
  Future<String> verifyOtp({required String otp}) async {
    final res = await request.post(url: ApiPath.verifyOtp, body: {"otp": otp}, isAuth: true);
    return res.data["message"];
  }

  @override
  Future<void> changePassword({required String oldPassword, required String newPassword}) async {
    await request.put(
      url: ApiPath.changePassword,
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({"old_password": oldPassword, "new_password": newPassword}),
      isAuth: true,
    );
    return;
  }

  @override
  Future<User> updateProfile({required UpdateProfileDTO params}) async {
    final req = await request.postWithImage(
      url: ApiPath.updateProfile,
      body: params.getBody(),
      bodyImage: params.getProfilePictureMap(),
      isAuth: true,
    );
    return User.fromMap(req.data);
  }

  @override
  Future<String> forgetPassword({required String email, required String otp, required String newPassword}) async {
    final req = await request.post(
        url: ApiPath.submitForgetPassword,
        body: {
          "email": email,
          "otp": otp,
          "new_password": newPassword,
        },
        isAuth: false);
    return req.data["message"] ?? "sukses";
  }

  @override
  Future<String> requestForgetPassword({required String email}) async {
    final req = await request.post(url: ApiPath.requestForgetPasswor, body: {
      "email": email,
    });
    return req.data["message"];
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(request: ref.read(requestProvider), pref: ref.read(prefProvider));
});
