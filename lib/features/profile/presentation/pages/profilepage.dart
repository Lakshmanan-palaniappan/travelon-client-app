import 'package:Travelon/core/utils/theme/AppColors.dart';
import 'package:Travelon/core/utils/widgets/MyLoader.dart';
import 'package:Travelon/features/auth/domain/entities/tourist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:Travelon/features/auth/presentation/bloc/auth_bloc.dart';
import '../../../../core/utils/widgets/Flash/SuccessFlash.dart';
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
    final theme = Theme.of(context);

    final nameCtrl = TextEditingController(text: tourist.name);
    final emailCtrl = TextEditingController(text: tourist.email);
    final contactCtrl = TextEditingController(text: tourist.contact);
    final nationalityCtrl = TextEditingController(text: tourist.nationality);
    final addressCtrl = TextEditingController(text: tourist.address);

    final formKey = GlobalKey<FormState>();
    bool hasChanges = false;

    bool isValidEmail(String email) {
      final regex = RegExp(r'^[\w\.\-]+@([\w\-]+\.)+[a-zA-Z]{2,}$');
      return regex.hasMatch(email);
    }

    bool isValidName(String name) {
      final regex = RegExp(r'^[a-zA-Z ]{3,50}$');
      return regex.hasMatch(name);
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black54,
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.9,   // ✅ almost full screen
          minChildSize: 0.6,
          maxChildSize: 0.98,      // ✅ near full screen
          expand: false,
          builder: (context, scrollController) {
            return StatefulBuilder(
              builder: (context, setSheetState) {
                void checkChanges() {
                  final changed =
                      nameCtrl.text.trim() != (tourist.name ?? "") ||
                          emailCtrl.text.trim() != (tourist.email ?? "") ||
                          addressCtrl.text.trim() != (tourist.address ?? "");

                  if (changed != hasChanges) {
                    setSheetState(() => hasChanges = changed);
                  }
                }

                final bottomInset = MediaQuery.of(context).viewInsets.bottom;

                return AnimatedPadding(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOutCubic,
                  padding: EdgeInsets.only(bottom: bottomInset),
                  child: Container(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(24)),
                    ),
                    child: SafeArea(
                      top: false,
                      child: Column(
                        children: [
                          // ── Drag handle
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Container(
                              width: 40,
                              height: 4,
                              decoration: BoxDecoration(
                                color: theme.colorScheme.tertiary,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),

                          Text(
                            "Edit Profile",
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 8),

                          // ─────────────── BODY (SCROLLABLE) ───────────────
                          Expanded(
                            child: Form(
                              key: formKey,
                              child: ListView(
                                controller: scrollController,
                                padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                                children: [
                                  _editableFormField(
                                    theme: theme,
                                    controller: nameCtrl,
                                    label: "Name",
                                    icon: Icons.person_outline,
                                    onChanged: (_) => checkChanges(),
                                    validator: (v) {
                                      if (v == null || v.trim().isEmpty) {
                                        return "Name is required";
                                      }
                                      if (!isValidName(v.trim())) {
                                        return "3–50 letters only (no numbers/symbols)";
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 12),

                                  _editableFormField(
                                    theme: theme,
                                    controller: emailCtrl,
                                    label: "Email",
                                    icon: Icons.email_outlined,
                                    keyboardType: TextInputType.emailAddress,
                                    onChanged: (_) => checkChanges(),
                                    validator: (v) {
                                      if (v == null || v.trim().isEmpty) {
                                        return "Email is required";
                                      }
                                      if (!isValidEmail(v.trim())) {
                                        return "Enter a valid email address";
                                      }
                                      return null;
                                    },
                                    helperText:
                                    "Changing email may require OTP verification",
                                  ),
                                  const SizedBox(height: 12),

                                  _readOnlyField(
                                    theme: theme,
                                    controller: contactCtrl,
                                    label: "Contact",
                                    icon: Icons.phone_outlined,
                                    helperText: "Change via OTP verification",
                                  ),
                                  const SizedBox(height: 12),

                                  _readOnlyField(
                                    theme: theme,
                                    controller: nationalityCtrl,
                                    label: "Nationality",
                                    icon: Icons.flag_outlined,
                                    helperText:
                                    "Nationality can only be set during registration",
                                  ),
                                  const SizedBox(height: 12),

                                  _editableFormField(
                                    theme: theme,
                                    controller: addressCtrl,
                                    label: "Address",
                                    icon: Icons.location_on_outlined,
                                    onChanged: (_) => checkChanges(),
                                    validator: (v) {
                                      if (v == null || v.trim().isEmpty) {
                                        return "Address is required";
                                      }
                                      if (v.trim().length < 5) {
                                        return "Address is too short";
                                      }
                                      return null;
                                    },
                                  ),

                                  const SizedBox(height: 120), // space for footer
                                ],
                              ),
                            ),
                          ),

                          // ─────────────── FIXED FOOTER ───────────────
                          Container(
                            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surface,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.08),
                                  blurRadius: 10,
                                  offset: const Offset(0, -2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () => Navigator.pop(context),
                                    style: OutlinedButton.styleFrom(
                                      backgroundColor: theme.brightness==Brightness.dark?AppColors.darkUtilSecondary:AppColors.bgLight,
                                      padding:
                                      const EdgeInsets.symmetric(vertical: 14),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                    ),
                                    child: Text("Cancel",style: TextStyle(
                                      color: AppColors.bgDark
                                    ),),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: hasChanges
                                        ? () {
                                      if (!formKey.currentState!.validate()) {
                                        return;
                                      }

                                      context.read<AuthBloc>().add(
                                        UpdateProfileEvent(
                                          touristId: tourist.id!,
                                          data: {
                                            "Name": nameCtrl.text.trim(),
                                            "Email": emailCtrl.text.trim(),
                                            "Address": addressCtrl.text.trim(),
                                          },
                                        ),
                                      );

                                      Navigator.pop(context);

                                      SuccessFlash.show(
                                        context,
                                        message:
                                        "Profile updated successfully",
                                        title: "Success",
                                      );
                                    }
                                        : null,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                      theme.colorScheme.tertiary,
                                      foregroundColor:
                                      theme.colorScheme.onTertiary,
                                      padding:
                                      const EdgeInsets.symmetric(vertical: 14),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                    ),
                                    child: const Text(
                                      "Update",
                                      style:
                                      TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }


  Widget _readOnlyField({
    required ThemeData theme,
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? helperText,
  }) {
    return TextField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        helperText: helperText,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: theme.colorScheme.secondary.withOpacity(0.08),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _editableFormField({
    required ThemeData theme,
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? helperText,
    required ValueChanged<String> onChanged,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      onChanged: onChanged,
      validator: validator,
      scrollPadding: const EdgeInsets.only(bottom: 120), // ✅ keeps field visible
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: theme.textTheme.titleLarge?.color
        ),
        helperText: helperText,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: theme.colorScheme.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: theme.colorScheme.onTertiary
          )
        ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                  color: theme.colorScheme.tertiary
              )
          )
      ),
    );
  }







}
