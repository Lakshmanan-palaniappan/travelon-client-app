import 'dart:io';
import 'package:flutter/material.dart';
import 'package:Travelon/core/utils/theme/AppColors.dart';

class MyFilePickerField extends StatelessWidget {
  final String hintText;
  final bool required;
  final File? file;
  final VoidCallback onTap;
  final double radius;

  const MyFilePickerField({
    super.key,
    required this.hintText,
    required this.onTap,
    this.file,
    this.required = false,
    this.radius = 14,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final fileName = file?.path.split('/').last;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(
              color: theme.dividerColor,
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.upload_file,
                color: AppColors.primaryDark,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  fileName ??
                      (required ? "$hintText *" : hintText),
                  style: textTheme.bodyLarge?.copyWith(
                    color: fileName == null
                        ? AppColors.lightSecondary.withOpacity(0.6)
                        : AppColors.Light,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
