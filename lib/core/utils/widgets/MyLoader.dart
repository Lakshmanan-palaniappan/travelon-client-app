import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:Travelon/core/utils/appimageassets.dart';

class Myloader extends StatelessWidget {
  const Myloader({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: 1.0,
      duration: const Duration(milliseconds: 400),
      child: Container(
        color: Colors.black.withOpacity(0.4),
        alignment: Alignment.center,
        child: Lottie.asset(
          AppImageAssets().travelon_lottie,
          width: 200,
          height: 200,
          fit: BoxFit.contain,
          repeat: true,
        ),
      ),
    );
  }
}
