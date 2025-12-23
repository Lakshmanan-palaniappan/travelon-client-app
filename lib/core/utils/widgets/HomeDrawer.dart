import 'package:Travelon/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Drawer(
      backgroundColor: scheme.surface,
      child: Column(
        children: [
          // ── Header ──
          DrawerHeader(
            decoration: BoxDecoration(color: scheme.primary),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                "Travelon",
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: scheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // ── Menu Items ──
          _drawerItem(
            context,
            icon: Icons.home,
            title: "Home",
            onTap: () => Navigator.pop(context),
          ),
          _drawerItem(
            context,
            icon: Icons.person_2_rounded,
            title: "My Profile",
            onTap: () {},
          ),

          _drawerItem(
            context,
            icon: Icons.history,
            title: "My Requests",
            onTap: () {},
          ),
          _drawerItem(
            context,
            icon: Icons.card_travel,
            title: "My Trips",
            onTap: () {},
          ),

          _drawerItem(
            context,
            icon: Icons.settings,
            title: "Settings",
            onTap: () {},
          ),

          const Spacer(),

          _drawerItem(
            context,
            icon: Icons.logout,
            title: "Logout",
            onTap: () {
              _confirmLogout(context);
            },
            isDestructive: true,
          ),
        ],
      ),
    );
  }

  Future<bool> _confirmLogout(BuildContext context) async {
    final authBloc = context.read<AuthBloc>();

    return await showDialog<bool>(
          context: context,
          builder:
              (_) => AlertDialog(
                title: const Text('Logout'),
                content: const Text('Are you sure you want to log out?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      authBloc.add(LogoutEvent());
                      context.go('/login');
                    },
                    child: const Text('Logout'),
                  ),
                ],
              ),
        ) ??
        false;
  }

  Widget _drawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    final scheme = Theme.of(context).colorScheme;

    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive ? scheme.error : scheme.onSurface,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isDestructive ? scheme.error : scheme.onSurface,
        ),
      ),
      onTap: onTap,
    );
  }
}
