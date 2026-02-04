import 'package:Travelon/core/utils/theme/AppColors.dart';
import 'package:flutter/material.dart';

import 'package:Travelon/core/utils/theme/AppColors.dart';
import 'package:flutter/material.dart';

class MyElevatedButton extends StatelessWidget {
  final String text;
  final IconData? icon;
  final double? width;
  final Color? color;

  final double height;
  final double radius;
  final VoidCallback? onPressed;

  const MyElevatedButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.width,
    this.color,
    this.height = 52.0,
    this.radius = 14.0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bool isDisabled = onPressed == null;

    final double screenWidth = MediaQuery.of(context).size.width;

    final double resolvedWidth = width ??
        (screenWidth < 600 ? double.infinity : 420);

    final Color backgroundColor = isDisabled
        ? (isDark
        ? AppColors.iconDisabledDark.withOpacity(0.4)
        : AppColors.iconDisabledLight.withOpacity(0.4))
        : (color ??
        (isDark ? AppColors.secondaryDark : AppColors.lightUtilPrimary));

    return Center(
      child: SizedBox(
        width: resolvedWidth,
        height: height,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor,
            foregroundColor: Colors.white,
            elevation: 0,
            textStyle: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).textTheme.bodyLarge!.color,
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
      ),
    );
  }
}


