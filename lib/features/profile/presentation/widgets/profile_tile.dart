import 'package:flutter/material.dart';
import 'package:Travelon/core/utils/theme/AppTextstyles.dart';

class ProfileTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const ProfileTile({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      leading: Icon(icon, color: theme.colorScheme.primary),
      title: Text(
        title,
        style: AppTextStyles.body.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        value,
        style: AppTextStyles.body.copyWith(
          color: theme.textTheme.bodyMedium!.color,
        ),
      ),
    );
  }
}
