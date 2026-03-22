import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/persistence/local_store.dart';
import '../../journey/application/journey_progression_provider.dart';
import '../../journey/drops/application/journey_drops_providers.dart';
import '../../journey/xp/application/journey_xp_providers.dart';
import '../../journey/xp/domain/journey_xp_levels.dart';
import '../../journey/xp/domain/journey_xp_models.dart';
import '../data/learner_progression_catalog.dart';
import '../domain/learner_progression_models.dart';

String learnerProgressionStorageKeyForLearner(String learnerId) =>
    'progression.learner.v1.$learnerId';

final learnerProgressionControllerProvider = StateNotifierProvider.family<
  LearnerProgressionController,
  LearnerProgressionState,
  String
>((ref, learnerId) {
  return LearnerProgressionController(ref, learnerId);
});

final learnerProgressionSummaryProvider =
    Provider.family<LearnerProgressionSummary, String>((ref, learnerId) {
      final controller = ref.watch(learnerProgressionControllerProvider(learnerId).notifier);
      ref.watch(learnerProgressionControllerProvider(learnerId));
      return controller.buildSummary();
    });

class LearnerProgressionController
    extends StateNotifier<LearnerProgressionState> {
  LearnerProgressionController(this._ref, this.learnerId)
    : _store = _ref.read(localStoreProvider),
      super(
        LearnerProgressionState.fromJson(
          _ref.read(localStoreProvider).getJsonMap(
                learnerProgressionStorageKeyForLearner(learnerId),
              ),
        ),
      );

  final Ref _ref;
  final LocalStore _store;
  final String learnerId;

  LearnerProgressionAwardResult award({
    required String sourceRef,
    required LearnerProgressionActivityType activityType,
    required String sourceModule,
    required int xp,
    required int drops,
    DateTime? occurredAt,
    Map<String, Object?> metadata = const <String, Object?>{},
    bool mirrorToJourney = false,
    bool incrementLearningStageCompletion = false,
  }) {
    if (state.entriesBySourceRef.containsKey(sourceRef)) {
      return const LearnerProgressionAwardResult(
        awardedXp: 0,
        awardedDrops: 0,
        wasDuplicate: true,
        newBadgeIds: <String>[],
        newMilestoneIds: <String>[],
        leveledUp: false,
      );
    }

    final previousSummary = buildSummary();
    final timestamp = occurredAt ?? DateTime.now();
    final entry = LearnerProgressionEntry(
      sourceRef: sourceRef,
      activityType: activityType,
      sourceModule: sourceModule,
      occurredAtIso: timestamp.toIso8601String(),
      xpAwarded: xp,
      oceanDropsAwarded: drops,
      metadata: <String, Object?>{
        ...metadata,
        'learnerId': learnerId,
      },
    );
    final nextEntries = Map<String, LearnerProgressionEntry>.from(
      state.entriesBySourceRef,
    )..[sourceRef] = entry;
    state = state.copyWith(
      entriesBySourceRef: nextEntries,
      lastUpdatedAtIso: timestamp.toIso8601String(),
    );

    final nextMetrics = _buildMetrics(nextEntries.values);
    final newBadgeIds = _unlockBadges(metrics: nextMetrics, occurredAt: timestamp);
    final newMilestoneIds = _unlockMilestones(
      metrics: nextMetrics,
      occurredAt: timestamp,
    );

    if (mirrorToJourney) {
      if (xp > 0) {
        _ref.read(journeyXpSummaryProvider.notifier).awardLearningXp(
          sourceRef: sourceRef,
          occurredAt: timestamp,
          sourceModule: sourceModule,
          xp: xp,
          metadata: <String, Object?>{
            ...metadata,
            'learnerId': learnerId,
          },
        );
      }
      if (drops > 0) {
        _ref.read(journeyDropSummaryProvider.notifier).awardLearningDrop(
          sourceRef: sourceRef,
          occurredAt: timestamp,
          metadata: <String, Object?>{
            ...metadata,
            'learnerId': learnerId,
          },
        );
      }
      if (incrementLearningStageCompletion) {
        _ref
            .read(journeyProgressUpdateHelperProvider)
            .addLearningStageCompletions(1);
      }
    }

    _persist();
    final nextSummary = buildSummary();
    return LearnerProgressionAwardResult(
      awardedXp: xp,
      awardedDrops: drops,
      wasDuplicate: false,
      newBadgeIds: newBadgeIds,
      newMilestoneIds: newMilestoneIds,
      leveledUp:
          nextSummary.xpSummary.currentLevel >
          previousSummary.xpSummary.currentLevel,
    );
  }

  LearnerProgressionSummary buildSummary({
    Set<String>? sourceModules,
  }) {
    final entries = state.entriesBySourceRef.values
        .where(
          (entry) =>
              sourceModules == null || sourceModules.contains(entry.sourceModule),
        )
        .toList(growable: false);
    final metrics = _buildMetrics(entries);
    final xpSummary = _buildXpSummary(entries);
    final unlockedBadges = state.badgeUnlockedAtById.entries
        .map((unlock) {
          final definition = learnerProgressionBadgeCatalog.firstWhere(
            (item) => item.badgeId == unlock.key,
            orElse: () => learnerProgressionBadgeCatalog.first,
          );
          return LearnerProgressionBadgeUnlock(
            definition: definition,
            unlockedAtIso: unlock.value,
          );
        })
        .toList(growable: false)
      ..sort((a, b) => b.unlockedAtIso.compareTo(a.unlockedAtIso));
    final unlockedMilestones = state.milestoneUnlockedAtById.entries
        .map((unlock) {
          final definition = learnerProgressionMilestoneCatalog.firstWhere(
            (item) => item.milestoneId == unlock.key,
            orElse: () => learnerProgressionMilestoneCatalog.first,
          );
          return LearnerProgressionMilestoneUnlock(
            definition: definition,
            unlockedAtIso: unlock.value,
          );
        })
        .toList(growable: false)
      ..sort((a, b) => b.unlockedAtIso.compareTo(a.unlockedAtIso));
    return LearnerProgressionSummary(
      metrics: metrics,
      xpSummary: xpSummary,
      unlockedBadges: unlockedBadges,
      unlockedMilestones: unlockedMilestones,
    );
  }

  IconData iconForName(String iconName) {
    return switch (iconName) {
      'auto_stories_rounded' => Icons.auto_stories_rounded,
      'quiz_rounded' => Icons.quiz_rounded,
      'style_rounded' => Icons.style_rounded,
      'favorite_border_rounded' => Icons.favorite_border_rounded,
      'timeline_rounded' => Icons.timeline_rounded,
      'nightlight_round_rounded' => Icons.nightlight_round_rounded,
      'bedtime_rounded' => Icons.bedtime_rounded,
      'menu_book_rounded' => Icons.menu_book_rounded,
      'flag_rounded' => Icons.flag_rounded,
      _ => Icons.star_rounded,
    };
  }

  List<String> _unlockBadges({
    required LearnerProgressionMetrics metrics,
    required DateTime occurredAt,
  }) {
    final next = Map<String, String>.from(state.badgeUnlockedAtById);
    final unlocked = <String>[];

    void unlock(String badgeId) {
      if (next.containsKey(badgeId)) return;
      next[badgeId] = occurredAt.toIso8601String();
      unlocked.add(badgeId);
    }

    if (metrics.storyCompletions >= 1) unlock('badge_first_story');
    if (metrics.quizCompletions >= 1) unlock('badge_first_quiz');
    if (metrics.memoryCompletions >= 1) unlock('badge_first_memory');
    if (metrics.duaLessonCompletions >= 1) unlock('badge_first_dua');
    if (metrics.seerahStageCompletions >= 1) unlock('badge_first_seerah_stage');
    if (metrics.bedtimeRoutineCompletions >= 1) {
      unlock('badge_first_bedtime_routine');
    }
    if (metrics.bedtimeRoutineCompletions >= 7) {
      unlock('badge_bedtime_streak_7');
    }
    if (metrics.storyCompletions >= 10) unlock('badge_stories_10');
    if (metrics.seerahJourneyCompletions >= 1) {
      unlock('badge_journey_complete');
    }

    state = state.copyWith(badgeUnlockedAtById: next);
    return unlocked;
  }

  List<String> _unlockMilestones({
    required LearnerProgressionMetrics metrics,
    required DateTime occurredAt,
  }) {
    final next = Map<String, String>.from(state.milestoneUnlockedAtById);
    final unlocked = <String>[];
    for (final definition in learnerProgressionMilestoneCatalog) {
      if (next.containsKey(definition.milestoneId)) {
        continue;
      }
      if (metrics.valueForMilestone(definition.metric) < definition.threshold) {
        continue;
      }
      next[definition.milestoneId] = occurredAt.toIso8601String();
      unlocked.add(definition.milestoneId);
    }
    state = state.copyWith(milestoneUnlockedAtById: next);
    return unlocked;
  }

  LearnerProgressionMetrics _buildMetrics(
    Iterable<LearnerProgressionEntry> entries,
  ) {
    final ordered = entries.toList(growable: false)
      ..sort((a, b) => a.occurredAtIso.compareTo(b.occurredAtIso));
    final totalXp = ordered.fold<int>(0, (sum, item) => sum + item.xpAwarded);
    final totalDrops = ordered.fold<int>(
      0,
      (sum, item) => sum + item.oceanDropsAwarded,
    );
    final dayKeys = ordered
        .map((item) => LocalStore.todayKey(DateTime.parse(item.occurredAtIso)))
        .toSet()
        .toList(growable: false)
      ..sort();
    return LearnerProgressionMetrics(
      totalXp: totalXp,
      totalDrops: totalDrops,
      kidsArabicLessonCompletions: ordered
          .where(
            (item) =>
                item.activityType ==
                LearnerProgressionActivityType.kidsArabicLessonCompletion,
          )
          .length,
      kidsArabicDailyMissionCompletions: ordered
          .where(
            (item) =>
                item.activityType ==
                LearnerProgressionActivityType.kidsArabicDailyMissionCompletion,
          )
          .length,
      storyCompletions: ordered
          .where(
            (item) =>
                item.activityType ==
                    LearnerProgressionActivityType.bedtimeStoryCompletion ||
                item.metadata['countsAsStoryCompletion'] == true,
          )
          .length,
      quizCompletions: ordered
          .where(
            (item) =>
                item.activityType ==
                LearnerProgressionActivityType.bedtimeQuizCompletion,
          )
          .length,
      memoryCompletions: ordered
          .where(
            (item) =>
                item.activityType ==
                LearnerProgressionActivityType.bedtimeMemoryCompletion,
          )
          .length,
      duaLessonCompletions: ordered
          .where(
            (item) =>
                item.activityType ==
                LearnerProgressionActivityType.duaLessonCompletion,
          )
          .length,
      duaPracticeSessions: ordered
          .where(
            (item) =>
                item.activityType ==
                LearnerProgressionActivityType.duaPracticeCompletion,
          )
          .length,
      duaMyDayCompletions: ordered
          .where(
            (item) =>
                item.activityType ==
                LearnerProgressionActivityType.duaMyDayCompletion,
          )
          .length,
      bedtimeRoutineCompletions: ordered
          .where(
            (item) =>
                item.activityType ==
                LearnerProgressionActivityType.bedtimeRoutineCompletion,
          )
          .length,
      seerahNodeCompletions: ordered
          .where(
            (item) =>
                item.activityType ==
                LearnerProgressionActivityType.seerahNodeCompletion,
          )
          .length,
      seerahStageCompletions: ordered
          .where(
            (item) =>
                item.activityType ==
                LearnerProgressionActivityType.seerahStageCompletion,
          )
          .length,
      seerahJourneyCompletions: ordered
          .where(
            (item) =>
                item.activityType ==
                LearnerProgressionActivityType.seerahJourneyCompletion,
          )
          .length,
      currentLearningStreakDays: _currentStreak(dayKeys),
      longestLearningStreakDays: _longestStreak(dayKeys),
      lastActivityAtIso: ordered.isEmpty ? null : ordered.last.occurredAtIso,
      activeDayKeys: dayKeys,
    );
  }

  XpSummary _buildXpSummary(Iterable<LearnerProgressionEntry> entries) {
    final ordered = entries.toList(growable: false)
      ..sort((a, b) => a.occurredAtIso.compareTo(b.occurredAtIso));
    final totalXp = ordered.fold<int>(0, (sum, item) => sum + item.xpAwarded);
    final timestamp = ordered.isEmpty
        ? DateTime.now()
        : DateTime.parse(ordered.last.occurredAtIso);
    final todayKey = LocalStore.todayKey(timestamp);
    final todayXp = ordered
        .where((item) => LocalStore.todayKey(DateTime.parse(item.occurredAtIso)) == todayKey)
        .fold<int>(0, (sum, item) => sum + item.xpAwarded);
    final current = xpLevelForTotalXp(totalXp);
    final next = xpNextLevelForTotalXp(totalXp);
    final currentStartXp = current.totalXpRequired;
    final nextXp = next?.totalXpRequired;
    final xpIntoLevel = totalXp - currentStartXp;
    final xpRequiredInLevel = nextXp == null
        ? 1
        : (nextXp - currentStartXp).clamp(1, 1 << 30);
    final remaining = nextXp == null ? 0 : (nextXp - totalXp).clamp(0, nextXp);
    final progress = nextXp == null
        ? 1.0
        : (xpIntoLevel / xpRequiredInLevel).clamp(0.0, 1.0).toDouble();
    return XpSummary(
      totalXp: totalXp,
      todayXp: todayXp,
      currentLevel: current.level,
      currentLevelTitle: current.title,
      currentLevelStartXp: currentStartXp,
      nextLevel: next?.level,
      nextLevelTitle: next?.title,
      nextLevelTotalXp: nextXp,
      xpIntoLevel: xpIntoLevel.clamp(0, 1 << 30),
      xpRequiredInLevel: xpRequiredInLevel,
      xpRemainingToNextLevel: remaining,
      progressPercent: progress,
      updatedAt: timestamp,
    );
  }

  int _currentStreak(List<String> dayKeys) {
    if (dayKeys.isEmpty) {
      return 0;
    }
    final knownDays = dayKeys.toSet();
    final now = DateTime.now();
    var cursor = DateTime(now.year, now.month, now.day);
    if (!knownDays.contains(LocalStore.todayKey(cursor))) {
      final yesterday = cursor.subtract(const Duration(days: 1));
      if (!knownDays.contains(LocalStore.todayKey(yesterday))) {
        return 0;
      }
      cursor = yesterday;
    }
    var streak = 0;
    while (knownDays.contains(LocalStore.todayKey(cursor))) {
      streak += 1;
      cursor = cursor.subtract(const Duration(days: 1));
    }
    return streak;
  }

  int _longestStreak(List<String> dayKeys) {
    if (dayKeys.isEmpty) {
      return 0;
    }
    final ordered = dayKeys.toList(growable: false)..sort();
    var best = 1;
    var current = 1;
    for (var index = 1; index < ordered.length; index += 1) {
      final previous = DateTime.parse(ordered[index - 1]);
      final currentDate = DateTime.parse(ordered[index]);
      final expected = previous.add(const Duration(days: 1));
      if (_sameDate(expected, currentDate)) {
        current += 1;
      } else {
        current = 1;
      }
      if (current > best) {
        best = current;
      }
    }
    return best;
  }

  bool _sameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  void _persist() {
    _store.setJsonMap(
      learnerProgressionStorageKeyForLearner(learnerId),
      state.toJson(),
    );
  }
}
