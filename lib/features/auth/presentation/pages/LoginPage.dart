import 'package:Travelon/core/utils/appcolors.dart';
import 'package:Travelon/core/utils/widgets/MyElevatedButton.dart';
import 'package:Travelon/core/utils/widgets/MyLoader.dart';
import 'package:Travelon/core/utils/widgets/MyTextField.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/auth_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  @override
  void dispose() {
    emailCtrl.dispose();
    passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          context.go('/home');
          Flushbar(
            message: "Login Successful 🎉",
            backgroundColor: Colors.green.shade600,
            duration: const Duration(seconds: 3),
            margin: const EdgeInsets.all(8),
            borderRadius: BorderRadius.circular(12),
            flushbarPosition: FlushbarPosition.TOP,
            icon: const Icon(Icons.check_circle, color: Colors.white),
          ).show(context);
        } else if (state is AuthError) {
          Flushbar(
            message: state.error,
            backgroundColor: Colors.red.shade600,
            duration: const Duration(seconds: 3),
            margin: const EdgeInsets.all(8),
            borderRadius: BorderRadius.circular(12),
            flushbarPosition: FlushbarPosition.TOP,
            icon: const Icon(Icons.error, color: Colors.white),
          ).show(context);
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.backgroundLight,
          body: Stack(
            children: [
              Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MyTextField(
                        hintText: "Enter Email",
                        labelText: "Email",
                        ctrl: emailCtrl,
                      ),
                      MyTextField(
                        hintText: "Enter Password",
                        labelText: "Password",
                        ctrl: passCtrl,
                        obscure: true,
                      ),
                      const SizedBox(height: 20),
                      Myelevatedbutton(
                        show_text: "Login",
                        onPressed: () {
                          final email = emailCtrl.text.trim();
                          final password = passCtrl.text.trim();

                          if (email.isEmpty || password.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Please fill all fields"),
                              ),
                            );
                            return;
                          }

                          // ✅ Hide keyboard properly
                          FocusScope.of(context).unfocus();

                          context.read<AuthBloc>().add(
                            LoginTouristEvent(email, password),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),

              if (state is AuthLoading)
                Container(
                  color: Colors.black.withOpacity(0.4),
                  alignment: Alignment.center,
                  child: const Myloader(),
                ),
            ],
          ),
        );
      },
    );
  }
}
