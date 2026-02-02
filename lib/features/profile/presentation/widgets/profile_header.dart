import 'package:flutter/material.dart';
import 'package:Travelon/core/utils/theme/AppTextstyles.dart';

import '../../../../core/utils/theme/AppColors.dart';

class ProfileHeader extends StatelessWidget {
  final String name;

  const ProfileHeader({super.key, required this.name});

  @override
  Widget build(BuildContext context) {

    String getInitials(String name) {
      final parts = name.trim().split(RegExp(r'\s+'));
      if (parts.isEmpty) return "?";
      if (parts.length == 1) return parts.first[0].toUpperCase();
      return '${parts.first[0].toUpperCase()}${parts.last[0].toUpperCase()}';
    }
    final theme = Theme.of(context);
    final isDark=theme.brightness==Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
        isDark?theme.colorScheme.primary:theme.colorScheme.primary,
            isDark?theme.colorScheme.primaryContainer:AppColors.surfaceLight,
            isDark?AppColors.darkUtilSecondary:AppColors.secondaryLight.withOpacity(0.95)
          ],
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: [
          // Avatar
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 44,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              child: Text(
                getInitials(name),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style:
                theme.textTheme.headlineSmall?.copyWith(
                  color: isDark ? AppColors.primaryDark : AppColors.primaryLight,
                  fontWeight: FontWeight.w700,
                  fontSize: 34
                ),
              ),
            ),
          ),

          const SizedBox(height: 14),

          // Name
          Text(
            name,
            textAlign: TextAlign.center,
            style: AppTextStyles.title.copyWith(
              fontSize: 21,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.95),
              shadows: [
                Shadow(
                  color: Colors.black.withOpacity(0.25),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),

          const SizedBox(height: 4),

          // Optional subtitle (feels VERY iOS)
          Text(
            "Tourist Account",
            style: theme.textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              letterSpacing: 0.4,
            ),
          ),
        ],
      ),
    );
  }
}
