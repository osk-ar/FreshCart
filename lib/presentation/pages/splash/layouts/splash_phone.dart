import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:supermarket/core/constants/app_paths.dart';
import 'package:supermarket/core/routing/app_routes.dart';
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
            case Unauthenticated():
              context.pushReplacementNamed(AppRoutes.login);
              break;
            case Authenticated():
              context.pushReplacementNamed(AppRoutes.home);
              break;
          }
        },
        child: Center(
          child: SvgPicture.asset(
            AppPaths.appLogo,
            height: 156.r,
            width: 156.r,
          ),
        ),
      ),
    );
  }
}
