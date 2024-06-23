import 'package:flutter/material.dart';

class MyChipTheme {
  MyChipTheme._();

  static final lightChipTheme = ChipThemeData(
      disabledColor: Colors.grey.withOpacity(0.4),
      selectedColor: Colors.blue,
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
      checkmarkColor: Colors.white,
      labelStyle: const TextStyle(color: Colors.black),
      brightness: Brightness.light);

      static final darkChipTheme = ChipThemeData(
      disabledColor: Colors.grey,
      selectedColor: Colors.blue,
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
      checkmarkColor: Colors.white,
      labelStyle: const TextStyle(color: Colors.white),
      brightness: Brightness.light);
}
