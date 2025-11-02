import 'package:Travelon/core/utils/appcolors.dart';
import 'package:Travelon/core/utils/appimageassets.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SecondOnboardingPage extends StatelessWidget {
  const SecondOnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            AppImageAssets().worldmap_lottie,
            height: 450,
            width: 450,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 4.0, right: 4.0),
            child: Text(
              'Design Your Perfect Story',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,

                color: AppColors.textPrimaryDark,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 4.0, right: 4.0),
            child: Text(
              "Uncover hidden gems and create stories that last a lifetime. We handle the complexity, so you can focus on the wonder.",
              textAlign: TextAlign.center,

              style: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondaryGrey,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
