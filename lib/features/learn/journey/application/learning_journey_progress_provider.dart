import 'dart:math' as math;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../features/ocean/application/ocean_drops_provider.dart';
import '../../../../shared/persistence/local_store.dart';
import '../../../journey/application/journey_progression_provider.dart';
import '../../hadith/application/hadith_daily_reflection_service.dart';
import '../../prophets/application/daily_learning_service.dart';
import '../../quran/application/quran_providers.dart';
import '../../shared/application/learn_system_engine_provider.dart';
import '../../world/application/world_creation_provider.dart';
import '../data/learning_journey_registry.dart';
import '../data/learning_path_registry.dart';
import '../domain/learning_journey_models.dart';
import '../domain/learning_path_models.dart';

const _learningJourneyProgressKey = 'learn.journey.progress.v1';
const _learningPathStateStorageKey = 'learn.path.state.v1';

// Progress uses stable registry IDs instead of display text so learning content
// can evolve safely without invalidating user completion data.

class LearningJourneyProgressState {
  const LearningJourneyProgressState({
    required this.startedJourneyIds,
    required this.completedStageIds,
    required this.completedStageDateKeys,
    required this.lastOpenedJourneyId,
    required this.lastOpenedStageId,
    required this.activeDayKeys,
    required this.todayLightOpenedDayKeys,
    required this.currentStreakDays,
    required this.bestStreakDays,
  });

  final Set<String> startedJourneyIds;
  final Set<String> completedStageIds;
  final Map<String, String> completedStageDateKeys;
  final String? lastOpenedJourneyId;
  final String? lastOpenedStageId;
  final Set<String> activeDayKeys;
  final Set<String> todayLightOpenedDayKeys;
  final int currentStreakDays;
  final int bestStreakDays;

  LearningJourneyProgressState copyWith({
    Set<String>? startedJourneyIds,
    Set<String>? completedStageIds,
    Map<String, String>? completedStageDateKeys,
    String? lastOpenedJourneyId,
    String? lastOpenedStageId,
    bool clearLastOpenedJourneyId = false,
    bool clearLastOpenedStageId = false,
    Set<String>? activeDayKeys,
    Set<String>? todayLightOpenedDayKeys,
    int? currentStreakDays,
    int? bestStreakDays,
  }) {
    return LearningJourneyProgressState(
      startedJourneyIds: startedJourneyIds ?? this.startedJourneyIds,
      completedStageIds: completedStageIds ?? this.completedStageIds,
      completedStageDateKeys:
          completedStageDateKeys ?? this.completedStageDateKeys,
      lastOpenedJourneyId: clearLastOpenedJourneyId
          ? null
          : (lastOpenedJourneyId ?? this.lastOpenedJourneyId),
      lastOpenedStageId: clearLastOpenedStageId
          ? null
          : (lastOpenedStageId ?? this.lastOpenedStageId),
      activeDayKeys: activeDayKeys ?? this.activeDayKeys,
      todayLightOpenedDayKeys:
          todayLightOpenedDayKeys ?? this.todayLightOpenedDayKeys,
      currentStreakDays: currentStreakDays ?? this.currentStreakDays,
      bestStreakDays: bestStreakDays ?? this.bestStreakDays,
    );
  }

  static LearningJourneyProgressState initial() {
    return const LearningJourneyProgressState(
      startedJourneyIds: <String>{},
      completedStageIds: <String>{},
      completedStageDateKeys: <String, String>{},
      lastOpenedJourneyId: null,
      lastOpenedStageId: null,
      activeDayKeys: <String>{},
      todayLightOpenedDayKeys: <String>{},
      currentStreakDays: 0,
      bestStreakDays: 0,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'startedJourneyIds': startedJourneyIds.toList(growable: false),
      'completedStageIds': completedStageIds.toList(growable: false),
      'completedStageDateKeys': completedStageDateKeys,
      'lastOpenedJourneyId': lastOpenedJourneyId,
      'lastOpenedStageId': lastOpenedStageId,
      'activeDayKeys': activeDayKeys.toList(growable: false),
      'todayLightOpenedDayKeys': todayLightOpenedDayKeys.toList(
        growable: false,
      ),
      'currentStreakDays': currentStreakDays,
      'bestStreakDays': bestStreakDays,
    };
  }

  static LearningJourneyProgressState fromJson(Map<String, dynamic>? json) {
    if (json == null) return initial();
    return LearningJourneyProgressState(
      startedJourneyIds: _asStringSet(json['startedJourneyIds']),
      completedStageIds: _asStringSet(json['completedStageIds']),
      completedStageDateKeys: _asStringMap(json['completedStageDateKeys']),
      lastOpenedJourneyId: json['lastOpenedJourneyId']?.toString(),
      lastOpenedStageId: json['lastOpenedStageId']?.toString(),
      activeDayKeys: _asStringSet(json['activeDayKeys']),
      todayLightOpenedDayKeys: _asStringSet(json['todayLightOpenedDayKeys']),
      currentStreakDays: _asInt(json['currentStreakDays']),
      bestStreakDays: _asInt(json['bestStreakDays']),
    );
  }
}

class LearningJourneyContinueState {
  const LearningJourneyContinueState({
    required this.hasJourney,
    this.journey,
    this.stage,
    required this.journeyCompleted,
    this.suggestedNextJourney,
  });

  final bool hasJourney;
  final LearningJourney? journey;
  final LearningJourneyStage? stage;
  final bool journeyCompleted;
  final LearningJourney? suggestedNextJourney;
}

class LearningJourneyCompletionResult {
  const LearningJourneyCompletionResult({
    required this.stageCompleted,
    required this.journeyCompleted,
    required this.phaseCompleted,
    required this.learnedTogether,
    required this.oceanDropsAwarded,
    required this.currentStreakDays,
    this.completedPhase,
  });

  final bool stageCompleted;
  final bool journeyCompleted;
  final bool phaseCompleted;
  final bool learnedTogether;
  final int oceanDropsAwarded;
  final int currentStreakDays;
  final LearningPathPhase? completedPhase;
}

class LearningJourneyRecommendationSet {
  const LearningJourneyRecommendationSet({
    required this.reason,
    required this.journeys,
  });

  final LearningJourneyRecommendationReason reason;
  final List<LearningJourney> journeys;
}

enum LearningJourneyRecommendationReason {
  defaultJourney,
  worship,
  arabic,
  nearCompletion,
  completed,
  fallback,
}

enum TodayLightKind { prophet, hadith, verse, reflection, trivia, dhikr }

class LearningJourneyTodayLight {
  const LearningJourneyTodayLight({
    required this.id,
    required this.kind,
    required this.title,
    required this.subtitle,
    required this.badge,
    this.routeName,
    this.pathParameters = const <String, String>{},
    this.queryParameters = const <String, String>{},
  });

  final String id;
  final TodayLightKind kind;
  final String title;
  final String subtitle;
  final String badge;
  final String? routeName;
  final Map<String, String> pathParameters;
  final Map<String, String> queryParameters;
}

class LearningJourneyProgressNotifier
    extends StateNotifier<LearningJourneyProgressState> {
  LearningJourneyProgressNotifier(this._ref)
    : _store = _ref.read(localStoreProvider),
      super(LearningJourneyProgressState.initial()) {
    _load();
  }

  final Ref _ref;
  final LocalStore _store;

  void _load() {
    state = _sanitizeProgressState(
      LearningJourneyProgressState.fromJson(
        _store.getJsonMap(_learningJourneyProgressKey),
      ),
    );
  }

  void _save() {
    _store.setJsonMap(_learningJourneyProgressKey, state.toJson());
  }

  void recordStageOpened({required String journeyId, required String stageId}) {
    final nextStarted = Set<String>.from(state.startedJourneyIds)
      ..add(journeyId);
    state = state.copyWith(
      startedJourneyIds: nextStarted,
      lastOpenedJourneyId: journeyId,
      lastOpenedStageId: stageId,
    );
    _save();
  }

  bool markStageCompleted({
    required String journeyId,
    required String stageId,
  }) {
    return completeStage(journeyId: journeyId, stageId: stageId).stageCompleted;
  }

  LearningJourneyCompletionResult completeStage({
    required String journeyId,
    required String stageId,
    bool learnedTogether = false,
  }) {
    if (state.completedStageIds.contains(stageId)) {
      recordActiveDay();
      return LearningJourneyCompletionResult(
        stageCompleted: false,
        journeyCompleted: _isJourneyCompleted(
          journeyId,
          state.completedStageIds,
        ),
        phaseCompleted: false,
        learnedTogether: learnedTogether,
        oceanDropsAwarded: 0,
        currentStreakDays: state.currentStreakDays,
      );
    }

    final todayKey = LocalStore.todayKey();
    final nextCompleted = Set<String>.from(state.completedStageIds)
      ..add(stageId);
    final nextCompletedDates = Map<String, String>.from(
      state.completedStageDateKeys,
    )..[stageId] = todayKey;
    final nextStarted = Set<String>.from(state.startedJourneyIds)
      ..add(journeyId);
    final streakState = _applyActiveDay(
      activeDayKeys: Set<String>.from(state.activeDayKeys)..add(todayKey),
    );

    state = state.copyWith(
      startedJourneyIds: nextStarted,
      completedStageIds: nextCompleted,
      completedStageDateKeys: nextCompletedDates,
      lastOpenedJourneyId: journeyId,
      lastOpenedStageId: stageId,
      activeDayKeys: streakState.activeDayKeys,
      currentStreakDays: streakState.currentStreakDays,
      bestStreakDays: streakState.bestStreakDays,
    );
    _save();

    final completedJourneyIds = _completedJourneyIds(nextCompleted);
    final journeyCompleted = _isJourneyCompleted(journeyId, nextCompleted);
    final completedPhase = _completedPathPhase(
      journeyId: journeyId,
      completedJourneyIds: completedJourneyIds,
    );
    final timestamp = DateTime.now().toIso8601String();
    var awardedDrops = 0;

    awardedDrops += _ref
        .read(oceanDropsProvider.notifier)
        .awardDrop(
          actionType: oceanActionLearningSegmentCompleted,
          sourceModule: oceanSourceLearn,
          referenceId: stageId,
          metadata: <String, dynamic>{
            'journeyId': journeyId,
            'timestamp': timestamp,
            'communityKind': 'stage',
            'learnedTogether': learnedTogether,
          },
        );
    if (journeyCompleted) {
      awardedDrops += _ref
          .read(oceanDropsProvider.notifier)
          .awardDrop(
            actionType: oceanActionLearningJourneyCompleted,
            sourceModule: oceanSourceLearn,
            referenceId: journeyId,
            metadata: <String, dynamic>{
              'journeyId': journeyId,
              'timestamp': timestamp,
              'communityKind': 'journey',
              'learnedTogether': learnedTogether,
            },
          );
    }
    if (completedPhase != null) {
      awardedDrops += _ref
          .read(oceanDropsProvider.notifier)
          .awardDrop(
            actionType: oceanActionLearningPathPhaseCompleted,
            sourceModule: oceanSourceLearn,
            referenceId: completedPhase.id,
            metadata: <String, dynamic>{
              'journeyId': journeyId,
              'phaseId': completedPhase.id,
              'timestamp': timestamp,
              'communityKind': 'phase',
              'learnedTogether': learnedTogether,
            },
          );
    }
    if (learnedTogether) {
      awardedDrops += _ref
          .read(oceanDropsProvider.notifier)
          .awardDrop(
            actionType: oceanActionLearningTogetherCompleted,
            sourceModule: oceanSourceLearn,
            referenceId: '$journeyId::$stageId',
            metadata: <String, dynamic>{
              'journeyId': journeyId,
              'stageId': stageId,
              'timestamp': timestamp,
              'communityKind': 'family',
            },
          );
    }
    _ref
        .read(journeyProgressUpdateHelperProvider)
        .addLearningStageCompletions(1);
    return LearningJourneyCompletionResult(
      stageCompleted: true,
      journeyCompleted: journeyCompleted,
      phaseCompleted: completedPhase != null,
      learnedTogether: learnedTogether,
      oceanDropsAwarded: awardedDrops,
      currentStreakDays: streakState.currentStreakDays,
      completedPhase: completedPhase,
    );
  }

  bool markTodayLightOpened(String lightId) {
    final todayKey = LocalStore.todayKey();
    final nextTodayLight = Set<String>.from(state.todayLightOpenedDayKeys)
      ..add(todayKey);
    final streakState = _applyActiveDay(
      activeDayKeys: Set<String>.from(state.activeDayKeys)..add(todayKey),
    );
    final wasNew = !state.todayLightOpenedDayKeys.contains(todayKey);
    state = state.copyWith(
      todayLightOpenedDayKeys: nextTodayLight,
      activeDayKeys: streakState.activeDayKeys,
      currentStreakDays: streakState.currentStreakDays,
      bestStreakDays: streakState.bestStreakDays,
    );
    _save();
    if (wasNew) {
      _ref
          .read(oceanDropsProvider.notifier)
          .awardDrop(
            actionType: oceanActionLearningDailyLightCompleted,
            sourceModule: oceanSourceLearn,
            referenceId: lightId,
            metadata: <String, dynamic>{
              'timestamp': DateTime.now().toIso8601String(),
              'communityKind': 'daily',
            },
          );
    }
    return wasNew;
  }

  void recordActiveDay() {
    final todayKey = LocalStore.todayKey();
    final streakState = _applyActiveDay(
      activeDayKeys: Set<String>.from(state.activeDayKeys)..add(todayKey),
    );
    state = state.copyWith(
      activeDayKeys: streakState.activeDayKeys,
      currentStreakDays: streakState.currentStreakDays,
      bestStreakDays: streakState.bestStreakDays,
    );
    _save();
  }

  LearningJourneyProgressState _applyActiveDay({
    required Set<String> activeDayKeys,
  }) {
    final streak = _computeStreak(activeDayKeys);
    return state.copyWith(
      activeDayKeys: activeDayKeys,
      currentStreakDays: streak.current,
      bestStreakDays: math.max(streak.best, state.bestStreakDays),
    );
  }

  _StreakData _computeStreak(Set<String> dayKeys) {
    if (dayKeys.isEmpty) return const _StreakData(current: 0, best: 0);
    final parsed =
        dayKeys
            .map((key) => DateTime.tryParse('${key}T00:00:00'))
            .whereType<DateTime>()
            .toList(growable: false)
          ..sort();

    var best = 0;
    var running = 0;
    DateTime? previous;
    for (final day in parsed) {
      if (previous == null || day.difference(previous).inDays == 1) {
        running += 1;
      } else if (day.difference(previous).inDays == 0) {
        continue;
      } else {
        running = 1;
      }
      best = math.max(best, running);
      previous = day;
    }

    var current = 0;
    final today = DateTime.now();
    var cursor = DateTime(today.year, today.month, today.day);
    final available = parsed.map((day) => LocalStore.todayKey(day)).toSet();
    while (available.contains(LocalStore.todayKey(cursor))) {
      current += 1;
      cursor = cursor.subtract(const Duration(days: 1));
    }
    return _StreakData(current: current, best: best);
  }

  bool _isJourneyCompleted(String journeyId, Set<String> completedStageIds) {
    final journey = LearningJourneyRegistry.journeyById(journeyId);
    if (journey == null || journey.stageIds.isEmpty) {
      return false;
    }
    return journey.stageIds.every(completedStageIds.contains);
  }

  LearningPathPhase? _completedPathPhase({
    required String journeyId,
    required Set<String> completedJourneyIds,
  }) {
    final savedPath = UserLearningPathState.fromJson(
      _store.getJsonMap(_learningPathStateStorageKey),
    );
    if (savedPath == null) {
      return null;
    }
    final path = LearningPathRegistry.pathForLevel(savedPath.selectedLevel);
    if (path == null) {
      return null;
    }
    for (final phase in path.phases) {
      if (!phase.journeyIds.contains(journeyId)) {
        continue;
      }
      final phaseComplete =
          phase.journeyIds.isNotEmpty &&
          phase.journeyIds.every(completedJourneyIds.contains);
      if (phaseComplete) {
        return phase;
      }
    }
    return null;
  }

  Set<String> _completedJourneyIds(Set<String> completedStageIds) {
    final completedJourneys = <String>{};
    for (final journey in LearningJourneyRegistry.journeys) {
      if (journey.stageIds.isNotEmpty &&
          journey.stageIds.every(completedStageIds.contains)) {
        completedJourneys.add(journey.id);
      }
    }
    return completedJourneys;
  }
}

class _StreakData {
  const _StreakData({required this.current, required this.best});

  final int current;
  final int best;
}

Map<String, String> _asStringMap(Object? value) {
  final raw = value as Map?;
  if (raw == null) return const <String, String>{};
  return raw.map(
    (key, mapValue) => MapEntry(key.toString(), mapValue.toString()),
  );
}

Set<String> _asStringSet(Object? value) {
  final raw = value as List?;
  if (raw == null) return const <String>{};
  return raw.map((item) => item.toString()).toSet();
}

int _asInt(Object? value) {
  if (value is int) return value;
  return int.tryParse(value?.toString() ?? '') ?? 0;
}

final learningJourneyProgressProvider =
    StateNotifierProvider<
      LearningJourneyProgressNotifier,
      LearningJourneyProgressState
    >((ref) {
      return LearningJourneyProgressNotifier(ref);
    });

final learningJourneyContinueProvider = Provider<LearningJourneyContinueState>((
  ref,
) {
  final state = ref.watch(learningJourneyProgressProvider);
  final startedJourneys = state.startedJourneyIds
      .map(LearningJourneyRegistry.journeyById)
      .whereType<LearningJourney>()
      .toList(growable: false);
  final lastOpenedJourney = state.lastOpenedJourneyId == null
      ? null
      : LearningJourneyRegistry.journeyById(state.lastOpenedJourneyId!);
  LearningJourney? selectedJourney;
  LearningJourneyStage? selectedStage;
  LearningJourney? suggestedNext;
  var journeyCompleted = false;

  final lastOpenedJourneyIsActive =
      lastOpenedJourney != null &&
      !_isJourneyCompleted(lastOpenedJourney, state.completedStageIds);
  if (lastOpenedJourneyIsActive) {
    selectedJourney = lastOpenedJourney;
    selectedStage =
        _firstIncompleteStageForJourney(
          lastOpenedJourney,
          state.completedStageIds,
        ) ??
        LearningJourneyRegistry.stageById(lastOpenedJourney.stageIds.first);
  }

  if (selectedJourney == null) {
    selectedJourney = _selectProgressDrivenJourney(
      startedJourneys: startedJourneys,
      completedStageIds: state.completedStageIds,
      preferredJourneyId: lastOpenedJourney?.id,
    );
    if (selectedJourney != null &&
        !_isJourneyCompleted(selectedJourney, state.completedStageIds)) {
      selectedStage =
          _firstIncompleteStageForJourney(
            selectedJourney,
            state.completedStageIds,
          ) ??
          LearningJourneyRegistry.stageById(selectedJourney.stageIds.first);
    }
  }

  if (selectedJourney == null) {
    final completedJourney = _selectCompletedJourney(
      startedJourneys: startedJourneys,
      completedStageIds: state.completedStageIds,
      preferredJourneyId: lastOpenedJourney?.id,
    );
    if (completedJourney != null) {
      final next = _nextJourneysForJourney(
        completedJourney,
        completedJourneyIslandIds: _journeysByIsland(state.completedStageIds),
      ).firstOrNull;
      selectedJourney = completedJourney;
      journeyCompleted = true;
      suggestedNext = next;
    }
  }

  if (selectedJourney == null) {
    selectedJourney =
        LearningJourneyRegistry.journeyById('islam-foundations') ??
        LearningJourneyRegistry.journeyById('prophets-journey') ??
        LearningJourneyRegistry.journeyById('salah-foundations');
    if (selectedJourney != null) {
      selectedStage = _firstIncompleteStageForJourney(
        selectedJourney,
        state.completedStageIds,
      );
    }
  }

  return LearningJourneyContinueState(
    hasJourney: selectedJourney != null,
    journey: selectedJourney,
    stage: selectedStage,
    journeyCompleted: journeyCompleted,
    suggestedNextJourney: suggestedNext,
  );
});

final learningJourneyRecommendationsProvider =
    Provider<LearningJourneyRecommendationSet>((ref) {
      final state = ref.watch(learningJourneyProgressProvider);
      if (state.startedJourneyIds.isEmpty) {
        return LearningJourneyRecommendationSet(
          reason: LearningJourneyRecommendationReason.defaultJourney,
          journeys: [
            if (LearningJourneyRegistry.journeyById('islam-foundations') !=
                null)
              LearningJourneyRegistry.journeyById('islam-foundations')!,
            LearningJourneyRegistry.journeyById('prophets-journey')!,
            LearningJourneyRegistry.journeyById('salah-foundations')!,
            LearningJourneyRegistry.journeyById('arabic-alphabet')!,
          ],
        );
      }

      final currentJourney = state.lastOpenedJourneyId == null
          ? null
          : LearningJourneyRegistry.journeyById(state.lastOpenedJourneyId!);

      final stageCompletedCount = state.completedStageIds.length;
      final hasWorshipCompletion = _hasCompletedIslandProgress(
        islandId: 'practice-worship',
        state: state,
      );
      final hasArabicCompletion = _hasCompletedIslandProgress(
        islandId: 'arabic-learning',
        state: state,
      );
      final completedJourneyIds = state.startedJourneyIds
          .map(LearningJourneyRegistry.journeyById)
          .whereType<LearningJourney>()
          .where(
            (journey) => _isJourneyCompleted(journey, state.completedStageIds),
          )
          .map((journey) => journey.id)
          .toSet();

      if (hasWorshipCompletion) {
        return LearningJourneyRecommendationSet(
          reason: LearningJourneyRecommendationReason.worship,
          journeys: [
            if (!completedJourneyIds.contains('daily-dhikr'))
              LearningJourneyRegistry.journeyById('daily-dhikr')!,
            if (!completedJourneyIds.contains('duas-daily-life'))
              LearningJourneyRegistry.journeyById('duas-daily-life')!,
          ],
        );
      }

      if (hasArabicCompletion) {
        return LearningJourneyRecommendationSet(
          reason: LearningJourneyRecommendationReason.arabic,
          journeys: [
            if (!completedJourneyIds.contains('journey-quran'))
              LearningJourneyRegistry.journeyById('journey-quran')!,
            if (!completedJourneyIds.contains('understanding-al-fatihah'))
              LearningJourneyRegistry.journeyById('understanding-al-fatihah')!,
          ],
        );
      }

      final completionRatioForCurrent = currentJourney == null
          ? 0.0
          : _journeyCompletionRatio(currentJourney, state.completedStageIds);
      if (currentJourney == null) {
        return LearningJourneyRecommendationSet(
          reason: LearningJourneyRecommendationReason.fallback,
          journeys: [
            if (LearningJourneyRegistry.journeyById('islam-foundations') !=
                null)
              LearningJourneyRegistry.journeyById('islam-foundations')!,
            LearningJourneyRegistry.journeyById('journey-quran')!,
            LearningJourneyRegistry.journeyById('beautiful-character')!,
          ],
        );
      }

      final sameIsland = LearningJourneyRegistry.journeysForIsland(
        currentJourney.islandId,
      ).where((item) => item.id != currentJourney.id).toList(growable: false);
      final complementary = switch (currentJourney.islandId) {
        'core-knowledge' => LearningJourneyRegistry.journeyById(
          'salah-foundations',
        ),
        'practice-worship' => LearningJourneyRegistry.journeyById(
          'journey-quran',
        ),
        'arabic-learning' => LearningJourneyRegistry.journeyById(
          'understanding-al-fatihah',
        ),
        'understanding-islam' => LearningJourneyRegistry.journeyById(
          'prophets-journey',
        ),
        'discovery' => LearningJourneyRegistry.journeyById('journey-quran'),
        _ => LearningJourneyRegistry.journeyById('reflection-mode'),
      };
      if (completionRatioForCurrent >= 0.9 && sameIsland.isNotEmpty) {
        final nextJourneyFromCurrent =
            sameIsland
                .where(
                  (item) => _isJourneyInProgress(item, state.completedStageIds),
                )
                .firstOrNull ??
            sameIsland.firstOrNull;
        if (nextJourneyFromCurrent != null) {
          final nextProgress = _journeyCompletionRatio(
            nextJourneyFromCurrent,
            state.completedStageIds,
          );
          if (nextProgress == 0.0) {
            return LearningJourneyRecommendationSet(
              reason: LearningJourneyRecommendationReason.nearCompletion,
              journeys: [nextJourneyFromCurrent],
            );
          }
        }
      }

      if (completionRatioForCurrent >= 1.0 && stageCompletedCount > 0) {
        final stagedSuggestions = _nextJourneysForJourney(
          currentJourney,
          completedJourneyIslandIds: _journeysByIsland(state.completedStageIds),
        );
        if (stagedSuggestions.isNotEmpty) {
          return LearningJourneyRecommendationSet(
            reason: LearningJourneyRecommendationReason.completed,
            journeys: stagedSuggestions,
          );
        }
      }

      final journeys = <LearningJourney>[
        if (sameIsland.isNotEmpty) sameIsland.first,
        if (sameIsland.length > 1) sameIsland[1],
        if (complementary != null &&
            !sameIsland.any((item) => item.id == complementary.id) &&
            complementary.id != currentJourney.id)
          complementary,
      ];
      return LearningJourneyRecommendationSet(
        reason: LearningJourneyRecommendationReason.defaultJourney,
        journeys:
            (journeys..addAll(
                  _fallbackRecommendationPool(
                    currentJourney: currentJourney,
                    completedStageIds: state.completedStageIds,
                  ),
                ))
                .where(
                  (item) => !_isJourneyCompleted(item, state.completedStageIds),
                )
                .fold<List<LearningJourney>>(<LearningJourney>[], (list, item) {
                  if (!list.any((existing) => existing.id == item.id)) {
                    list.add(item);
                  }
                  return list;
                })
                .take(4)
                .toList(growable: false),
      );
    });

final learningJourneyTodayLightProvider = Provider<LearningJourneyTodayLight>((
  ref,
) {
  final prophetDaily = ref.watch(todayDailyLearningBundleProvider);
  final hadithDaily = ref.watch(hadithDailyReflectionBundleProvider);
  final quranDaily = ref.watch(quranDailyVerseProvider);
  final worldDaily = ref.watch(worldDailySignProvider);
  ref.watch(learnDailyItemProvider);

  final day = DateTime.now();
  final seed = day.year * 372 + day.month * 31 + day.day;
  final kind = TodayLightKind.values[seed % TodayLightKind.values.length];

  late final LearningJourneyTodayLight light;
  switch (kind) {
    case TodayLightKind.prophet:
      light = LearningJourneyTodayLight(
        id: 'today-light:${prophetDaily.dateKey}:prophet',
        kind: kind,
        title: prophetDaily.item.title,
        subtitle: prophetDaily.item.subtitle ?? '',
        badge: '',
        routeName: 'learnProphetsHub',
        queryParameters: prophetDaily.item.linkedProphetId == null
            ? const <String, String>{}
            : {'prophet': prophetDaily.item.linkedProphetId!},
      );
    case TodayLightKind.hadith:
      light = LearningJourneyTodayLight(
        id: 'today-light:${hadithDaily.dateKey}:hadith',
        kind: kind,
        title: hadithDaily.entry?.title ?? '',
        subtitle: hadithDaily.entry?.meaning ?? '',
        badge: '',
        routeName: hadithDaily.entry == null
            ? 'learnHadithLanding'
            : 'hadithLessonDetail',
        pathParameters: hadithDaily.entry == null
            ? const <String, String>{}
            : {'lessonId': hadithDaily.entry!.id},
      );
    case TodayLightKind.verse:
      light = LearningJourneyTodayLight(
        id: 'today-light:${LocalStore.todayKey()}:verse',
        kind: kind,
        title: quranDaily.locationLabel,
        subtitle: quranDaily.translation,
        badge: '',
        routeName: 'quranReader',
        pathParameters: {'surahNumber': '${quranDaily.surahNumber}'},
        queryParameters: {'ayah': '${quranDaily.ayahNumber}'},
      );
    case TodayLightKind.reflection:
      light = LearningJourneyTodayLight(
        id: 'today-light:${LocalStore.todayKey()}:reflection',
        kind: kind,
        title: '',
        subtitle: worldDaily.prompt,
        badge: '',
        routeName: 'worldLessonDetail',
        pathParameters: {'lessonId': worldDaily.lessonId},
      );
    case TodayLightKind.trivia:
      light = const LearningJourneyTodayLight(
        id: 'today-light:trivia',
        kind: TodayLightKind.trivia,
        title: '',
        subtitle: '',
        badge: '',
        routeName: 'learnTriviaSession',
      );
    case TodayLightKind.dhikr:
      light = LearningJourneyTodayLight(
        id: 'today-light:${LocalStore.todayKey()}:dhikr',
        kind: kind,
        title: '',
        subtitle: '',
        badge: '',
        routeName: 'learnJourneyDetail',
        pathParameters: {'journeyId': 'daily-dhikr'},
      );
  }

  return _safeTodayLightFallback(light);
});

bool _isJourneyCompleted(
  LearningJourney journey,
  Set<String> completedStageIds,
) {
  return _journeyCompletionRatio(journey, completedStageIds) >= 1.0;
}

bool _isJourneyInProgress(
  LearningJourney journey,
  Set<String> completedStageIds,
) {
  return journey.stageIds.any((id) => completedStageIds.contains(id));
}

LearningJourneyStage? _firstIncompleteStageForJourney(
  LearningJourney journey,
  Set<String> completedStageIds,
) {
  for (final stageId in journey.stageIds) {
    if (!completedStageIds.contains(stageId)) {
      return LearningJourneyRegistry.stageById(stageId);
    }
  }
  if (journey.stageIds.isNotEmpty) {
    return LearningJourneyRegistry.stageById(journey.stageIds.last);
  }
  return null;
}

double _journeyCompletionRatio(
  LearningJourney journey,
  Set<String> completedStageIds,
) {
  if (journey.stageIds.isEmpty) return 0.0;
  final completed = journey.stageIds.where(completedStageIds.contains).length;
  return completed / journey.stageIds.length;
}

LearningJourneyProgressState _sanitizeProgressState(
  LearningJourneyProgressState state,
) {
  final validStageIds = LearningJourneyRegistry.stages
      .map((item) => item.id)
      .toSet();
  final validJourneyIds = LearningJourneyRegistry.journeys
      .map((item) => item.id)
      .toSet();
  return state.copyWith(
    startedJourneyIds: state.startedJourneyIds
        .where(validJourneyIds.contains)
        .toSet(),
    completedStageIds: state.completedStageIds
        .where(validStageIds.contains)
        .toSet(),
    completedStageDateKeys: Map<String, String>.fromEntries(
      state.completedStageDateKeys.entries.where(
        (entry) => validStageIds.contains(entry.key),
      ),
    ),
    lastOpenedJourneyId: validJourneyIds.contains(state.lastOpenedJourneyId)
        ? state.lastOpenedJourneyId
        : null,
    lastOpenedStageId: validStageIds.contains(state.lastOpenedStageId)
        ? state.lastOpenedStageId
        : null,
    clearLastOpenedJourneyId: !validJourneyIds.contains(
      state.lastOpenedJourneyId,
    ),
    clearLastOpenedStageId: !validStageIds.contains(state.lastOpenedStageId),
  );
}

List<LearningJourney> _fallbackRecommendationPool({
  required LearningJourney currentJourney,
  required Set<String> completedStageIds,
}) {
  const ids = <String>[
    'beautiful-character',
    'daily-wisdom',
    'stories-signs',
    'journey-quran',
    'daily-dhikr',
  ];
  return ids
      .where((id) => id != currentJourney.id)
      .map(LearningJourneyRegistry.journeyById)
      .whereType<LearningJourney>()
      .where((journey) => !_isJourneyCompleted(journey, completedStageIds))
      .toList(growable: false);
}

LearningJourneyTodayLight _safeTodayLightFallback(
  LearningJourneyTodayLight light,
) {
  final hasUsableCopy =
      light.title.trim().isNotEmpty || light.subtitle.trim().isNotEmpty;
  if (hasUsableCopy && light.routeName != null && light.routeName!.isNotEmpty) {
    return light;
  }
  return const LearningJourneyTodayLight(
    id: 'today-light:fallback',
    kind: TodayLightKind.verse,
    title: '',
    subtitle: '',
    badge: '',
    routeName: 'learnJourneyDetail',
    pathParameters: {'journeyId': 'journey-quran'},
  );
}

LearningJourney? _selectProgressDrivenJourney({
  required List<LearningJourney> startedJourneys,
  required Set<String> completedStageIds,
  required String? preferredJourneyId,
}) {
  final candidates = startedJourneys
      .where((journey) {
        return !_isJourneyCompleted(journey, completedStageIds);
      })
      .toList(growable: false);

  if (candidates.isEmpty) return null;

  candidates.sort((a, b) {
    final ratioA = _journeyCompletionRatio(a, completedStageIds);
    final ratioB = _journeyCompletionRatio(b, completedStageIds);
    final byRatio = ratioB.compareTo(ratioA);
    if (byRatio != 0) return byRatio;

    if (preferredJourneyId != null) {
      if (a.id == preferredJourneyId) return -1;
      if (b.id == preferredJourneyId) return 1;
    }
    return a.order.compareTo(b.order);
  });
  return candidates.first;
}

LearningJourney? _selectCompletedJourney({
  required List<LearningJourney> startedJourneys,
  required Set<String> completedStageIds,
  required String? preferredJourneyId,
}) {
  final completed = startedJourneys
      .where((journey) {
        return _isJourneyCompleted(journey, completedStageIds);
      })
      .toList(growable: false);
  if (completed.isEmpty) return null;

  if (preferredJourneyId != null) {
    final preferred = completed.firstWhere(
      (journey) => journey.id == preferredJourneyId,
      orElse: () => completed.first,
    );
    return preferred;
  }
  return completed.first;
}

List<LearningJourney> _nextJourneysForJourney(
  LearningJourney journey, {
  required Map<String, List<LearningJourney>> completedJourneyIslandIds,
}) {
  final candidates = <LearningJourney>[];
  if (journey.islandId == 'practice-worship') {
    final dhikr = LearningJourneyRegistry.journeyById('daily-dhikr');
    if (dhikr != null) candidates.add(dhikr);
    final duas = LearningJourneyRegistry.journeyById('duas-daily-life');
    if (duas != null) candidates.add(duas);
    final salah = LearningJourneyRegistry.journeyById('salah-foundations');
    if (salah != null) candidates.add(salah);
    return _excludeAlreadySuggested(
      candidates,
      completedIds: completedJourneyIslandIds['practice-worship']
          ?.map((item) => item.id)
          .toSet(),
    );
  }

  if (journey.islandId == 'arabic-learning') {
    final quran = LearningJourneyRegistry.journeyById('journey-quran');
    final shortSurahs = LearningJourneyRegistry.journeyById('short-surahs');
    if (quran != null) candidates.add(quran);
    if (shortSurahs != null) candidates.add(shortSurahs);
    return _excludeAlreadySuggested(
      candidates,
      completedIds: completedJourneyIslandIds['arabic-learning']
          ?.map((item) => item.id)
          .toSet(),
    );
  }

  final companion = LearningJourneyRegistry.journeyById('salah-foundations');
  final dhikr = LearningJourneyRegistry.journeyById('daily-dhikr');
  if (companion != null) candidates.add(companion);
  if (dhikr != null) candidates.add(dhikr);
  return _excludeAlreadySuggested(
    candidates,
    completedIds: completedJourneyIslandIds[journey.islandId]
        ?.map((item) => item.id)
        .toSet(),
  );
}

Map<String, List<LearningJourney>> _journeysByIsland(
  Set<String> completedStageIds,
) {
  final entries = <String, List<LearningJourney>>{};
  for (final journey in LearningJourneyRegistry.journeys) {
    if (_isJourneyCompleted(journey, completedStageIds)) {
      entries
          .putIfAbsent(journey.islandId, () => <LearningJourney>[])
          .add(journey);
    }
  }
  return entries;
}

List<LearningJourney> _excludeAlreadySuggested(
  List<LearningJourney> journeys, {
  Set<String>? completedIds,
}) {
  if (completedIds == null || completedIds.isEmpty) return journeys;
  return journeys
      .where((journey) => !completedIds.contains(journey.id))
      .toList();
}

bool _hasCompletedIslandProgress({
  required String islandId,
  required LearningJourneyProgressState state,
}) {
  return _journeysByIsland(state.completedStageIds)[islandId]?.isNotEmpty ??
      false;
}

class LearningCommunitySummary {
  const LearningCommunitySummary({
    required this.weekDrops,
    required this.totalDrops,
    required this.learnTogetherDrops,
  });

  final int weekDrops;
  final int totalDrops;
  final int learnTogetherDrops;

  bool get hasContribution => totalDrops > 0;
}

final learningCommunitySummaryProvider = Provider<LearningCommunitySummary>((
  ref,
) {
  final events = ref.watch(oceanDropsProvider.select((state) => state.events));
  final now = DateTime.now();
  final startOfWeek = DateTime(
    now.year,
    now.month,
    now.day,
  ).subtract(Duration(days: now.weekday - 1));
  final learningActionTypes = <String>{
    oceanActionLearningSegmentCompleted,
    oceanActionLearningJourneyCompleted,
    oceanActionLearningPathPhaseCompleted,
    oceanActionLearningTogetherCompleted,
    oceanActionLearningDailyLightCompleted,
  };

  var weekDrops = 0;
  var totalDrops = 0;
  var learnTogetherDrops = 0;

  for (final event in events) {
    if (event.sourceModule != oceanSourceLearn ||
        !learningActionTypes.contains(event.actionType)) {
      continue;
    }
    totalDrops += event.amount;
    if (!event.timestamp.isBefore(startOfWeek)) {
      weekDrops += event.amount;
    }
    if (event.actionType == oceanActionLearningTogetherCompleted) {
      learnTogetherDrops += event.amount;
    }
  }

  return LearningCommunitySummary(
    weekDrops: weekDrops,
    totalDrops: totalDrops,
    learnTogetherDrops: learnTogetherDrops,
  );
});
