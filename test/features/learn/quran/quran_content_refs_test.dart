import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/learn/quran/domain/quran_content_refs.dart';
import 'package:path_of_nur/shared/content/learning_quote.dart';
import 'package:path_of_nur/shared/widgets/quran_quote_block.dart';

void main() {
  test('learning compact quote is backed by canonical verse metadata', () {
    final quote = buildLearningCompactQuote();

    expect(quote.ref.surah, 38);
    expect(quote.ref.ayah, 29);
    expect(quote.ref.ayahEnd, isNull);
  });

  test('daily quote pools only store verse references', () {
    final quotes = <QuranQuote>[
      ...quranFocusedQuotePool,
      ...dhikrFocusedQuotePool,
      ...reflectionFocusedQuotePool,
    ];

    expect(quotes, isNotEmpty);
    for (final quote in quotes) {
      expect(quote.ref.surah, greaterThan(0));
      expect(quote.ref.ayah, greaterThan(0));
    }
  });

  test('quote location text supports ayah ranges', () {
    const quote = QuranQuote(
      ref: QuranQuoteRef(surah: 23, ayah: 1, ayahEnd: 2),
    );

    expect(quote.locationText, contains('23:1-2'));
  });

  test('audio refs require reciter metadata', () {
    expect(
      () => QuranAudioRef(surah: 1, ayah: 1, reciterId: ''),
      throwsA(isA<AssertionError>()),
    );
  });
}
