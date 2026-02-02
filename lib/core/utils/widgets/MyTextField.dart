import 'package:flutter/material.dart';
import 'package:Travelon/core/utils/theme/AppColors.dart';

class MyTextField extends StatelessWidget {
  final String hintText;
  final bool required;
  final double radius;
  final double width;
  final TextEditingController ctrl;
  final TextInputType keyboard;
  final bool obscure;
  final Color? color;
  final String? Function(String?)? validator;

  const MyTextField({
    super.key,
    required this.hintText,
    required this.ctrl,
    this.validator,
    this.required = false,
    this.width = double.infinity,
    this.radius = 14.0,
    this.keyboard = TextInputType.text,
    this.obscure = false,
    this.color
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // 🎨 COLORS (theme-aware)
    final bgColor =
        isDark ? AppColors.surfaceDark : AppColors.surfaceLight;

    final textColor =
        Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;

    final hintColor =
        isDark ? AppColors.textDisabledDark : AppColors.textSecondaryLight;

    final borderIdle =
        isDark ? AppColors.primaryDark : AppColors.primaryLight;

    final borderFocus =
        isDark ? AppColors.primaryDark : AppColors.primaryLight;

    final errorColor =
        Theme.of(context).colorScheme.error;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: SizedBox(
        width: width,
        child: TextFormField(
          controller: ctrl,
          keyboardType: keyboard,
          obscureText: obscure,
          validator: validator,
          autovalidateMode: AutovalidateMode.onUserInteraction,

          style: theme.textTheme.bodyLarge?.copyWith(
            color: AppColors.surfaceLight,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.2,
          ),

          decoration: InputDecoration(
            hintText: required ? '$hintText *' : hintText,
            hintStyle: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.textDisabledDark.withOpacity(0.9),
              fontWeight: FontWeight.w400,
            ),

            filled: true,
            fillColor: color ?? AppColors.surfaceDark,

            contentPadding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 16,
            ),

            // 🟢 DEFAULT
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(radius),
              borderSide: BorderSide(
                color: borderIdle.withOpacity(0.35),
                width: 1.4,
              ),
            ),

            // 🟢 FOCUS
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(radius),
              borderSide: BorderSide(
                color: borderFocus,
                width: 1.8,
              ),
            ),

            // 🔴 ERROR
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(radius),
              borderSide: BorderSide(
                color: errorColor,
                width: 1.6,
              ),
            ),

            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(radius),
              borderSide: BorderSide(
                color: errorColor,
                width: 1.8,
              ),
            ),

            errorStyle: theme.textTheme.bodySmall?.copyWith(
              color: errorColor,
              height: 1.2,
            ),
          ),
        ),
      ),
    );
  }
}
