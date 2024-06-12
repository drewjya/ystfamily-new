import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ystfamily/src/features/auth/repository/auth_repository_impl.dart';

class ForgetPassword extends AsyncNotifier<String> {
  @override
  FutureOr<String> build() {
    return '';
  }

  requestForgetPassword({required String email}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() =>
        ref.read(authRepositoryProvider).requestForgetPassword(email: email));
  }

  submitForgetPassword(
      {required String email,
      required String newPassword,
      required String otp}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => ref
        .read(authRepositoryProvider)
        .forgetPassword(email: email, otp: otp, newPassword: newPassword));
  }
}

final forgetPasswordProvider = AsyncNotifierProvider<ForgetPassword, String>(
  () => ForgetPassword(),
);
