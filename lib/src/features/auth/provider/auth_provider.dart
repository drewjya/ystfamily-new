import 'dart:async';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:ystfamily/src/core/core.dart';
import 'package:ystfamily/src/features/auth/model/dto/login_dto.dart';
import 'package:ystfamily/src/features/auth/model/dto/register_dto.dart';
import 'package:ystfamily/src/features/auth/model/dto/update_profile.dart';
import 'package:ystfamily/src/features/auth/model/user.dart';
import 'package:ystfamily/src/features/auth/repository/auth_repository_impl.dart';

class AuthNotifier extends AsyncNotifier<User> {
  @override
  FutureOr<User> build() async {
    await Future.delayed(const Duration(seconds: 3));
    return ref.read(authRepositoryProvider).getProfile();
  }

  Future login({required LoginDTO params}) async {
    state = const AsyncLoading();
    final val = await AsyncValue.guard(
        () => ref.read(authRepositoryProvider).login(params: params));
    if (val.hasValue) {
      await FirebaseMessaging.instance.getToken().then((value) async {
        log('message: ${value.toString()}');
        if (value != null) {
          await ref
              .read(authRepositoryProvider)
              .sendTokenFirebase(token: value);
        }
      });
    }
    state = val;
  }

  Future logout() async {
    state = const AsyncLoading();
    await Future.delayed(const Duration(milliseconds: 500));
    await ref.read(authRepositoryProvider).logout();
    state = await AsyncValue.guard(
        () => ref.read(authRepositoryProvider).getProfile());
  }

  Future register({required RegisterDTO registerDTO}) async {
    state = const AsyncLoading();
    final val = await AsyncValue.guard(
        () => ref.read(authRepositoryProvider).register(params: registerDTO));
    if (val.hasValue) {
      await FirebaseMessaging.instance.getToken().then((value) async {
        if (value != null) {
          await ref
              .read(authRepositoryProvider)
              .sendTokenFirebase(token: value);
        }
      });
    }
    state = val;
  }

  Future<AsyncValue<User>> updateProfile(
      {required UpdateProfileDTO params}) async {
    final val = await AsyncValue.guard(
        () => ref.read(authRepositoryProvider).updateProfile(params: params));
    if (val.asData?.value != null) {
      state = const AsyncLoading();
      state = val;
    }
    return val;
  }
}

final authProvider =
    AsyncNotifierProvider<AuthNotifier, User>(AuthNotifier.new);
