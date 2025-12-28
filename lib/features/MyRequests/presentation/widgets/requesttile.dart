import 'package:Travelon/core/utils/theme/AppColors.dart';
import 'package:flutter/material.dart';

class RequestTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const RequestTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark=theme.brightness==Brightness.dark;

    return Material(
      color: theme.scaffoldBackgroundColor,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isDark?AppColors.primaryDark:AppColors.primaryLight,
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 28,
                color: isDark?AppColors.primaryDark:AppColors.primaryLight,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                          color: isDark?AppColors.Light:AppColors.Dark
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: isDark?AppColors.Light:AppColors.Dark
                      ),


                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded,color: isDark?AppColors.primaryDark:AppColors.primaryLight),
            ],
          ),
        ),
      ),
    );
  }
}
