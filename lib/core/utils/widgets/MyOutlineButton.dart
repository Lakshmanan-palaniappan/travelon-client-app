import 'package:flutter/material.dart';
import 'package:Travelon/core/utils/theme/AppColors.dart';

class MyOutlinedButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final double width, height, radius;
  final Color? borderColor;
  final Color? textColor;
  final Color? bgColor;

  const MyOutlinedButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.width = double.infinity,
    this.height = 52.0,
    this.radius = 50.0,
    this.borderColor,
    this.textColor,
    this.bgColor
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: width,
      height: height,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: bgColor ?? Colors.transparent,
          side: BorderSide(color: borderColor ?? Colors.transparent, width: 2.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
          textStyle: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          
        ),
        child: Text(
          text,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: textColor ?? AppColors.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
