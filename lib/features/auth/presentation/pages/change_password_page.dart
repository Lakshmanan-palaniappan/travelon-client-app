import 'package:Travelon/core/utils/token_storage.dart';
import 'package:Travelon/core/utils/widgets/Flash/ErrorFlash.dart';
import 'package:Travelon/core/utils/widgets/Flash/SuccessFlash.dart';
import 'package:Travelon/core/utils/widgets/Flash/WarningFlash.dart';
import 'package:Travelon/core/utils/widgets/MyElevatedButton.dart';
import 'package:Travelon/core/utils/widgets/MyTextField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Travelon/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:go_router/go_router.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();

  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscureOld = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final touristId = await TokenStorage.getTouristId();

    if (touristId == null) {
      WarningFlash.show(
        context,
        message: "Session expired. Please login again.",
      );
      return;
    }

    context.read<AuthBloc>().add(
      ChangePasswordEvent(
        touristId: touristId,
        oldPassword: _oldPasswordController.text.trim(),
        newPassword: _newPasswordController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Change Password",
          style: TextStyle(color: theme.textTheme.titleLarge?.color),
        ),
        leading: IconButton(
          onPressed: () => context.go('/settings'),
          icon: Icon(Icons.arrow_back_ios,
            color: theme.iconTheme.color,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthPasswordChanged) {
            SuccessFlash.show(
              context,
              message: "Password changed. Please login again.",
            );
            context.go('/login');
          }

          if (state is AuthError) {
            ErrorFlash.show(context, message: state.error);
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔐 Header Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.tertiary.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.lock_reset_rounded,
                        size: 36,
                        color: theme.iconTheme.color,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Update Your Password",
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: theme.textTheme.titleLarge?.color
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "For your security, choose a strong new password.",
                              style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.textTheme.bodyLarge?.color
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // 📦 Form Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: theme.colorScheme.tertiary),
                  ),
                  child: Column(
                    children: [
                      MyTextField(
                        hintText: "Current Password",
                        ctrl: _oldPasswordController,
                        obscure: _obscureOld,
                        required: true,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureOld
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: theme.iconTheme.color,
                          ),
                          onPressed: () {
                            setState(() => _obscureOld = !_obscureOld);
                          },
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Enter current password";
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      MyTextField(
                        hintText: "New Password",
                        ctrl: _newPasswordController,
                        obscure: _obscureNew,
                        required: true,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureNew
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: theme.iconTheme.color,
                          ),
                          onPressed: () {
                            setState(() => _obscureNew = !_obscureNew);
                          },
                        ),
                        validator: (value) {
                          if (value == null || value.length < 6) {
                            return "Password must be at least 6 characters";
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      MyTextField(
                        hintText: "Confirm New Password",
                        ctrl: _confirmPasswordController,
                        obscure: _obscureConfirm,
                        required: true,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirm
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: theme.iconTheme.color,
                          ),
                          onPressed: () {
                            setState(() => _obscureConfirm = !_obscureConfirm);
                          },
                        ),
                        validator: (value) {
                          if (value != _newPasswordController.text) {
                            return "Passwords do not match";
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // 🔘 Submit Button
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    final isLoading = state is AuthLoading;

                    return SizedBox(
                      width: double.infinity,
                      child: MyElevatedButton(
                        text: isLoading ? "Changing..." : "Change Password",
                        onPressed: isLoading ? null : _submit,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
