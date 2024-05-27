import 'dart:developer';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:ystfamily/src/core/core.dart';
import 'package:ystfamily/src/features/auth/provider/auth_provider.dart';
import 'package:ystfamily/src/features/auth/repository/auth_repository_impl.dart';

class RVersion {
  final bool needUpdate;
  final SVersion? sVersion;

  const RVersion({required this.needUpdate, this.sVersion});
}

Future<RVersion> checkVersion(WidgetRef ref) async {
  try {
    PackageInfo info = await PackageInfo.fromPlatform();
    final versi = await ref.read(authRepositoryProvider).version();
    log("[DATA ]${info.version} ");
    if (!versi.launched) {
      return RVersion(sVersion: versi, needUpdate: false);
    }

    return RVersion(sVersion: versi, needUpdate: info.version != versi.version);
  } catch (e) {
    log("[DATA ]$e VERSIOn");
    return const RVersion(needUpdate: false);
  }
}

class SplashScreen extends HookConsumerWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final version = useState<RVersion?>(null);
    ref.listen(authProvider, (previous, next) {
      next.when(
        data: (value) async {
          version.value = await checkVersion(ref);
          if (version.value?.needUpdate == false) {
            Future.delayed(
              const Duration(seconds: 2),
              () async {
                if (value.isConfirmed) {
                  const HomePageRoute().go(context);
                } else {
                  const OTPRoute().go(context);
                }
              },
            );
          }
        },
        error: (error, stackTrace) async {
          version.value = await checkVersion(ref);

          await FirebaseMessaging.instance.deleteToken();
          if (version.value?.needUpdate == false) {
            Future.delayed(
              const Duration(seconds: 2),
              () => const LoginRoute().go(context),
            );
          }
        },
        loading: () {},
      );
    });

    return SafeArea(
      top: false,
      bottom: false,
      maintainBottomViewPadding: false,
      minimum: const EdgeInsets.all(0),
      child: Scaffold(
        body: version.value?.needUpdate == true
            ? Center(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.all(32),
                  height: 200,
                  width: 300,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Silahkan update ke versi terbaru"),
                      ElevatedButton(
                          onPressed: () {
                            launchUrlString(
                              Platform.isIOS
                                  ? version.value!.sVersion!.appStoreLink
                                  : version.value!.sVersion!.playStoreLink,
                              mode: LaunchMode.externalApplication,
                            );
                          },
                          child: const Text("Update")),
                    ],
                  ),
                ),
              )
            : Center(
                child: Image.asset(
                  "assets/logo_img.png",
                  width: 95,
                ),
              ),
      ),
    );
  }
}
