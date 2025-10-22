import 'package:flutter/material.dart';

import '../appcolors.dart';

class Myelevatedbutton extends StatelessWidget {
  final String show_text;
  final double width, height;
  final VoidCallback onPressed;
  const Myelevatedbutton({
    super.key,
    required this.show_text,
    required this.onPressed,
    this.width = 350.0,
    this.height = 50.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 350,
      height: 50.0,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.secondaryLightBlue,
          foregroundColor: AppColors.surfaceWhite,
          textStyle: TextStyle(fontSize: 20.0),
        ),
        child: Text(show_text),
      ),
    );
  }
}
