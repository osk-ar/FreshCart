import 'dart:developer';

import 'package:easy_localization/easy_localization.dart' as e_loc;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supermarket/core/routing/app_routes.dart';
import 'package:supermarket/core/constants/app_strings.dart';
import 'package:supermarket/core/services/validation_service.dart';
import 'package:supermarket/core/utils/extensions.dart';
import 'package:supermarket/presentation/blocs/localization/localization_cubit.dart';
import 'package:supermarket/presentation/blocs/login/login_auth_cubit.dart';
import 'package:supermarket/presentation/blocs/login/login_ui_cubit.dart';
import 'package:supermarket/presentation/widgets/auth_navigation_text.dart';
import 'package:supermarket/presentation/widgets/localization_button.dart';
import 'package:supermarket/presentation/widgets/primary_button.dart';
import 'package:supermarket/presentation/widgets/secondary_button.dart';

class LoginPhone extends StatefulWidget {
  const LoginPhone({super.key});

  @override
  State<LoginPhone> createState() => _LoginPhoneState();
}

class _LoginPhoneState extends State<LoginPhone> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final FocusNode _emailFocusNode;
  late final FocusNode _passwordFocusNode;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(AppStrings.login),
        centerTitle: true,
        actions: [
          BlocBuilder<LocalizationCubit, Locale>(
            builder: (context, isDarkMode) {
              return LocalizationButton(
                languageCode: context.locale.languageCode,
                onPressed:
                    () => context.read<LocalizationCubit>().switchLocale(),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: Text(
                  AppStrings.email,
                  style: context.theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(height: 8.h),
              TextFormField(
                controller: _emailController,
                focusNode: _emailFocusNode,
                validator: ValidationService.validateEmail,
                onFieldSubmitted: (value) {
                  FocusScope.of(context).requestFocus(_passwordFocusNode);
                },
                onEditingComplete: () {
                  FocusScope.of(context).requestFocus(_passwordFocusNode);
                },
                onSaved: (newValue) {
                  FocusScope.of(context).requestFocus(_passwordFocusNode);
                },
                decoration: InputDecoration(
                  hintText: AppStrings.emailHint,
                  helperText: "",
                  constraints: BoxConstraints(maxWidth: 358.w, minHeight: 56.h),
                ),
                textDirection: TextDirection.ltr,
              ),
              Spacer(),
              SizedBox(
                width: double.infinity,
                child: Text(
                  AppStrings.password,
                  style: context.theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(height: 8.h),
              BlocBuilder<LoginUiCubit, bool>(
                builder: (context, shouldObsecurePassword) {
                  return TextFormField(
                    controller: _passwordController,
                    focusNode: _passwordFocusNode,
                    validator: ValidationService.validatePassword,
                    obscureText: shouldObsecurePassword,
                    decoration: InputDecoration(
                      hintText: AppStrings.securePasswordHint,
                      helperText: "",
                      constraints: BoxConstraints(
                        maxWidth: 358.w,
                        minHeight: 56.h,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          shouldObsecurePassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed:
                            () =>
                                context
                                    .read<LoginUiCubit>()
                                    .togglePasswordVisibility(),
                      ),
                    ),
                    textDirection: TextDirection.ltr,
                  );
                },
              ),
              Spacer(),
              SizedBox(height: 216.h),
              BlocConsumer<LoginAuthCubit, LoginAuthState>(
                listener: (context, state) {
                  switch (state) {
                    case LoginSuccess():
                      context.message("Success");
                      break;
                    case LoginFailure():
                      context.message("Failure: ${state.error}");
                      break;
                    default:
                  }
                },
                builder: (context, state) {
                  return PrimaryButton(
                    label: AppStrings.login,
                    onPressed: () {
                      if (!_formKey.currentState!.validate()) return;
                      context.read<LoginAuthCubit>().loginWithEmailAndPassword(
                        _emailController.text.trim(),
                        _passwordController.text.trim(),
                      );
                    },
                  );
                },
              ),
              SizedBox(height: 8.h),
              SecondaryButton(
                label: AppStrings.continueWithGoogle,
                onPressed:
                    () => context.read<LoginAuthCubit>().loginWithGoogle(),
              ),
              SizedBox(height: 8.h),
              Text(
                AppStrings.or,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: context.theme.hintColor,
                ),
              ),
              SizedBox(height: 8.h),
              TextButton(
                onPressed: () => log("Continue as Guest Not Implemented yet"),
                //todo add guest auth functionality
                child: Text(
                  AppStrings.continueAsGuest,
                  style: context.theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(height: 24.h),
              AuthNavigationText(
                leadingText: AppStrings.dontHaveAnAccount,
                trailingText: AppStrings.signUp,
                onPressed:
                    () => context.pushReplacementNamed(AppRoutes.register),
              ),
              SizedBox(height: 8.h),
            ],
          ),
        ),
      ),
    );
  }
}
