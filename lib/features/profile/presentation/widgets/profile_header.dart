import 'package:flutter/material.dart';
import 'package:Travelon/core/utils/theme/AppTextstyles.dart';

class ProfileHeader extends StatelessWidget {
  final String name;

  const ProfileHeader({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            theme.colorScheme.primary.withOpacity(0.9),
            theme.colorScheme.primaryContainer,
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
              backgroundColor: Colors.white,
              child: Text(
                name.isNotEmpty ? name[0].toUpperCase() : '?',
                style: AppTextStyles.title.copyWith(
                  fontSize: 34,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.primary,
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
              color: Colors.white.withOpacity(0.95),
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
              color: Colors.white.withOpacity(0.75),
              letterSpacing: 0.4,
            ),
          ),
        ],
      ),
    );
  }
}
