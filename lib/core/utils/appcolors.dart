import 'package:flutter/material.dart';

class AppColors {
  // --- Core Brand Colors ---
  static const Color primaryBlue = Color(0xFF05668D); // Deep Teal-Blue
  static const Color secondaryLightBlue = Color(0xFF42B3D5); // Lighter Blue
  static const Color accentOrange = Color(
    0xFFF09D51,
  ); // Warm Sunset Orange (CTA)

  // --- Background & Surface ---
  static const Color backgroundLight = Color(
    0xFFF8F8F8,
  ); // Main background (Light Theme)
  static const Color surfaceWhite = Color(
    0xFFFFFFFF,
  ); // Card/Elevated surfaces (Light Theme)
  static const Color dividerGrey = Color(
    0xFFE0E0E0,
  ); // Subtle Divider/Stroke color

  // --- Text & Icon Colors ---
  static const Color textPrimaryDark = Color(
    0xFF263238,
  ); // Darkest Text (Light Theme)
  static const Color textSecondaryGrey = Color(
    0xFF757575,
  ); // Medium Grey Text (Light Theme)
  static const Color textOnDark = Color(0xFFFFFFFF); // Light Text

  // --- Status/System Colors ---
  static const Color successGreen = Color(0xFF4CAF50);
  static const Color errorRed = Color(0xFFD32F2F);

  // New Dark Mode Surfaces/Backgrounds (derived from primaryBlue or near-black)
  static const Color backgroundDark = Color(0xFF121212); // Pure dark background
  static const Color surfaceDark = Color(
    0xFF1E1E1E,
  ); // Elevated surfaces/Cards in Dark mode
}

class AppThemes {
  // --- Light Theme ColorScheme ---
  static final ColorScheme _lightColorScheme = ColorScheme(
    // Primary: Brand color for active elements, headers, and focus states.
    primary: AppColors.primaryBlue,
    // OnPrimary: Text/Icon color on top of the primary color (e.g., AppBar title).
    onPrimary: AppColors.textOnDark, // White
    // Secondary: Used for secondary call-to-action, selection controls, and accents.
    secondary: AppColors.secondaryLightBlue,
    // OnSecondary: Text/Icon color on top of the secondary color.
    onSecondary: AppColors.textPrimaryDark, // Dark text
    // Tertiary (Accent): Used for high-emphasis elements, like the main CTA/FAB.
    tertiary: AppColors.accentOrange,
    // OnTertiary: Text/Icon color on top of the tertiary color.
    onTertiary: AppColors.textOnDark, // White
    // Background: Main screen background color.
    background: AppColors.backgroundLight,
    // OnBackground: Primary text color on the background.
    onBackground: AppColors.textPrimaryDark,

    // Surface: Color for cards, sheets, menus, and elevated widgets.
    surface: AppColors.surfaceWhite,
    // OnSurface: Primary text color on surfaces (e.g., text on a Card widget).
    onSurface: AppColors.textPrimaryDark,

    // Error: For validation errors, warnings, and critical alerts.
    error: AppColors.errorRed,
    // OnError: Text/Icon color on top of the error color.
    onError: AppColors.textOnDark, // White
    // Divider color is handled outside of ColorScheme, often via DividerTheme or direct use.

    // Material 3 properties - can be automatically generated, but we set key ones.
    // PrimaryContainer: A lighter shade of primary, used for less-prominent containers (e.g., filled AppBar).
    primaryContainer:
        AppColors.secondaryLightBlue, // Using secondary for a light container
    onPrimaryContainer: AppColors.textPrimaryDark,

    brightness: Brightness.light,
  );

  // --- Dark Theme ColorScheme ---
  static final ColorScheme _darkColorScheme = ColorScheme(
    brightness: Brightness.dark,

    // Primary: Same brand color, but M3 automatically calculates a highly visible shade.
    primary:
        AppColors
            .secondaryLightBlue, // Brighter color works better as primary in Dark Mode
    onPrimary: AppColors.textPrimaryDark, // Dark text on bright primary
    // Secondary: Brand's secondary color.
    secondary: AppColors.primaryBlue, // Deeper color for secondary in Dark Mode
    onSecondary: AppColors.textOnDark, // White
    // Tertiary (Accent): High-emphasis CTA color remains visible.
    tertiary: AppColors.accentOrange,
    onTertiary: AppColors.textOnDark, // White
    // Background: Main screen background (darker than surface).
    background: AppColors.backgroundDark,
    onBackground: AppColors.textOnDark, // White
    // Surface: Card/Elevated surfaces (slightly lighter than background for visual separation).
    surface: AppColors.surfaceDark,
    onSurface: AppColors.textOnDark, // White
    // Error: For validation errors, warnings, and critical alerts.
    error: AppColors.errorRed,
    onError: AppColors.textOnDark, // White
    // PrimaryContainer: A darker variant of the primary color.
    primaryContainer: AppColors.primaryBlue, // Deep blue as container
    onPrimaryContainer: AppColors.textOnDark, // White
  );

  // --- Light ThemeData ---
  static final ThemeData lightTheme = ThemeData(
    fontFamily: 'Archivo',
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: _lightColorScheme,

    // Component Themes
    appBarTheme: AppBarTheme(
      backgroundColor: _lightColorScheme.primary, // Deep Teal-Blue
      foregroundColor:
          _lightColorScheme.onPrimary, // Text/Icons on AppBar: White
      elevation: 1.0,
      shadowColor: AppColors.dividerGrey,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _lightColorScheme.tertiary, // Accent Orange (CTA)
        foregroundColor: _lightColorScheme.onTertiary, // Text on CTA: White
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      ),
    ),

    textTheme: TextTheme(
      // Default body text
      bodyMedium: TextStyle(color: AppColors.textPrimaryDark),
      // Secondary/Hint text
      bodySmall: TextStyle(color: AppColors.textSecondaryGrey),
    ),

    dividerColor: AppColors.dividerGrey,
    scaffoldBackgroundColor: AppColors.backgroundLight,
  );

  // --- Dark ThemeData ---
  static final ThemeData darkTheme = ThemeData(
    fontFamily: 'Archivo',
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: _darkColorScheme,

    // Component Themes
    appBarTheme: AppBarTheme(
      backgroundColor:
          _darkColorScheme.primaryContainer, // Darker surface for AppBar
      foregroundColor:
          _darkColorScheme.onPrimaryContainer, // Text/Icons on AppBar: White
      elevation: 1.0,
      shadowColor: Colors.black,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _darkColorScheme.tertiary, // Accent Orange (CTA)
        foregroundColor: _darkColorScheme.onTertiary, // Text on CTA: White
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      ),
    ),

    textTheme: TextTheme(
      // Default body text (light text)
      bodyMedium: TextStyle(color: AppColors.textOnDark),
      // Secondary/Hint text (lighter grey for hints)
      bodySmall: TextStyle(color: AppColors.textSecondaryGrey.withOpacity(0.7)),
    ),

    // Using a light grey or white for dividers in dark mode
    dividerColor: AppColors.textOnDark.withOpacity(0.12),
    scaffoldBackgroundColor: AppColors.backgroundDark,
  );
}
