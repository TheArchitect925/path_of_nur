import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/persistence/local_store.dart';
import '../application/quran_providers.dart';
import '../data/quran_word_glossary.dart';
import '../domain/quran_content_refs.dart';
import '../domain/quran_core_word.dart';

const _quranWordsMasteredKey = 'learn.quran.words.mastered';
final RegExp _quranWordDiacriticsRegex = RegExp(
  r'[\u0610-\u061A\u064B-\u065F\u0670\u06D6-\u06ED\u0640]',
);

final quranCoreWordsProvider = FutureProvider<List<QuranCoreWord>>((ref) async {
  final raw = await rootBundle.loadString(
    'assets/data/quran_top_words_curated.json',
  );
  final decoded = jsonDecode(raw);
  if (decoded is! List) return const [];
  return decoded
      .whereType<Map>()
      .map((item) => item.map((k, v) => MapEntry(k.toString(), v)))
      .map(QuranCoreWord.fromJson)
      .where((item) => item.rank > 0)
      .toList()
    ..sort((a, b) => a.rank.compareTo(b.rank));
});

/// Reader-facing glossary: the curated top-words dataset keyed by its
/// normalized form, with the hand-written glossary entries layered on top.
/// The reader shows a gloss chip only for words this map knows.
final quranWordGlossaryProvider = FutureProvider<Map<String, QuranWordGloss>>((
  ref,
) async {
  final words = await ref.watch(quranCoreWordsProvider.future);
  final map = <String, QuranWordGloss>{};
  for (final word in words) {
    final key = normalizeQuranWordForGlossary(word.arabic);
    if (key.isEmpty) continue;
    map.putIfAbsent(
      key,
      () => QuranWordGloss(
        arabic: word.arabic,
        gloss: word.meaning,
        transliteration: word.transliteration,
      ),
    );
  }
  map.addAll(curatedGlossaryOverrides);
  return Map.unmodifiable(map);
});

class QuranWordUsageSummary {
  const QuranWordUsageSummary({
    required this.word,
    required this.occurrenceRefs,
  });

  final QuranCoreWord word;
  final List<QuranQuoteRef> occurrenceRefs;

  QuranQuoteRef? get exampleRef =>
      occurrenceRefs.isEmpty ? null : occurrenceRefs.first;

  int get ayahCount => occurrenceRefs.length;
}

String normalizeQuranWordToken(String text) {
  final normalized = text
      .trim()
      .replaceAll(_quranWordDiacriticsRegex, '')
      .replaceAll('ٱ', 'ا')
      .replaceAll('أ', 'ا')
      .replaceAll('إ', 'ا')
      .replaceAll('آ', 'ا')
      .replaceAll('ى', 'ي')
      .replaceAll('ؤ', 'و')
      .replaceAll('ئ', 'ي');
  return normalized;
}

List<String> tokenizeQuranArabicWords(String arabicAyahText) {
  return arabicAyahText
      .split(RegExp(r'\s+'))
      .map(normalizeQuranWordToken)
      .where((token) => token.isNotEmpty)
      .toList(growable: false);
}

final quranTopWordUsageIndexProvider =
    FutureProvider<Map<int, QuranWordUsageSummary>>((ref) async {
      final words = await ref.watch(quranCoreWordsProvider.future);
      final translationCode = ref.watch(
        quranReaderSettingsProvider.select((state) => state.translationCode),
      );
      final repository = ref.watch(quranRepositoryProvider);

      final targetRanksByToken = <String, List<int>>{};
      final wordsByRank = <int, QuranCoreWord>{};
      for (final word in words) {
        wordsByRank[word.rank] = word;
        final normalized = normalizeQuranWordToken(word.arabic);
        if (normalized.isEmpty) continue;
        targetRanksByToken
            .putIfAbsent(normalized, () => <int>[])
            .add(word.rank);
      }

      final refsByRank = <int, List<QuranQuoteRef>>{
        for (final word in words) word.rank: <QuranQuoteRef>[],
      };

      final totalSurahs = repository.getSurahs().length;
      for (var surahNumber = 1; surahNumber <= totalSurahs; surahNumber++) {
        final ayahs = repository.getAyahsForSurah(
          surahNumber,
          translationCode: translationCode,
        );
        for (final ayah in ayahs) {
          final tokens = tokenizeQuranArabicWords(ayah.arabic);
          final matchedRanks = <int>{};
          for (final token in tokens) {
            final ranks = targetRanksByToken[token];
            if (ranks == null) continue;
            matchedRanks.addAll(ranks);
          }
          if (matchedRanks.isEmpty) continue;
          final refForAyah = QuranQuoteRef(
            surah: ayah.surahNumber,
            ayah: ayah.ayahNumber,
          );
          for (final rank in matchedRanks) {
            refsByRank[rank]!.add(refForAyah);
          }
        }
      }

      return {
        for (final entry in refsByRank.entries)
          if (wordsByRank.containsKey(entry.key))
            entry.key: QuranWordUsageSummary(
              word: wordsByRank[entry.key]!,
              occurrenceRefs: entry.value,
            ),
      };
    });

class QuranWordsProgressState {
  const QuranWordsProgressState({required this.masteredRanks});

  final Set<int> masteredRanks;

  QuranWordsProgressState copyWith({Set<int>? masteredRanks}) {
    return QuranWordsProgressState(
      masteredRanks: masteredRanks ?? this.masteredRanks,
    );
  }
}

class QuranWordsProgressNotifier
    extends StateNotifier<QuranWordsProgressState> {
  QuranWordsProgressNotifier(this._store)
    : super(QuranWordsProgressState(masteredRanks: _loadSet(_store)));

  final LocalStore _store;

  static Set<int> _loadSet(LocalStore store) {
    final list = store.getJsonList(_quranWordsMasteredKey);
    if (list == null) return <int>{};
    final out = <int>{};
    for (final item in list) {
      final value = int.tryParse(item.toString());
      if (value != null && value > 0) out.add(value);
    }
    return out;
  }

  void toggleMastered(int rank) {
    final next = Set<int>.from(state.masteredRanks);
    if (next.contains(rank)) {
      next.remove(rank);
    } else {
      next.add(rank);
    }
    state = state.copyWith(masteredRanks: next);
    _store.setJsonList(_quranWordsMasteredKey, next.toList()..sort());
  }
}

final quranWordsProgressProvider =
    StateNotifierProvider<QuranWordsProgressNotifier, QuranWordsProgressState>(
      (ref) => QuranWordsProgressNotifier(ref.watch(localStoreProvider)),
    );

final quranCoreWordByRankProvider = Provider.family<QuranCoreWord?, int>((
  ref,
  rank,
) {
  final wordsAsync = ref.watch(quranCoreWordsProvider);
  return wordsAsync.valueOrNull?.where((word) => word.rank == rank).firstOrNull;
});
