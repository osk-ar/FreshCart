part of 'package:supermarket/presentation/blocs/login/login_auth_cubit.dart';

abstract class LoginAuthState {}

class LoginAuthInitial extends LoginAuthState {}

class LoginCredsLoading extends LoginAuthState {}

class LoginGoogleLoading extends LoginAuthState {}

class LoginGuestLoading extends LoginAuthState {}

class LoginSuccess extends LoginAuthState {}

class LoginFailure extends LoginAuthState {
  final String error;

  LoginFailure(this.error);
}
