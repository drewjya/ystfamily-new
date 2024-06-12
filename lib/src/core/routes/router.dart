// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:ystfamily/main.dart';
import 'package:ystfamily/src/features/auth/view/change_password_screen.dart';
import 'package:ystfamily/src/features/auth/view/forget_password_screen.dart';
import 'package:ystfamily/src/features/auth/view/login_screen.dart';
import 'package:ystfamily/src/features/auth/view/otp_confirmation_password.dart';
import 'package:ystfamily/src/features/auth/view/otp_screen.dart';
import 'package:ystfamily/src/features/auth/view/register_screen.dart';
import 'package:ystfamily/src/features/cabang/cabang.dart';
import 'package:ystfamily/src/features/history/view/detail_history_screen.dart';
import 'package:ystfamily/src/features/home/home.dart';
import 'package:ystfamily/src/features/notification/view/notification_screen.dart';
import 'package:ystfamily/src/features/order/order.dart';
import 'package:ystfamily/src/features/order/view/order_screen.dart';
import 'package:ystfamily/src/features/profile/profile.dart';
import 'package:ystfamily/src/features/profile/view/edit_profile_screen.dart';

import '../core.dart';

part 'router.g.dart';

Page<void> _buildCustomTransition(
        BuildContext context, GoRouterState state, Widget child) =>
    CupertinoPage(child: child);

@TypedGoRoute<SplashRoute>(path: SplashRoute.routeName)
class SplashRoute extends GoRouteData {
  static const routeName = "/splash";
  const SplashRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const SplashScreen();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      _buildCustomTransition(context, state, const SplashScreen());
}

@TypedGoRoute<LoginRoute>(path: LoginRoute.routeName)
class LoginRoute extends GoRouteData {
  static const routeName = "/login";
  const LoginRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const LoginScreen();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      _buildCustomTransition(context, state, const LoginScreen());
}

@TypedGoRoute<RegisterRoute>(path: RegisterRoute.routeName)
class RegisterRoute extends GoRouteData {
  static const routeName = "/register";
  const RegisterRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const RegisterScreen();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      _buildCustomTransition(context, state, const RegisterScreen());
}

@TypedGoRoute<ForgetPasswordRoute>(path: ForgetPasswordRoute.routeName)
class ForgetPasswordRoute extends GoRouteData {
  static const routeName = "/forget-password";
  const ForgetPasswordRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const ForgetPasswordScreen();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      CupertinoPage(child: build(context, state));
}

@TypedGoRoute<OTPRoute>(path: OTPRoute.routeName)
class OTPRoute extends GoRouteData {
  static const routeName = "/otp";

  const OTPRoute();
  @override
  Widget build(BuildContext context, GoRouterState state) => const OTPScreen();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      _buildCustomTransition(context, state, const OTPScreen());
}

@TypedGoRoute<OtpForgetPasswordRoute>(path: OtpForgetPasswordRoute.routeName)
class OtpForgetPasswordRoute extends GoRouteData {
  static const routeName = "/otp-forget-password/:email";
  final String email;
  const OtpForgetPasswordRoute(
    this.email,
  );
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      OTPConfirmationPasswordScreen(email: email);

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      _buildCustomTransition(context, state, build(context, state));
}

@TypedShellRoute<HomeRoute>(
  routes: <TypedRoute<RouteData>>[
    TypedGoRoute<HomePageRoute>(path: HomePageRoute.routeName),
    TypedGoRoute<HistoryPageRoute>(path: HistoryPageRoute.routeName),
    TypedGoRoute<ProfilePageRoute>(path: ProfilePageRoute.routeName),
    // TypedGoRoute<FavoritePageRoute>(path: FavoritePageRoute.routeName),
  ],
)
class HomeRoute extends ShellRouteData {
  const HomeRoute();

  static final $navigatorKey = shellNavigatorKey;
  @override
  Widget builder(BuildContext context, GoRouterState state, Widget navigator) {
    return HomeScreen(
      child: navigator,
    );
  }
}

class HomePageRoute extends GoRouteData {
  static const routeName = "/home";
  const HomePageRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const HomePage();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CupertinoPage(
        child: HeroControllerScope(
            controller: MaterialApp.createMaterialHeroController(),
            child: build(context, state)));
  }
}

class HistoryPageRoute extends GoRouteData {
  static const routeName = "/history";
  const HistoryPageRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const HistoryPage();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CupertinoPage(child: build(context, state));
  }
}

class ProfilePageRoute extends GoRouteData {
  static const routeName = "/profile";
  const ProfilePageRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const ProfilePage();
  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CupertinoPage(child: build(context, state));
  }
}

@TypedGoRoute<NotificationPageRoute>(path: NotificationPageRoute.routeName)
class NotificationPageRoute extends GoRouteData {
  static const routeName = "/notification";

  const NotificationPageRoute();
  static final GlobalKey<NavigatorState> $parentNavigatorKey = navigatorKey;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const NotificationScreen();
  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CupertinoPage(child: build(context, state));
  }
}

@TypedGoRoute<CabangRoute>(path: CabangRoute.routeName)
class CabangRoute extends GoRouteData {
  static const routeName = "/cabang/:tipe";

  final String tipe;

  const CabangRoute({required this.tipe});
  static final GlobalKey<NavigatorState> $parentNavigatorKey = navigatorKey;

  @override
  Widget build(BuildContext context, GoRouterState state) => CabangScreen(
        tipe: tipe,
      );
  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CupertinoPage(child: build(context, state));
  }
}

@TypedGoRoute<DetailHistoryRoute>(path: DetailHistoryRoute.routeName)
class DetailHistoryRoute extends GoRouteData {
  static const routeName = "/detail/history/:id";

  final int id;

  const DetailHistoryRoute({required this.id});
  static final GlobalKey<NavigatorState> $parentNavigatorKey = navigatorKey;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      DetailHistoryScreen(id: id);
  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CupertinoPage(child: build(context, state));
  }
}

@TypedGoRoute<ChangePasswordRoute>(path: ChangePasswordRoute.routeName)
class ChangePasswordRoute extends GoRouteData {
  static const routeName = "/change-password";

  const ChangePasswordRoute();
  static final GlobalKey<NavigatorState> $parentNavigatorKey = navigatorKey;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const ChangePasswordScreen();
  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CupertinoPage(child: build(context, state));
  }
}

@TypedGoRoute<EditProfileRoute>(path: EditProfileRoute.routeName)
class EditProfileRoute extends GoRouteData {
  static const routeName = "/edit-profile";

  const EditProfileRoute();
  static final GlobalKey<NavigatorState> $parentNavigatorKey = navigatorKey;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const EditProfileScreen();
  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CupertinoPage(child: build(context, state));
  }
}

@TypedGoRoute<OrderRoute>(path: OrderRoute.routeName)
class OrderRoute extends GoRouteData {
  static const routeName = "/order/:branch";

  final String branch;

  const OrderRoute({required this.branch});
  static final GlobalKey<NavigatorState> $parentNavigatorKey = navigatorKey;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return OrderScreen(
      branchName: branch,
    );
  }

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return CupertinoPage(child: build(context, state));
  }
}
