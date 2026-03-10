import 'dart:math';

import 'package:quran/quran.dart' as q;

import '../domain/quran_ayah.dart';
import '../domain/quran_daily_verse.dart';
import '../domain/quran_surah.dart';

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
        transliteration: null,
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

    return QuranDailyVerse(
      surahNumber: surahNumber,
      ayahNumber: ayahNumber,
      arabic: q.getVerse(surahNumber, ayahNumber),
      translation: q.getVerseTranslation(
        surahNumber,
        ayahNumber,
        translation: translation,
      ),
      transliteration: '',
      locationLabel: '${q.getSurahName(surahNumber)} $surahNumber:$ayahNumber',
    );
  }

  List<QuranSearchResultData> search(
    String query, {
    required String translationCode,
    int maxResults = 80,
  }) {
    final rawQuery = query.trim();
    final normalized = _normalizeForSearch(rawQuery);
    if (normalized.isEmpty) return const [];

    final surahs = getSurahs();
    final results = <QuranSearchResultData>[];

    for (final surah in surahs) {
      final transliterated = _normalizeForSearch(surah.transliteratedName);
      final english = _normalizeForSearch(surah.englishName);
      final arabic = _normalizeArabicForSearch(surah.arabicName);
      final queryArabic = _normalizeArabicForSearch(rawQuery);
      final queryDigits = normalized.replaceAll(RegExp(r'[^0-9]'), '');
      final score = _surahMatchScore(
        transliterated: transliterated,
        english: english,
        arabic: arabic,
        queryNormalized: normalized,
        queryArabic: queryArabic,
        queryDigits: queryDigits,
        surahNumber: surah.number,
      );
      if (score > 0) {
        results.add(
          QuranSearchResultData(
            surah: surah,
            ayahNumber: null,
            matchText: '${surah.transliteratedName} • ${surah.englishName}',
            score: score,
          ),
        );
      }
    }

    final verseRows = _searchIndexByTranslation.putIfAbsent(
      translationCode,
      () => _buildSearchIndex(translationCode),
    );

    for (final row in verseRows) {
      final score = _verseMatchScore(
        normalizedQuery: normalized,
        normalizedArabicQuery: _normalizeArabicForSearch(rawQuery),
        row: row,
      );
      if (score > 0) {
        final surah = surahs[row.surahNumber - 1];
        results.add(
          QuranSearchResultData(
            surah: surah,
            ayahNumber: row.ayahNumber,
            matchText: row.translation,
            score: score,
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
      for (var ayah = 1; ayah <= count; ayah++) {
        final arabic = q.getVerse(surah, ayah);
        final translated = q.getVerseTranslation(
          surah,
          ayah,
          translation: translation,
        );
        rows.add(
          _VerseSearchRow(
            surahNumber: surah,
            ayahNumber: ayah,
            translation: translated,
            searchBlob:
                '${_normalizeForSearch(q.getSurahName(surah))} '
                '${_normalizeForSearch(q.getSurahNameEnglish(surah))} '
                '${surah.toString()} '
                '${_normalizeArabicForSearch(arabic)} '
                '${_normalizeForSearch(translated)}',
            normalizedArabic: _normalizeArabicForSearch(arabic),
            normalizedTranslation: _normalizeForSearch(translated),
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
    if (queryArabic.isNotEmpty && arabic.contains(queryArabic)) {
      score += 110;
    }
    return score;
  }

  int _verseMatchScore({
    required String normalizedQuery,
    required String normalizedArabicQuery,
    required _VerseSearchRow row,
  }) {
    var score = 0;
    if (row.normalizedTranslation.startsWith(normalizedQuery)) {
      score += 95;
    } else if (row.normalizedTranslation.contains(normalizedQuery)) {
      score += 60;
    }
    if (normalizedArabicQuery.isNotEmpty &&
        row.normalizedArabic.contains(normalizedArabicQuery)) {
      score += 105;
    }
    if (row.searchBlob.contains(normalizedQuery)) {
      score += 30;
    }
    return score;
  }

  String _normalizeForSearch(String value) {
    return _normalizeArabicForSearch(
      value,
    ).toLowerCase().replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  String _normalizeArabicForSearch(String value) {
    return value
        // tashkeel and Quranic marks
        .replaceAll(RegExp(r'[\u064B-\u065F\u0670\u06D6-\u06ED]'), '')
        .replaceAll('ـ', '')
        // unify hamza/alef forms
        .replaceAll('أ', 'ا')
        .replaceAll('إ', 'ا')
        .replaceAll('آ', 'ا')
        .replaceAll('ٱ', 'ا')
        .replaceAll('ؤ', 'و')
        .replaceAll('ئ', 'ي')
        .replaceAll('ى', 'ي')
        .replaceAll('ة', 'ه');
  }
}

class QuranSearchResultData {
  const QuranSearchResultData({
    required this.surah,
    required this.ayahNumber,
    required this.matchText,
    required this.score,
  });

  final QuranSurah surah;
  final int? ayahNumber;
  final String matchText;
  final int score;
}

class _VerseSearchRow {
  const _VerseSearchRow({
    required this.surahNumber,
    required this.ayahNumber,
    required this.translation,
    required this.searchBlob,
    required this.normalizedArabic,
    required this.normalizedTranslation,
  });

  final int surahNumber;
  final int ayahNumber;
  final String translation;
  final String searchBlob;
  final String normalizedArabic;
  final String normalizedTranslation;
}
