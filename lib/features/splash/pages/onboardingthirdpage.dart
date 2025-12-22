import 'package:Travelon/core/utils/appimageassets.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ThirdOnboardingPage extends StatelessWidget {
  const ThirdOnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: colors.background,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          /// --- Animation ---
          Lottie.asset(AppImageAssets().planning_man_lottie, height: 420),

          const SizedBox(height: 24),

          /// --- Title ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Support, Wherever You Go',
              textAlign: TextAlign.center,
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: colors.onBackground,
              ),
            ),
          ),

          const SizedBox(height: 12),

          /// --- Description ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              "Travel with the assurance of dedicated 24/7 support.\n"
              "Your next great adventure is just a reliable click away.",
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium?.copyWith(
                color: colors.onBackground.withOpacity(0.7),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
