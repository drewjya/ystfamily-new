import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ystfamily/src/features/auth/repository/auth_repository_impl.dart';

part 'otp_provider.g.dart';

@Riverpod(keepAlive: false)
class OtpLength extends _$OtpLength {
  @override
  DateTime? build() {
    return null;
  }

  void setDate() {
    state = DateTime.now().add(const Duration(seconds: 30));
  }
}

// final otpProvider = StreamProvider<int>((ref) async* {
//   final dateTime = ref.watch(otpLengthProvider);
//   if (dateTime != null) {
//     yield* getDate(dateTime);
//   }
//   return;
// });

@Riverpod(keepAlive: false)
class Otp extends _$Otp {
  @override
  int build() {
    final data = ref.watch(otpLengthProvider);
    if (data != null) {
      final otpVal = ref.watch(intOtpProvider(data));
      return otpVal <= 0 ? 0 : otpVal;
    }
    return 0;
  }
}

@Riverpod(keepAlive: false)
int intOtp(IntOtpRef ref, DateTime time) {
  final timer = Timer.periodic(const Duration(seconds: 1), (timer) {
    final data = time.difference(DateTime.now()).inSeconds;
    if (data <= 0) {
      timer.cancel();
      ref.state = 0;
    } else {
      ref.state = data;
    }
  });
  ref.onDispose(() {
    timer.cancel();
  });
  return 0;
}

Stream<int> getDate(DateTime dateTime) {
  return Stream.periodic(
    const Duration(seconds: 1),
    (computationCount) {
      return dateTime.difference(DateTime.now()).inSeconds;
    },
  );
}

class OtpNotifier extends AsyncNotifier<String> {
  @override
  FutureOr<String> build() {
    return '';
  }

  postOTP({required String otp}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => ref.read(authRepositoryProvider).verifyOtp(otp: otp));
  }

  postConfirmChangePassword({required String otp, required String email, required String newPassword}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => ref.read(authRepositoryProvider).forgetPassword(email: email, otp: otp, newPassword: newPassword));
  }
}

final verifyOtpProvider = AsyncNotifierProvider<OtpNotifier, String>(
  () => OtpNotifier(),
);
