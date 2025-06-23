part of 'package:supermarket/presentation/blocs/register/register_auth_bloc.dart';

class AuthState {}

class AuthInitial extends AuthState {}

class RegisterAuthLoading extends AuthState {}

class GoogleAuthLoading extends AuthState {}

class GuestAuthLoading extends AuthState {}

class AuthSuccess extends AuthState {}

class AuthFailure extends AuthState {
  final String error;

  AuthFailure(this.error);
}
