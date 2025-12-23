import 'package:Travelon/core/utils/widgets/Flash/ErrorFlash.dart';
import 'package:Travelon/core/utils/widgets/Flash/SuccessFlash.dart';
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
        if (state is AuthSuccess) {
          final tourist = state.tourist;
          context.go('/home', extra: tourist);
          // Flushbar(
          //   message: "Login Successful 🎉",
          //   backgroundColor: Colors.green.shade600,
          //   duration: const Duration(seconds: 3),
          //   margin: const EdgeInsets.all(8),
          //   borderRadius: BorderRadius.circular(12),
          //   flushbarPosition: FlushbarPosition.TOP,
          //   icon: const Icon(Icons.check_circle, color: Colors.white),
          // ).show(context);
          SuccessFlash.show(context, message: "Login Successful 🎉");
        } else if (state is AuthError) {
          print(state.error);
          // Flushbar(
          //   message: state.error,
          //   backgroundColor: Colors.red.shade600,
          //   duration: const Duration(seconds: 3),
          //   margin: const EdgeInsets.all(8),
          //   borderRadius: BorderRadius.circular(12),
          //   flushbarPosition: FlushbarPosition.TOP,
          //   icon: const Icon(Icons.error, color: Colors.white),
          // ).show(context);
          ErrorFlash.show(context, message: state.error);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Theme.of(context).colorScheme.background,
            leading: IconButton(
              onPressed: () {
                context.go('/landingpage');
              },
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Theme.of(context).colorScheme.primary,
                size: 35.0,
              ),
            ),
          ),
          backgroundColor: Theme.of(context).colorScheme.background,
          body: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        _welcomeText(context),
                        const SizedBox(height: 20),
                        _buildTextField("Email", "Enter Email", emailCtrl),
                        const SizedBox(height: 10),
                        _buildTextField(
                          "Password",
                          "Enter Password",
                          passCtrl,
                          obscure: true,
                        ),
                        const SizedBox(height: 20),
                        _signinButton(),
                      ],
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: _signUpRedirectText(context),
                    ),
                  ],
                ),
              ),
              if (state is AuthLoading)
                Container(
                  color: Colors.black.withOpacity(
                    0.4,
                  ), // can keep overlay semi-black
                  alignment: Alignment.center,
                  child: const Myloader(),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTextField(
    String title,
    String hintText,
    TextEditingController controller, {
    bool obscure = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium),

        const SizedBox(height: 5.0),
        MyTextField(hintText: hintText, ctrl: controller, obscure: obscure),
      ],
    );
  }

  Widget _signinButton() {
    return MyElevatedButton(
      radius: 50.0,
      text: "Sign in",
      onPressed: () {
        final email = emailCtrl.text.trim();
        final password = passCtrl.text.trim();
        if (email.isEmpty || password.isEmpty) {
          // ErrorFlash(context, "Please Fill All Fields!");
          ErrorFlash.show(context, message: "Please Fill All Fields!");

          return;
        }

        FocusScope.of(context).unfocus();
        context.read<AuthBloc>().add(LoginTouristEvent(email, password));
      },
    );
  }

  Widget _welcomeText(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Welcome Back!", style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 4),
        Text(
          "Login to your verified profile to access",
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _signUpRedirectText(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account? ",
          style: textTheme.bodySmall?.copyWith(
            color: textTheme.bodySmall?.color, // uses theme text color
          ),
        ),
        GestureDetector(
          onTap: () {
            context.go('/register');
          },
          child: Text(
            "Sign up",
            style: textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.primary, // CTA color
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
