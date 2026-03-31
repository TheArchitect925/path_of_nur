import 'package:flutter/widgets.dart';

@immutable
class QuranSurahSummaryBackgroundSpec {
  const QuranSurahSummaryBackgroundSpec({
    required this.surahNumber,
    required this.surahKey,
    required this.themeTitle,
    required this.visualPrompt,
    required this.assetPath,
    this.alignment = Alignment.center,
    this.opacity = 0.18,
  });

  final int surahNumber;
  final String surahKey;
  final String themeTitle;
  final String visualPrompt;
  final String assetPath;
  final Alignment alignment;
  final double opacity;
}
