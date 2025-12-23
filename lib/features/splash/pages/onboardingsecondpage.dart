import 'package:Travelon/core/utils/appimageassets.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SecondOnboardingPage extends StatelessWidget {
  const SecondOnboardingPage({super.key});

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
          Lottie.asset(
            AppImageAssets().worldmap_lottie,
            height: 420,
          ),

          const SizedBox(height: 24),

          /// --- Title ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Design Your Perfect Story',
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
              "Uncover hidden gems and create stories that last a lifetime. "
              "We handle the complexity, so you can focus on the wonder.",
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
