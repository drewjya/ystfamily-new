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
    final res = await request.get(
      url: AuthPath.refreshProfile,
      isAuth: true,
      isRefresh: true,
    );
    log('$res');

    final data = AuthResponse.fromMap(res.data);
    await pref.setString(PrefConst.accessToken, data.session.accessToken);
    await pref.setString(PrefConst.refreshToken, data.session.refreshToken);
    return data.account;
  }

  @override
  Future<User> login({required LoginDTO params}) async {
    final res = await request.post(
      url: AuthPath.login,
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
    Future.wait([
      pref.remove(PrefConst.accessToken),
      pref.remove(PrefConst.refreshToken),
      FirebaseMessaging.instance.deleteToken()
    ]);
  }

  @override
  Future<User> register({required RegisterDTO params}) async {
    final res = await request.post(
      url: AuthPath.register,
      body: params.toMap(),
    );

    final data = User.fromMap(res.data);

    return data;
  }

  @override
  Future<void> sendTokenFirebase({required String token}) async {
    try {
      await request.post(
        url: AuthPath.tokenFirebase,
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
    final res = await request.post(url: AuthPath.confirmOtp(otp), isAuth: true);
    return "${res.data}";
  }

  @override
  Future<void> changePassword(
      {required String oldPassword, required String newPassword}) async {
    await request.put(
      url: AuthPath.changePassword,
      headers: {
        "Content-Type": "application/json",
      },
      body:
          jsonEncode({"oldPassword": oldPassword, "newPassword": newPassword}),
      isAuth: true,
    );
    return;
  }

  @override
  Future<User> updateProfile({required UpdateProfileDTO params}) async {
    final req = await request.postWithImage(
      url: AuthPath.editProfile,
      body: params.getBody(),
      mode: Mode.put,
      bodyImage: params.getProfilePictureMap(),
      isAuth: true,
    );
    return User.fromMap(req.data);
  }

  @override
  Future<String> forgetPassword(
      {required String email,
      required String otp,
      required String newPassword}) async {
    final req = await request.post(
        url: AuthPath.forgetPassword,
        body: {
          "email": email,
          "otp": otp,
          "password": newPassword,
        },
        isAuth: false);
    return req.message;
  }

  @override
  Future<String> requestForgetPassword({required String email}) async {
    final req = await request.post(url: AuthPath.requestForgetPassword(email));
    return "${req.data}";
  }

  @override
  Future<bool> deleteAccount() async {
    final req = await request.delete(url: AuthPath.deleteAccount, isAuth: true);
    return req.data != null;
  }

  @override
  Future<SVersion> version() async {
    final req = await request.get(url: AuthPath.version);

    return SVersion.fromMap(req.data);
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
      request: ref.read(requestProvider), pref: ref.read(prefProvider));
});

class SVersion {
  final String version;
  final bool launched;
  final String appStoreLink;
  final String playStoreLink;
  const SVersion({
    required this.version,
    required this.launched,
    required this.appStoreLink,
    required this.playStoreLink,
  });

  SVersion copyWith({
    String? version,
    bool? launched,
    String? appStoreLink,
    String? playStoreLink,
  }) {
    return SVersion(
      version: version ?? this.version,
      launched: launched ?? this.launched,
      appStoreLink: appStoreLink ?? this.appStoreLink,
      playStoreLink: playStoreLink ?? this.playStoreLink,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'version': version,
      'launched': launched,
      'appStoreLink': appStoreLink,
      'playStoreLink': playStoreLink,
    };
  }

  factory SVersion.fromMap(Map<String, dynamic> map) {
    return SVersion(
      version: map['version'] as String,
      launched: map['launched'] as bool,
      appStoreLink: map['appStroreLink'] as String,
      playStoreLink: map['playStoreLink'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory SVersion.fromJson(String source) =>
      SVersion.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SVersion(version: $version, launched: $launched, appStoreLink: $appStoreLink, playStoreLink: $playStoreLink)';
  }

  @override
  bool operator ==(covariant SVersion other) {
    if (identical(this, other)) return true;

    return other.version == version &&
        other.launched == launched &&
        other.appStoreLink == appStoreLink &&
        other.playStoreLink == playStoreLink;
  }

  @override
  int get hashCode {
    return version.hashCode ^
        launched.hashCode ^
        appStoreLink.hashCode ^
        playStoreLink.hashCode;
  }
}
