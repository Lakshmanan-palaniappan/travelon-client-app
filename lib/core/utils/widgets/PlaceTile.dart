// PlaceTile.dart
import 'package:flutter/material.dart';

import '../theme/AppColors.dart';

class Placetile extends StatelessWidget {
  final double? width;
  final String title;
  final bool selected;
  final VoidCallback? onTap;
  final Color? color;

  const Placetile({
    super.key,
    this.width,
    required this.title,
    this.selected = false,
    this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness==Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: width ?? double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: color ??
              (selected
                  ? isDark?AppColors.primaryDark.withOpacity(0.12):AppColors.primaryLight.withOpacity(0.12)
                  : isDark?AppColors.surfaceDark:AppColors.surfaceLight),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected
                ? isDark?AppColors.primaryDark:AppColors.primaryLight
                : isDark?AppColors.Light:AppColors.Dark,
            width: selected ? 1.8 : 1,
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: selected
                  ? isDark?AppColors.darkSecondary:AppColors.MenuButton
                  : Colors.grey,
              child: Icon(
                Icons.place,
                size: 20,
                color: !selected
                    ? Colors.white
                    : isDark?AppColors.primaryDark:AppColors.primaryLight,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isDark?AppColors.Light:AppColors.Dark
                ),
              ),
            ),
            Icon(
              selected ? Icons.check_circle : Icons.add_circle_outline,
              color: selected
                  ? isDark?AppColors.primaryDark:AppColors.primaryLight
                  : colorScheme.outline,
            ),
          ],
        ),
      ),
    );
  }
}
