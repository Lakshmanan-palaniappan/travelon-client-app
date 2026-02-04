import 'package:Travelon/core/utils/theme/AppColors.dart';
import 'package:Travelon/core/utils/theme/cubit/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


void showThemeSelector(BuildContext context) {
  final theme = Theme.of(context);

  showModalBottomSheet(
    context: context,
    isScrollControlled: false,
    backgroundColor: Colors.transparent, // 👈 for rounded container
    builder: (_) {
      final cubit = context.read<ThemeCubit>();

      return Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: theme.colorScheme.outline.withOpacity(0.4),
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Title
            Text(
              "Choose Theme",
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            _themeTile(context, "System", Icons.settings_rounded, ThemeMode.system, cubit),
            const SizedBox(height: 8),
            _themeTile(context, "Light", Icons.light_mode_rounded, ThemeMode.light, cubit),
            const SizedBox(height: 8),
            _themeTile(context, "Dark", Icons.dark_mode_rounded, ThemeMode.dark, cubit),
          ],
        ),
      );
    },
  );
}

Widget _themeTile(
    BuildContext context,
    String title,
    IconData icon,
    ThemeMode mode,
    ThemeCubit cubit,
    ) {
  final theme = Theme.of(context);
  final bool selected = cubit.state.mode == mode;

  return InkWell(
    borderRadius: BorderRadius.circular(16),
    onTap: () {
      cubit.setTheme(mode);
      Navigator.pop(context);
    },
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: selected
              ? theme.colorScheme.tertiary
              : theme.dividerColor,
        ),
        color: selected
            ? theme.colorScheme.tertiary.withOpacity(0.12)
            : theme.colorScheme.surface,
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: selected
                ? theme.colorScheme.tertiary
                : theme.iconTheme.color,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
          if (selected)
            Icon(
              Icons.check_circle_rounded,
              color: theme.colorScheme.tertiary,
            ),
        ],
      ),
    ),
  );
}
