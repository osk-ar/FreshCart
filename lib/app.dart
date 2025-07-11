import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supermarket/core/routing/app_routes.dart';
import 'package:supermarket/core/routing/route_manager.dart';
import 'package:supermarket/core/services/dependency_injection.dart';
import 'package:supermarket/core/services/local_database_service.dart';
import 'package:supermarket/core/services/navigation_service.dart';
import 'package:supermarket/core/theme/app_theme.dart';
import 'package:supermarket/presentation/blocs/theme/theme_cubit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void dispose() {
    LocalDatabaseService.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return BlocProvider<ThemeCubit>(
          create: (context) => serviceLocator<ThemeCubit>()..loadTheme(),
          child: BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, themeMode) {
              return MaterialApp(
                //debugging
                debugShowCheckedModeBanner: false,
                // localization
                localizationsDelegates: context.localizationDelegates,
                supportedLocales: context.supportedLocales,
                locale: context.locale,
                // navigation
                initialRoute: AppRoutes.splash,
                onUnknownRoute: RouteManager.onUnknownRoute,
                onGenerateRoute: RouteManager.onGenerateRoute,
                navigatorKey: serviceLocator<NavigationService>().navigatorKey,
                // theme
                darkTheme: AppTheme.darkTheme,
                theme: AppTheme.lightTheme,
                themeMode: themeMode,
              );
            },
          ),
        );
      },
    );
  }
}
