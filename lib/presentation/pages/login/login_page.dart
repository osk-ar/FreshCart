import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supermarket/core/services/dependency_injection.dart';
import 'package:supermarket/presentation/blocs/localization/localization_cubit.dart';
import 'package:supermarket/presentation/blocs/login/login_auth_cubit.dart';
import 'package:supermarket/presentation/blocs/login/login_ui_cubit.dart';
import 'package:supermarket/presentation/pages/login/layouts/login_phone.dart';
import 'package:supermarket/presentation/widgets/adaptive_layout.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => serviceLocator<LoginUiCubit>()),
        BlocProvider(create: (context) => serviceLocator<LoginAuthCubit>()),
        BlocProvider(create: (context) => serviceLocator<LocalizationCubit>()),
      ],
      child: AdaptiveLayout(
        phoneLayout: LoginPhone(),
        tabletLayout: LoginPhone(),
        desktopLayout: LoginPhone(),
      ),
    );
  }
}
