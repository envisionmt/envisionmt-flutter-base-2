import 'package:flutter/material.dart';

class AppNavigator {
  static final navigatorKey = GlobalKey<NavigatorState>();

  static Future<T?>? pushReplacementNamed<T extends Object?, TO extends Object?>(
    String routeName, {
    TO? result,
    Object? arguments,
  }) {
    return navigatorKey.currentState
        ?.pushReplacementNamed<T, TO>(routeName, arguments: arguments, result: result);
  }

  static Future<T?>? pushNamedAndRemoveUntil<T extends Object?>(
      String newRouteName,
      RoutePredicate predicate, {
        Object? arguments,
      }) {
    return navigatorKey.currentState?.pushNamedAndRemoveUntil(newRouteName, arguments: arguments, predicate);
  }

  static Future<T?>? pushNamed<T extends Object?>(
    String routeName, {
    Object? arguments,
  }) {
    return navigatorKey.currentState?.pushNamed<T>(routeName, arguments: arguments);
  }

  static void pop<T extends Object?>([ T? result ]) {
    navigatorKey.currentState?.pop(result);
  }
}

final boxDecoration = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(10.0),
  boxShadow: [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 6.0,
      offset: Offset(0, 2),
    ),
  ],
);
