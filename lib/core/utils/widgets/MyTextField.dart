import 'package:Travelon/core/utils/appcolors.dart';
import 'package:flutter/material.dart';

class Mytextfield extends StatelessWidget {
  final String hint_text;
  final String label_text;
  final double radius;
  final double width;
  const Mytextfield({
    super.key,
    required this.hint_text,
    required this.label_text,
    this.width = 350.0,
    this.radius = 10.0,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: SizedBox(
        width: width,
        child: TextField(
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.secondaryLightBlue.withOpacity(0.1),

            // Default border shape (for layout consistency)
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(radius),
              borderSide: BorderSide(
                color: AppColors.secondaryLightBlue.withOpacity(0.25),
                width: 2.0,
              ),
            ),

            // When text field is not focused
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(radius),
              borderSide: BorderSide(
                color: AppColors.secondaryLightBlue.withOpacity(0.25),
                width: 2.0,
              ),
            ),

            // When text field is focused
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(radius),
              borderSide: BorderSide(
                color: AppColors.primaryBlue.withOpacity(0.75),
                width: 2.5,
              ),
            ),

            // Optional: red border for error state
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(radius),
              borderSide: const BorderSide(color: Colors.red, width: 2.0),
            ),

            hintText: hint_text,
            labelText: label_text,
            hintStyle: TextStyle(color: AppColors.primaryBlue),
            labelStyle: TextStyle(color: AppColors.primaryBlue),
          ),
        ),
      ),
    );
  }
}
