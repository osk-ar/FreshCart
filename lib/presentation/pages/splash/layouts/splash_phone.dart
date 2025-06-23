import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supermarket/core/constants/app_paths.dart';
import 'package:supermarket/core/constants/app_routes.dart';
import 'package:supermarket/core/utils/extensions.dart';
import 'package:supermarket/presentation/blocs/splash/splash_navigation_bloc.dart';

class SplashPhone extends StatelessWidget {
  const SplashPhone({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<SplashNavigationBloc, NavigationState>(
        listener: (context, state) {
          switch (state) {
            case FirstTimeUse():
              context.pushReplacementNamed(AppRoutes.boarding);
              break;
            case Authenticated():
              context.pushReplacementNamed(AppRoutes.home);
              break;
            case Unauthenticated():
              context.pushReplacementNamed(AppRoutes.login);
              break;
          }
        },
        child: Center(child: Image.asset(AppPaths.appLogo)),
      ),
    );
  }
}
