// PlaceTile.dart
import 'package:flutter/material.dart';

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
                  ? colorScheme.primary.withOpacity(0.12)
                  : colorScheme.surface),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected
                ? colorScheme.primary
                : colorScheme.outline.withOpacity(0.4),
            width: selected ? 1.8 : 1,
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: selected
                  ? colorScheme.primary
                  : colorScheme.primary.withOpacity(0.15),
              child: Icon(
                Icons.place,
                size: 20,
                color: selected
                    ? Colors.white
                    : colorScheme.primary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Icon(
              selected ? Icons.check_circle : Icons.add_circle_outline,
              color: selected
                  ? colorScheme.primary
                  : colorScheme.outline,
            ),
          ],
        ),
      ),
    );
  }
}
