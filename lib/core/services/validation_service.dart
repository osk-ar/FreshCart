import 'package:supermarket/core/constants/app_strings.dart';

class ValidationService {
  static String? validateName(String? name) {
    if (name == null || name.isEmpty) {
      return AppStrings.nameEmptyError;
    }
    if (name.length < 2) {
      return AppStrings.nameMinLengthError;
    }
    return null;
  }

  static String? validateEmail(String? email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (email == null || email.isEmpty) {
      return AppStrings.emailEmptyError;
    }
    if (!emailRegex.hasMatch(email)) {
      return AppStrings.emailInvalidError;
    }
    return null; // Email is valid
  }

  /// 8 characters at least one digit, one uppercase letter, one lowercase letter, one symbol
  static String? validatePassword(String? password) {
    final passwordRegex = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*()_+{}\[\]:;<>,.?~\\/-]).{8,}$',
    );

    if (password == null || password.isEmpty) {
      return AppStrings.passwordEmptyError;
    }
    if (password.length < 8) {
      return AppStrings.passwordMinLengthError;
    }
    if (!RegExp(r'(?=.*[a-z])').hasMatch(password)) {
      return AppStrings.passwordLowercaseError;
    }
    if (!RegExp(r'(?=.*[A-Z])').hasMatch(password)) {
      return AppStrings.passwordUppercaseError;
    }
    if (!RegExp(r'(?=.*\d)').hasMatch(password)) {
      return AppStrings.passwordDigitError;
    }
    if (!RegExp(r'(?=.*[!@#$%^&*()_+{}\[\]:;<>,.?~\\/-])').hasMatch(password)) {
      return AppStrings.passwordSymbolError;
    }

    if (!passwordRegex.hasMatch(password)) {
      // This is a general fallback, if the specific errors above don't catch it.
      // You might consider if this specific general error is still needed
      // if the individual checks are comprehensive enough.
      return AppStrings.passwordGeneralError;
    }

    return null; // Password is valid
  }

  // You might want to add a validateConfirmPassword method here as well
  static String? validateConfirmPassword(
    String? confirmPassword,
    String? password,
  ) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      // You could create a specific error for empty confirm password if desired,
      // or reuse the general password empty error.
      return AppStrings.passwordEmptyError;
    }
    if (confirmPassword != password) {
      return AppStrings.passwordsDoNotMatch;
    }
    return null;
  }

  static String? validateItemName(String? name) {
    if (name == null || name.isEmpty) {
      return AppStrings.itemNameEmptyError;
    }
    return null;
  }

  static String? validatePrice(String? price) {
    if (price == null || price.isEmpty) {
      return AppStrings.priceEmptyError;
    }
    if (double.tryParse(price) == null) {
      return AppStrings.priceInvalidError;
    }
    return null;
  }
}
