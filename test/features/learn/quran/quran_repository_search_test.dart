import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/learn/quran/application/quran_search_normalization.dart';
import 'package:path_of_nur/features/learn/quran/application/quran_search_support.dart';
import 'package:path_of_nur/features/learn/quran/data/quran_repository.dart';

void main() {
  const translationCode = 'en.sahih';

  test('surah name search returns the canonical surah result first', () {
    final repository = QuranRepository();
    final surah = repository.getSurahs().first;
    final results = repository.search(
      surah.transliteratedName,
      translationCode: translationCode,
    );

    expect(results, isNotEmpty);
    expect(results.first.surah.number, surah.number);
    expect(results.first.ayahNumber, isNull);
  });

  test('english word search returns the expected ayah', () {
    final repository = QuranRepository();
    final results = repository.search(
      'recompense',
      translationCode: translationCode,
    );

    expect(
      results.any(
        (result) => result.surah.number == 1 && result.ayahNumber == 4,
      ),
      isTrue,
    );
    expect(results.first.matchField, QuranSearchMatchField.translation);
    expect(results.first.snippetText, isNotEmpty);
    expect(results.first.highlightTerms, isNotEmpty);
  });

  test('exact phrase match ranks above weaker matches', () {
    final repository = QuranRepository();
    final ayah = repository.getAyahsForSurah(
      1,
      translationCode: translationCode,
    )[3];
    final query = normalizeQuranSearchText(ayah.translation);

    final results = repository.search(query, translationCode: translationCode);

    expect(results, isNotEmpty);
    expect(results.first.surah.number, 1);
    expect(results.first.ayahNumber, 4);
  });

  test('normalized phrase search matches the expected ayah first', () {
    final repository = QuranRepository();
    final ayah = repository.getAyahsForSurah(
      1,
      translationCode: translationCode,
    )[3];
    final normalizedWords = normalizeQuranSearchText(
      ayah.translation,
    ).split(' ').where((token) => token.isNotEmpty).toList();
    final query = <String>[
      normalizedWords.first,
      if (normalizedWords.length > 1) '${normalizedWords[1]},',
      ...normalizedWords.skip(2).take(4),
    ].join(' ');
    final results = repository.search(query, translationCode: translationCode);

    expect(results, isNotEmpty);
    expect(results.first.surah.number, 1);
    expect(results.first.ayahNumber, 4);
  });

  test('transliteration search returns the expected ayah', () {
    final repository = QuranRepository();
    final results = repository.search(
      'naabudu',
      translationCode: translationCode,
    );

    expect(results, isNotEmpty);
    expect(results.first.surah.number, 1);
    expect(results.first.ayahNumber, 5);
    expect(results.first.matchField, QuranSearchMatchField.transliteration);
  });

  test('transliteration variants for rahman stay strongly aligned', () {
    final repository = QuranRepository();

    for (final query in const <String>[
      'rahman',
      'ar-rahman',
      'al rahman',
      'rahmaan',
    ]) {
      final results = repository.search(
        query,
        translationCode: translationCode,
      );
      expect(results, isNotEmpty, reason: query);
      expect(
        results
            .take(5)
            .any(
              (result) =>
                  (result.surah.number == 55 && result.ayahNumber == 1) ||
                  (result.surah.number == 1 &&
                      <int?>{1, 3}.contains(result.ayahNumber)),
            ),
        isTrue,
        reason: query,
      );
    }
  });

  test(
    'transliteration name variants resolve to the same canonical results',
    () {
      final repository = QuranRepository();

      final musaResults = <String, List<dynamic>>{
        'musa': repository.search('musa', translationCode: translationCode),
        'moosa': repository.search('moosa', translationCode: translationCode),
        'ibrahim': repository.search(
          'ibrahim',
          translationCode: translationCode,
        ),
        'ibraheem': repository.search(
          'ibraheem',
          translationCode: translationCode,
        ),
        'yasin': repository.search('yasin', translationCode: translationCode),
        'ya seen': repository.search(
          'ya seen',
          translationCode: translationCode,
        ),
      };

      expect(
        musaResults['musa']!.first.ayahNumber,
        musaResults['moosa']!.first.ayahNumber,
      );
      expect(
        musaResults['ibrahim']!
            .take(3)
            .map((result) => result.ayahNumber)
            .toSet(),
        contains(musaResults['ibraheem']!.first.ayahNumber),
      );
      expect(
        musaResults['yasin']!
            .take(5)
            .any((result) => result.surah.number == 36),
        isTrue,
      );
      expect(
        musaResults['ya seen']!
            .take(5)
            .any((result) => result.surah.number == 36),
        isTrue,
      );
    },
  );

  test('transliteration normalization produces stable compact forms', () {
    expect(
      buildQuranTransliterationSearchForms('ar-rahman'),
      contains('rahman'),
    );
    expect(buildQuranTransliterationSearchForms('rahmaan'), contains('rahman'));
    expect(buildQuranTransliterationSearchForms('ya seen'), contains('yasin'));
    expect(buildQuranTransliterationSearchForms('moosa'), contains('musa'));
  });

  test('arabic word search returns the expected ayah first', () {
    final repository = QuranRepository();
    final results = repository.search(
      'اهدنا',
      translationCode: translationCode,
    );

    expect(results, isNotEmpty);
    expect(results.first.surah.number, 1);
    expect(results.first.ayahNumber, 6);
    expect(results.first.matchField, QuranSearchMatchField.arabic);
  });

  test('arabic phrase search returns the expected ayah first', () {
    final repository = QuranRepository();
    final results = repository.search(
      'الصراط المستقيم',
      translationCode: translationCode,
    );

    expect(results, isNotEmpty);
    expect(results.first.surah.number, 1);
    expect(results.first.ayahNumber, 6);
  });

  test('normalized arabic variant queries stay strongly aligned', () {
    final repository = QuranRepository();

    for (final query in const <String>[
      'اهدنا',
      'ٱهْدِنَا',
      'الصراط المستقيم',
      'ٱلصِّرَٰطَ ٱلْمُسْتَقِيمَ',
      'إبراهيم',
      'ابراهيم',
    ]) {
      final results = repository.search(
        query,
        translationCode: translationCode,
      );
      expect(results, isNotEmpty, reason: query);
    }

    final hdinA = repository.search('اهدنا', translationCode: translationCode);
    final decoratedHdinA = repository.search(
      'ٱهْدِنَا',
      translationCode: translationCode,
    );
    expect(hdinA.first.surah.number, decoratedHdinA.first.surah.number);
    expect(hdinA.first.ayahNumber, decoratedHdinA.first.ayahNumber);

    final path = repository.search(
      'الصراط المستقيم',
      translationCode: translationCode,
    );
    final decoratedPath = repository.search(
      'ٱلصِّرَٰطَ ٱلْمُسْتَقِيمَ',
      translationCode: translationCode,
    );
    expect(path.first.surah.number, decoratedPath.first.surah.number);
    expect(path.first.ayahNumber, decoratedPath.first.ayahNumber);
  });

  test('arabic normalization removes tashkeel and normalizes variants', () {
    expect(normalizeQuranArabicSearchText('ٱهْدِنَا'), 'اهدنا');
    expect(
      normalizeQuranArabicSearchText('ٱلصِّرَٰطَ ٱلْمُسْتَقِيمَ'),
      'الصراط المستقيم',
    );
    expect(normalizeQuranArabicSearchText('إبراهيم'), 'ابراهيم');
    expect(normalizeQuranArabicSearchText('رحمة'), 'رحمه');
  });

  test(
    'field filters narrow results through the canonical repository search',
    () {
      final repository = QuranRepository();

      final surahResults = repository.search(
        'baqarah',
        translationCode: translationCode,
        fieldFilter: QuranSearchFieldFilter.surah,
      );
      expect(surahResults, isNotEmpty);
      expect(surahResults.first.ayahNumber, isNull);
      expect(surahResults.first.matchField, QuranSearchMatchField.surah);

      final translationResults = repository.search(
        'recompense',
        translationCode: translationCode,
        fieldFilter: QuranSearchFieldFilter.translation,
      );
      expect(translationResults, isNotEmpty);
      expect(
        translationResults.every(
          (result) => result.matchField == QuranSearchMatchField.translation,
        ),
        isTrue,
      );

      final transliterationResults = repository.search(
        'naabudu',
        translationCode: translationCode,
        fieldFilter: QuranSearchFieldFilter.transliteration,
      );
      expect(transliterationResults, isNotEmpty);
      expect(
        transliterationResults.first.matchField,
        QuranSearchMatchField.transliteration,
      );

      final arabicResults = repository.search(
        'اهدنا',
        translationCode: translationCode,
        fieldFilter: QuranSearchFieldFilter.arabic,
      );
      expect(arabicResults, isNotEmpty);
      expect(arabicResults.first.matchField, QuranSearchMatchField.arabic);
    },
  );
}
