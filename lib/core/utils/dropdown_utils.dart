import 'package:flutter/material.dart';

class DropdownUtils {
  /// Converts a list of String values into DropdownMenuItem<String> list
  static List<DropdownMenuItem<String>> buildDropdownItems(List<String> options) {
    return options
        .map(
          (option) => DropdownMenuItem<String>(
            value: option,
            child: Text(option),
          ),
        )
        .toList();
  }
}
