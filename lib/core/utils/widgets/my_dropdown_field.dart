import 'package:flutter/material.dart';
import 'MyDropdown.dart';

class MyDropdownField<T> extends StatelessWidget {
  final String label;
  final bool required;
  final String hintText;
  final List<DropdownMenuItem<T>> items;
  final T? value;
  final ValueChanged<T?> onChanged;
  final String? Function(T?)? validator;

  const MyDropdownField({
    super.key,
    required this.label,
    required this.hintText,
    required this.items,
    required this.value,
    required this.onChanged,
    this.validator,
    this.required = false,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 🔹 Label + *
        RichText(
          text: TextSpan(
            text: label,
            style: textTheme.titleMedium,
            children: [
              if (required)
                TextSpan(
                  text: ' *',
                  style: textTheme.titleMedium?.copyWith(
                    color: colorScheme.error,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
        ),

        const SizedBox(height: 6),

        // 🔹 Dropdown
        MyDropdown<T>(
          hintText: hintText,
          items: items,
          value: value,
          onChanged: onChanged,
          validator:
              validator ??
              (required
                  ? (v) => v == null ? 'Please select $label' : null
                  : null),
        ),
      ],
    );
  }
}
