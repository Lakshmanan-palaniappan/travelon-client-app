import 'package:Travelon/core/utils/theme/AppColors.dart';
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
    final isDark=theme.brightness==Brightness.dark;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      leading: Icon(icon, color: isDark?AppColors.primaryDark:AppColors.primaryLight),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: AppColors.primaryDarkMode
        ),
      ),
      subtitle: Text(
        value,
        style: AppTextStyles.body.copyWith(
          color: isDark?AppColors.Light:AppColors.Dark,
        ),
      ),
    );
  }
}
