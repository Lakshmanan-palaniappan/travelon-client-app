import 'package:flutter/material.dart';
import 'package:Travelon/core/utils/appcolors.dart';

class MyDropdown<T> extends StatelessWidget {
  final String labelText;
  final List<DropdownMenuItem<T>> items;
  final T? value;
  final ValueChanged<T?> onChanged;
  final double width;
  final double radius;
  final String? Function(T?)? validator;

  const MyDropdown({
    super.key,
    required this.labelText,
    required this.items,
    required this.value,
    required this.onChanged,
    this.validator,
    this.width = 350.0,
    this.radius = 4.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: DropdownButtonFormField<T>(
        value: value,
        items: items,
        onChanged: onChanged,
        validator: validator,
        decoration: InputDecoration(
          labelText: labelText,
          filled: true,
          fillColor: AppColors.secondaryLightBlue.withOpacity(0.1),

          // Default border shape
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius),
            borderSide: BorderSide(
              color: AppColors.secondaryLightBlue.withOpacity(0.25),
              width: 2.0,
            ),
          ),

          // When not focused
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius),
            borderSide: BorderSide(
              color: AppColors.secondaryLightBlue.withOpacity(0.25),
              width: 2.0,
            ),
          ),

          // When focused
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius),
            borderSide: BorderSide(
              color: AppColors.primaryBlue.withOpacity(0.75),
              width: 2.5,
            ),
          ),

          // Error border
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius),
            borderSide: const BorderSide(color: Colors.red, width: 2.0),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
        ),
      ),
    );
  }
}
