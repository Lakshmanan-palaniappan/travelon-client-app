import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:Travelon/core/utils/theme/AppColors.dart';

/// Utility class for displaying warning notifications using Flushbar.
///
/// Used to show non-intrusive warning messages at the top of the screen
/// without disrupting the current UI.
class WarningFlash {
  /// Displays a warning notification.
  ///
  /// [context] is required to show the flushbar.
  /// [message] is the warning message displayed to the user.
  /// [title] defaults to "Warning".
  static void show(
    BuildContext context, {
    String title = "Warning",
    required String message,
  }) {
    // Access theme colors to keep the notification consistent with the app theme
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    Flushbar(
      title: title,
      message: message,
      duration: const Duration(seconds: 3),

      // Theme-driven warning color
      backgroundColor: AppColors.warning,

      icon: Icon(
        Icons.warning_amber_rounded,
        color: scheme.onTertiary,
        size: 28,
      ),

      titleColor: scheme.onTertiary,
      messageColor: scheme.onTertiary,

      blockBackgroundInteraction: true,
      borderRadius: BorderRadius.circular(14),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.all(16),
      flushbarPosition: FlushbarPosition.TOP,
      animationDuration: const Duration(milliseconds: 350),

      boxShadows: [
        BoxShadow(
          color: scheme.shadow.withOpacity(0.25),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
    ).show(context);
  }
}
