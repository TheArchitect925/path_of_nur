import 'package:flutter_test/flutter_test.dart';

import 'package:path_of_nur/features/kids_arabic/application/kids_arabic_progression.dart';
import 'package:path_of_nur/features/kids_arabic/data/kids_arabic_letters_data.dart';

void main() {
  test('kids Arabic dataset contains 28 letters', () {
    expect(kidsArabicLetters, hasLength(28));
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
}
