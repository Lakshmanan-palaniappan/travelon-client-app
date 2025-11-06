import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

void showErrorFlash(BuildContext context, String message, {String? title}) {
  Flushbar(
    title: title,
    message: message,
    duration: const Duration(seconds: 3),
    backgroundColor: Colors.red.shade600,
    icon: const Icon(Icons.error_outline, color: Colors.white),
    borderRadius: BorderRadius.circular(8),
    margin: const EdgeInsets.all(12),
    flushbarPosition: FlushbarPosition.TOP,
  ).show(context);
}
