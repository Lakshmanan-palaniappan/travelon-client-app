import 'package:Travelon/core/utils/appcolors.dart';
import 'package:Travelon/core/utils/appimageassets.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FirstOnboardingPage extends StatefulWidget {
  const FirstOnboardingPage({super.key});

  @override
  State<FirstOnboardingPage> createState() => _FirstOnboardingPageState();
}

class _FirstOnboardingPageState extends State<FirstOnboardingPage> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            children: [
              SvgPicture.asset(
                AppImageAssets().blob_svg,
                height: 450,
                width: 450,
              ),
              Center(
                child: Lottie.asset(
                  AppImageAssets().travel_lottie,
                  height: 350.0,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 4.0, right: 4.0),
            child: Text(
              'Explore the World With Trust',
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
              'Your journey is our priority. Discover curated trips and book with confidence, backed by our promise of reliability.',
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
