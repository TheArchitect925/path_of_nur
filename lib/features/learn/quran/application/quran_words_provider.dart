import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/persistence/local_store.dart';
import '../domain/quran_core_word.dart';

const _quranWordsMasteredKey = 'learn.quran.words.mastered';

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
