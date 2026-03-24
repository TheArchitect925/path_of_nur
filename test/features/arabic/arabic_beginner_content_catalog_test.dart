import 'package:flutter_test/flutter_test.dart';

import 'package:path_of_nur/features/arabic/data/arabic_beginner_content_catalog.dart';
import 'package:path_of_nur/features/kids_arabic/data/kids_arabic_beginner_words_data.dart';
import 'package:path_of_nur/features/kids_arabic/data/kids_arabic_mini_phrases_data.dart';

void main() {
  test('shared beginner Arabic words expose a curated starter set', () {
    expect(
      arabicSharedBeginnerWords.map((item) => item.id),
      orderedEquals(arabicSharedBeginnerWordOrderIds),
    );
    expect(arabicSharedBeginnerWords, hasLength(5));

    for (final word in arabicSharedBeginnerWords) {
      expect(word.arabicText, isNotEmpty);
      expect(word.transliteration, isNotEmpty);
      expect(word.simpleMeaning, isNotEmpty);
      expect(word.letterIds, isNotEmpty);
    }
  });

  test('shared beginner Arabic phrases expose the intended starter set', () {
    expect(
      arabicSharedMiniPhrases.map((item) => item.id),
      orderedEquals(arabicSharedMiniPhraseOrderIds),
    );
    expect(arabicSharedMiniPhrases, hasLength(8));

    for (final phrase in arabicSharedMiniPhrases) {
      expect(phrase.arabicText, isNotEmpty);
      expect(phrase.transliteration, isNotEmpty);
      expect(phrase.simpleMeaning, isNotEmpty);
    }
  });

  test(
    'Kids Arabic words and mini phrases now derive from the shared catalog',
    () {
      for (final word in kidsArabicBeginnerWords) {
        final shared = arabicSharedBeginnerWordById(word.id);
        expect(shared, isNotNull);
        expect(word.wordAr, shared!.arabicText);
        expect(word.transliteration, shared.transliteration);
        expect(word.letterIds, orderedEquals(shared.letterIds));
      }

      for (final phrase in kidsArabicMiniPhrases) {
        final shared = arabicSharedMiniPhraseById(phrase.id);
        expect(shared, isNotNull);
        expect(phrase.phraseAr, shared!.arabicText);
        expect(phrase.transliteration, shared.transliteration);
      }
    },
  );
}
