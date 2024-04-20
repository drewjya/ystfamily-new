import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:pwa_install/pwa_install.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:ystfamily/firebase_options.dart';
import 'package:ystfamily/src/core/api/firebase/push_notification.dart';
import 'package:ystfamily/src/core/api/firebase/push_notification_impl.dart';
import 'package:ystfamily/src/core/core.dart';
import 'package:ystfamily/src/core/provider/pref_provider.dart';

final sl = GetIt.instance;

final navigatorKey = GlobalKey<NavigatorState>();
final shellNavigatorKey = GlobalKey<NavigatorState>();
final snackbarKey = GlobalKey<ScaffoldMessengerState>();

final GoRouter _router = GoRouter(
  routes: $appRoutes,
  navigatorKey: navigatorKey,
  initialLocation: SplashRoute.routeName,
  debugLogDiagnostics: true,
);

Future<void> bootstrap(Widget app) async {
  WidgetsFlutterBinding.ensureInitialized();
  final pref = await SharedPreferences.getInstance();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await initPushNotif();
  sl<PushNotification>().initPushNotification().then((value) {
    sl<PushNotification>().setPushNotificationListeners();
  });
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  setPathUrlStrategy();
  runApp(ProviderScope(
    overrides: [
      prefProvider.overrideWithValue(pref),
    ],
    child: app,
  ));
}

Future<void> main() async {
  if (kIsWeb) {
    PWAInstall().setup(installCallback: () {
      debugPrint('APP INSTALLED!');
    });
  }
  bootstrap(const MyApp());
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: "YST Family",
      scaffoldMessengerKey: snackbarKey,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: VColor.primaryBackground),
        useMaterial3: true,
      ),
      routerConfig: _router,
    );
  }
}
