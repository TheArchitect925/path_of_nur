import 'bedtime_story_learning_models.dart';

enum BedtimeParentActivityType {
  storyStarted,
  storyListened,
  storyCompleted,
  quizCompleted,
  memoryCompleted,
}

enum BedtimeParentRecommendationType {
  continueStory,
  completeQuiz,
  completeMemory,
  nextStory,
  tonightStory,
}

class BedtimeParentOverviewSummary {
  const BedtimeParentOverviewSummary({
    required this.learnerId,
    required this.learnerDisplayName,
    required this.currentLevel,
    required this.currentLevelTitle,
    required this.xpProgressPercent,
    required this.xpRemainingToNextLevel,
    required this.totalStoriesCompleted,
    required this.totalStoryPartsCompleted,
    required this.totalQuizzesCompleted,
    required this.totalMemorySessionsCompleted,
    required this.totalRecallActivitiesCompleted,
    required this.totalBedtimeLearningSessions,
    required this.totalXpEarnedFromBedtimeLearning,
    required this.totalOceanDropsEarnedFromBedtimeLearning,
    required this.totalXpEarnedAcrossKidsLearning,
    required this.totalOceanDropsEarnedAcrossKidsLearning,
    required this.totalKidsStoriesCompleted,
    required this.totalSeerahStagesCompleted,
    required this.totalSeerahJourneysCompleted,
    required this.totalDuasLearned,
    required this.totalArabicLettersCompleted,
    required this.totalArabicReviewLetters,
    required this.currentBedtimeLearningStreak,
    required this.longestBedtimeLearningStreak,
    required this.lastBedtimeSessionDateIso,
    required this.prophetsExploredCount,
    required this.lessonsLearned,
  });

  final String? learnerId;
  final String? learnerDisplayName;
  final int currentLevel;
  final String currentLevelTitle;
  final double xpProgressPercent;
  final int xpRemainingToNextLevel;
  final int totalStoriesCompleted;
  final int totalStoryPartsCompleted;
  final int totalQuizzesCompleted;
  final int totalMemorySessionsCompleted;
  final int totalRecallActivitiesCompleted;
  final int totalBedtimeLearningSessions;
  final int totalXpEarnedFromBedtimeLearning;
  final int totalOceanDropsEarnedFromBedtimeLearning;
  final int totalXpEarnedAcrossKidsLearning;
  final int totalOceanDropsEarnedAcrossKidsLearning;
  final int totalKidsStoriesCompleted;
  final int totalSeerahStagesCompleted;
  final int totalSeerahJourneysCompleted;
  final int totalDuasLearned;
  final int totalArabicLettersCompleted;
  final int totalArabicReviewLetters;
  final int currentBedtimeLearningStreak;
  final int longestBedtimeLearningStreak;
  final String? lastBedtimeSessionDateIso;
  final int prophetsExploredCount;
  final List<String> lessonsLearned;
}

enum KidsParentContinueType { story, seerah, dua, arabic }

class KidsParentContinueLearningItem {
  const KidsParentContinueLearningItem({
    required this.type,
    required this.title,
    required this.subtitle,
    required this.routeName,
    this.pathParameters = const <String, String>{},
    this.queryParameters = const <String, String>{},
  });

  final KidsParentContinueType type;
  final String title;
  final String subtitle;
  final String routeName;
  final Map<String, String> pathParameters;
  final Map<String, String> queryParameters;
}

enum KidsParentLearningAreaType { stories, seerah, duas, arabic }

class KidsParentLearningAreaSummary {
  const KidsParentLearningAreaSummary({
    required this.type,
    required this.completedCount,
    required this.totalCount,
    required this.secondaryCount,
    required this.lastActiveDateIso,
    required this.hasActivity,
  });

  final KidsParentLearningAreaType type;
  final int completedCount;
  final int totalCount;
  final int secondaryCount;
  final String? lastActiveDateIso;
  final bool hasActivity;
}

enum KidsParentRecentActivityType {
  story,
  quiz,
  memory,
  duaLesson,
  duaPractice,
  duaMyDay,
  seerahNode,
  seerahStage,
  seerahJourney,
  arabicLesson,
  arabicDailyMission,
  bedtimeRoutine,
}

class KidsParentRecentActivityItem {
  const KidsParentRecentActivityItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.type,
    required this.occurredAtIso,
  });

  final String id;
  final String title;
  final String subtitle;
  final KidsParentRecentActivityType type;
  final String occurredAtIso;
}

class BedtimeParentHabitSummary {
  const BedtimeParentHabitSummary({
    required this.currentStreak,
    required this.longestStreak,
    required this.activeDaysThisWeek,
    required this.activeDaysThisMonth,
    required this.averageSessionsPerWeek,
    required this.lastActiveDateIso,
    required this.activeDayKeys,
  });

  final int currentStreak;
  final int longestStreak;
  final int activeDaysThisWeek;
  final int activeDaysThisMonth;
  final double averageSessionsPerWeek;
  final String? lastActiveDateIso;
  final List<String> activeDayKeys;
}

class BedtimeParentRecentActivityItem {
  const BedtimeParentRecentActivityItem({
    required this.id,
    required this.storyId,
    required this.title,
    required this.prophetId,
    required this.type,
    required this.occurredAtIso,
    required this.completionState,
  });

  final String id;
  final String storyId;
  final String title;
  final String prophetId;
  final BedtimeParentActivityType type;
  final String occurredAtIso;
  final BedtimeStoryLearningCompletionState completionState;
}

class BedtimeParentProphetProgress {
  const BedtimeParentProphetProgress({
    required this.prophetId,
    required this.title,
    required this.mainLesson,
    required this.storyPartsCompleted,
    required this.totalStoryParts,
    required this.quizCompleted,
    required this.memoryCompleted,
    required this.started,
    required this.completed,
    required this.continueStoryId,
  });

  final String prophetId;
  final String title;
  final String mainLesson;
  final int storyPartsCompleted;
  final int totalStoryParts;
  final bool quizCompleted;
  final bool memoryCompleted;
  final bool started;
  final bool completed;
  final String? continueStoryId;
}

class BedtimeParentRecommendation {
  const BedtimeParentRecommendation({
    required this.type,
    required this.storyId,
    required this.title,
    required this.subtitle,
    this.activityMode,
  });

  final BedtimeParentRecommendationType type;
  final String storyId;
  final String title;
  final String subtitle;
  final BedtimeStoryLearningMode? activityMode;
}

class BedtimeParentDashboardSummary {
  const BedtimeParentDashboardSummary({
    required this.overview,
    required this.habitSummary,
    required this.continueLearning,
    required this.learningAreas,
    required this.learningRecentActivity,
    required this.recentActivity,
    required this.prophetProgress,
    required this.recommendations,
    required this.progressionBadges,
    required this.progressionMilestones,
  });

  final BedtimeParentOverviewSummary overview;
  final BedtimeParentHabitSummary habitSummary;
  final KidsParentContinueLearningItem? continueLearning;
  final List<KidsParentLearningAreaSummary> learningAreas;
  final List<KidsParentRecentActivityItem> learningRecentActivity;
  final List<BedtimeParentRecentActivityItem> recentActivity;
  final List<BedtimeParentProphetProgress> prophetProgress;
  final List<BedtimeParentRecommendation> recommendations;
  final List<String> progressionBadges;
  final List<String> progressionMilestones;
}
