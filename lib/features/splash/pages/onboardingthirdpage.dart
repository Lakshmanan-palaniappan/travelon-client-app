import 'package:Travelon/core/utils/appcolors.dart';
import 'package:Travelon/core/utils/appimageassets.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ThirdOnboardingPage extends StatelessWidget {
  const ThirdOnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            children: [
              Center(
                child: Lottie.asset(
                  AppImageAssets().planning_man_lottie,
                  height: 450,
                  width: 450,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 4.0, right: 4.0),
            child: Text(
              'Support, Wherever You Go',
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
              "Travel with the assurance of dedicated 24/7 support.\n Your next great adventure is just a reliable click away.",
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
