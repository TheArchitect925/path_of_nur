import 'dart:math' as math;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/application/daily_clock_provider.dart';
import '../../../../shared/persistence/local_store.dart';
import '../../../journey/drops/application/journey_drops_providers.dart';
import '../data/quran_ayah_action_repository.dart';
import '../domain/quran_ayah_action_models.dart';
import '../domain/quran_reference_models.dart';
import 'quran_ayah_explanation_provider.dart';
import 'quran_daily_reflection_provider.dart';
import 'quran_providers.dart';

const _quranAyahActionStateKey = 'learn.quran.ayah_actions.v1';

class QuranAyahActionState {
  const QuranAyahActionState({
    required this.completedAyahKeysByDateKey,
    required this.currentStreak,
    required this.bestStreak,
    required this.lastCompletedDateKey,
  });

  final Map<String, Set<String>> completedAyahKeysByDateKey;
  final int currentStreak;
  final int bestStreak;
  final String? lastCompletedDateKey;

  bool isCompletedForDay({required String dateKey, required String ayahKey}) {
    return completedAyahKeysByDateKey[dateKey]?.contains(ayahKey) ?? false;
  }

  QuranAyahActionState copyWith({
    Map<String, Set<String>>? completedAyahKeysByDateKey,
    int? currentStreak,
    int? bestStreak,
    String? lastCompletedDateKey,
  }) {
    return QuranAyahActionState(
      completedAyahKeysByDateKey:
          completedAyahKeysByDateKey ?? this.completedAyahKeysByDateKey,
      currentStreak: currentStreak ?? this.currentStreak,
      bestStreak: bestStreak ?? this.bestStreak,
      lastCompletedDateKey: lastCompletedDateKey ?? this.lastCompletedDateKey,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'completedAyahKeysByDateKey': <String, List<String>>{
      for (final entry in completedAyahKeysByDateKey.entries)
        entry.key: entry.value.toList(growable: false),
    },
    'currentStreak': currentStreak,
    'bestStreak': bestStreak,
    'lastCompletedDateKey': lastCompletedDateKey,
  };

  static QuranAyahActionState fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const QuranAyahActionState(
        completedAyahKeysByDateKey: <String, Set<String>>{},
        currentStreak: 0,
        bestStreak: 0,
        lastCompletedDateKey: null,
      );
    }
    final completed = <String, Set<String>>{};
    final rawCompleted = json['completedAyahKeysByDateKey'];
    if (rawCompleted is Map) {
      for (final entry in rawCompleted.entries) {
        final dateKey = entry.key.toString();
        if (dateKey.isEmpty) continue;
        final rawList = entry.value is List
            ? entry.value as List
            : const <dynamic>[];
        final ayahKeys = rawList
            .map((item) => item.toString().trim())
            .where((item) => item.isNotEmpty)
            .toSet();
        if (ayahKeys.isNotEmpty) {
          completed[dateKey] = ayahKeys;
        }
      }
    }
    return QuranAyahActionState(
      completedAyahKeysByDateKey: completed,
      currentStreak: (json['currentStreak'] as num?)?.toInt() ?? 0,
      bestStreak: (json['bestStreak'] as num?)?.toInt() ?? 0,
      lastCompletedDateKey: json['lastCompletedDateKey']?.toString(),
    );
  }
}

class QuranAyahActionController extends StateNotifier<QuranAyahActionState> {
  QuranAyahActionController(this._ref)
    : _store = _ref.read(localStoreProvider),
      super(
        QuranAyahActionState.fromJson(
          _ref.read(localStoreProvider).getJsonMap(_quranAyahActionStateKey),
        ),
      );

  final Ref _ref;
  final LocalStore _store;

  static const int historyRetentionDays = 120;

  void _persist() {
    _store.setJsonMap(_quranAyahActionStateKey, state.toJson());
  }

  bool completeAction(QuranAyahAction action, {DateTime? now}) {
    final occurredAt = now ?? DateTime.now();
    final dateKey = LocalStore.todayKey(occurredAt);
    if (state.isCompletedForDay(dateKey: dateKey, ayahKey: action.ayahKey)) {
      return false;
    }

    final nextCompleted = <String, Set<String>>{
      for (final entry in state.completedAyahKeysByDateKey.entries)
        entry.key: Set<String>.from(entry.value),
    };
    nextCompleted.putIfAbsent(dateKey, () => <String>{}).add(action.ayahKey);

    final trimmed = _trimHistory(nextCompleted, now: occurredAt);
    final streak = _computeStreak(trimmed, occurredAt);
    final best = math.max(state.bestStreak, streak);

    state = state.copyWith(
      completedAyahKeysByDateKey: trimmed,
      currentStreak: streak,
      bestStreak: best,
      lastCompletedDateKey: dateKey,
    );
    _persist();

    _ref
        .read(quranReadingProgressProvider.notifier)
        .touchLocation(
          surahNumber: action.surahNumber,
          ayahNumber: action.ayahNumber,
        );

    _ref
        .read(journeyDropSummaryProvider.notifier)
        .awardQuranDrop(
          sourceRef: 'quran_ayah_action:$dateKey:${action.ayahKey}',
          occurredAt: occurredAt,
          metadata: <String, Object?>{
            'surah': action.surahNumber,
            'ayah': action.ayahNumber,
            'category': action.category.name,
            'difficulty': action.difficulty.name,
            'rewardDrops': action.rewardDrops,
            'surface': 'ayah_action',
            'tags': action.tags,
          },
        );

    return true;
  }

  Map<String, Set<String>> _trimHistory(
    Map<String, Set<String>> source, {
    required DateTime now,
  }) {
    final threshold = DateTime(
      now.year,
      now.month,
      now.day,
    ).subtract(const Duration(days: historyRetentionDays));
    final trimmed = <String, Set<String>>{};
    for (final entry in source.entries) {
      final date = DateTime.tryParse(entry.key);
      if (date == null || date.isBefore(threshold) || entry.value.isEmpty) {
        continue;
      }
      trimmed[entry.key] = entry.value;
    }
    return trimmed;
  }

  int _computeStreak(Map<String, Set<String>> completed, DateTime now) {
    if (completed.isEmpty) return 0;
    var streak = 0;
    var cursor = DateTime(now.year, now.month, now.day);
    while ((completed[LocalStore.todayKey(cursor)]?.isNotEmpty ?? false)) {
      streak += 1;
      cursor = cursor.subtract(const Duration(days: 1));
    }
    return streak;
  }
}

final quranAyahActionRepositoryProvider = Provider<QuranAyahActionRepository>((
  ref,
) {
  return const QuranAyahActionRepository();
});

final quranAyahActionStateProvider =
    StateNotifierProvider<QuranAyahActionController, QuranAyahActionState>((
      ref,
    ) {
      return QuranAyahActionController(ref);
    });

final quranAyahActionProvider =
    Provider.family<
      QuranAyahAction?,
      (int surah, int ayah, String languageCode, bool preferKids)
    >((ref, input) {
      final entry = ref.watch(
        quranAyahExplanationEntryProvider((input.$1, input.$2)),
      );
      if (entry == null) return null;
      return ref
          .watch(quranAyahActionRepositoryProvider)
          .actionForEntry(entry, languageCode: input.$3, preferKids: input.$4);
    });

final quranAyahActionsForSurahProvider =
    Provider.family<
      Map<int, QuranAyahAction>,
      (int surah, String languageCode, bool preferKids)
    >((ref, input) {
      final entries = ref.watch(
        quranAyahExplanationsForSurahProvider(input.$1),
      );
      final repository = ref.watch(quranAyahActionRepositoryProvider);
      final actions = <int, QuranAyahAction>{};
      for (final entry in entries) {
        final action = repository.actionForEntry(
          entry,
          languageCode: input.$2,
          preferKids: input.$3,
        );
        if (action != null) {
          actions[entry.ayahNumber] = action;
        }
      }
      return Map<int, QuranAyahAction>.unmodifiable(actions);
    });

final quranAyahActionRecommendationProvider =
    Provider.family<
      QuranAyahActionRecommendation?,
      (int surah, int ayah, String languageCode, bool preferKids)
    >((ref, input) {
      final action = ref.watch(
        quranAyahActionProvider((input.$1, input.$2, input.$3, input.$4)),
      );
      if (action == null) return null;
      final explanation = ref.watch(
        quranResolvedAyahExplanationProvider((
          input.$1,
          input.$2,
          input.$4
              ? QuranExplanationDetailLevel.kids
              : QuranExplanationDetailLevel.standard,
          input.$3,
        )),
      );
      final dateKey = LocalStore.todayKey(
        ref.watch(dailyNowProvider).value ?? DateTime.now(),
      );
      return QuranAyahActionRecommendation(
        action: action,
        explanationPreview:
            explanation?.previewText ??
            explanation?.body ??
            action.localizedActionText(input.$3),
        explanationBody:
            explanation?.body ?? action.localizedActionText(input.$3),
        isCompletedToday: ref.watch(
          quranAyahActionStateProvider.select(
            (state) => state.isCompletedForDay(
              dateKey: dateKey,
              ayahKey: action.ayahKey,
            ),
          ),
        ),
        score: 0,
        isDailyAnchor: false,
        isRecentReading: false,
        isFoundational: false,
      );
    });

final quranAyahActionRecommendationsForSurahProvider =
    Provider.family<
      Map<int, QuranAyahActionRecommendation>,
      (int surah, String languageCode, bool preferKids)
    >((ref, input) {
      final actions = ref.watch(
        quranAyahActionsForSurahProvider((input.$1, input.$2, input.$3)),
      );
      final explanations = ref.watch(
        quranResolvedAyahExplanationsForSurahProvider((
          input.$1,
          input.$3
              ? QuranExplanationDetailLevel.kids
              : QuranExplanationDetailLevel.standard,
          input.$2,
        )),
      );
      final state = ref.watch(quranAyahActionStateProvider);
      final dateKey = LocalStore.todayKey(
        ref.watch(dailyNowProvider).value ?? DateTime.now(),
      );
      final recommendations = <int, QuranAyahActionRecommendation>{};
      for (final entry in actions.entries) {
        final explanation = explanations[entry.key];
        recommendations[entry.key] = QuranAyahActionRecommendation(
          action: entry.value,
          explanationPreview:
              explanation?.previewText ??
              explanation?.body ??
              entry.value.localizedActionText(input.$2),
          explanationBody:
              explanation?.body ?? entry.value.localizedActionText(input.$2),
          isCompletedToday: state.isCompletedForDay(
            dateKey: dateKey,
            ayahKey: entry.value.ayahKey,
          ),
          score: 0,
          isDailyAnchor: false,
          isRecentReading: false,
          isFoundational: false,
        );
      }
      return Map<int, QuranAyahActionRecommendation>.unmodifiable(
        recommendations,
      );
    });

final quranDailyAyahActionRecommendationsProvider =
    Provider<List<QuranAyahActionRecommendation>>((ref) {
      final now = ref.watch(dailyNowProvider).value ?? DateTime.now();
      final dateKey = LocalStore.todayKey(now);
      final languageCode = 'en';
      final dailySummary = ref.watch(quranDailyReflectionSummaryProvider);
      final recentReadings = ref.watch(quranRecentReadingsProvider);
      final actionState = ref.watch(quranAyahActionStateProvider);
      final explanationRepository = ref.watch(
        quranAyahExplanationRepositoryProvider,
      );
      final actionRepository = ref.watch(quranAyahActionRepositoryProvider);

      final orderedKeys = <String>[];
      void addKey(int surah, int ayah) {
        final key = '$surah:$ayah';
        if (!orderedKeys.contains(key)) {
          orderedKeys.add(key);
        }
      }

      addKey(
        dailySummary.assignment.entry.ref.surah,
        dailySummary.assignment.entry.ref.ayah,
      );
      for (final reading in recentReadings.take(6)) {
        addKey(reading.surahNumber, reading.ayahNumber);
      }
      for (final fallback in _foundationalFallbackAyahs) {
        addKey(fallback.$1, fallback.$2);
      }

      final recommendations = <QuranAyahActionRecommendation>[];
      for (var index = 0; index < orderedKeys.length; index += 1) {
        final key = orderedKeys[index];
        final parts = key.split(':');
        if (parts.length != 2) continue;
        final surah = int.tryParse(parts.first);
        final ayah = int.tryParse(parts.last);
        if (surah == null || ayah == null) continue;
        final entry = explanationRepository.getExplanation(
          surahNumber: surah,
          ayahNumber: ayah,
        );
        if (entry == null) continue;
        final action = actionRepository.actionForEntry(
          entry,
          languageCode: languageCode,
        );
        if (action == null) continue;
        final explanation =
            entry.resolve(
              QuranExplanationDetailLevel.standard,
              languageCode: languageCode,
            ) ??
            entry.resolve(
              QuranExplanationDetailLevel.simple,
              languageCode: languageCode,
            );
        final isDailyAnchor =
            surah == dailySummary.assignment.entry.ref.surah &&
            ayah == dailySummary.assignment.entry.ref.ayah;
        final isRecentReading = recentReadings.any(
          (reading) =>
              reading.surahNumber == surah && reading.ayahNumber == ayah,
        );
        final isFoundational = _foundationalFallbackAyahs.contains((
          surah,
          ayah,
        ));
        final isCompletedToday = actionState.isCompletedForDay(
          dateKey: dateKey,
          ayahKey: action.ayahKey,
        );
        final score =
            (isDailyAnchor ? 100 : 0) +
            (isRecentReading ? 45 : 0) +
            (isFoundational ? 25 : 0) +
            (isCompletedToday ? -30 : 10) +
            math.max(0, 8 - index).toInt();
        recommendations.add(
          QuranAyahActionRecommendation(
            action: action,
            explanationPreview:
                explanation?.previewText ??
                explanation?.body ??
                action.localizedActionText(languageCode),
            explanationBody:
                explanation?.body ?? action.localizedActionText(languageCode),
            isCompletedToday: isCompletedToday,
            score: score,
            isDailyAnchor: isDailyAnchor,
            isRecentReading: isRecentReading,
            isFoundational: isFoundational,
          ),
        );
      }

      recommendations.sort((a, b) {
        final byScore = b.score.compareTo(a.score);
        if (byScore != 0) return byScore;
        return a.action.ayahKey.compareTo(b.action.ayahKey);
      });
      return recommendations.take(3).toList(growable: false);
    });

final quranPrimaryDailyAyahActionRecommendationProvider =
    Provider<QuranAyahActionRecommendation?>((ref) {
      final recommendations = ref.watch(
        quranDailyAyahActionRecommendationsProvider,
      );
      return recommendations.isEmpty ? null : recommendations.first;
    });

const List<(int, int)> _foundationalFallbackAyahs = <(int, int)>[
  (1, 1),
  (1, 5),
  (1, 6),
  (2, 255),
  (96, 1),
  (99, 7),
  (99, 8),
  (103, 3),
  (112, 1),
  (113, 1),
  (114, 1),
];
