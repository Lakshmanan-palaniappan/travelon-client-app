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
      appBar: AppBar(title: const Text("Change Password"), centerTitle: true),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthPasswordChanged) {
            // ScaffoldMessenger.of(
            //   context,
            // ).showSnackBar(SnackBar(content: Text(state.message)));
            SuccessFlash.show(
              context,
              message: "Password changed. Please login again.",
            );
            context.go('/login');
          }

          if (state is AuthError) {
            // ScaffoldMessenger.of(
            //   context,
            // ).showSnackBar(SnackBar(content: Text(state.error)));
            ErrorFlash.show(context, message: state.error);
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                MyTextField(
                  hintText: "Current Password",
                  ctrl: _oldPasswordController,
                  obscure: true,
                  required: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Enter current password";
                    }
                    return null;
                  },
                ),

                MyTextField(
                  hintText: "New Password",
                  ctrl: _newPasswordController,
                  obscure: true,
                  required: true,
                  validator: (value) {
                    if (value == null || value.length < 6) {
                      return "Password must be at least 6 characters";
                    }
                    return null;
                  },
                ),

                MyTextField(
                  hintText: "Confirm New Password",
                  ctrl: _confirmPasswordController,
                  obscure: true,
                  required: true,
                  validator: (value) {
                    if (value != _newPasswordController.text) {
                      return "Passwords do not match";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 32),

                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    final isLoading = state is AuthLoading;

                    return MyElevatedButton(
                      text: "Change Password",
                      onPressed: isLoading ? null : _submit,
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
