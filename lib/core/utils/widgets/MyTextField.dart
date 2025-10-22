import 'package:flutter/material.dart';

class Mytextfield extends StatelessWidget {
  final String hint_text;
  final String label_text;
  final double radius;
  final double width;
  const Mytextfield({
    super.key,
    required this.hint_text,
    required this.label_text,
    this.width = 350.0,
    this.radius = 50.0,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: SizedBox(
        width: width,
        child: TextField(
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white10),
              borderRadius: BorderRadius.circular(radius),
            ),
            hintText: hint_text,
            labelText: label_text,
          ),
        ),
      ),
    );
  }
}
