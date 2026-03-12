import 'dart:math' as math;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/persistence/local_store.dart';
import '../data/seeded_quran_learning_data.dart';
import '../domain/quran_learning_models.dart';

const _quranMemorizationProgressKey = 'learn.quran.memorization.progress.v1';

class QuranMemorizationProgressController
    extends StateNotifier<Map<String, MemorizationProgress>> {
  QuranMemorizationProgressController(this._store)
    : super(_loadState(_store.getJsonMap(_quranMemorizationProgressKey)));

  final LocalStore _store;

  static Map<String, MemorizationProgress> _loadState(
    Map<String, dynamic>? json,
  ) {
    if (json == null) return <String, MemorizationProgress>{};
    final output = <String, MemorizationProgress>{};
    for (final entry in json.entries) {
      final parsed = MemorizationProgress.fromJson(
        entry.value as Map<String, dynamic>?,
      );
      if (parsed != null) {
        output[parsed.verseId] = parsed;
      }
    }
    return output;
  }

  void _save() {
    final payload = state.map((key, value) => MapEntry(key, value.toJson()));
    _store.setJsonMap(_quranMemorizationProgressKey, payload);
  }

  MemorizationProgress getOrCreate(String verseId, {DateTime? now}) {
    final existing = state[verseId];
    if (existing != null) return existing;
    final today = _startOfDay(now ?? DateTime.now());
    final created = MemorizationProgress(
      verseId: verseId,
      stage: MemorizationStage.newVerse,
      lastReviewed: null,
      nextReview: today,
      reviewCount: 0,
    );
    state = {...state, verseId: created};
    _save();
    return created;
  }

  void markReviewed(
    String verseId, {
    bool success = true,
    MemorizationStage? targetStage,
    DateTime? now,
  }) {
    final anchor = _startOfDay(now ?? DateTime.now());
    final current = getOrCreate(verseId, now: anchor);

    final nextStage =
        targetStage ?? _nextStage(current.stage, success: success);
    final interval = _nextIntervalDays(
      stage: nextStage,
      reviewCount: current.reviewCount,
      success: success,
    );

    final updated = current.copyWith(
      stage: nextStage,
      lastReviewed: anchor,
      nextReview: anchor.add(Duration(days: interval)),
      reviewCount: current.reviewCount + 1,
    );

    state = {...state, verseId: updated};
    _save();
  }

  MemorizationStage _nextStage(
    MemorizationStage current, {
    required bool success,
  }) {
    if (!success) {
      return current == MemorizationStage.newVerse
          ? MemorizationStage.newVerse
          : MemorizationStage.repeating;
    }

    return switch (current) {
      MemorizationStage.newVerse => MemorizationStage.repeating,
      MemorizationStage.repeating => MemorizationStage.phrasePractice,
      MemorizationStage.phrasePractice => MemorizationStage.hiddenRecall,
      MemorizationStage.hiddenRecall => MemorizationStage.mastered,
      MemorizationStage.mastered => MemorizationStage.mastered,
    };
  }

  int _nextIntervalDays({
    required MemorizationStage stage,
    required int reviewCount,
    required bool success,
  }) {
    if (!success) return 1;
    final stageBase = switch (stage) {
      MemorizationStage.newVerse => 1,
      MemorizationStage.repeating => 2,
      MemorizationStage.phrasePractice => 3,
      MemorizationStage.hiddenRecall => 5,
      MemorizationStage.mastered => 7,
    };
    final growth = math.min(14, (reviewCount / 2).floor());
    return math.min(30, stageBase + growth);
  }

  DateTime _startOfDay(DateTime value) =>
      DateTime(value.year, value.month, value.day);
}

final quranLearningVersesProvider = Provider<List<QuranLearningVerse>>((_) {
  return seededQuranLearningVerses;
});

final quranLearningPathsProvider = Provider<List<QuranLearningPath>>((_) {
  return seededQuranLearningPaths;
});

final quranLearningVerseByIdProvider =
    Provider.family<QuranLearningVerse?, String>((ref, verseId) {
      for (final verse in ref.watch(quranLearningVersesProvider)) {
        if (verse.id == verseId) return verse;
      }
      return null;
    });

final quranMemorizationProgressProvider =
    StateNotifierProvider<
      QuranMemorizationProgressController,
      Map<String, MemorizationProgress>
    >((ref) {
      return QuranMemorizationProgressController(ref.watch(localStoreProvider));
    });

final quranMemorizationDueProvider = Provider<List<MemorizationProgress>>((
  ref,
) {
  final progress = ref.watch(quranMemorizationProgressProvider);
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);

  final due =
      progress.values
          .where((item) {
            final target = DateTime(
              item.nextReview.year,
              item.nextReview.month,
              item.nextReview.day,
            );
            return !target.isAfter(today);
          })
          .toList(growable: false)
        ..sort((a, b) => a.nextReview.compareTo(b.nextReview));

  return due;
});

final quranMemorizationCoverageProvider = Provider<double>((ref) {
  final verses = ref.watch(quranLearningVersesProvider);
  if (verses.isEmpty) return 0;
  final progress = ref.watch(quranMemorizationProgressProvider);
  var started = 0;
  for (final verse in verses) {
    if (progress.containsKey(verse.id)) started += 1;
  }
  return (started / verses.length).clamp(0.0, 1.0);
});

final quranDailyReflectionVerseProvider = Provider<QuranLearningVerse>((ref) {
  final verses = ref.watch(quranLearningVersesProvider);
  final now = DateTime.now();
  final daySeed = now.year * 372 + now.month * 31 + now.day;
  return verses[daySeed % verses.length];
});
