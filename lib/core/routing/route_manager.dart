import 'package:flutter/material.dart';
import 'package:supermarket/core/routing/app_routes.dart';
import 'package:supermarket/presentation/pages/boarding/boarding_page.dart';
import 'package:supermarket/presentation/pages/home/home_page.dart';
import 'package:supermarket/presentation/pages/login/login_page.dart';
import 'package:supermarket/presentation/pages/register/register_page.dart';
import 'package:supermarket/presentation/pages/splash/splash_page.dart';

class RouteManager {
  RouteManager._();
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => const SplashPage());
      case AppRoutes.boarding:
        return MaterialPageRoute(builder: (_) => const BoardingPage());
      case AppRoutes.register:
        return MaterialPageRoute(builder: (_) => const RegisterPage());
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => const HomePage());
      default:
        return MaterialPageRoute(builder: (_) => notFoundScreen());
    }
  }

  static Route<dynamic>? onUnknownRoute(RouteSettings settings) {
    return MaterialPageRoute(builder: (_) => notFoundScreen());
  }

  static Widget notFoundScreen() {
    return Scaffold(
      appBar: AppBar(title: const Text('Not Found')),
      body: const Center(child: Text('Page not found')),
    );
  }

  //todo: use or delete
  // ignore: unused_element
  static Route _animateNavigation(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;

        const curve = Curves.ease;

        var tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));

        return SlideTransition(position: animation.drive(tween), child: child);
      },
    );
  }
}
