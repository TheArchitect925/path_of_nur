import 'package:flutter/material.dart';

import '../../application/quran_surah_summary_background_resolver.dart';
import '../quran_summary_theme.dart';

class QuranSurahSummaryCardBackground extends StatelessWidget {
  const QuranSurahSummaryCardBackground({
    super.key,
    required this.surahNumber,
    required this.palette,
  });

  final int surahNumber;
  final QuranSummaryThemePalette palette;

  @override
  Widget build(BuildContext context) {
    final spec = resolveQuranSurahSummaryBackgroundSpec(surahNumber);
    final assetPath = resolveQuranSurahSummaryBackgroundAsset(surahNumber);
    if (spec == null || assetPath == null) {
      return const SizedBox.shrink();
    }

    return IgnorePointer(
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: spec.opacity,
              child: Image.asset(
                assetPath,
                fit: BoxFit.cover,
                alignment: spec.alignment,
                filterQuality: FilterQuality.low,
                cacheWidth: 1200,
                errorBuilder: (context, error, stackTrace) =>
                    const SizedBox.shrink(),
              ),
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    palette.cardTop.withValues(alpha: 0.68),
                    palette.cardBottom.withValues(alpha: 0.50),
                    palette.cardBottom.withValues(alpha: 0.80),
                  ],
                  stops: const [0, 0.48, 1],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
