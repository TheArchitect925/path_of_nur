import 'package:flutter/material.dart';

import 'app_fonts.dart';

class AppTextStyles {
  const AppTextStyles._();

  // Latin-script scale. Colors intentionally omitted: callers take them from
  // AppAppearanceTheme so every style works in all 11 theme modes.

  /// Page-level display headings (hero titles, large numerals paired with a
  /// serif voice).
  static const TextStyle displaySerif = TextStyle(
    fontFamily: AppFonts.latinSerif,
    fontSize: 30,
    height: 34 / 30,
    fontWeight: FontWeight.w600,
  );

  /// Section and card titles.
  static const TextStyle titleSerif = TextStyle(
    fontFamily: AppFonts.latinSerif,
    fontSize: 22,
    height: 1.25,
    fontWeight: FontWeight.w600,
  );

  /// Emphasized UI titles where serif would be too formal (tiles, sheets).
  static const TextStyle titleSans = TextStyle(
    fontFamily: AppFonts.latinSans,
    fontSize: 17,
    height: 1.3,
    fontWeight: FontWeight.w600,
  );

  /// Default body copy.
  static const TextStyle body = TextStyle(
    fontFamily: AppFonts.latinSans,
    fontSize: 15,
    height: 1.45,
    fontWeight: FontWeight.w400,
  );

  /// Secondary/supporting copy (subtitles, captions with room to breathe).
  static const TextStyle bodySecondary = TextStyle(
    fontFamily: AppFonts.latinSans,
    fontSize: 13.5,
    height: 1.4,
    fontWeight: FontWeight.w400,
  );

  /// Tracked uppercase labels (section eyebrows, chips, meta rows).
  static const TextStyle label = TextStyle(
    fontFamily: AppFonts.latinSans,
    fontSize: 12,
    height: 1.2,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.8,
  );

  /// Numerals that must align vertically (countdowns, stats, counters).
  static const TextStyle numeric = TextStyle(
    fontFamily: AppFonts.latinSans,
    fontSize: 15,
    height: 1.2,
    fontWeight: FontWeight.w600,
    fontFeatures: [FontFeature.tabularFigures()],
  );

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
