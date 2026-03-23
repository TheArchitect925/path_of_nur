import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/learn/quran/application/quran_word_highlight_sync.dart';
import 'package:path_of_nur/features/learn/quran/data/quran_word_timing_repository.dart';

void main() {
  test('uses precise segment timings when available', () {
    final index = resolveQuranWordHighlightIndex(
      arabicText: 'بسم الله الرحمن الرحيم',
      position: const Duration(milliseconds: 650),
      totalDuration: const Duration(seconds: 3),
      preciseSegments: const [
        QuranWordTimingSegment(wordIndex: 0, startMs: 0, endMs: 200),
        QuranWordTimingSegment(wordIndex: 1, startMs: 201, endMs: 600),
        QuranWordTimingSegment(wordIndex: 2, startMs: 601, endMs: 1000),
      ],
    );

    expect(index, 2);
  });

  test('falls back to approximate timing from real playback position', () {
    final earlyIndex = resolveQuranWordHighlightIndex(
      arabicText: 'الحمد لله رب العالمين',
      position: const Duration(milliseconds: 150),
      totalDuration: const Duration(seconds: 2),
    );
    final lateIndex = resolveQuranWordHighlightIndex(
      arabicText: 'الحمد لله رب العالمين',
      position: const Duration(milliseconds: 1700),
      totalDuration: const Duration(seconds: 2),
    );

    expect(earlyIndex, 0);
    expect(lateIndex, greaterThanOrEqualTo(2));
  });

  test('clamps to the final known word after segment timings end', () {
    final index = resolveQuranWordHighlightIndex(
      arabicText: 'قل هو الله أحد',
      position: const Duration(seconds: 5),
      totalDuration: const Duration(seconds: 5),
      preciseSegments: const [
        QuranWordTimingSegment(wordIndex: 0, startMs: 0, endMs: 400),
        QuranWordTimingSegment(wordIndex: 1, startMs: 401, endMs: 900),
        QuranWordTimingSegment(wordIndex: 2, startMs: 901, endMs: 1200),
      ],
    );

    expect(index, 2);
  });
}
