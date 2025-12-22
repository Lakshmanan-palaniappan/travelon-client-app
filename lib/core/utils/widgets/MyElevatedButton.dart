import 'package:Travelon/core/utils/theme/AppColors.dart';
import 'package:flutter/material.dart';

class MyElevatedButton extends StatelessWidget {
  final String text;
  final IconData? icon;
  final double width, height, radius;
  final VoidCallback? onPressed; // ✅ nullable

  const MyElevatedButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.width = double.infinity,
    this.height = 52.0,
    this.radius = 14.0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final bool isDisabled = onPressed == null;

    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isDisabled
              ? AppColors.primary.withOpacity(0.4) // ✅ disabled
              : AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          textStyle: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
        ),
        child: icon == null
            ? Text(text)
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 20),
                  const SizedBox(width: 8),
                  Text(text),
                ],
              ),
      ),
    );
  }
}
