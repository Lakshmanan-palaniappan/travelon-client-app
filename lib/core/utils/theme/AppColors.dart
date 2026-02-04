import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF1A73E8);

  // LIGHT THEME
  static const Color primaryLight = Color(0xFFFEF7F8); // background
  static const Color secondaryLight = Color(0xFF90C2E7); // accent blue

  static const Color lightUtilPrimary = Color(0xFF22819A); // buttons / links
  static const Color lightUtilSecondary = Color(0xFFCDD4DD); // chips / fills

  // Background & surfaces
  static const Color bgLight = Color(0xFFFEF7F8);
  static const Color surfaceLight = Color(0xFFFFFFFF);

  // Text
  static const Color textPrimaryLight = Color(0xFF1F2A37); // deep slate
  static const Color textSecondaryLight = Color(0xFF4B5563); // muted slate
  static const Color textDisabledLight = Color(0xFF9CA3AF);

  // Icons
  static const Color iconPrimaryLight = Color(0xFF1F2A37);
  static const Color iconSecondaryLight = Color(0xFF6B7280);
  static const Color iconDisabledLight = Color(0xFFB0B7C3);

  // Dividers / borders
  static const Color dividerLight = Color(0xFFE5E7EB);

  // DARK THEME
  static const Color primaryDark = Color(0xFF312B1E); // background
  static const Color secondaryDark = Color(0xFFFC5C02); // accent orange

  static const Color darkUtilPrimary = Color(0xFFE2CEAE); // text / highlights
  static const Color darkUtilSecondary = Color(0xFF7C6B51); // muted elements

  // Background & surfaces
  static const Color bgDark = Color(0xFF1E1A14);
  static const Color surfaceDark = Color(0xFF312B1E);

  // Text
  static const Color textPrimaryDark = Color(0xFFEFE6D8);
  static const Color textSecondaryDark = Color(0xFFCBBFA8);
  static const Color textDisabledDark = Color(0xFF80868B);

  // Icons
  static const Color iconPrimaryDark = Color(0xFFEFE6D8);
  static const Color iconSecondaryDark = Color(0xFFB8A98A);
  static const Color iconDisabledDark = Color(0xFF6E6E6E);

  // Dividers / borders
  static const Color dividerDark = Color(0xFF453C2C);


  // STATES (shared)
  static const Color error = Color(0xFFD93025);
  static const Color success = Color(0xFF81C995);
  static const Color warning = Color(0xFFEBF578);
}

class AppColors1 {
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
class AppColorsLegacy{
  static const Color primary = Color(0xFF1A73E8); // Google Maps Blue
  // Light Theme Colors
  static const Color primaryLight = Color(0xFFFEF7F8);
  static const Color secondaryLight = Color(0xFF90C2E7); 
  static const Color lightUtilPrimary=Color(0xFF22819A);
  static const Color lightUtilSecondary=Color(0xFFCDD4DD);


  // Dark Theme Colors
  static const Color primaryDark = Color(0xFF312B1E);
  static const Color secondaryDark = Color(0xFFFC5C02);
  static const Color darkUtilPrimary=Color(0xFFE2CEAE);
  static const Color darkUtilSecondary=Color(0xFF7C6B51);

  // Common Colors
  static const Color textDisabledDark = Color(0xFF80868B);


}
