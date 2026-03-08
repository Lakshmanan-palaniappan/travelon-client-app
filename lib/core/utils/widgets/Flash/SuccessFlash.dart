import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:Travelon/core/utils/theme/AppColors.dart';

/// Utility class for displaying success notifications using Flushbar.
///
/// Used to show non-intrusive success messages at the top of the screen
/// without disrupting the current UI.
class SuccessFlash {
  /// Displays a success notification.
  ///
  /// [context] is required to show the flushbar.
  /// [message] is the success message displayed to the user.
  /// [title] defaults to "Success".
  /// [duration] controls how long the notification stays visible.
  static void show(
    BuildContext context, {
    String title = "Success",
    required String message,
  }) {
    final theme = Theme.of(context);

    Flushbar(
      title: title,
      message: message,
      duration: const Duration(seconds: 2),
      backgroundColor: AppColors.success,
      icon: const Icon(Icons.check_circle, color: Colors.white, size: 28),
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
