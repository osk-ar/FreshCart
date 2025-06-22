import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supermarket/core/services/dependency_injection.dart';
import 'package:supermarket/presentation/blocs/splash/splash_bloc.dart';
import 'package:supermarket/presentation/pages/splash/layouts/splash_phone.dart';
import 'package:supermarket/presentation/widgets/adaptive_layout.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceLocator<SplashBloc>()..add(SplashCheckAuth()),
      child: AdaptiveLayout(
        phoneLayout: SplashPhone(),
        tabletLayout: SplashPhone(),
        desktopLayout: SplashPhone(),
      ),
    );
  }
}
