import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ystfamily/src/features/auth/repository/auth_repository_impl.dart';

class ChangePasswordNotifier extends AsyncNotifier<String> {
  @override
  FutureOr<String> build() {
    return '';
  }

  changePassword({required String oldPassword, required String newPassword}) async {
    state = const AsyncLoading();
    final a = await AsyncValue.guard(() => ref.read(authRepositoryProvider).changePassword(oldPassword: oldPassword, newPassword: newPassword));
    state = a.when(
      data: (data) => const AsyncValue.data("success"),
      error: (error, stackTrace) => AsyncValue.error(error, stackTrace),
      loading: () => const AsyncValue.loading(),
    );
  }
}

final changePasswordProvider = AsyncNotifierProvider<ChangePasswordNotifier, String>(
  () => ChangePasswordNotifier(),
);
