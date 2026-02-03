import 'package:Travelon/core/utils/theme/AppColors.dart';
import 'package:Travelon/core/utils/widgets/MyLoader.dart';
import 'package:Travelon/features/auth/domain/entities/tourist.dart';
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
    final isDark=theme.brightness==Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text("Profile",style: TextStyle(
          color: theme.textTheme.titleLarge?.color,
        ),),

        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
            color: theme.iconTheme.color,
          onPressed: () => context.go('/menu'),
        ),
        actions: [ 
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is AuthSuccess) {
                return IconButton(
                  icon: const Icon(Icons.mode_edit_rounded),
                  color: theme.iconTheme.color,
                  onPressed: () =>
                      _showEditProfileDialog(context, state.tourist),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],

      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Center(child: Myloader());
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

  void _showEditProfileDialog(BuildContext context, Tourist tourist) {
    final email = TextEditingController(text: tourist.email);
    final contact = TextEditingController(text: tourist.contact);
    final address = TextEditingController(text: tourist.address);
    final nationality = TextEditingController(text: tourist.nationality);

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Edit Profile"),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: email,
                    decoration: const InputDecoration(labelText: "Email"),
                  ),
                  TextField(
                    controller: contact,
                    decoration: const InputDecoration(labelText: "Contact"),
                  ),
                  TextField(
                    controller: address,
                    decoration: const InputDecoration(labelText: "Address"),
                  ),
                  TextField(
                    controller: nationality,
                    decoration: const InputDecoration(labelText: "Nationality"),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () {
                  context.read<AuthBloc>().add(
                    UpdateProfileEvent(
                      touristId: tourist.id!,
                      data: {
                        "Email": email.text.trim(),
                        "Contact": contact.text.trim(),
                        "Address": address.text.trim(),
                        "Nationality": nationality.text.trim(),
                      },
                    ),
                  );

                  Navigator.pop(context);
                },
                child: const Text("Save"),
              ),
            ],
          ),
    );
  }
}
