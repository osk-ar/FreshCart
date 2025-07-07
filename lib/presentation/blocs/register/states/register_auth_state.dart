part of 'package:supermarket/presentation/blocs/register/register_auth_cubit.dart';

abstract class RegisterAuthState {}

class RegisterAuthInitial extends RegisterAuthState {}

class RegisterCredsLoading extends RegisterAuthState {}

class RegisterGoogleLoading extends RegisterAuthState {}

class RegisterGuestLoading extends RegisterAuthState {}

class RegisterSuccess extends RegisterAuthState {}

class RegisterFailure extends RegisterAuthState {
  final String error;

  RegisterFailure(this.error);
}
