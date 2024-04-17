import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

extension GoRouterExtension on GoRouter {
  String location() {
    final RouteMatch lastMatch = routerDelegate.currentConfiguration.last;
    final RouteMatchList matchList = lastMatch is ImperativeRouteMatch
        ? lastMatch.matches
        : routerDelegate.currentConfiguration;
    final String location = matchList.uri.toString();
    return location;
  }

  bool contains(String routeName) {
    final route = routerDelegate.currentConfiguration.matches
        .map((e) => e.matchedLocation);
    return route.contains(routeName);
  }
}

extension GoContext on BuildContext {
  GoRouter get router => GoRouter.of(this);
}
