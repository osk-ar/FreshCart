import 'dart:developer';

import 'package:easy_localization/easy_localization.dart' as ez_loc;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supermarket/core/routing/app_routes.dart';
import 'package:supermarket/core/constants/app_strings.dart';
import 'package:supermarket/core/services/validation_service.dart';
import 'package:supermarket/core/utils/extensions.dart';
import 'package:supermarket/presentation/blocs/localization/localization_cubit.dart';
import 'package:supermarket/presentation/blocs/register/register_auth_cubit.dart';
import 'package:supermarket/presentation/blocs/register/register_ui_cubit.dart';
import 'package:supermarket/presentation/widgets/auth_navigation_text.dart';
import 'package:supermarket/presentation/widgets/localization_button.dart';
import 'package:supermarket/presentation/widgets/primary_button.dart';
import 'package:supermarket/presentation/widgets/secondary_button.dart';

class RegisterPhone extends StatefulWidget {
  const RegisterPhone({super.key});

  @override
  State<RegisterPhone> createState() => _RegisterPhoneState();
}

class _RegisterPhoneState extends State<RegisterPhone> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;
  late final FocusNode _nameFocusNode;
  late final FocusNode _emailFocusNode;
  late final FocusNode _passwordFocusNode;
  late final FocusNode _confirmPasswordFocusNode;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _nameFocusNode = FocusNode();
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
    _confirmPasswordFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(AppStrings.register),
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
                  AppStrings.name,
                  style: context.theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(height: 8.h),
              TextFormField(
                controller: _nameController,
                focusNode: _nameFocusNode,
                validator: ValidationService.validateName,
                onFieldSubmitted: (value) {
                  FocusScope.of(context).requestFocus(_emailFocusNode);
                },
                onEditingComplete: () {
                  FocusScope.of(context).requestFocus(_emailFocusNode);
                },
                onSaved: (newValue) {
                  FocusScope.of(context).requestFocus(_emailFocusNode);
                },
                decoration: InputDecoration(
                  hintText: AppStrings.nameHint,
                  helperText: "",
                  constraints: BoxConstraints(maxWidth: 358.w, minHeight: 56.h),
                ),
                textDirection: TextDirection.ltr,
              ),
              Spacer(),
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
              BlocBuilder<RegisterUiCubit, bool>(
                builder: (context, shouldObsecurePassword) {
                  return TextFormField(
                    controller: _passwordController,
                    focusNode: _passwordFocusNode,
                    validator: ValidationService.validatePassword,
                    obscureText: shouldObsecurePassword,
                    onFieldSubmitted: (value) {
                      FocusScope.of(
                        context,
                      ).requestFocus(_confirmPasswordFocusNode);
                    },
                    onEditingComplete: () {
                      FocusScope.of(
                        context,
                      ).requestFocus(_confirmPasswordFocusNode);
                    },
                    onSaved: (newValue) {
                      FocusScope.of(
                        context,
                      ).requestFocus(_confirmPasswordFocusNode);
                    },
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
                                    .read<RegisterUiCubit>()
                                    .togglePasswordVisibility(),
                      ),
                    ),
                    textDirection: TextDirection.ltr,
                  );
                },
              ),
              Spacer(),
              SizedBox(
                width: double.infinity,
                child: Text(
                  AppStrings.confirmPassword,
                  style: context.theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(height: 8.h),
              BlocBuilder<RegisterUiCubit, bool>(
                builder: (context, shouldObsecurePassword) {
                  return TextFormField(
                    controller: _confirmPasswordController,
                    focusNode: _confirmPasswordFocusNode,
                    validator:
                        (confirmPassword) =>
                            ValidationService.validateConfirmPassword(
                              confirmPassword,
                              _passwordController.text,
                            ),
                    obscureText: shouldObsecurePassword,
                    decoration: InputDecoration(
                      hintText: AppStrings.reEnterPasswordHint,
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
                                    .read<RegisterUiCubit>()
                                    .togglePasswordVisibility(),
                      ),
                    ),
                    textDirection: TextDirection.ltr,
                  );
                },
              ),
              Spacer(),
              BlocConsumer<RegisterAuthCubit, RegisterAuthState>(
                listener: (context, state) {
                  switch (state) {
                    case RegisterSuccess():
                      context.message("Success");
                      context.pushAndRemoveUntil(
                        AppRoutes.home,
                        (route) => false,
                      );
                      break;
                    case RegisterFailure():
                      context.message("Failure: ${state.error}");
                      break;
                    default:
                  }
                },
                builder: (context, state) {
                  return PrimaryButton(
                    label: AppStrings.register,
                    onPressed: () {
                      if (!_formKey.currentState!.validate()) return;
                      context
                          .read<RegisterAuthCubit>()
                          .registerWithEmailAndPassword(
                            _emailController.text.trim(),
                            _passwordController.text.trim(),
                            _nameController.text.trim(),
                          );
                    },
                  );
                },
              ),
              SizedBox(height: 8.h),
              SecondaryButton(
                label: AppStrings.continueWithGoogle,
                onPressed:
                    () =>
                        context.read<RegisterAuthCubit>().registerWithGoogle(),
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
                leadingText: AppStrings.alreadyHaveAccount,
                trailingText: AppStrings.signIn,
                onPressed: () => context.pushReplacementNamed(AppRoutes.login),
              ),
              SizedBox(height: 8.h),
            ],
          ),
        ),
      ),
    );
  }
}
