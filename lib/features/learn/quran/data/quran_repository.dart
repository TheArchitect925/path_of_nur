import 'dart:math';

import 'package:quran/quran.dart' as q;

import '../application/quran_search_normalization.dart';
import '../application/quran_search_support.dart';
import '../domain/quran_ayah.dart';
import '../domain/quran_daily_verse.dart';
import '../domain/quran_surah.dart';
import 'quran_transliteration_local_data.dart';

class QuranRepository {
  QuranRepository();

  final Map<String, List<QuranAyah>> _ayahCache = {};
  List<QuranSurah>? _surahCache;
  final Map<String, List<_VerseSearchRow>> _searchIndexByTranslation = {};

  List<QuranSurah> getSurahs() {
    if (_surahCache != null) return _surahCache!;
    _surahCache = List<QuranSurah>.generate(q.totalSurahCount, (index) {
      final number = index + 1;
      return QuranSurah(
        number: number,
        arabicName: q.getSurahNameArabic(number),
        transliteratedName: q.getSurahName(number),
        englishName: q.getSurahNameEnglish(number),
        verseCount: q.getVerseCount(number),
        revelationPlace: q.getPlaceOfRevelation(number),
      );
    });
    return _surahCache!;
  }

  List<QuranAyah> getAyahsForSurah(
    int surahNumber, {
    required String translationCode,
  }) {
    final key = '$surahNumber::$translationCode';
    final cached = _ayahCache[key];
    if (cached != null) return cached;

    final count = q.getVerseCount(surahNumber);
    final translation = _translationForCode(translationCode);
    final transliterationRows = quranTransliterationLocalData[surahNumber];

    final rows = List<QuranAyah>.generate(count, (index) {
      final ayahNumber = index + 1;
      return QuranAyah(
        surahNumber: surahNumber,
        ayahNumber: ayahNumber,
        arabic: q.getVerse(surahNumber, ayahNumber),
        translation: q.getVerseTranslation(
          surahNumber,
          ayahNumber,
          translation: translation,
        ),
        transliteration: index < (transliterationRows?.length ?? 0)
            ? transliterationRows![index]
            : '',
      );
    });

    _ayahCache[key] = rows;
    return rows;
  }

  QuranDailyVerse getDailyVerse({
    required DateTime date,
    required String translationCode,
  }) {
    final dayIndex = date.difference(DateTime(date.year, 1, 1)).inDays;
    final globalVerseIndex = dayIndex % q.totalVerseCount;
    final location = _verseLocationFromGlobalIndex(globalVerseIndex);
    final translation = _translationForCode(translationCode);

    final surahNumber = location.$1;
    final ayahNumber = location.$2;
    final transliterationRows = quranTransliterationLocalData[surahNumber];

    return QuranDailyVerse(
      surahNumber: surahNumber,
      ayahNumber: ayahNumber,
      arabic: q.getVerse(surahNumber, ayahNumber),
      translation: q.getVerseTranslation(
        surahNumber,
        ayahNumber,
        translation: translation,
      ),
      transliteration: ayahNumber - 1 < (transliterationRows?.length ?? 0)
          ? transliterationRows![ayahNumber - 1]
          : '',
      locationLabel: '${q.getSurahName(surahNumber)} $surahNumber:$ayahNumber',
    );
  }

  List<QuranSearchResultData> search(
    String query, {
    required String translationCode,
    int maxResults = 80,
    QuranSearchFieldFilter fieldFilter = QuranSearchFieldFilter.all,
  }) {
    final rawQuery = query.trim();
    final normalized = normalizeQuranSearchText(rawQuery);
    final normalizedArabicQuery = normalizeQuranArabicSearchText(rawQuery);
    final queryTokens = tokenizeQuranSearchText(rawQuery);
    final arabicTokens = tokenizeQuranArabicSearchText(rawQuery);
    final transliterationForms = buildQuranTransliterationSearchForms(rawQuery);
    final transliterationTokens = tokenizeQuranTransliterationSearchText(
      rawQuery,
    );
    if (normalized.isEmpty) return const [];

    final surahs = getSurahs();
    final results = <QuranSearchResultData>[];

    if (fieldFilter.allowsMatchField(QuranSearchMatchField.surah)) {
      for (final surah in surahs) {
        final transliterated = normalizeQuranSearchText(
          surah.transliteratedName,
        );
        final english = normalizeQuranSearchText(surah.englishName);
        final arabic = normalizeQuranArabicSearchText(surah.arabicName);
        final queryDigits = normalized.replaceAll(RegExp(r'[^0-9]'), '');
        final score = _surahMatchScore(
          transliterated: transliterated,
          english: english,
          arabic: arabic,
          queryNormalized: normalized,
          queryArabic: normalizedArabicQuery,
          queryDigits: queryDigits,
          surahNumber: surah.number,
        );
        if (score > 0) {
          final displayText =
              '${surah.transliteratedName} • ${surah.englishName} • ${surah.arabicName}';
          final metadata = buildQuranSearchPresentationMetadata(
            field: QuranSearchMatchField.surah,
            query: rawQuery,
            sourceText: displayText,
          );
          results.add(
            QuranSearchResultData(
              surah: surah,
              ayahNumber: null,
              matchText: displayText,
              arabicText: null,
              translationText: null,
              transliterationText: null,
              matchField: QuranSearchMatchField.surah,
              snippetText: metadata.snippetText,
              highlightTerms: metadata.highlightTerms,
              score: score,
            ),
          );
        }
      }
    }

    final verseRows = _searchIndexByTranslation.putIfAbsent(
      translationCode,
      () => _buildSearchIndex(translationCode),
    );

    for (final row in verseRows) {
      final score = _verseMatchScore(
        normalizedQuery: normalized,
        normalizedArabicQuery: normalizedArabicQuery,
        queryTokens: queryTokens,
        arabicTokens: arabicTokens,
        transliterationForms: transliterationForms,
        transliterationTokens: transliterationTokens,
        row: row,
        fieldFilter: fieldFilter,
      );
      if (score.score > 0 && score.field != null) {
        final surah = surahs[row.surahNumber - 1];
        final matchedSource = switch (score.field!) {
          QuranSearchMatchField.translation => row.translation,
          QuranSearchMatchField.transliteration => row.transliteration,
          QuranSearchMatchField.arabic => row.arabic,
          QuranSearchMatchField.surah =>
            '${surah.transliteratedName} • ${surah.englishName} • ${surah.arabicName}',
        };
        final metadata = buildQuranSearchPresentationMetadata(
          field: score.field!,
          query: rawQuery,
          sourceText: matchedSource,
        );
        results.add(
          QuranSearchResultData(
            surah: surah,
            ayahNumber: row.ayahNumber,
            matchText: matchedSource,
            arabicText: row.arabic,
            translationText: row.translation,
            transliterationText: row.transliteration,
            matchField: score.field!,
            snippetText: metadata.snippetText,
            highlightTerms: metadata.highlightTerms,
            score: score.score,
          ),
        );
      }
    }
    results.sort((a, b) {
      final byScore = b.score.compareTo(a.score);
      if (byScore != 0) return byScore;
      final bySurah = a.surah.number.compareTo(b.surah.number);
      if (bySurah != 0) return bySurah;
      return (a.ayahNumber ?? 0).compareTo(b.ayahNumber ?? 0);
    });
    return results.take(maxResults).toList();
  }

  (int, int) randomAyah() {
    final rnd = Random();
    final surah = rnd.nextInt(q.totalSurahCount) + 1;
    final ayah = rnd.nextInt(q.getVerseCount(surah)) + 1;
    return (surah, ayah);
  }

  List<_VerseSearchRow> _buildSearchIndex(String translationCode) {
    final translation = _translationForCode(translationCode);
    final rows = <_VerseSearchRow>[];
    for (var surah = 1; surah <= q.totalSurahCount; surah++) {
      final count = q.getVerseCount(surah);
      final normalizedSurahTransliterated = normalizeQuranSearchText(
        q.getSurahName(surah),
      );
      final normalizedSurahEnglish = normalizeQuranSearchText(
        q.getSurahNameEnglish(surah),
      );
      final transliterationRows = quranTransliterationLocalData[surah];
      for (var ayah = 1; ayah <= count; ayah++) {
        final arabic = q.getVerse(surah, ayah);
        final translated = q.getVerseTranslation(
          surah,
          ayah,
          translation: translation,
        );
        final transliteration = ayah - 1 < (transliterationRows?.length ?? 0)
            ? transliterationRows![ayah - 1]
            : '';
        final normalizedTranslation = normalizeQuranSearchText(translated);
        final normalizedArabic = normalizeQuranArabicSearchText(arabic);
        final normalizedTransliteration =
            normalizeQuranTransliterationSearchText(transliteration);
        final translationTokens = normalizedTranslation.isEmpty
            ? const <String>{}
            : normalizedTranslation.split(' ').toSet();
        final arabicTokens = normalizedArabic.isEmpty
            ? const <String>{}
            : normalizedArabic.split(' ').toSet();
        final transliterationTokens = normalizedTransliteration.isEmpty
            ? const <String>{}
            : normalizedTransliteration.split(' ').toSet();
        final transliterationForms = buildQuranTransliterationSearchForms(
          transliteration,
        );
        rows.add(
          _VerseSearchRow(
            surahNumber: surah,
            ayahNumber: ayah,
            arabic: arabic,
            translation: translated,
            transliteration: transliteration,
            normalizedCombinedText: combineQuranSearchFields([
              normalizedSurahTransliterated,
              normalizedSurahEnglish,
              surah.toString(),
              normalizedTranslation,
              normalizedTransliteration,
              ...transliterationForms,
            ]),
            normalizedArabic: normalizedArabic,
            normalizedTranslation: normalizedTranslation,
            normalizedTransliteration: normalizedTransliteration,
            translationTokens: translationTokens,
            arabicTokens: arabicTokens,
            transliterationTokens: transliterationTokens,
            transliterationForms: transliterationForms,
          ),
        );
      }
    }
    return rows;
  }

  (int, int) _verseLocationFromGlobalIndex(int zeroBased) {
    var cursor = zeroBased;
    for (var surah = 1; surah <= q.totalSurahCount; surah++) {
      final count = q.getVerseCount(surah);
      if (cursor < count) {
        return (surah, cursor + 1);
      }
      cursor -= count;
    }
    return (1, 1);
  }

  q.Translation _translationForCode(String code) {
    switch (code) {
      case 'en.sahih':
        return q.Translation.enSaheeh;
      case 'en.clear':
        return q.Translation.enClearQuran;
      case 'ur.urdu':
        return q.Translation.urdu;
      case 'bn.bengali':
        return q.Translation.bengali;
      case 'id.indonesian':
        return q.Translation.indonesian;
      case 'tr.saheeh':
        return q.Translation.trSaheeh;
      case 'fa.dari':
        return q.Translation.faHusseinDari;
      default:
        return q.Translation.enSaheeh;
    }
  }

  int _surahMatchScore({
    required String transliterated,
    required String english,
    required String arabic,
    required String queryNormalized,
    required String queryArabic,
    required String queryDigits,
    required int surahNumber,
  }) {
    var score = 0;
    if (queryDigits.isNotEmpty && surahNumber.toString() == queryDigits) {
      score += 120;
    }
    if (transliterated.startsWith(queryNormalized)) {
      score += 100;
    } else if (transliterated.contains(queryNormalized)) {
      score += 70;
    }
    if (english.startsWith(queryNormalized)) {
      score += 90;
    } else if (english.contains(queryNormalized)) {
      score += 65;
    }
    if (queryArabic.isNotEmpty) {
      if (arabic == queryArabic) {
        score += 140;
      } else if (arabic.startsWith(queryArabic)) {
        score += 125;
      } else if (arabic.contains(queryArabic)) {
        score += 110;
      }
    }
    return score;
  }

  _MatchScore _verseMatchScore({
    required String normalizedQuery,
    required String normalizedArabicQuery,
    required List<String> queryTokens,
    required List<String> arabicTokens,
    required Set<String> transliterationForms,
    required List<String> transliterationTokens,
    required _VerseSearchRow row,
    required QuranSearchFieldFilter fieldFilter,
  }) {
    final isSingleTokenQuery = queryTokens.length == 1;
    final isPhraseQuery = queryTokens.length > 1;
    final hasExactWordMatch =
        isSingleTokenQuery && row.translationTokens.contains(normalizedQuery);
    final hasAllWordMatches =
        queryTokens.isNotEmpty &&
        queryTokens.every(row.translationTokens.contains);
    final isSingleArabicTokenQuery = arabicTokens.length == 1;
    final isArabicPhraseQuery = arabicTokens.length > 1;
    final hasExactArabicWordMatch =
        isSingleArabicTokenQuery &&
        row.arabicTokens.contains(normalizedArabicQuery);
    final hasAllArabicWordMatches =
        arabicTokens.isNotEmpty &&
        arabicTokens.every(row.arabicTokens.contains);
    var translationScore = 0;
    var arabicScore = 0;
    var transliterationScore = 0;

    if (row.normalizedTranslation == normalizedQuery) {
      translationScore += 240;
    } else if (isPhraseQuery &&
        row.normalizedTranslation.startsWith(normalizedQuery)) {
      translationScore += 200;
    } else if (row.normalizedTranslation.startsWith(normalizedQuery)) {
      translationScore += 150;
    } else if (isPhraseQuery &&
        row.normalizedTranslation.contains(normalizedQuery)) {
      translationScore += 140;
    } else if (row.normalizedTranslation.contains(normalizedQuery)) {
      translationScore += 80;
    }
    if (hasExactWordMatch) {
      translationScore += 120;
    }
    if (hasAllWordMatches) {
      translationScore += 70 + (queryTokens.length * 10);
    }
    if (normalizedArabicQuery.isNotEmpty) {
      if (row.normalizedArabic == normalizedArabicQuery) {
        arabicScore += 280;
      } else if (isArabicPhraseQuery &&
          row.normalizedArabic.startsWith(normalizedArabicQuery)) {
        arabicScore += 240;
      } else if (row.normalizedArabic.startsWith(normalizedArabicQuery)) {
        arabicScore += 200;
      } else if (isArabicPhraseQuery &&
          row.normalizedArabic.contains(normalizedArabicQuery)) {
        arabicScore += 180;
      } else if (row.normalizedArabic.contains(normalizedArabicQuery)) {
        arabicScore += 120;
      }
    }
    if (hasExactArabicWordMatch) {
      arabicScore += 140;
    }
    if (hasAllArabicWordMatches) {
      arabicScore += 80 + (arabicTokens.length * 12);
    }
    final primaryTransliterationQuery = transliterationForms.isEmpty
        ? ''
        : transliterationForms.first;
    final hasExactTransliterationWordMatch =
        transliterationTokens.length == 1 &&
        row.transliterationTokens.contains(primaryTransliterationQuery);
    final hasAllTransliterationWordMatches =
        transliterationTokens.isNotEmpty &&
        transliterationTokens.every(row.transliterationTokens.contains);
    if (transliterationForms.isNotEmpty) {
      if (row.transliterationForms.any(transliterationForms.contains)) {
        transliterationScore += 210;
      } else if (row.normalizedTransliteration == primaryTransliterationQuery) {
        transliterationScore += 180;
      } else if (row.transliterationForms.any(
        (form) => transliterationForms.any(form.startsWith),
      )) {
        transliterationScore += 150;
      } else if (transliterationTokens.length > 1 &&
          primaryTransliterationQuery.isNotEmpty &&
          row.normalizedTransliteration.contains(primaryTransliterationQuery)) {
        transliterationScore += 110;
      }
    }
    if (hasExactTransliterationWordMatch) {
      transliterationScore += 90;
    }
    if (hasAllTransliterationWordMatches) {
      transliterationScore += 60 + (transliterationTokens.length * 8);
    }

    if (!fieldFilter.allowsMatchField(QuranSearchMatchField.translation)) {
      translationScore = 0;
    }
    if (!fieldFilter.allowsMatchField(QuranSearchMatchField.arabic)) {
      arabicScore = 0;
    }
    if (!fieldFilter.allowsMatchField(QuranSearchMatchField.transliteration)) {
      transliterationScore = 0;
    }

    if (translationScore > 0 &&
        row.normalizedCombinedText.contains(normalizedQuery)) {
      translationScore += 30;
    }
    if (transliterationScore > 0 &&
        row.normalizedCombinedText.contains(normalizedQuery)) {
      transliterationScore += 20;
    }

    final candidates = <_MatchScore>[
      _MatchScore(
        score: translationScore,
        field: QuranSearchMatchField.translation,
      ),
      _MatchScore(score: arabicScore, field: QuranSearchMatchField.arabic),
      _MatchScore(
        score: transliterationScore,
        field: QuranSearchMatchField.transliteration,
      ),
    ]..sort((a, b) => b.score.compareTo(a.score));

    final best = candidates.first;
    if (best.score <= 0) {
      return const _MatchScore(score: 0, field: null);
    }
    return best;
  }
}

class QuranSearchResultData {
  const QuranSearchResultData({
    required this.surah,
    required this.ayahNumber,
    required this.matchText,
    required this.arabicText,
    required this.translationText,
    required this.transliterationText,
    required this.matchField,
    required this.snippetText,
    required this.highlightTerms,
    required this.score,
  });

  final QuranSurah surah;
  final int? ayahNumber;
  final String matchText;
  final String? arabicText;
  final String? translationText;
  final String? transliterationText;
  final QuranSearchMatchField matchField;
  final String snippetText;
  final List<String> highlightTerms;
  final int score;
}

class _MatchScore {
  const _MatchScore({required this.score, required this.field});

  final int score;
  final QuranSearchMatchField? field;
}

class _VerseSearchRow {
  const _VerseSearchRow({
    required this.surahNumber,
    required this.ayahNumber,
    required this.arabic,
    required this.translation,
    required this.transliteration,
    required this.normalizedCombinedText,
    required this.normalizedArabic,
    required this.normalizedTranslation,
    required this.normalizedTransliteration,
    required this.translationTokens,
    required this.arabicTokens,
    required this.transliterationTokens,
    required this.transliterationForms,
  });

  final int surahNumber;
  final int ayahNumber;
  final String arabic;
  final String translation;
  final String transliteration;
  final String normalizedCombinedText;
  final String normalizedArabic;
  final String normalizedTranslation;
  final String normalizedTransliteration;
  final Set<String> translationTokens;
  final Set<String> arabicTokens;
  final Set<String> transliterationTokens;
  final Set<String> transliterationForms;
}
