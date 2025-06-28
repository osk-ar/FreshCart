import 'package:flutter/material.dart';
import 'package:supermarket/core/routing/app_routes.dart';
import 'package:supermarket/presentation/pages/boarding/boarding_page.dart';
import 'package:supermarket/presentation/pages/login/login_page.dart';
import 'package:supermarket/presentation/pages/register/register_page.dart';
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
      case AppRoutes.register:
        return MaterialPageRoute(builder: (_) => const RegisterPage());
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
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
