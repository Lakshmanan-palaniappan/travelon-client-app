import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Travelon/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:Travelon/core/utils/theme/AppColors.dart';
import 'package:Travelon/core/utils/theme/AppTextstyles.dart';
import 'package:go_router/go_router.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        leading: IconButton(
          onPressed: () {
            context.go('/home');
          },
          icon: Icon(Icons.arrow_back_ios_rounded),
        ),
        centerTitle: true,
        backgroundColor: theme.colorScheme.surface,
        foregroundColor: theme.colorScheme.onSurface,
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
                  // ===== Avatar & Name =====
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color:
                              theme.brightness == Brightness.light
                                  ? Colors.black12
                                  : Colors.black45,
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: theme.colorScheme.primary
                              .withOpacity(0.1),
                          child: Text(
                            tourist.name.isNotEmpty
                                ? tourist.name[0].toUpperCase()
                                : '?',
                            style: AppTextStyles.title.copyWith(
                              fontSize: 40,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          tourist.name,
                          style: AppTextStyles.title.copyWith(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: theme.textTheme.titleLarge!.color,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ===== Profile Info Card =====
                  Card(
                    color: theme.colorScheme.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          ProfileItem(title: "Email", value: tourist.email),
                          Divider(color: theme.dividerColor),
                          ProfileItem(title: "Contact", value: tourist.contact),
                          Divider(color: theme.dividerColor),
                          ProfileItem(
                            title: "Nationality",
                            value: tourist.nationality,
                          ),
                          Divider(color: theme.dividerColor),
                          ProfileItem(title: "Gender", value: tourist.gender),
                          Divider(color: theme.dividerColor),
                          ProfileItem(title: "Address", value: tourist.address),
                          Divider(color: theme.dividerColor),
                          ProfileItem(
                            title: "Agency ID",
                            value: tourist.agencyId.toString(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return Center(
            child: Text(
              "No tourist data found.",
              style: theme.textTheme.bodyLarge,
            ),
          );
        },
      ),
    );
  }
}

class ProfileItem extends StatelessWidget {
  final String title;
  final String value;

  const ProfileItem({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$title: ",
            style: AppTextStyles.body.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.textTheme.bodyLarge!.color,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.body.copyWith(
                color: theme.textTheme.bodyMedium!.color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
