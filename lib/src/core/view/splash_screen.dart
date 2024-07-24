// ignore_for_file: public_member_api_docs, sort_constructors_first
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

  @override
  String toString() => 'RVersion(needUpdate: $needUpdate, sVersion: $sVersion)';
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

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  RVersion? version;

  @override
  Widget build(BuildContext context) {
    ref.listen(authProvider, (previous, next) {
      next.when(
        data: (value) async {
          version = await checkVersion(ref);

          setState(() {});
          if (version?.needUpdate == false) {
            log("$version VERSION");
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
          } else {
            log("$version VERSION");
          }
        },
        error: (error, stackTrace) async {
          version = await checkVersion(ref);
          setState(() {});
          await FirebaseMessaging.instance.deleteToken();

          if (version?.needUpdate == false) {
            Future.delayed(
              const Duration(seconds: 2),
              () => const UnHomeRoute().go(context),
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
        body: version?.needUpdate == true
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
                      const Text(
                        "Silahkan update ke versi terbaru",
                      ),
                      ElevatedButton(
                          onPressed: () {
                            launchUrlString(
                              Platform.isIOS
                                  ? version!.sVersion!.appStoreLink
                                  : version!.sVersion!.playStoreLink,
                              mode: LaunchMode.externalNonBrowserApplication,
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
