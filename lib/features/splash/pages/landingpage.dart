import 'package:Travelon/core/utils/appcolors.dart';
import 'package:Travelon/core/utils/widgets/MyElevatedButton.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

import '../../../core/utils/appimageassets.dart';

class Landingpage extends StatelessWidget {
  const Landingpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Padding(
        padding: const EdgeInsets.all(55.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Lottie.asset(
            //   AppImageAssets().register_lottie,
            //   width: 250,
            //   height: 250,
            // ),
            Myelevatedbutton(
              show_text: "Register",
              onPressed: () {
                context.go('/register');
              },
            ),
            SizedBox(height: 35.0),
            Myelevatedbutton(show_text: "Login", onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
