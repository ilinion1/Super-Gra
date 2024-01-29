import 'package:flutter/material.dart';

abstract class AppColors {
  static const background = Color(0xFF252637);
  static const secondaryBackground = Color(0xFF1C1C27);
  static const white = Color(0xFFFFFFFF);
  static const grey = Color(0xFFC6C7D7);
  static const pink = Color(0xFFC94071);
  static const blue = Color(0xFF5A52F1);
  static const black = Color(0xFF0F0F1E);

  // gradient
  static const mainGradient = LinearGradient(
    colors: [
      Color(0xFFDE4851),
      Color(0xFF6A23B7),
    ],
  );
}
