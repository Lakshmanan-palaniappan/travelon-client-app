import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class SuccessFlash {
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
      backgroundColor: theme.colorScheme.primary, // ✅ success color
      icon: const Icon(
        Icons.check_circle,
        color: Colors.white,
        size: 28,
      ),
      borderRadius: BorderRadius.circular(14),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.all(16),
      flushbarPosition: FlushbarPosition.TOP,
      animationDuration: const Duration(milliseconds: 350),
      boxShadows: const [
        BoxShadow(
          color: Colors.black26,
          blurRadius: 8,
          offset: Offset(0, 4),
        ),
      ],
    ).show(context);
  }
}
