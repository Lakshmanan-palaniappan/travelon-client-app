import 'package:Travelon/core/utils/widgets/menuitem.dart';
import 'package:Travelon/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: scheme.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      backgroundColor: scheme.background,
      body: Stack(
        children: [
          // ── HEADER BACKGROUND ──
          Container(
            height: MediaQuery.of(context).size.height * 0.35,
            decoration: BoxDecoration(
              color: scheme.primary,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
            ),
          ),

          // ── CONTENT ──
          SafeArea(
            child: Column(
              children: [
                // ── HEADER CONTENT ──
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
                            backgroundColor: scheme.onPrimary.withOpacity(0.15),
                            child: Text(
                              name.isNotEmpty ? name[0].toUpperCase() : "?",
                              style: theme.textTheme.headlineMedium?.copyWith(
                                color: scheme.onPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 15.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name,
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  color: scheme.onPrimary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              if (contact.isNotEmpty)
                                Text(
                                  contact,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: scheme.onPrimary.withOpacity(0.9),
                                  ),
                                ),
                              if (email.isNotEmpty)
                                Text(
                                  email,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: scheme.onPrimary.withOpacity(0.75),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),

                // ── MENU CARD ──
                Expanded(
                  child: Container(
                    // margin: const EdgeInsets.symmetric(horizontal: 16),
                    // padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: scheme.surface,
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
                      children: [
                        menuItem(
                          context,
                          icon: Icons.home,
                          title: "Home",
                          onTap: () => context.go('/home'),
                        ),
                        menuItem(
                          context,
                          icon: Icons.person_outline,
                          title: "Manage My Profile",
                          onTap: () => context.push('/profile'),
                        ),
                        menuItem(
                          context,
                          icon: Icons.history,
                          title: "Request Trip",
                          onTap: () {
                            context.push('/request');
                          },
                        ),
                        menuItem(
                          context,
                          icon: Icons.card_travel,
                          title: "My Trips",
                          onTap: () {
                            context.push('/trips');
                          },
                        ),

                        menuItem(
                          context,
                          icon: Icons.settings,
                          title: "Settings",
                          onTap: () {
                            context.push('/settings');
                          },
                        ),

                        // const SizedBox(height: 16),

                        // // ── LOGOUT BUTTON ──
                        // Padding(
                        //   padding: const EdgeInsets.symmetric(horizontal: 16),
                        //   child: ElevatedButton.icon(
                        //     style: ElevatedButton.styleFrom(
                        //       backgroundColor: scheme.primary,
                        //       foregroundColor: scheme.onPrimary,
                        //       padding: const EdgeInsets.symmetric(vertical: 14),
                        //       shape: RoundedRectangleBorder(
                        //         borderRadius: BorderRadius.circular(24),
                        //       ),
                        //     ),
                        //     icon: const Icon(Icons.logout),
                        //     label: const Text("Logout"),
                        //     onPressed: () {
                        //       context.read<AuthBloc>().add(LogoutEvent());
                        //     },
                        //   ),
                        // ),

                        // const SizedBox(height: 16),

                        // // ── FOOTER ──
                        // Center(
                        //   child: Text(
                        //     "Version 1.0.0",
                        //     style: theme.textTheme.labelSmall,
                        //   ),
                        // ),
                        // const SizedBox(height: 8),
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
