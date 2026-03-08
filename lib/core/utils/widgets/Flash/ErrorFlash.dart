import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:Travelon/core/utils/theme/AppColors.dart';

/// Utility class for displaying error notifications using Flushbar.
///
/// Used to show non-intrusive error messages at the top of the screen
/// without disrupting the current UI.
class ErrorFlash {
  /// Displays an error notification.
  ///
  /// [context] is required to show the flushbar.
  /// [message] is the error message displayed to the user.
  /// [title] defaults to "Error".
  /// [duration] controls how long the notification stays visible.
  static void show(
    BuildContext context, {
    required String message,
    String title = "Error",
    Duration duration = const Duration(seconds: 3),
  }) {
    Flushbar(
      title: title,
      message: message,
      duration: duration,
      backgroundColor: AppColors.error,
      icon: const Icon(Icons.error_outline, color: Colors.white, size: 28),
      blockBackgroundInteraction: true,
      borderRadius: BorderRadius.circular(14),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.all(16),
      flushbarPosition: FlushbarPosition.TOP,
      animationDuration: const Duration(milliseconds: 350),
      boxShadows: const [
        BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4)),
      ],
    ).show(context);
  }
}
