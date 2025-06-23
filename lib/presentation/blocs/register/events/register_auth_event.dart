part of 'package:supermarket/presentation/blocs/register/register_auth_bloc.dart';

class RegisterAuthEvent {}

class RegisterWithEmailAndPassword extends RegisterAuthEvent {
  final String email;
  final String password;

  RegisterWithEmailAndPassword(this.email, this.password);
}

class RegisterWithGoogle extends RegisterAuthEvent {}

class RegisterWithGuest extends RegisterAuthEvent {}
