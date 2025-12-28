import 'package:flutter/material.dart';
import 'AppColors.dart';
import 'AppTextstyles.dart';

class AppThemes {
  // ===============================
  // LIGHT THEME
  // ===============================
  static final ThemeData light = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.bgLight,
    fontFamily: AppTextStyles.fontFamily,

    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      onPrimary: Colors.white,

      secondary: AppColors.secondary,
      onSecondary: Colors.white,

      background: AppColors.bgLight,
      onBackground: AppColors.textPrimaryLight,

      surface: AppColors.surfaceLight,
      onSurface: AppColors.textPrimaryLight,

      error: AppColors.error,
      onError: Colors.white,
    ),

    dividerColor: AppColors.dividerLight,

    textTheme: const TextTheme().copyWith(
      titleLarge: AppTextStyles.title.copyWith(
        color: AppColors.textPrimaryLight,
      ),
      titleMedium: AppTextStyles.sectionTitle.copyWith(
        color: AppColors.textPrimaryLight,
      ),
      bodyLarge: AppTextStyles.body.copyWith(color: AppColors.textPrimaryLight),
      bodyMedium: AppTextStyles.bodySecondary.copyWith(
        color: AppColors.textSecondaryLight,
      ),
      labelSmall: AppTextStyles.helper.copyWith(
        color: AppColors.textDisabledLight,
      ),
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.surfaceLight,
      elevation: 0,
      foregroundColor: AppColors.textPrimaryLight,
    ),

    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white, // == onPrimary
    ),
  );

  // ===============================
  // DARK THEME
  // ===============================
  static final ThemeData dark = ThemeData(
    
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.bgDark,
    fontFamily: AppTextStyles.fontFamily,

    colorScheme: const ColorScheme.dark(
      primary: AppColors.primaryDarkMode,
      onPrimary: Colors.black,

      secondary: AppColors.secondaryDarkMode,
      onSecondary: Colors.black,

      background: AppColors.bgDark,
      onBackground: AppColors.textPrimaryDark,

      surface: AppColors.surfaceDark,
      onSurface: AppColors.textPrimaryDark,

      error: AppColors.errorDarkMode,
      onError: Colors.black,
    ),

    dividerColor: AppColors.dividerDark,

    textTheme: const TextTheme().copyWith(
      titleLarge: AppTextStyles.title.copyWith(
        color: AppColors.textPrimaryDark,
      ),
      titleMedium: AppTextStyles.sectionTitle.copyWith(
        color: AppColors.textPrimaryDark,
      ),
      bodyLarge: AppTextStyles.body.copyWith(color: AppColors.textPrimaryDark),
      bodyMedium: AppTextStyles.bodySecondary.copyWith(
        color: AppColors.textSecondaryDark,
      ),
      labelSmall: AppTextStyles.helper.copyWith(
        color: AppColors.textDisabledDark,
      ),
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.surfaceDark,
      elevation: 0,
      foregroundColor: AppColors.textPrimaryDark,
    ),

    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.primaryDarkMode,
      foregroundColor: Colors.black, // == onPrimary
    ),
  );
}
