import 'package:flutter/material.dart';
import 'package:supermarket/core/constants/app_routes.dart';
import 'package:supermarket/presentation/pages/boarding/boarding_page.dart';
import 'package:supermarket/presentation/pages/splash/splash_page.dart';

class RouteManager {
  RouteManager._();
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    // Handle different routes based on settings.name
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => const SplashPage());
      case AppRoutes.boarding:
        return MaterialPageRoute(builder: (_) => const BoardingPage());
      default:
        return MaterialPageRoute(builder: (_) => notFoundScreen());
    }
  }

  static Route<dynamic>? onUnknownRoute(RouteSettings settings) {
    // Handle unknown routes
    return MaterialPageRoute(builder: (_) => notFoundScreen());
  }

  // You can also define a NotFoundScreen to handle unknown routes
  static Widget notFoundScreen() {
    return Scaffold(
      appBar: AppBar(title: const Text('Not Found')),
      body: const Center(child: Text('Page not found')),
    );
  }
}
