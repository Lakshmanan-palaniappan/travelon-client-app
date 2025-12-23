import 'package:flutter/material.dart';

class MyDropdown<T> extends StatelessWidget {
  final String? labelText;
  final String hintText;
  final List<DropdownMenuItem<T>> items;
  final T? value;
  final ValueChanged<T?> onChanged;
  final String? Function(T?)? validator;
  final double width;
  final double radius;

  const MyDropdown({
    super.key,
    this.labelText,
    required this.hintText,
    required this.items,
    required this.value,
    required this.onChanged,
    this.validator,
    this.width = 350.0,
    this.radius = 14.0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 18.0),
      child: SizedBox(
        width: width,
        child: DropdownButtonFormField<T>(
          value: value,
          items: items,
          onChanged: onChanged,
          validator: validator,
          dropdownColor: colorScheme.surface,
          decoration: InputDecoration(
            filled: true,
            fillColor: colorScheme.surface,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(radius),
              borderSide: BorderSide(color: theme.dividerColor, width: 1.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(radius),
              borderSide: BorderSide(
                color: theme.dividerColor.withOpacity(0.7),
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(radius),
              borderSide: BorderSide(
                color: colorScheme.primary,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(radius),
              borderSide: BorderSide(color: colorScheme.error, width: 1.8),
            ),
            labelText: labelText,
            hintText: hintText,
            labelStyle: textTheme.bodySmall?.copyWith(
              color: textTheme.bodyMedium?.color,
              fontWeight: FontWeight.w500,
            ),
            hintStyle: textTheme.bodySmall?.copyWith(
              color: textTheme.bodyMedium?.color?.withOpacity(0.6),
            ),
          ),
        ),
      ),
    );
  }
}
