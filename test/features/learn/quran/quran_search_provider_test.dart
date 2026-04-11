import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/learn/quran/application/quran_providers.dart';
import 'package:path_of_nur/features/learn/quran/application/quran_search_normalization.dart';
import 'package:path_of_nur/features/learn/quran/application/quran_search_support.dart';
import 'package:path_of_nur/features/learn/quran/data/quran_repository.dart';

import '../../../test_helpers/app_test_harness.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<ProviderContainer> makeContainer() {
    return makeTestContainer();
  }

  test('quran search matches surah names and ayah translation text', () async {
    final container = await makeContainer();
    addTearDown(container.dispose);

    container.read(quranSearchQueryProvider.notifier).state = 'opening';
    var results = await container.read(quranSearchResultsProvider.future);
    expect(
      results.any((result) => result.ayah == null && result.surah.number == 1),
      isTrue,
    );

    container.read(quranSearchQueryProvider.notifier).state = 'recompense';
    container.invalidate(quranSearchResultsProvider);
    results = await container.read(quranSearchResultsProvider.future);
    expect(
      results.any(
        (result) =>
            result.ayah?.surahNumber == 1 && result.ayah?.ayahNumber == 4,
      ),
      isTrue,
    );
  });

  test(
    'quran search type parsing defaults to all and supports wire values',
    () {
      expect(QuranSearchTypeX.fromWireValue(null), QuranSearchType.all);
      expect(QuranSearchTypeX.fromWireValue('text'), QuranSearchType.text);
      expect(QuranSearchTypeX.fromWireValue('theme'), QuranSearchType.theme);
      expect(QuranSearchTypeX.fromWireValue('topic'), QuranSearchType.topic);
      expect(QuranSearchTypeX.fromWireValue('surah'), QuranSearchType.surah);
    },
  );

  test(
    'quran search matches english phrase text through canonical provider',
    () async {
      final container = await makeContainer();
      addTearDown(container.dispose);

      final repository = QuranRepository();
      final ayah = repository.getAyahsForSurah(
        1,
        translationCode: 'en.sahih',
      )[3];
      final phraseQuery = normalizeQuranSearchText(
        ayah.translation,
      ).split(' ').where((token) => token.isNotEmpty).take(5).join(' ');

      container.read(quranSearchQueryProvider.notifier).state = phraseQuery;
      final results = await container.read(quranSearchResultsProvider.future);

      expect(results, isNotEmpty);
      expect(results.first.ayah?.surahNumber, 1);
      expect(results.first.ayah?.ayahNumber, 4);
      expect(results.first.matchField, QuranSearchMatchField.translation);
    },
  );

  test('quran search matches ayah arabic text', () async {
    final container = await makeContainer();
    addTearDown(container.dispose);

    container.read(quranSearchQueryProvider.notifier).state = 'الحمد';
    final results = await container.read(quranSearchResultsProvider.future);

    expect(
      results.any(
        (result) =>
            result.ayah?.surahNumber == 1 && result.ayah?.ayahNumber == 2,
      ),
      isTrue,
    );
  });

  test(
    'quran search matches arabic phrase text through canonical provider',
    () async {
      final container = await makeContainer();
      addTearDown(container.dispose);

      container.read(quranSearchQueryProvider.notifier).state =
          'الصراط المستقيم';
      final results = await container.read(quranSearchResultsProvider.future);

      expect(results, isNotEmpty);
      expect(results.first.ayah?.surahNumber, 1);
      expect(results.first.ayah?.ayahNumber, 6);
      expect(results.first.matchField, QuranSearchMatchField.arabic);
    },
  );

  test('arabic variant queries resolve to the same canonical ayah', () async {
    final container = await makeContainer();
    addTearDown(container.dispose);

    for (final query in const <String>['اهدنا', 'ٱهْدِنَا']) {
      container.read(quranSearchQueryProvider.notifier).state = query;
      container.invalidate(quranSearchResultsProvider);
      final results = await container.read(quranSearchResultsProvider.future);
      expect(results, isNotEmpty, reason: query);
      expect(results.first.ayah?.surahNumber, 1, reason: query);
      expect(results.first.ayah?.ayahNumber, 6, reason: query);
      expect(results.first.matchField, QuranSearchMatchField.arabic);
    }
  });

  test(
    'quran search matches transliteration text through repository data',
    () async {
      final container = await makeContainer();
      addTearDown(container.dispose);

      container.read(quranSearchQueryProvider.notifier).state = 'naabudu';
      final results = await container.read(quranSearchResultsProvider.future);

      expect(
        results.any(
          (result) =>
              result.ayah?.surahNumber == 1 && result.ayah?.ayahNumber == 5,
        ),
        isTrue,
      );
    },
  );

  test(
    'transliteration variant queries resolve to the same strong canonical ayah',
    () async {
      final container = await makeContainer();
      addTearDown(container.dispose);

      for (final query in const <String>[
        'rahman',
        'ar-rahman',
        'al rahman',
        'rahmaan',
      ]) {
        container.read(quranSearchQueryProvider.notifier).state = query;
        container.invalidate(quranSearchResultsProvider);
        final results = await container.read(quranSearchResultsProvider.future);
        expect(results, isNotEmpty, reason: query);
        expect(
          results
              .take(5)
              .any(
                (result) =>
                    (result.ayah?.surahNumber == 55 &&
                        result.ayah?.ayahNumber == 1) ||
                    (result.ayah?.surahNumber == 1 &&
                        <int?>{1, 3}.contains(result.ayah?.ayahNumber)),
              ),
          isTrue,
          reason: query,
        );
      }
    },
  );

  test(
    'primary quran text search results stay separate from knowledge hits',
    () async {
      final container = await makeContainer();
      addTearDown(container.dispose);

      container.read(quranSearchQueryProvider.notifier).state = 'guidance';
      final results = await container.read(quranSearchResultsProvider.future);

      expect(results, isNotEmpty);
      expect(results.every((result) => result.reference == null), isTrue);
    },
  );

  test(
    'provider field filters narrow results through the canonical path',
    () async {
      final container = await makeContainer();
      addTearDown(container.dispose);

      final translationResults = await container.read(
        quranTextSearchResultsProvider(
          const QuranTextSearchQuery(
            query: 'recompense',
            fieldFilter: QuranSearchFieldFilter.translation,
          ),
        ).future,
      );
      expect(translationResults, isNotEmpty);
      expect(
        translationResults.first.matchField,
        QuranSearchMatchField.translation,
      );

      final arabicResults = await container.read(
        quranTextSearchResultsProvider(
          const QuranTextSearchQuery(
            query: 'اهدنا',
            fieldFilter: QuranSearchFieldFilter.arabic,
          ),
        ).future,
      );
      expect(arabicResults, isNotEmpty);
      expect(arabicResults.first.matchField, QuranSearchMatchField.arabic);

      final surahResults = await container.read(
        quranTextSearchResultsProvider(
          const QuranTextSearchQuery(
            query: 'baqarah',
            fieldFilter: QuranSearchFieldFilter.surah,
          ),
        ).future,
      );
      expect(surahResults, isNotEmpty);
      expect(surahResults.first.ayah, isNull);
      expect(surahResults.first.matchField, QuranSearchMatchField.surah);
    },
  );

  test(
    'surah lookup provider supports direct surah matching patterns',
    () async {
      final container = await makeContainer();
      addTearDown(container.dispose);

      final byName = container.read(quranFilteredSurahListProvider('baqarah'));
      expect(byName, isNotEmpty);
      expect(byName.any((surah) => surah.number == 2), isTrue);

      final byNumber = container.read(quranFilteredSurahListProvider('2'));
      expect(byNumber.any((surah) => surah.number == 2), isTrue);
    },
  );

  test(
    'recent searches are deduplicated, capped, and keep field context',
    () async {
      final container = await makeContainer();
      addTearDown(container.dispose);

      final notifier = container.read(quranRecentSearchesProvider.notifier);
      for (var i = 0; i < 14; i += 1) {
        notifier.addSearch('query $i');
      }
      notifier.addSearch(
        'Rahman',
        fieldFilter: QuranSearchFieldFilter.transliteration,
      );
      notifier.addSearch(
        'ar-rahman',
        fieldFilter: QuranSearchFieldFilter.transliteration,
      );

      final recent = container.read(quranRecentSearchesProvider);
      expect(recent.length, 12);
      expect(recent.first.query, 'ar-rahman');
      expect(recent.first.fieldFilter, QuranSearchFieldFilter.transliteration);
      expect(
        recent.where(
          (item) => normalizeQuranSearchText(item.query) == 'rahman',
        ),
        hasLength(1),
      );
    },
  );

  test('saved searches persist, rerun metadata, and can be removed', () async {
    final container = await makeContainer();
    addTearDown(container.dispose);

    final notifier = container.read(quranSavedSearchesProvider.notifier);
    notifier.save('mercy', fieldFilter: QuranSearchFieldFilter.translation);
    notifier.save(
      'rahman',
      fieldFilter: QuranSearchFieldFilter.transliteration,
    );

    final saved = container.read(quranSavedSearchesProvider);
    expect(saved, hasLength(2));
    expect(
      notifier.isSaved(
        'rahman',
        fieldFilter: QuranSearchFieldFilter.transliteration,
      ),
      isTrue,
    );

    notifier.remove('mercy', fieldFilter: QuranSearchFieldFilter.translation);
    expect(
      notifier.isSaved(
        'mercy',
        fieldFilter: QuranSearchFieldFilter.translation,
      ),
      isFalse,
    );
    expect(container.read(quranSavedSearchesProvider), hasLength(1));
  });

  test(
    'suggested searches expose the curated canonical starter queries',
    () async {
      final container = await makeContainer();
      addTearDown(container.dispose);

      final suggestions = container.read(quranSuggestedSearchesProvider);
      expect(
        suggestions.map((item) => item.query),
        containsAll(<String>[
          'mercy',
          'guidance',
          'patience',
          'sabr',
          'rahman',
          'repentance',
        ]),
      );
    },
  );
}
