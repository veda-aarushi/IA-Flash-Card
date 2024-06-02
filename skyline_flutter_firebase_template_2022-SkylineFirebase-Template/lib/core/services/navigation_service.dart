import 'package:flutter/material.dart';

abstract class NavigationService {
  GlobalKey<NavigatorState> _navigationKey = GlobalKey<NavigatorState>();
  GlobalKey<NavigatorState> get navigationKey => _navigationKey;
  void pop(returnValue);
  Future<dynamic> navigateTo(String routeName, {dynamic arguments});
  Future<dynamic> pushNamed(String routeName, {Object arguments});
  Future<dynamic> pushReplacementNamed(String routeName, {Object arguments});
  Future<dynamic> popAllAndPushNamed(
      String routeName, {
        Object arguments,
      });
  void popUntil(bool Function(Route<dynamic>) predicate);
}

class NavigationServiceImpl implements NavigationService {
  GlobalKey<NavigatorState> _navigationKey = GlobalKey<NavigatorState>();

  GlobalKey<NavigatorState> get navigationKey => _navigationKey;

  void pop(returnValue) {
    return _navigationKey.currentState.pop(returnValue);
  }
  // bool pop({returnValue}) {
  //   return navigatorKey.currentState.pop(returnValue);
  // }

  Future<dynamic> navigateTo(String routeName, {dynamic arguments}) {
    print('NavigationService navigateTo $routeName');
    return _navigationKey.currentState
        .pushNamed(routeName, arguments: arguments);

  }

  //new from provider architecture reference
  Future<dynamic> pushNamed(String routeName, {Object arguments}) {
    return navigationKey.currentState
        .pushNamed(routeName, arguments: arguments);
  }

  Future<dynamic> pushReplacementNamed(String routeName, {Object arguments}) {
    return navigationKey.currentState?.pushReplacementNamed(
      routeName,
      arguments: arguments,
    );
  }

  Future<dynamic> popAllAndPushNamed(
      String routeName, {
        Object arguments,
      }) {
    return navigationKey.currentState.pushNamedAndRemoveUntil(
      routeName,
          (_) => false,
      arguments: arguments,
    );
  }

  void popUntil(bool Function(Route<dynamic>) predicate) {
    navigationKey.currentState.popUntil(predicate);
  }
}
