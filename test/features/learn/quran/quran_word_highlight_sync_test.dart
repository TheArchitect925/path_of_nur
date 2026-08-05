import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/learn/quran/application/quran_word_highlight_sync.dart';
import 'package:path_of_nur/features/learn/quran/data/quran_word_timing_repository.dart';

void main() {
  test('holds the previous word briefly at precise timing boundaries', () {
    const segments = <QuranWordTimingSegment>[
      QuranWordTimingSegment(wordIndex: 0, startMs: 0, endMs: 900),
      QuranWordTimingSegment(wordIndex: 1, startMs: 901, endMs: 1800),
    ];

    final heldIndex = resolveQuranWordHighlightIndex(
      arabicText: 'بِسْمِ اللَّهِ',
      position: const Duration(milliseconds: 930),
      preciseSegments: segments,
      previousWordIndex: 0,
    );

    final advancedIndex = resolveQuranWordHighlightIndex(
      arabicText: 'بِسْمِ اللَّهِ',
      position: const Duration(milliseconds: 1040),
      preciseSegments: segments,
      previousWordIndex: 0,
    );

    expect(heldIndex, 0);
    expect(advancedIndex, 1);
  });

  test(
    'fallback weighting avoids jumping immediately at approximate word edges',
    () {
      final heldIndex = resolveQuranWordHighlightIndex(
        arabicText: 'الْحَمْدُ لِلَّهِ رَبِّ',
        position: const Duration(milliseconds: 705),
        totalDuration: const Duration(milliseconds: 2000),
        previousWordIndex: 0,
      );

      final advancedIndex = resolveQuranWordHighlightIndex(
        arabicText: 'الْحَمْدُ لِلَّهِ رَبِّ',
        position: const Duration(milliseconds: 1240),
        totalDuration: const Duration(milliseconds: 2000),
        previousWordIndex: 0,
      );

      expect(heldIndex, 0);
      expect(advancedIndex, greaterThanOrEqualTo(1));
    },
  );
}
