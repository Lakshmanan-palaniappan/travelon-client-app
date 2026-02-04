import 'package:Travelon/core/utils/open_url.dart';
import 'package:Travelon/core/widgets/theme_selector_sheet.dart';
import 'package:Travelon/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:Travelon/core/widgets/settings_section.dart';
import 'package:Travelon/core/widgets/settings_tile.dart';

import '../../../../core/utils/theme/AppColors.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.bgDark : AppColors.bgLight,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.bgDark : AppColors.bgLight,
        title: Text(
          "Settings",
          style: TextStyle(
            color: theme.textTheme.titleLarge?.color,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: theme.iconTheme.color,
          ),
          onPressed: () => context.go('/menu'),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 32),
        children: [
          // ───── APP ─────
          SettingsSection(
            title: "App",
            children: [
              SettingsTile(
                icon: Icons.palette_outlined,
                title: "Theme",
                subtitle: "Light / Dark / System",
                onTap: () {
                  showThemeSelector(context);
                },
              ),
              // SettingsTile(
              //   icon: Icons.notifications_outlined,
              //   title: "Notifications",
              //   subtitle: "Manage alerts",
              //   onTap: () {},
              // ),
            ],
          ),

          // ───── LEGAL ─────
          SettingsSection(
            title: "Legal",
            children: [
              SettingsTile(
                icon: Icons.description_outlined,
                title: "Privacy Policy",
                onTap: () {
                  openUrl("https://yourdomain.com/privacy");
                },
              ),

              SettingsTile(
                icon: Icons.gavel_outlined,
                title: "Terms & Conditions",
                onTap: () {
                  openUrl("https://yourdomain.com/terms");
                },
              ),

              SettingsTile(
                icon: Icons.verified_outlined,
                title: "Licenses",
                onTap: () {
                  context.go('/settings/license');
                },
              ),
            ],
          ),

          // ───── ACCOUNT ─────
          SettingsSection(
            title: "Account",

            children: [
              SettingsTile(
                icon: Icons.lock_outline,
                title: "Change Password",
                onTap: () {
                  // open reusable password dialog
                  context.push('/change-password');
                },
              ),
              SettingsTile(
                iconbg: AppColors.error,
                icon: Icons.logout_rounded,
                title: "Logout",
                iconColor: AppColors.bgDark,
                onTap: () {
                  // show logout dialog
                  _confirmLogout(context);
                },
                trailing: const SizedBox.shrink(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<bool> _confirmLogout(BuildContext context) async {
    final authBloc = context.read<AuthBloc>();
    final theme = Theme.of(context);

    return await showDialog<bool>(
          context: context,
          builder:
              (_) => AlertDialog(
                backgroundColor: theme.colorScheme.surfaceBright,
                title: Text(
                  'Logout',
                  style: TextStyle(color: theme.textTheme.titleLarge?.color),
                ),
                content: Text(
                  'Are you sure you want to log out?',
                  style: TextStyle(color: theme.textTheme.bodyMedium?.color),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: AppColors.success,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.error
                    ),
                    onPressed: () {
                      authBloc.add(LogoutEvent());
                      context.go('/login');
                    },
                    child: Text('Logout',
                      style: TextStyle(
                          color: theme.textTheme.bodyMedium?.color
                      ),
                    ),
                  ),
                ],
              ),
        ) ??
        false;
  }
}
