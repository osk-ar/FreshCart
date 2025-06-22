import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supermarket/core/constants/app_paths.dart';
import 'package:supermarket/core/constants/app_routes.dart';
import 'package:supermarket/core/utils/extensions.dart';
import 'package:supermarket/presentation/blocs/splash/splash_bloc.dart';

class SplashPhone extends StatelessWidget {
  const SplashPhone({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<SplashBloc, SplashState>(
        listener: (context, state) {
          switch (state) {
            case FirstTimeUse():
              context.pushNamed(AppRoutes.boarding);
              break;
            case Authenticated():
              context.pushNamed(AppRoutes.home);
              break;
            case Unauthenticated():
              context.pushNamed(AppRoutes.login);
              break;
            default:
              log("Unknown Splash State: $state");
          }
        },
        child: Center(child: Image.asset(AppPaths.appLogo)),
      ),
    );
  }
}
