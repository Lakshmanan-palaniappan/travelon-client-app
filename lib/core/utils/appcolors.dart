import 'package:flutter/material.dart';

class AppColors {
  // --- Core Brand Colors ---

  // Deep Teal-Blue: Primary color for brand identity, main headers, and important elements.
  // Symbolizes trust, stability, and intelligence.
  static const Color primaryBlue = Color(0xFF05668D);

  // Lighter Blue: Used for active states, selected items, and secondary elements.
  // Provides a refreshing, calming feeling.
  static const Color secondaryLightBlue = Color(0xFF42B3D5);

  // Warm Sunset Orange: Used exclusively for Calls To Action (CTA),
  // buttons, and alerts to signify excitement and action.
  static const Color accentOrange = Color(0xFFF09D51);

  // --- Background & Surface ---

  // Background for the main screens. A very subtle, warm off-white for visual comfort.
  static const Color backgroundLight = Color(0xFFF8F8F8);

  // Pure White: Used for card backgrounds, elevated surfaces, and modal sheets.
  // Enhances cleanliness and professionalism.
  static const Color surfaceWhite = Color(0xFFFFFFFF);

  // Subtle Divider/Stroke color.
  static const Color dividerGrey = Color(0xFFE0E0E0);

  // --- Text & Icon Colors ---

  // Darkest Text: For body copy, main titles, and maximum readability.
  static const Color textPrimaryDark = Color(0xFF263238);

  // Medium Grey Text: For subheadings, secondary information, and hints.
  static const Color textSecondaryGrey = Color(0xFF757575);

  // Light Text: For text over dark backgrounds (e.g., text on primaryBlue).
  static const Color textOnDark = Color(0xFFFFFFFF);

  // --- Status/System Colors ---

  // Success Green: For confirmed bookings, successful payments, and positive feedback.
  static const Color successGreen = Color(0xFF4CAF50);

  // Error Red: For warnings, failed transactions, and critical alerts.
  static const Color errorRed = Color(0xFFD32F2F);
}
