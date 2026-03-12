import 'package:flutter/material.dart';

import 'app_fonts.dart';

class AppTextStyles {
  const AppTextStyles._();

  static TextStyle quranVerse({
    double size = 26,
    Color color = const Color(0xFF1F1B17),
    FontWeight weight = FontWeight.w600,
  }) {
    return TextStyle(
      fontFamily: AppFonts.quranArabic,
      fontSize: size,
      color: color,
      fontWeight: weight,
      height: 1.65,
      shadows: const [
        Shadow(
          color: Color(0x5E2C8A64),
          blurRadius: 1.0,
          offset: Offset(0, 0.4),
        ),
        Shadow(
          color: Color(0x55B88D3A),
          blurRadius: 0.8,
          offset: Offset(0, -0.2),
        ),
      ],
    );
  }

  static TextStyle arabicLearning({
    double size = 22,
    Color color = const Color(0xFF2A2118),
    FontWeight weight = FontWeight.w600,
  }) {
    return TextStyle(
      fontFamily: AppFonts.arabicLearning,
      fontSize: size,
      color: color,
      fontWeight: weight,
      height: 1.5,
    );
  }
}
