import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:supermarket/core/error/failures.dart';

extension ThemeExtension on BuildContext {
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  ThemeData get theme => Theme.of(this);
}

extension NavigationExtension on BuildContext {
  void pushNamed(String routeName, {Object? arguments}) {
    Navigator.pushNamed(this, routeName, arguments: arguments);
  }

  void pushReplacementNamed(String routeName, {Object? arguments}) {
    Navigator.pushReplacementNamed(this, routeName, arguments: arguments);
  }

  void pushAndRemoveUntil(
    String routeName,
    RoutePredicate predicate, {
    Object? arguments,
  }) {
    Navigator.pushNamedAndRemoveUntil(
      this,
      routeName,
      predicate,
      arguments: arguments,
    );
  }

  void pop<T extends Object?>([T? result]) {
    Navigator.pop(this, result);
  }
}

extension SnackBarExtension on BuildContext {
  void message(String message) {
    ScaffoldMessenger.of(this).showSnackBar(SnackBar(content: Text(message)));
  }
}

extension ExceptionExtension on Object? {
  Failure mapExceptionToFailure([StackTrace? stackTrace]) {
    if (this is FirebaseException) {
      switch ((this as FirebaseException).code) {
        case 'invalid-credential':
        case 'user-not-found':
        case 'wrong-password':
          return InvalidCredentialFailure(
            originalException: this,
            stackTrace: stackTrace,
          );
        case 'email-already-in-use':
          return EmailInUseFailure(
            originalException: this,
            stackTrace: stackTrace,
          );
        case 'invalid-email':
          return InvalidEmailFailure(
            originalException: this,
            stackTrace: stackTrace,
          );
        case 'weak-password':
          return WeakPasswordFailure(
            originalException: this,
            stackTrace: stackTrace,
          );
        case 'requires-recent-login':
          return RequiresRecentLoginFailure(
            originalException: this,
            stackTrace: stackTrace,
          );
        case 'too-many-requests':
          return TooManyRequestsFailure(
            originalException: this,
            stackTrace: stackTrace,
          );
        case 'user-disabled':
          return UserDisabledFailure(
            originalException: this,
            stackTrace: stackTrace,
          );
        case 'permission-denied':
          return PermissionDeniedFailure(
            originalException: this,
            stackTrace: stackTrace,
          );
        case 'not-found':
        case 'object-not-found':
          return NotFoundFailure(
            originalException: this,
            stackTrace: stackTrace,
          );
        default:
          return ServerFailure(
            message:
                'A Firebase error occurred: ${(this as FirebaseException).message ?? 'Unknown error'}.',
            originalException: this,
            stackTrace: stackTrace,
          );
      }
    } else if (this is SocketException) {
      return NetworkFailure(originalException: this, stackTrace: stackTrace);
    } else if (this is DatabaseException) {
      switch ((this as DatabaseException).toString()) {
        case "unique constraint failed":
          return UniqueConstraintFailure(originalException: this);
        case "syntax error":
          return SyntaxErrorFailure(originalException: this);

        default:
          return UnknownDatabaseFailure(originalException: this);
      }
    } else {
      return ServerFailure(
        message: 'An unknown error occurred: ${toString()}',
        originalException: this,
        stackTrace: stackTrace,
      );
    }
  }
}
