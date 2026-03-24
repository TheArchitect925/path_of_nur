import 'dart:math' as math;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/persistence/local_store.dart';
import '../../../../shared/application/daily_clock_provider.dart';
import '../data/seeded_quran_learning_data.dart';
import '../domain/quran_learning_models.dart';

const _quranMemorizationProgressKey = 'learn.quran.memorization.progress.v1';

String quranMemorizationVerseId({
  required int surahNumber,
  required int ayahNumber,
}) => 'q_${surahNumber}_$ayahNumber';

class QuranMemorizationReference {
  const QuranMemorizationReference({
    required this.verseId,
    required this.surahNumber,
    required this.ayahNumber,
  });

  final String verseId;
  final int surahNumber;
  final int ayahNumber;
}

QuranMemorizationReference? quranMemorizationReferenceFromVerseId(
  String verseId,
) {
  final match = RegExp(r'^q_(\d+)_(\d+)$').firstMatch(verseId);
  if (match == null) return null;
  final surahNumber = int.tryParse(match.group(1) ?? '');
  final ayahNumber = int.tryParse(match.group(2) ?? '');
  if (surahNumber == null || ayahNumber == null) return null;
  return QuranMemorizationReference(
    verseId: verseId,
    surahNumber: surahNumber,
    ayahNumber: ayahNumber,
  );
}

class QuranMemorizationReviewEntry {
  const QuranMemorizationReviewEntry({
    required this.progress,
    required this.surahNumber,
    required this.ayahNumber,
    this.seededVerse,
  });

  final MemorizationProgress progress;
  final int surahNumber;
  final int ayahNumber;
  final QuranLearningVerse? seededVerse;
}

class QuranMemorizationReviewSections {
  const QuranMemorizationReviewSections({
    required this.continueReview,
    required this.reviewToday,
    required this.recentlyMemorized,
    required this.needsRevision,
    required this.allMemorized,
  });

  final List<QuranMemorizationReviewEntry> continueReview;
  final List<QuranMemorizationReviewEntry> reviewToday;
  final List<QuranMemorizationReviewEntry> recentlyMemorized;
  final List<QuranMemorizationReviewEntry> needsRevision;
  final List<QuranMemorizationReviewEntry> allMemorized;
}

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
      addedAt: today,
      lastReviewed: null,
      nextReview: today,
      reviewCount: 0,
      lastReviewSuccessful: null,
    );
    state = {...state, verseId: created};
    _save();
    return created;
  }

  MemorizationProgress toggleVerse({
    required int surahNumber,
    required int ayahNumber,
    DateTime? now,
  }) {
    final verseId = quranMemorizationVerseId(
      surahNumber: surahNumber,
      ayahNumber: ayahNumber,
    );
    final existing = state[verseId];
    if (existing != null) {
      final next = Map<String, MemorizationProgress>.from(state)
        ..remove(verseId);
      state = next;
      _save();
      return existing;
    }
    return getOrCreate(verseId, now: now);
  }

  void remove(String verseId) {
    if (!state.containsKey(verseId)) return;
    final next = Map<String, MemorizationProgress>.from(state)..remove(verseId);
    state = next;
    _save();
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
      lastReviewSuccessful: success,
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

final quranMemorizationEntryForAyahProvider =
    Provider.family<MemorizationProgress?, (int surahNumber, int ayahNumber)>((
      ref,
      key,
    ) {
      final progress = ref.watch(quranMemorizationProgressProvider);
      return progress[quranMemorizationVerseId(
        surahNumber: key.$1,
        ayahNumber: key.$2,
      )];
    });

final quranMemorizationReviewEntriesProvider =
    Provider<List<QuranMemorizationReviewEntry>>((ref) {
      final progress = ref.watch(quranMemorizationProgressProvider);
      final verses = ref.watch(quranLearningVersesProvider);
      final seededById = <String, QuranLearningVerse>{
        for (final verse in verses) verse.id: verse,
      };

      final items = <QuranMemorizationReviewEntry>[];
      for (final entry in progress.values) {
        final seeded = seededById[entry.verseId];
        final reference = seeded == null
            ? quranMemorizationReferenceFromVerseId(entry.verseId)
            : QuranMemorizationReference(
                verseId: entry.verseId,
                surahNumber: seeded.surah,
                ayahNumber: seeded.ayah,
              );
        if (reference == null) continue;
        items.add(
          QuranMemorizationReviewEntry(
            progress: entry,
            surahNumber: reference.surahNumber,
            ayahNumber: reference.ayahNumber,
            seededVerse: seeded,
          ),
        );
      }

      items.sort((a, b) {
        final nextReview = a.progress.nextReview.compareTo(
          b.progress.nextReview,
        );
        if (nextReview != 0) return nextReview;
        final surah = a.surahNumber.compareTo(b.surahNumber);
        if (surah != 0) return surah;
        return a.ayahNumber.compareTo(b.ayahNumber);
      });
      return items;
    });

final quranMemorizationReviewSectionsProvider =
    Provider<QuranMemorizationReviewSections>((ref) {
      final entries = ref.watch(quranMemorizationReviewEntriesProvider);
      final now = ref.watch(dailyNowProvider).value ?? DateTime.now();
      final today = _normalizeReviewDay(now);

      bool isDue(QuranMemorizationReviewEntry entry) {
        final target = _normalizeReviewDay(entry.progress.nextReview);
        return !target.isAfter(today);
      }

      bool isContinueReview(QuranMemorizationReviewEntry entry) {
        final lastReviewed = entry.progress.lastReviewed;
        if (lastReviewed == null || isDue(entry)) return false;
        final daysSinceLastReview = today
            .difference(_normalizeReviewDay(lastReviewed))
            .inDays;
        return daysSinceLastReview <= 3;
      }

      bool isRecentlyMemorized(QuranMemorizationReviewEntry entry) {
        if (isDue(entry) || isContinueReview(entry)) return false;
        final daysSinceAdded = today
            .difference(_normalizeReviewDay(entry.progress.addedAt))
            .inDays;
        return daysSinceAdded <= 5 && entry.progress.reviewCount <= 1;
      }

      bool needsRevision(QuranMemorizationReviewEntry entry) {
        if (isDue(entry)) return false;
        final unsuccessful = entry.progress.lastReviewSuccessful == false;
        final stillEarly =
            entry.progress.reviewCount < 2 &&
            entry.progress.stage == MemorizationStage.repeating;
        return unsuccessful || stillEarly;
      }

      final reviewToday = entries.where(isDue).toList(growable: false);
      final continueReview = entries
          .where((entry) => isContinueReview(entry))
          .toList(growable: false);
      final recentlyMemorized = entries
          .where((entry) => isRecentlyMemorized(entry))
          .toList(growable: false);
      final needsRevisionEntries = entries
          .where((entry) => needsRevision(entry))
          .toList(growable: false);

      return QuranMemorizationReviewSections(
        continueReview: continueReview,
        reviewToday: reviewToday,
        recentlyMemorized: recentlyMemorized,
        needsRevision: needsRevisionEntries,
        allMemorized: entries,
      );
    });

final quranMemorizationStartedCountProvider = Provider<int>((ref) {
  return ref.watch(quranMemorizationReviewEntriesProvider).length;
});

DateTime _normalizeReviewDay(DateTime value) =>
    DateTime(value.year, value.month, value.day);

final quranDailyReflectionVerseProvider = Provider<QuranLearningVerse>((ref) {
  final verses = ref.watch(quranLearningVersesProvider);
  final now = DateTime.now();
  final daySeed = now.year * 372 + now.month * 31 + now.day;
  return verses[daySeed % verses.length];
});
