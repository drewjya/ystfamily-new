import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:ystfamily/src/core/core.dart';
import 'package:ystfamily/src/features/auth/provider/auth_provider.dart';

class SplashScreen extends HookConsumerWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(authProvider, (previous, next) {
      next.when(
        data: (value) {
          Future.delayed(
            const Duration(seconds: 2),
            () {
              if (value.verified) {
                const HomePageRoute().go(context);
              } else {
                const OTPRoute().go(context);
              }
            },
          );
        },
        error: (error, stackTrace) {
          FirebaseMessaging.instance.deleteToken();
          Future.delayed(
            const Duration(seconds: 2),
            () => const LoginRoute().go(context),
          );
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
        body: Center(
          child: Image.asset(
            "assets/logo.png",
            width: 95,
          ),
        ),
      ),
    );
  }
}
