import '../../journey/xp/domain/journey_xp_models.dart';

enum LearnerProgressionActivityType {
  kidsArabicLessonCompletion,
  kidsArabicDailyMissionCompletion,
  bedtimeStoryCompletion,
  bedtimeQuizCompletion,
  bedtimeMemoryCompletion,
  duaLessonCompletion,
  duaPracticeCompletion,
  duaMyDayCompletion,
  bedtimeRoutineCompletion,
  seerahNodeCompletion,
  seerahStageCompletion,
  seerahJourneyCompletion,
}

enum LearnerProgressionBadgeCategory {
  story,
  dua,
  seerah,
  routine,
  consistency,
  milestone,
}

enum LearnerProgressionMilestoneMetric {
  storiesCompleted,
  quizzesCompleted,
  duaLessonsCompleted,
  seerahStagesCompleted,
  seerahJourneysCompleted,
  bedtimeRoutineCompleted,
  learningStreakDays,
}

class LearnerProgressionEntry {
  const LearnerProgressionEntry({
    required this.sourceRef,
    required this.activityType,
    required this.sourceModule,
    required this.occurredAtIso,
    required this.xpAwarded,
    required this.oceanDropsAwarded,
    this.metadata = const <String, Object?>{},
  });

  final String sourceRef;
  final LearnerProgressionActivityType activityType;
  final String sourceModule;
  final String occurredAtIso;
  final int xpAwarded;
  final int oceanDropsAwarded;
  final Map<String, Object?> metadata;

  Map<String, Object?> toJson() => <String, Object?>{
    'sourceRef': sourceRef,
    'activityType': activityType.name,
    'sourceModule': sourceModule,
    'occurredAtIso': occurredAtIso,
    'xpAwarded': xpAwarded,
    'oceanDropsAwarded': oceanDropsAwarded,
    'metadata': metadata,
  };

  factory LearnerProgressionEntry.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      throw ArgumentError.notNull('json');
    }
    return LearnerProgressionEntry(
      sourceRef: json['sourceRef']?.toString() ?? '',
      activityType: LearnerProgressionActivityType.values.firstWhere(
        (item) => item.name == json['activityType']?.toString(),
        orElse: () => LearnerProgressionActivityType.bedtimeStoryCompletion,
      ),
      sourceModule: json['sourceModule']?.toString() ?? '',
      occurredAtIso: json['occurredAtIso']?.toString() ?? '',
      xpAwarded: (json['xpAwarded'] as num?)?.toInt() ?? 0,
      oceanDropsAwarded: (json['oceanDropsAwarded'] as num?)?.toInt() ?? 0,
      metadata: Map<String, Object?>.from(
        (json['metadata'] as Map?)?.map(
              (key, value) => MapEntry(key.toString(), value),
            ) ??
            const <String, Object?>{},
      ),
    );
  }
}

class LearnerProgressionState {
  const LearnerProgressionState({
    this.entriesBySourceRef = const <String, LearnerProgressionEntry>{},
    this.badgeUnlockedAtById = const <String, String>{},
    this.milestoneUnlockedAtById = const <String, String>{},
    this.lastUpdatedAtIso,
  });

  final Map<String, LearnerProgressionEntry> entriesBySourceRef;
  final Map<String, String> badgeUnlockedAtById;
  final Map<String, String> milestoneUnlockedAtById;
  final String? lastUpdatedAtIso;

  LearnerProgressionState copyWith({
    Map<String, LearnerProgressionEntry>? entriesBySourceRef,
    Map<String, String>? badgeUnlockedAtById,
    Map<String, String>? milestoneUnlockedAtById,
    String? lastUpdatedAtIso,
    bool clearLastUpdatedAtIso = false,
  }) {
    return LearnerProgressionState(
      entriesBySourceRef: entriesBySourceRef ?? this.entriesBySourceRef,
      badgeUnlockedAtById: badgeUnlockedAtById ?? this.badgeUnlockedAtById,
      milestoneUnlockedAtById:
          milestoneUnlockedAtById ?? this.milestoneUnlockedAtById,
      lastUpdatedAtIso: clearLastUpdatedAtIso
          ? null
          : (lastUpdatedAtIso ?? this.lastUpdatedAtIso),
    );
  }

  Map<String, Object?> toJson() => <String, Object?>{
    'entriesBySourceRef': entriesBySourceRef.map(
      (key, value) => MapEntry(key, value.toJson()),
    ),
    'badgeUnlockedAtById': badgeUnlockedAtById,
    'milestoneUnlockedAtById': milestoneUnlockedAtById,
    'lastUpdatedAtIso': lastUpdatedAtIso,
  };

  factory LearnerProgressionState.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const LearnerProgressionState();
    }
    final rawEntries = json['entriesBySourceRef'];
    final entries = <String, LearnerProgressionEntry>{};
    if (rawEntries is Map) {
      for (final entry in rawEntries.entries) {
        entries[entry.key.toString()] = LearnerProgressionEntry.fromJson(
          entry.value is Map<String, dynamic>
              ? entry.value as Map<String, dynamic>
              : (entry.value as Map?)?.map(
                      (key, value) => MapEntry(key.toString(), value),
                    ) ??
                    <String, dynamic>{},
        );
      }
    }
    return LearnerProgressionState(
      entriesBySourceRef: entries,
      badgeUnlockedAtById: Map<String, String>.from(
        (json['badgeUnlockedAtById'] as Map?)?.map(
              (key, value) => MapEntry(key.toString(), value.toString()),
            ) ??
            const <String, String>{},
      ),
      milestoneUnlockedAtById: Map<String, String>.from(
        (json['milestoneUnlockedAtById'] as Map?)?.map(
              (key, value) => MapEntry(key.toString(), value.toString()),
            ) ??
            const <String, String>{},
      ),
      lastUpdatedAtIso: json['lastUpdatedAtIso']?.toString(),
    );
  }
}

class LearnerProgressionBadgeDefinition {
  const LearnerProgressionBadgeDefinition({
    required this.badgeId,
    required this.titleKey,
    required this.descriptionKey,
    required this.category,
    required this.iconName,
  });

  final String badgeId;
  final String titleKey;
  final String descriptionKey;
  final LearnerProgressionBadgeCategory category;
  final String iconName;
}

class LearnerProgressionMilestoneDefinition {
  const LearnerProgressionMilestoneDefinition({
    required this.milestoneId,
    required this.titleKey,
    required this.descriptionKey,
    required this.metric,
    required this.threshold,
  });

  final String milestoneId;
  final String titleKey;
  final String descriptionKey;
  final LearnerProgressionMilestoneMetric metric;
  final int threshold;
}

class LearnerProgressionBadgeUnlock {
  const LearnerProgressionBadgeUnlock({
    required this.definition,
    required this.unlockedAtIso,
  });

  final LearnerProgressionBadgeDefinition definition;
  final String unlockedAtIso;
}

class LearnerProgressionMilestoneUnlock {
  const LearnerProgressionMilestoneUnlock({
    required this.definition,
    required this.unlockedAtIso,
  });

  final LearnerProgressionMilestoneDefinition definition;
  final String unlockedAtIso;
}

class LearnerProgressionMetrics {
  const LearnerProgressionMetrics({
    required this.totalXp,
    required this.totalDrops,
    required this.kidsArabicLessonCompletions,
    required this.kidsArabicDailyMissionCompletions,
    required this.storyCompletions,
    required this.quizCompletions,
    required this.memoryCompletions,
    required this.duaLessonCompletions,
    required this.duaPracticeSessions,
    required this.duaMyDayCompletions,
    required this.bedtimeRoutineCompletions,
    required this.seerahNodeCompletions,
    required this.seerahStageCompletions,
    required this.seerahJourneyCompletions,
    required this.currentLearningStreakDays,
    required this.longestLearningStreakDays,
    required this.lastActivityAtIso,
    required this.activeDayKeys,
  });

  final int totalXp;
  final int totalDrops;
  final int kidsArabicLessonCompletions;
  final int kidsArabicDailyMissionCompletions;
  final int storyCompletions;
  final int quizCompletions;
  final int memoryCompletions;
  final int duaLessonCompletions;
  final int duaPracticeSessions;
  final int duaMyDayCompletions;
  final int bedtimeRoutineCompletions;
  final int seerahNodeCompletions;
  final int seerahStageCompletions;
  final int seerahJourneyCompletions;
  final int currentLearningStreakDays;
  final int longestLearningStreakDays;
  final String? lastActivityAtIso;
  final List<String> activeDayKeys;

  int valueForMilestone(LearnerProgressionMilestoneMetric metric) {
    return switch (metric) {
      LearnerProgressionMilestoneMetric.storiesCompleted => storyCompletions,
      LearnerProgressionMilestoneMetric.quizzesCompleted => quizCompletions,
      LearnerProgressionMilestoneMetric.duaLessonsCompleted =>
        duaLessonCompletions,
      LearnerProgressionMilestoneMetric.seerahStagesCompleted =>
        seerahStageCompletions,
      LearnerProgressionMilestoneMetric.seerahJourneysCompleted =>
        seerahJourneyCompletions,
      LearnerProgressionMilestoneMetric.bedtimeRoutineCompleted =>
        bedtimeRoutineCompletions,
      LearnerProgressionMilestoneMetric.learningStreakDays =>
        currentLearningStreakDays,
    };
  }
}

class LearnerProgressionSummary {
  const LearnerProgressionSummary({
    required this.metrics,
    required this.xpSummary,
    required this.unlockedBadges,
    required this.unlockedMilestones,
  });

  final LearnerProgressionMetrics metrics;
  final XpSummary xpSummary;
  final List<LearnerProgressionBadgeUnlock> unlockedBadges;
  final List<LearnerProgressionMilestoneUnlock> unlockedMilestones;
}

class LearnerProgressionAwardResult {
  const LearnerProgressionAwardResult({
    required this.awardedXp,
    required this.awardedDrops,
    required this.wasDuplicate,
    required this.newBadgeIds,
    required this.newMilestoneIds,
    required this.leveledUp,
  });

  final int awardedXp;
  final int awardedDrops;
  final bool wasDuplicate;
  final List<String> newBadgeIds;
  final List<String> newMilestoneIds;
  final bool leveledUp;
}
