import 'package:Travelon/core/utils/appcolors.dart';
import 'package:Travelon/core/utils/widgets/ErrorCard.dart';
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
          appBar: AppBar(
            elevation: 0,
            backgroundColor: AppColors.backgroundLight,
            leading: IconButton(
              onPressed: () {
                context.go('/landingpage');
              },
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: AppColors.primaryBlue,
                size: 35.0,
              ),
            ),
          ),
          backgroundColor: AppColors.backgroundLight,
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
                        _welcomeText(),
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
                      child: _signUpRedirectText(context),
                      alignment: AlignmentGeometry.bottomCenter,
                    ),
                  ],
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

  Widget _buildTextField(
    String title,
    String hintText,
    TextEditingController controller, {
    bool obscure = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimaryDark,
          ),
        ),
        const SizedBox(height: 5.0),
        MyTextField(hintText: hintText, ctrl: controller, obscure: obscure),
      ],
    );
  }

  Widget _signinButton() {
    return Myelevatedbutton(
      radius: 50.0,
      show_text: "Sign in",
      onPressed: () {
        final email = emailCtrl.text.trim();
        final password = passCtrl.text.trim();
        if (email.isEmpty || password.isEmpty) {
          showErrorFlash(context, "PleaseFill All Fields!");
          return;
        }

        FocusScope.of(context).unfocus();
        context.read<AuthBloc>().add(LoginTouristEvent(email, password));
      },
    );
  }

  Widget _welcomeText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Welcome Back!",
          style: TextStyle(fontSize: 25.0, color: AppColors.textPrimaryDark),
        ),
        Text(
          "Login to your verified profile to access",
          style: TextStyle(color: AppColors.textSecondaryGrey),
        ),
      ],
    );
  }

  Widget _signUpRedirectText(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Don't have an account? ",
          style: TextStyle(color: AppColors.textPrimaryDark),
        ),
        GestureDetector(
          onTap: () {
            context.go('/register');
          },
          child: Text(
            "Sign up",
            style: TextStyle(
              color: AppColors.primaryBlue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
