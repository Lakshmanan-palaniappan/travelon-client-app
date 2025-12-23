import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final String hintText;
  final bool required;
  final double radius;
  final double width;
  final TextEditingController ctrl;
  final TextInputType keyboard;
  final bool obscure;
  final String? Function(String?)? validator;

  const MyTextField({
    super.key,
    required this.hintText,
    required this.ctrl,
    this.validator,
    this.required = false,
    this.width = double.infinity,
    this.radius = 12.0,
    this.keyboard = TextInputType.text,
    this.obscure = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: SizedBox(
        width: width,
        child: TextFormField(
          controller: ctrl,
          keyboardType: keyboard,
          obscureText: obscure,
          style: textTheme.bodyLarge,
          autovalidateMode: AutovalidateMode.onUserInteraction,

          validator: validator,
          decoration: InputDecoration(
            hintText: required ? "$hintText *" : hintText,

            filled: true,
            fillColor: colorScheme.surface,

            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(radius),
              borderSide: BorderSide.none,
            ),

            hintStyle: textTheme.bodyMedium?.copyWith(
              color: textTheme.bodyMedium?.color?.withOpacity(0.6),
            ),
          ),
        ),
      ),
    );
  }
}
