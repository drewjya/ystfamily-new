import 'dart:async';
import 'dart:developer';

import 'package:package_info_plus/package_info_plus.dart';
import 'package:ystfamily/src/core/core.dart';
import 'package:ystfamily/src/features/auth/repository/auth_repository_impl.dart';

class VersionNotifier extends AsyncNotifier<bool> {
  @override
  FutureOr<bool> build() async {
    PackageInfo info = await PackageInfo.fromPlatform();
    final versi = await ref.read(authRepositoryProvider).version();
    if (!versi.launched) {
      return true;
    }
    log(info.version);
    return true;
  }
}
