import 'package:Travelon/core/utils/appimageassets.dart';
import 'package:Travelon/core/utils/widgets/MyElevatedButton.dart';
import 'package:Travelon/core/utils/widgets/MyOutlineButton.dart';
import 'package:Travelon/core/utils/theme/AppColors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnim = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textTheme = theme.textTheme;
    final size = MediaQuery.of(context).size;

    /// ── YOUR COLORS (SYSTEM THEME AWARE) ──
    final bg = isDark ? AppColors.bgDark : AppColors.bgLight;
    final primary = isDark ? AppColors.primaryDark : AppColors.primaryLight;
    final textSecondary =
         AppColors.MenuButton;

    return Scaffold(
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnim,
          child: Container(
            width: double.infinity,
            height: double.infinity,

            /// 🎨 FIXED gradient (visible in dark mode)
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

            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Spacer(),

                  /// 🟢 Lottie Animation
                  Lottie.asset(
                    AppImageAssets().register_lottie,
                    width: size.width * 0.75,
                    height: size.width * 0.75,
                  ),

                  const SizedBox(height: 24),

                  /// 🟢 Text Section
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Welcome to Travelon",
                        textAlign: TextAlign.center,
                        style: textTheme.headlineLarge?.copyWith(
                          color: primary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Plan smarter. Travel better.",
                        textAlign: TextAlign.center,
                        style: textTheme.titleLarge?.copyWith(
                          color: primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Your trusted travel companion for organizing trips, managing itineraries, and exploring the world effortlessly.",
                        textAlign: TextAlign.center,
                        style: textTheme.bodyMedium?.copyWith(
                          color: textSecondary,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),

                  /// 🟢 Register Button
                  MyElevatedButton(
                    radius: 50,
                    text: "Register",
                    color: AppColors.secondaryDarkMode,
                    onPressed: () => context.go('/register'),
                  ),

                  const SizedBox(height: 16),

                  /// 🟢 Login Button
                  MyOutlinedButton(
                    text: "Login",
                    textColor: AppColors.surfaceLight,
                    borderColor: primary,
                    onPressed: () => context.go('/login'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
