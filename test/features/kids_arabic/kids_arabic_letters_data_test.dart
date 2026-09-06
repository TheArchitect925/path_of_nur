import 'package:flutter_test/flutter_test.dart';

import 'package:path_of_nur/features/arabic/data/arabic_alphabet_catalog.dart';
import 'package:path_of_nur/features/kids_arabic/application/kids_arabic_progression.dart';
import 'package:path_of_nur/features/kids_arabic/application/kids_arabic_starter_tracing.dart';
import 'package:path_of_nur/features/kids_arabic/application/kids_arabic_vector_tracing.dart';
import 'package:path_of_nur/features/kids_arabic/data/kids_arabic_letters_data.dart';

void main() {
  test('kids Arabic dataset contains 28 letters', () {
    expect(kidsArabicLetters, hasLength(28));
    expect(
      kidsArabicLetters.map((letter) => letter.id),
      orderedEquals(arabicAlphabetLetterIds),
    );
    for (final letter in kidsArabicLetters) {
      expect(letter.glyph, isNotEmpty);
      expect(letter.nameAr, isNotEmpty);
      expect(letter.transliteration, isNotEmpty);
      expect(letter.exampleWordAr, isNotEmpty);
      expect(letter.rewardXp, greaterThan(0));
      expect(letter.rewardDrops, greaterThan(0));
    }
  });

  test('starter letters are surfaced first in the approved release order', () {
    expect(
      kidsArabicStarterReleaseOrderIds,
      orderedEquals(const ['alif', 'ba', 'meem', 'noon', 'seen']),
    );
    expect(
      kidsArabicProgressionOrderIds.take(5),
      orderedEquals(const ['alif', 'ba', 'meem', 'noon', 'seen']),
    );
  });

  test(
    'the stroke count a lesson promises is the stroke count the pad has',
    () {
      for (final letter in kidsArabicLetters) {
        final padStrokes = kidsArabicSupportsVectorTracing(letter.id)
            ? kidsArabicVectorTraceLetterFor(letter.id)!.strokes.length
            : kidsArabicTracingGuideFor(letter.id)!.strokes.length;
        expect(
          letter.strokeCount,
          padStrokes,
          reason:
              '${letter.id} promises ${letter.strokeCount} strokes; '
              'the pad has $padStrokes',
        );
      }
    },
  );
}
