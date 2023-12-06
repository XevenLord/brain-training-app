import 'package:flutter/material.dart';

class AppColors {
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);

  static const Color blue = Color.fromARGB(255, 0, 183, 255);
  static const Color brandBlue = Color(0xFF1C6BA4);
  static const Color lightBlue = Color(0xFFDCEDF9);
  static const Color fadedBlue = Color(0xFF7B8D9E);

  static const Color brandRed = Color(0xFF9D4C6C);
  static const Color lightRed = Color(0xFFF5E1E9);

  static const Color brandYellow = Color(0xFFE09F1F);
  static const Color lightYellow = Color(0xFFFAF0DB);

  static const Color grey = Color(0xFF4A545E);

  static const Color green = Color(0xFF1DB954);

  static const LinearGradient linearBlueProfile = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF1C6BA4),
      Color(0xFF69A6D2),
    ],
  );
  static const LinearGradient linearBluePurple = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF8258AB),
      Color(0xFF0085FF),
    ],
  );
  static const LinearGradient linearBlue = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF9CD0F6),
      Color(0xFFB8C3FF)
    ],
  );
}