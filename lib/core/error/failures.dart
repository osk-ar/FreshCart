import 'package:equatable/equatable.dart';
import 'package:supermarket/core/constants/app_strings.dart';

// --- 1. THE BASE FAILURE CLASS ---
abstract class Failure extends Equatable {
  final String message;
  final Object? originalException;
  final StackTrace? stackTrace;

  const Failure({
    required this.message,
    this.originalException,
    this.stackTrace,
  });

  @override
  List<Object?> get props => [message, originalException, stackTrace];
}

// --- 2. GENERIC FAILURE CLASSES ---

class ServerFailure extends Failure {
  ServerFailure({String? message, super.originalException, super.stackTrace})
    : super(message: message ?? AppStrings.serverFailure);
}

class NetworkFailure extends Failure {
  NetworkFailure({String? message, super.originalException, super.stackTrace})
    : super(message: message ?? AppStrings.networkFailure);
}

// --- 3. AUTHENTICATION-SPECIFIC FAILURE CLASSES ---

class AuthFailure extends Failure {
  const AuthFailure({
    required super.message,
    super.originalException,
    super.stackTrace,
  });
}

class InvalidCredentialFailure extends AuthFailure {
  InvalidCredentialFailure({
    String? message,
    super.originalException,
    super.stackTrace,
  }) : super(message: message ?? AppStrings.invalidCredentialFailure);
}

class EmailInUseFailure extends AuthFailure {
  EmailInUseFailure({
    String? message,
    super.originalException,
    super.stackTrace,
  }) : super(message: message ?? AppStrings.emailInUseFailure);
}

class InvalidEmailFailure extends AuthFailure {
  InvalidEmailFailure({
    String? message,
    super.originalException,
    super.stackTrace,
  }) : super(message: message ?? AppStrings.invalidEmailFailure);
}

class WeakPasswordFailure extends AuthFailure {
  WeakPasswordFailure({
    String? message,
    super.originalException,
    super.stackTrace,
  }) : super(message: message ?? AppStrings.weakPasswordFailure);
}

class RequiresRecentLoginFailure extends AuthFailure {
  RequiresRecentLoginFailure({
    String? message,
    super.originalException,
    super.stackTrace,
  }) : super(message: message ?? AppStrings.requiresRecentLoginFailure);
}

class TooManyRequestsFailure extends AuthFailure {
  TooManyRequestsFailure({
    String? message,
    super.originalException,
    super.stackTrace,
  }) : super(message: message ?? AppStrings.tooManyRequestsFailure);
}

class UserDisabledFailure extends AuthFailure {
  UserDisabledFailure({
    String? message,
    super.originalException,
    super.stackTrace,
  }) : super(message: message ?? AppStrings.userDisabledFailure);
}

// --- 4. DATABASE/STORAGE-SPECIFIC FAILURE CLASSES ---

class PermissionDeniedFailure extends Failure {
  PermissionDeniedFailure({
    String? message,
    super.originalException,
    super.stackTrace,
  }) : super(message: message ?? AppStrings.permissionDeniedFailure);
}

class NotFoundFailure extends Failure {
  NotFoundFailure({String? message, super.originalException, super.stackTrace})
    : super(message: message ?? AppStrings.notFoundFailure);
}
