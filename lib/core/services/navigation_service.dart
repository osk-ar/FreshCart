// lib/core/services/navigation_service.dart

import 'package:flutter/material.dart';

class NavigationService {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  Future<dynamic>? pushNamed(String routeName, {Object? arguments}) {
    return _navigatorKey.currentState?.pushNamed(
      routeName,
      arguments: arguments,
    );
  }

  void pop() {
    return _navigatorKey.currentState?.pop();
  }
}
