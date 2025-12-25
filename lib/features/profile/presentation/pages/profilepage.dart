import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:Travelon/features/auth/presentation/bloc/auth_bloc.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_tile.dart';
import '../widgets/profile_section.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => context.go('/home'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.mode_edit_rounded),
            onPressed: () {},
          ),
        ],
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is AuthSuccess) {
            final tourist = state.tourist;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  /// HEADER
                  ProfileHeader(name: tourist.name),

                  const SizedBox(height: 20),

                  /// INFO SECTION
                  ProfileSection(
                    children: [
                      ProfileTile(
                        icon: Icons.email_outlined,
                        title: "Email",
                        value: tourist.email,
                      ),
                      ProfileTile(
                        icon: Icons.phone_outlined,
                        title: "Contact",
                        value: tourist.contact,
                      ),
                      ProfileTile(
                        icon: Icons.flag_outlined,
                        title: "Nationality",
                        value: tourist.nationality,
                      ),
                      ProfileTile(
                        icon: Icons.person_outline,
                        title: "Gender",
                        value: tourist.gender,
                      ),
                      ProfileTile(
                        icon: Icons.location_on_outlined,
                        title: "Address",
                        value: tourist.address,
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  /// ACTIONS
                  // ProfileSection(
                  //   children: [
                  //     ListTile(
                  //       leading: const Icon(Icons.lock_outline),
                  //       title: const Text("Change Password"),
                  //       trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  //       onTap: () {
                  //         // open reusable alert dialog here
                  //       },
                  //     ),
                  //     ListTile(
                  //       leading: Icon(
                  //         Icons.logout,
                  //         color: theme.colorScheme.error,
                  //       ),
                  //       title: Text(
                  //         "Logout",
                  //         style: TextStyle(color: theme.colorScheme.error),
                  //       ),
                  //       onTap: () {
                  //         context.read<AuthBloc>().add(LogoutEvent());
                  //       },
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            );
          }

          return const Center(child: Text("No profile data"));
        },
      ),
    );
  }
}
