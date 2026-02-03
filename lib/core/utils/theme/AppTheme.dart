import 'package:flutter/material.dart';
import 'AppColors.dart';
import 'AppTextstyles.dart';

class AppThemes {
  // ===============================
  // LIGHT THEME
  // ===============================
  static final ThemeData light = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.bgLight,
    fontFamily: AppTextStyles.fontFamily,
    

    colorScheme: const ColorScheme.light(
      primary: AppColors.lightUtilPrimary,
      onPrimary: Colors.white,

      secondary: AppColors.secondaryLight,
      onSecondary: AppColors.textPrimaryLight,

      tertiary: AppColors.secondaryLight,
      onTertiary: AppColors.lightUtilSecondary,

      

      surface: AppColors.surfaceLight,
      onSurface: AppColors.textPrimaryLight,

      error: AppColors.error,
      onError: Colors.white,
    ),

    dividerColor: AppColors.dividerDark,

    iconTheme: const IconThemeData(
      color: AppColors.iconPrimaryLight,
    ),

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
      iconTheme: IconThemeData(
        color: AppColors.iconPrimaryLight,
      ),
    ),

    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.lightUtilPrimary,
      foregroundColor: Colors.white,
    ),
  );

  // ===============================
  // DARK THEME
  // ===============================
  static final ThemeData dark = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.bgDark,
    fontFamily: AppTextStyles.fontFamily,

    colorScheme: const ColorScheme.dark(
      primary: AppColors.primaryDark,
      onPrimary: Colors.white,

      secondary: AppColors.secondaryDark,
      onSecondary: Colors.black,

      tertiary: AppColors.darkUtilPrimary,
      onTertiary: AppColors.darkUtilSecondary,

      surface: AppColors.surfaceDark,
      onSurface: AppColors.textPrimaryDark,

      error: AppColors.error,
      onError: Colors.black,
    ),

    dividerColor: AppColors.dividerLight,

    iconTheme: const IconThemeData(
      color: AppColors.iconPrimaryDark,
    ),

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
      iconTheme: IconThemeData(
        color: AppColors.iconPrimaryDark,
      ),
    ),

    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.secondaryDark,
      foregroundColor: Colors.black,
    ),
  );
}
