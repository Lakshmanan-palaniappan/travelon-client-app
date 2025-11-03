import 'package:flutter/material.dart';
import '../appcolors.dart';

class Myelevatedbutton extends StatelessWidget {
  final String show_text;
  final double width, height, radius;
  final VoidCallback onPressed;

  const Myelevatedbutton({
    super.key,
    required this.show_text,
    required this.onPressed,
    this.width = 350.0,
    this.height = 50.0,
    this.radius = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.secondaryLightBlue,
          foregroundColor: AppColors.surfaceWhite,
          textStyle: const TextStyle(fontSize: 20.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
        ),
        child: Text(show_text),
      ),
    );
  }
}
