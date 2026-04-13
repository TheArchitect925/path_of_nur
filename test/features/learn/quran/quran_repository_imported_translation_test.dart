import 'package:flutter_test/flutter_test.dart';
import 'package:quran/quran.dart' as q;
import 'package:path_of_nur/features/learn/quran/data/quran_repository.dart';
import 'package:path_of_nur/features/learn/quran/domain/imported_quran_translation_bundle.dart';

const germanCode = 'de.quran_foundation_candidate';

void main() {
  test('repository resolves imported German ayahs without fallback', () {
    final repository = QuranRepository(
      importedBundles: {germanCode: _buildCompleteGermanTestBundle()},
    );

    final ayahs = repository.getAyahsForSurah(1, translationCode: germanCode);

    expect(ayahs.first.translation, 'DE 1:1');
    expect(ayahs[3].translation, 'DE 1:4');
  });

  test('repository uses imported German text for daily verse and search', () {
    final repository = QuranRepository(
      importedBundles: {germanCode: _buildCompleteGermanTestBundle()},
    );

    final dailyVerse = repository.getDailyVerse(
      date: DateTime(2026, 1, 1),
      translationCode: germanCode,
    );
    final searchResults = repository.search(
      'DE 1:4',
      translationCode: germanCode,
    );

    expect(dailyVerse.translation, 'DE 1:1');
    expect(searchResults, isNotEmpty);
    expect(searchResults.first.surah.number, 1);
    expect(searchResults.first.ayahNumber, 4);
  });

  test('repository throws when imported German bundle is incomplete', () {
    final repository = QuranRepository(
      importedBundles: {
        germanCode: const ImportedQuranTranslationBundle(
          code: germanCode,
          translatorName: 'Frank Bubenheim and Nadeem Elyas',
          sourceProvider: 'Quran Foundation',
          verseTextsByVerseKey: {'1:1': 'DE 1:1'},
        ),
      },
    );

    expect(
      () => repository.getAyahsForSurah(1, translationCode: germanCode),
      throwsA(isA<StateError>()),
    );
  });
}

ImportedQuranTranslationBundle _buildCompleteGermanTestBundle() {
  final verseTextsByVerseKey = <String, String>{};
  for (var surah = 1; surah <= q.totalSurahCount; surah += 1) {
    for (var ayah = 1; ayah <= q.getVerseCount(surah); ayah += 1) {
      verseTextsByVerseKey['$surah:$ayah'] = 'DE $surah:$ayah';
    }
  }

  return ImportedQuranTranslationBundle(
    code: germanCode,
    translatorName: 'Frank Bubenheim and Nadeem Elyas',
    sourceProvider: 'Quran Foundation',
    verseTextsByVerseKey: verseTextsByVerseKey,
  );
}
