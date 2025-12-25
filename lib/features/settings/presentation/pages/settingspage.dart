import 'package:Travelon/core/utils/open_url.dart';
import 'package:Travelon/core/widgets/theme_selector_sheet.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:Travelon/core/widgets/settings_section.dart';
import 'package:Travelon/core/widgets/settings_tile.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        title: const Text("Settings"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => context.go('/home'),
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
                  showLicensePage(context: context);
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
                icon: Icons.logout_rounded,
                title: "Logout",
                iconColor: Colors.redAccent,
                onTap: () {
                  // show logout dialog
                },
                trailing: const SizedBox.shrink(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
