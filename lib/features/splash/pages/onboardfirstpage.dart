import 'package:Travelon/core/utils/appimageassets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';

class FirstOnboardingPage extends StatelessWidget {
  const FirstOnboardingPage({super.key});

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
          /// --- Illustration ---
          Stack(
            alignment: Alignment.center,
            children: [
              SvgPicture.asset(
                AppImageAssets().blob_svg,
                height: 450,
                width: 450,
              ),
              Lottie.asset(
                AppImageAssets().travel_lottie,
                height: 350,
              ),
            ],
          ),

          const SizedBox(height: 24),

          /// --- Title ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Explore the World With Trust',
              textAlign: TextAlign.center,
              style: textTheme.titleLarge?.copyWith(
                color: colors.onBackground,
              ),
            ),
          ),

          const SizedBox(height: 12),

          /// --- Description ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Your journey is our priority. Discover curated trips and book with confidence, backed by our promise of reliability.',
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium?.copyWith(
                height: 1.5,
                color: colors.onBackground.withOpacity(0.7),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
