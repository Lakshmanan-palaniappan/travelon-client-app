import 'package:Travelon/core/utils/theme/AppColors.dart';
import 'package:flutter/material.dart';
import 'AppTextstyles.dart';

class AppThemes {
  static final ThemeData light = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.bgLight,
    fontFamily: AppTextStyles.fontFamily,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      error: AppColors.error,
      background: AppColors.bgLight,
      surface: AppColors.surfaceLight,
    ),
    dividerColor: AppColors.dividerLight,
    textTheme: TextTheme(
      titleLarge: AppTextStyles.title.copyWith(
        color: AppColors.textPrimaryLight,
      ),
      titleMedium: AppTextStyles.sectionTitle.copyWith(
        color: AppColors.textPrimaryLight,
      ),
      bodyLarge: AppTextStyles.body.copyWith(
        color: AppColors.textPrimaryLight,
      ),
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
      foregroundColor: Colors.white,
    ),
  );

  static final ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.bgDark,
    fontFamily: AppTextStyles.fontFamily,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primaryDarkMode,
      secondary: AppColors.secondaryDarkMode,
      error: AppColors.errorDarkMode,
      background: AppColors.bgDark,
      surface: AppColors.surfaceDark,
    ),
    dividerColor: AppColors.dividerDark,
    textTheme: TextTheme(
      titleLarge: AppTextStyles.title.copyWith(
        color: AppColors.textPrimaryDark,
      ),
      titleMedium: AppTextStyles.sectionTitle.copyWith(
        color: AppColors.textPrimaryDark,
      ),
      bodyLarge: AppTextStyles.body.copyWith(
        color: AppColors.textPrimaryDark,
      ),
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
      foregroundColor: Colors.black,
    ),
  );
}
