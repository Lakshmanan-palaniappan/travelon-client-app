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
                  ? theme.colorScheme.onTertiary
                  : theme.colorScheme.surface),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected
                ? theme.colorScheme.secondary
                : Theme.of(context).dividerColor,
            width: selected ? 1.8 : 1,
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: selected
                  ? Theme.of(context).colorScheme.secondary
                  : Colors.grey,
              child: Icon(
                Icons.place,
                size: 20,
                color: !selected
                    ? theme.iconTheme.color
                    : isDark?AppColors.primaryDark:AppColors.primaryLight,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
              ),
            ),
            Icon(
              selected ? Icons.check_circle : Icons.add_circle_outline,
              color: selected
                  ? theme.colorScheme.secondary
                  : colorScheme.outline,
            ),
          ],
        ),
      ),
    );
  }
}
