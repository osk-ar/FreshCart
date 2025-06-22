import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supermarket/core/theme/app_colors.dart';

class AppTheme {
  static final ThemeData _lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.lightPrimary,
    scaffoldBackgroundColor: AppColors.lightBackground,
    colorScheme: const ColorScheme.light(
      primary: AppColors.lightPrimary,
      onPrimary: AppColors.onPrimaryColor,
      secondary: AppColors.lightSecondaryButtons,
      onSecondary: AppColors.lightHintText,
      background: AppColors.lightBackground,
      onBackground: AppColors.primaryTextColorLight,
      surface: AppColors.lightBackground,
      onSurface: AppColors.primaryTextColorLight,
      error: Color(0xFFBA1A1A),
      onError: Colors.white,
    ),
    textTheme: TextTheme(
      displayLarge: TextStyle(color: AppColors.primaryTextColorLight),
      displayMedium: TextStyle(color: AppColors.primaryTextColorLight),
      displaySmall: TextStyle(color: AppColors.primaryTextColorLight),
      headlineLarge: TextStyle(color: AppColors.primaryTextColorLight),
      headlineMedium: TextStyle(color: AppColors.primaryTextColorLight),
      headlineSmall: TextStyle(color: AppColors.primaryTextColorLight),
      titleLarge: TextStyle(
        fontWeight: FontWeight.bold,
        color: AppColors.primaryTextColorLight,
      ),
      titleMedium: TextStyle(
        fontWeight: FontWeight.bold,
        color: AppColors.primaryTextColorLight,
      ),
      titleSmall: TextStyle(
        fontWeight: FontWeight.bold,
        color: AppColors.primaryTextColorLight,
      ),
      bodyLarge: TextStyle(color: AppColors.primaryTextColorLight),
      bodyMedium: TextStyle(color: AppColors.primaryTextColorLight),
      bodySmall: const TextStyle(color: AppColors.lightSecondaryText),
      labelLarge: const TextStyle(
        color: AppColors.onPrimaryColor,
        fontWeight: FontWeight.bold,
      ), // For text on primary buttons
      labelMedium: const TextStyle(color: AppColors.lightHintText),
      labelSmall: const TextStyle(color: AppColors.lightHintText),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.lightBackground,
      elevation: 0,
      iconTheme: IconThemeData(color: AppColors.lightPrimary),
      titleTextStyle: TextStyle(
        color: AppColors.primaryTextColorLight,
        fontSize: 20.sp,
        fontWeight: FontWeight.bold,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.lightTextfields,
      hintStyle: const TextStyle(color: AppColors.lightHintText),
      labelStyle: const TextStyle(color: AppColors.lightHintText),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0.r),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0.r),
        borderSide: const BorderSide(color: AppColors.lightPrimary),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.lightPrimary,
        foregroundColor: AppColors.onPrimaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0.r),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: AppColors.lightPrimary),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.lightPrimary,
      foregroundColor: AppColors.onPrimaryColor,
    ),
    cardTheme: CardTheme(
      color: AppColors.lightTextfields,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0.r),
      ),
    ),
  );

  static final ThemeData _darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.darkPrimary,
    scaffoldBackgroundColor: AppColors.darkBackground,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.darkPrimary,
      onPrimary: AppColors.onPrimaryColor,
      secondary: AppColors.darkSecondaryButtons,
      onSecondary: AppColors.darkHintText,
      background: AppColors.darkBackground,
      onBackground: AppColors.primaryTextColorDark,
      surface: AppColors.darkBackground,
      onSurface: AppColors.primaryTextColorDark,
      error: Color(0xFFFFB4AB),
      onError: Color(0xFF690005),
    ),
    textTheme: TextTheme(
      displayLarge: TextStyle(color: AppColors.primaryTextColorDark),
      displayMedium: TextStyle(color: AppColors.primaryTextColorDark),
      displaySmall: TextStyle(color: AppColors.primaryTextColorDark),
      headlineLarge: TextStyle(color: AppColors.primaryTextColorDark),
      headlineMedium: TextStyle(color: AppColors.primaryTextColorDark),
      headlineSmall: TextStyle(color: AppColors.primaryTextColorDark),
      titleLarge: const TextStyle(
        fontWeight: FontWeight.bold,
        color: AppColors.primaryTextColorDark,
      ),
      titleMedium: const TextStyle(
        fontWeight: FontWeight.bold,
        color: AppColors.primaryTextColorDark,
      ),
      titleSmall: const TextStyle(
        fontWeight: FontWeight.bold,
        color: AppColors.primaryTextColorDark,
      ),
      bodyLarge: TextStyle(color: AppColors.primaryTextColorDark),
      bodyMedium: TextStyle(color: AppColors.primaryTextColorDark),
      bodySmall: const TextStyle(color: AppColors.darkSecondaryText),
      labelLarge: const TextStyle(
        color: AppColors.onPrimaryColor,
        fontWeight: FontWeight.bold,
      ), // For text on primary buttons
      labelMedium: const TextStyle(color: AppColors.darkHintText),
      labelSmall: const TextStyle(color: AppColors.darkHintText),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.darkBackground,
      elevation: 0,
      iconTheme: IconThemeData(color: AppColors.darkPrimary),
      titleTextStyle: TextStyle(
        color: AppColors.primaryTextColorDark,
        fontSize: 20.sp,
        fontWeight: FontWeight.bold,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.darkTextfields,
      hintStyle: const TextStyle(color: AppColors.darkHintText),
      labelStyle: const TextStyle(color: AppColors.darkHintText),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0.r),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0.r),
        borderSide: const BorderSide(color: AppColors.darkPrimary),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.darkPrimary,
        foregroundColor: AppColors.onPrimaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0.r),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: AppColors.darkPrimary),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.darkPrimary,
      foregroundColor: AppColors.onPrimaryColor,
    ),
    cardTheme: CardTheme(
      color: AppColors.darkTextfields,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0.r),
      ),
    ),
  );

  static ThemeData get lightTheme => _lightTheme;

  static ThemeData get darkTheme => _darkTheme;
}
