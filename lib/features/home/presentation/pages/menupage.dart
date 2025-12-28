import 'package:Travelon/core/utils/widgets/MyElevatedButton.dart';
import 'package:Travelon/core/utils/widgets/menuitem.dart';
import 'package:Travelon/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:Travelon/features/trip/presentation/bloc/trip_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:Travelon/core/utils/theme/AppColors.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  String getInitials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return "?";
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return '${parts.first[0].toUpperCase()}${parts.last[0].toUpperCase()}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final headerBg =
    isDark ? AppColors.primaryDark : AppColors.primaryLight;
    final avatarBg =
    isDark ? AppColors.darkSecondary : AppColors.secondaryLight;
    final textPrimary =
    isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final textSecondary =
    isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
    final surfaceBg =
    isDark ? AppColors.surfaceDark : AppColors.surfaceLight;

    return Scaffold(
      backgroundColor:
      isDark ? AppColors.bgDark : AppColors.bgLight,

      // ── APP BAR ──
      appBar: AppBar(
        backgroundColor: headerBg,
        automaticallyImplyLeading: false,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              Icons.close_rounded,
              size: 28,
              color: avatarBg,
            ),
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go('/home');
              }
            },
          ),
        ],
      ),

      // ── BODY ──
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height.clamp(220, 320),
            decoration: BoxDecoration(
              color: headerBg,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    String name = "Guest";
                    String email = "";
                    String contact = "";

                    if (state is AuthSuccess) {
                      name = state.tourist.name;
                      email = state.tourist.email ?? "";
                      contact = state.tourist.contact;
                    }

                    return Padding(
                      padding: const EdgeInsets.fromLTRB(16, 32, 16, 24),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 36,
                            backgroundColor: avatarBg,
                            child: Text(
                              getInitials(name),
                              style: theme.textTheme.headlineMedium?.copyWith(
                                color: headerBg,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  name,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style:
                                  theme.textTheme.headlineSmall?.copyWith(
                                    color: textPrimary,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                if (contact.isNotEmpty)
                                  Text(
                                    contact,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: textSecondary,
                                    ),
                                  ),
                                if (email.isNotEmpty)
                                  Text(
                                    email,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: textSecondary,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),

                Expanded(
                  child: Container(
                    //margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: surfaceBg,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: ListView(
                      padding: const EdgeInsets.only(bottom: 24),
                      children: [
                        menuItem(context,
                            icon: Icons.home,
                            title: "Home",
                            onTap: () => context.go('/home')),
                        menuItem(context,
                            icon: Icons.person_outline,
                            title: "Manage My Profile",
                            onTap: () => context.push('/profile')),
                        menuItem(context,
                            icon: Icons.history,
                            title: "Request Trip",
                            onTap: () => context.push('/request')),
                        menuItem(context,
                            icon: Icons.card_travel,
                            title: "My Trips",
                            onTap: () => context.push('/trips')),
                        menuItem(context,
                            icon: Icons.settings,
                            title: "Settings",
                            onTap: () => context.push('/settings')),
                        MyElevatedButton(
                          text: "Refresh",
                          onPressed: () {
                            context
                                .read<TripBloc>()
                                .add(FetchCurrentTrip());
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

