import 'package:flutter/material.dart';

/// ===============================
/// COLORS
/// ===============================
class AppColors {
  // ---------- Brand ----------
  // (Kept for backward compatibility)
  static const Color primary = Color(0xFF1A73E8); // Google Maps Blue

  // Used as header / accent in LIGHT theme
  static const Color primaryLight = Color(0xFFDE3642);

  // Used as header / accent in DARK theme
  static const Color primaryDark = Color(0xFFEAD292);

  // ---------- SECONDARY ----------
  // Used in DARK theme (avatars, icons)
  static const Color darkSecondary = Color(0xFF012C4E);

  // Used in LIGHT theme (avatars, icons)
  static const Color lightSecondary = Color(0xFF565448);

  // (Legacy – kept to avoid breaking old code)
  static const Color secondary = Color(0xFF1E8E3E);
  static const Color secondaryLight = Color(0xFFE9EFE6);

  // ---------- ERROR ----------
  static const Color error = Color(0xFFD93025);
  static const Color errorLight = Color(0xFFFCE8E6);

  // ---------- Light Theme ----------
  static const Color bgLight = Color(0xFFF8F9FA);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color dividerLight = Color(0xFFE0E0E0);

  // static const Color textPrimaryLight   = Color(0xFFEAD292);
  // static const Color textSecondaryLight = Color(0xFFFFEFB3);
  // static const Color textDisabledLight  = Color(0xFF9AA0A6);

  static const Color textPrimaryLight = Color.fromARGB(255, 255, 0, 0);
  static const Color textSecondaryLight = Color.fromRGBO(255, 68, 0, 1);
  static const Color textDisabledLight = Color.fromARGB(255, 255, 0, 0);

  // ---------- Dark Theme ----------
  static const Color bgDark = Color(0xFF121212);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  static const Color dividerDark = Color(0xFF2C2C2C);

  static const Color Dark = Color(0xFF121212);
  static const Color Light = Color(0xFFF8F9FA);

  static const Color MenuButton = Color(0xFFEBF578);
  static const Color textPrimaryDark = Color(0xFF012C4E);
  static const Color textSecondaryDark = Color(0xFF050A30);
  static const Color textDisabledDark = Color(0xFF80868B);

  // ---------- Dark Mode Brand ----------
  static const Color primaryDarkMode = Color(0xFF8AB4F8);
  static const Color secondaryDarkMode = Color(0xFF81C995);
  static const Color errorDarkMode = Color(0xFFF28B82);
}

// ThemeData lightTheme = ThemeData(
//   brightness: Brightness.light,
//   scaffoldBackgroundColor: AppColors.bgLight,
//   fontFamily: AppTextStyles.fontFamily,

//   colorScheme: const ColorScheme.light(
//     primary: AppColors.primary,
//     secondary: AppColors.secondary,
//     error: AppColors.error,
//     background: AppColors.bgLight,
//     surface: AppColors.surfaceLight,
//   ),

//   dividerColor: AppColors.dividerLight,

//   textTheme: TextTheme(
//     titleLarge: AppTextStyles.title.copyWith(color: AppColors.textPrimaryLight),
//     titleMedium: AppTextStyles.sectionTitle.copyWith(
//       color: AppColors.textPrimaryLight,
//     ),
//     bodyLarge: AppTextStyles.body.copyWith(color: AppColors.textPrimaryLight),
//     bodyMedium: AppTextStyles.bodySecondary.copyWith(
//       color: AppColors.textSecondaryLight,
//     ),
//     labelSmall: AppTextStyles.helper.copyWith(
//       color: AppColors.textDisabledLight,
//     ),
//   ),

//   appBarTheme: const AppBarTheme(
//     backgroundColor: AppColors.surfaceLight,
//     elevation: 0,
//     foregroundColor: AppColors.textPrimaryLight,
//   ),

//   floatingActionButtonTheme: const FloatingActionButtonThemeData(
//     backgroundColor: AppColors.primary,
//     foregroundColor: Colors.white,
//   ),
// );

// ThemeData darkTheme = ThemeData(
//   brightness: Brightness.dark,
//   scaffoldBackgroundColor: AppColors.bgDark,
//   fontFamily: AppTextStyles.fontFamily,

//   colorScheme: const ColorScheme.dark(
//     primary: AppColors.primaryDarkMode,
//     secondary: AppColors.secondaryDarkMode,
//     error: AppColors.errorDarkMode,
//     background: AppColors.bgDark,
//     surface: AppColors.surfaceDark,
//   ),

//   dividerColor: AppColors.dividerDark,

//   textTheme: TextTheme(
//     titleLarge: AppTextStyles.title.copyWith(color: AppColors.textPrimaryDark),
//     titleMedium: AppTextStyles.sectionTitle.copyWith(
//       color: AppColors.textPrimaryDark,
//     ),
//     bodyLarge: AppTextStyles.body.copyWith(color: AppColors.textPrimaryDark),
//     bodyMedium: AppTextStyles.bodySecondary.copyWith(
//       color: AppColors.textSecondaryDark,
//     ),
//     labelSmall: AppTextStyles.helper.copyWith(
//       color: AppColors.textDisabledDark,
//     ),
//   ),

//   appBarTheme: const AppBarTheme(
//     backgroundColor: AppColors.surfaceDark,
//     elevation: 0,
//     foregroundColor: AppColors.textPrimaryDark,
//   ),

//   floatingActionButtonTheme: const FloatingActionButtonThemeData(
//     backgroundColor: AppColors.primaryDarkMode,
//     foregroundColor: Colors.black,
//   ),
// );
