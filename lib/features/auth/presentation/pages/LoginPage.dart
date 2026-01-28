import 'package:Travelon/core/utils/widgets/Flash/ErrorFlash.dart';
import 'package:Travelon/core/utils/widgets/Flash/SuccessFlash.dart';
import 'package:Travelon/core/utils/widgets/MyElevatedButton.dart';
import 'package:Travelon/core/utils/widgets/MyLoader.dart';
import 'package:Travelon/core/utils/widgets/MyTextField.dart';
import 'package:Travelon/core/utils/theme/AppColors.dart';
import 'package:flutter/material.dart';
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

    /// ── SAME COLOR PATTERN AS LANDING PAGE ──
    final bg =AppColors.bgDark;
    final primary =  AppColors.primaryDark;
    final textSecondary =
         AppColors.MenuButton;

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          context.go('/home', extra: state.tourist);
          SuccessFlash.show(context, message: "Login Successful");
        } else if (state is AuthError) {
          ErrorFlash.show(context, message: state.error);
        }
      },
      builder: (context, state) {
        return Scaffold(
          extendBodyBehindAppBar: true, // ⭐ KEY FIX
          backgroundColor: bg,

          /// ── APP BAR FLOATS ON GRADIENT ──
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            leading: IconButton(
              onPressed: () => context.go('/landingpage'),
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: primary,
                size: 30,
              ),
            ),
          ),

          /// ── FULL BACKGROUND (APPBAR + BODY)
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  primary.withOpacity(isDark ? 0.28 : 0.15),
                  bg,
                ],
              ),
            ),
            child: SafeArea(
              child: Stack(
                children: [
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(24.0),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight:
                            size.height - MediaQuery.of(context).padding.top,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 20),

                              _welcomeText(primary, textSecondary),

                              const SizedBox(height: 20),

                              _buildTextField(
                                
                                  "Email", "Enter Email", emailCtrl),

                              const SizedBox(height: 10),

                              _buildTextField(
                                "Password",
                                "Enter Password",
                                passCtrl,
                                obscure: true,
                              ),

                              const SizedBox(height: 6),

                              _forgotPassword(primary),

                              const SizedBox(height: 20),

                              _signinButton(AppColors.secondaryDarkMode),
                            ],
                          ),

                          Align(
                            alignment: Alignment.bottomCenter,
                            child: _signUpRedirectText(primary),
                          ),
                        ],
                      ),
                    ),
                  ),

                  /// ── LOADER OVERLAY
                  if (state is AuthLoading)
                    Container(
                      color: Colors.black.withOpacity(0.4),
                      alignment: Alignment.center,
                      child: const Myloader(),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ─────────────────────────────────────────────

  Widget _forgotPassword(Color primary) {
    return Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onTap: () => _showForgotPasswordDialog(context),
        child: Text(
          "Forgot password?",
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: primary,
                fontWeight: FontWeight.w600,
              ),
        ),
      ),
    );
  }

  void _showForgotPasswordDialog(BuildContext context) {
    final emailController = TextEditingController();
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          backgroundColor:
              isDark ? AppColors.surfaceLight : AppColors.surfaceDark,
          title: Text(
            "Reset Password",
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.surfaceDark : AppColors.Light,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Enter your registered email address",
                style: theme.textTheme.bodySmall?.copyWith(
                  color: isDark ? AppColors.surfaceDark : AppColors.Light,
                ),
                
              ),
              const SizedBox(height: 16),
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: "Email",
                  prefixIcon: const Icon(Icons.email_outlined),
                  filled: true,
                  fillColor:
                      isDark ? AppColors.surfaceLight : AppColors.surfaceDark,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    
                    
                  ),
                ),
              ),
            ],
          ),
          actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child:Text("Cancel",style: TextStyle(color:AppColors.errorDarkMode),),
            ),
            ElevatedButton(
              onPressed: () {
                final email = emailController.text.trim();
                if (email.isEmpty) {
                  ErrorFlash.show(context, message: "Please enter your email");
                  return;
                }
                context
                    .read<AuthBloc>()
                    .add(ForgotPasswordEvent(email));
                Navigator.pop(context);
              },
              child:  Text("Send Link",style: TextStyle(color:AppColors.secondaryDarkMode),),
            ),
          ],
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
        Text(title, style: TextStyle(color:AppColors.Light)),
        const SizedBox(height: 5),
        MyTextField(
          hintText: hintText,
          ctrl: controller,
          obscure: obscure,
          
        ),
      ],
    );
  }

  Widget _signinButton(Color primary) {
    return MyElevatedButton(
      radius: 50,
      text: "Sign in",
      color: primary,
      onPressed: () {
        final email = emailCtrl.text.trim();
        final password = passCtrl.text.trim();

        if (email.isEmpty || password.isEmpty) {
          ErrorFlash.show(context, message: "Please Fill All Fields!");
          return;
        }

        FocusScope.of(context).unfocus();
        context.read<AuthBloc>().add(
              LoginTouristEvent(email, password),
            );
      },
    );
  }

  Widget _welcomeText(Color primary, Color textSecondary) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Welcome Back!",
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(color: primary),
        ),
        const SizedBox(height: 4),
        Text(
          "Login to your verified profile to access",
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: textSecondary),
        ),
      ],
    );
  }

  Widget _signUpRedirectText(Color primary) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Don't have an account? ", style: textTheme.bodySmall),
        GestureDetector(
          onTap: () => context.go('/register'),
          child: Text(
            "Sign up",
            style: textTheme.bodySmall?.copyWith(
              color: primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
