import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ystfamily/src/features/auth/repository/auth_repository_impl.dart';

class DeleteAccount extends AsyncNotifier<bool> {
  @override
  FutureOr<bool> build() {
    return false;
  }

  requestDeleteAccount() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
        () => ref.read(authRepositoryProvider).deleteAccount());
  }
}

final deleteAccountProvider = AsyncNotifierProvider<DeleteAccount, bool>(
  () => DeleteAccount(),
);
