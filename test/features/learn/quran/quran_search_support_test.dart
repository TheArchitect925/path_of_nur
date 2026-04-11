import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/learn/quran/application/quran_search_support.dart';
import 'package:path_of_nur/features/learn/quran/data/quran_repository.dart';

void main() {
  test('snippet generation centers around the matched translation content', () {
    const source =
        'This is a longer translation sentence designed to keep the highlighted guidance wording near the middle of the snippet for search clarity.';
    final metadata = buildQuranSearchPresentationMetadata(
      field: QuranSearchMatchField.translation,
      query: 'guidance wording',
      sourceText: source,
      maxWords: 8,
    );

    expect(metadata.snippetText, contains('guidance'));
    expect(metadata.snippetText.split(RegExp(r'\s+')).length, lessThan(12));
    expect(metadata.highlightTerms, isNotEmpty);
  });

  test(
    'highlight parts mark translation, transliteration, and arabic safely',
    () {
      final translationParts = buildQuranSearchHighlightParts(
        text: 'Guide us to the straight path',
        highlightTerms: const <String>['Guide', 'path'],
      );
      expect(translationParts.any((part) => part.isHighlighted), isTrue);

      final transliterationParts = buildQuranSearchHighlightParts(
        text: 'ihdinas siratal mustaqeem',
        highlightTerms: const <String>['siratal'],
      );
      expect(transliterationParts.any((part) => part.isHighlighted), isTrue);

      final arabicParts = buildQuranSearchHighlightParts(
        text: 'اهدنا الصراط المستقيم',
        highlightTerms: const <String>['الصراط'],
      );
      expect(arabicParts.any((part) => part.isHighlighted), isTrue);
    },
  );

  test('field filter wire values round-trip safely', () {
    for (final filter in QuranSearchFieldFilter.values) {
      expect(QuranSearchFieldFilterX.fromWireValue(filter.wireValue), filter);
    }
    expect(
      QuranSearchFieldFilterX.fromWireValue('unexpected'),
      QuranSearchFieldFilter.all,
    );
  });

  test('reader surah search matches translation, transliteration, and arabic', () {
    final matches = buildReaderSurahSearchMatches(
      query: 'rahmaan',
      ayahs: const <QuranReaderSearchableAyah>[
        (
          ayahNumber: 1,
          translation: 'In the name of Allah, the Entirely Merciful',
          transliteration: 'bismi llahi r-rahmani r-raheem',
          arabic: 'بسم الله الرحمن الرحيم',
        ),
        (
          ayahNumber: 2,
          translation: 'All praise is due to Allah',
          transliteration: 'alhamdu lillahi rabbil alamin',
          arabic: 'الحمد لله رب العالمين',
        ),
      ],
    );

    expect(matches, isNotEmpty);
    expect(matches.first.ayahNumber, 1);
    expect(
      matches.first.matchesField(QuranSearchMatchField.transliteration),
      isTrue,
    );
  });

  test('reader surah search honors an arabic preferred field', () {
    final matches = buildReaderSurahSearchMatches(
      query: 'الصراط المستقيم',
      preferredField: QuranSearchMatchField.arabic,
      ayahs: const <QuranReaderSearchableAyah>[
        (
          ayahNumber: 6,
          translation: 'Guide us to the straight path',
          transliteration: 'ihdina s-sirata l-mustaqim',
          arabic: 'اهدنا الصراط المستقيم',
        ),
      ],
    );

    expect(matches.single.ayahNumber, 6);
    expect(matches.single.matchedFields, {QuranSearchMatchField.arabic});
    expect(matches.single.highlightTermsFor(QuranSearchMatchField.arabic), isNotEmpty);
  });

  test(
    'reader search highlighting uses only the exact translation query terms for father',
    () {
      final repository = QuranRepository();
      final ayah = repository.getAyahsForSurah(
        2,
        translationCode: 'en.sahih',
      ).firstWhere(
        (item) => item.ayahNumber == 233,
      );

      final matches = buildReaderSurahSearchMatches(
        query: 'father',
        preferredField: QuranSearchMatchField.translation,
        ayahs: <QuranReaderSearchableAyah>[
          (
            ayahNumber: ayah.ayahNumber,
            translation: ayah.translation,
            transliteration: ayah.transliteration ?? '',
            arabic: ayah.arabic,
          ),
        ],
      );

      expect(matches, hasLength(1));
      expect(matches.single.matchedFields, {QuranSearchMatchField.translation});
      final translationHighlights = matches.single.highlightTermsFor(
        QuranSearchMatchField.translation,
      );
      final normalizedHighlights = translationHighlights
          .map((term) => term.toLowerCase().replaceAll(RegExp(r"[^a-z]"), ''))
          .toSet();
      expect(normalizedHighlights, contains('father'));
      expect(normalizedHighlights, isNot(contains('mothers')));
      expect(normalizedHighlights, isNot(contains('allah')));
      expect(
        matches.single.highlightTermsFor(QuranSearchMatchField.transliteration),
        isEmpty,
      );
      expect(
        matches.single.highlightTermsFor(QuranSearchMatchField.arabic),
        isEmpty,
      );
    },
  );
}
