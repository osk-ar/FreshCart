import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supermarket/core/services/dependency_injection.dart';
import 'package:supermarket/presentation/blocs/localization/localization_cubit.dart';
import 'package:supermarket/presentation/blocs/register/register_auth_bloc.dart';
import 'package:supermarket/presentation/blocs/register/register_ui_cubit.dart';
import 'package:supermarket/presentation/pages/register/layouts/register_phone.dart';
import 'package:supermarket/presentation/widgets/adaptive_layout.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => serviceLocator<RegisterUiCubit>()),
        BlocProvider(create: (context) => serviceLocator<RegisterAuthBloc>()),
        BlocProvider(create: (context) => serviceLocator<LocalizationCubit>()),
      ],
      child: AdaptiveLayout(
        phoneLayout: RegisterPhone(),
        tabletLayout: RegisterPhone(),
        desktopLayout: RegisterPhone(),
      ),
    );
  }
}
