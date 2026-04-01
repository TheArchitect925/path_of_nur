import '../../guided_paths/domain/guided_learning_path_models.dart';
import '../../shared/domain/learn_system_models.dart';

enum LearningEngagementState { newLearner, active, returning, dormant }

enum LearningIntentSignal {
  foundations,
  quran,
  worship,
  character,
  stories,
  games,
  kids,
  general,
}

enum LearningRecommendationKind {
  continueGuidedPathStep,
  startGuidedPath,
  resumeGuidedPath,
}

enum LearningRecommendationReason {
  activeGuidedPath,
  sequencedAfterCompletion,
  quranMomentum,
  dhikrMomentum,
  salahMomentum,
  kidsProfile,
  noHistory,
  inactiveReentry,
  fridayRhythm,
  ramadanRhythm,
  keepMomentum,
  safeFallback,
}

enum LearningRecommendationContextTag { friday, ramadan, momentum }

class LearningRecommendationRouteTarget {
  const LearningRecommendationRouteTarget({
    required this.routeName,
    this.pathParameters = const <String, String>{},
    this.queryParameters = const <String, String>{},
  });

  final String routeName;
  final Map<String, String> pathParameters;
  final Map<String, String> queryParameters;
}

class LearningSignals {
  const LearningSignals({
    required this.isChildProfile,
    required this.ramadanModeEnabled,
    required this.now,
    required this.activePathId,
    required this.activeStepId,
    required this.completedPathIds,
    required this.startedPathIds,
    required this.pathLastUpdatedAtById,
    required this.pathCompletedAtById,
    required this.recentLearnDomains,
    required this.quranReadingCountLast7Days,
    required this.quranReadingSecondsToday,
    required this.quranHasPersonalizationSignals,
    required this.dhikrSessionsLast7Days,
    required this.salahActivityCount,
    required this.learnStartedCount,
    required this.learnCompletedCount,
    required this.learnSavedCount,
    required this.learnNotesCount,
    required this.lastLearnActivityAt,
  });

  final bool isChildProfile;
  final bool ramadanModeEnabled;
  final DateTime now;
  final String? activePathId;
  final String? activeStepId;
  final Set<String> completedPathIds;
  final Set<String> startedPathIds;
  final Map<String, DateTime> pathLastUpdatedAtById;
  final Map<String, DateTime> pathCompletedAtById;
  final List<LearnUnifiedDomain> recentLearnDomains;
  final int quranReadingCountLast7Days;
  final int quranReadingSecondsToday;
  final bool quranHasPersonalizationSignals;
  final int dhikrSessionsLast7Days;
  final int salahActivityCount;
  final int learnStartedCount;
  final int learnCompletedCount;
  final int learnSavedCount;
  final int learnNotesCount;
  final DateTime? lastLearnActivityAt;

  bool get hasHistory =>
      activePathId != null ||
      completedPathIds.isNotEmpty ||
      startedPathIds.isNotEmpty ||
      recentLearnDomains.isNotEmpty ||
      quranReadingCountLast7Days > 0 ||
      dhikrSessionsLast7Days > 0 ||
      learnStartedCount > 0 ||
      learnCompletedCount > 0;

  bool get isFriday => now.weekday == DateTime.friday;
}

class UserLearningProfile {
  const UserLearningProfile({
    required this.engagementState,
    required this.primaryIntent,
    required this.secondaryIntents,
    required this.hasHistory,
    required this.isChildProfile,
    required this.lastLearnActivityAt,
  });

  final LearningEngagementState engagementState;
  final LearningIntentSignal primaryIntent;
  final List<LearningIntentSignal> secondaryIntents;
  final bool hasHistory;
  final bool isChildProfile;
  final DateTime? lastLearnActivityAt;
}

class PathSuggestion {
  const PathSuggestion({
    required this.pathId,
    required this.reason,
    this.contextTag,
  });

  final String pathId;
  final LearningRecommendationReason reason;
  final LearningRecommendationContextTag? contextTag;
}

class PersonalizedLearnRecommendation {
  const PersonalizedLearnRecommendation({
    required this.kind,
    required this.reason,
    required this.routeTarget,
    this.contextTag,
    this.pathId,
    this.stepId,
  });

  final LearningRecommendationKind kind;
  final LearningRecommendationReason reason;
  final LearningRecommendationRouteTarget routeTarget;
  final LearningRecommendationContextTag? contextTag;
  final String? pathId;
  final String? stepId;
}

class LearningPersonalizationSummary {
  const LearningPersonalizationSummary({
    required this.profile,
    required this.primaryRecommendation,
    required this.secondarySuggestions,
  });

  final UserLearningProfile profile;
  final PersonalizedLearnRecommendation primaryRecommendation;
  final List<PathSuggestion> secondarySuggestions;
}

class LocalizedPathSuggestion {
  const LocalizedPathSuggestion({
    required this.pathId,
    required this.title,
    required this.subtitle,
    required this.routeTarget,
  });

  final String pathId;
  final String title;
  final String subtitle;
  final LearningRecommendationRouteTarget routeTarget;
}

class LocalizedLearningPersonalizationSummary {
  const LocalizedLearningPersonalizationSummary({
    required this.title,
    required this.subtitle,
    required this.reasonText,
    required this.primaryActionLabel,
    required this.primaryActionRouteTarget,
    required this.secondaryActionLabel,
    required this.secondaryActionRouteTarget,
    required this.progressLabel,
    required this.progressValue,
    required this.contextBadgeLabel,
    required this.secondarySuggestionsTitle,
    required this.secondarySuggestions,
  });

  final String title;
  final String subtitle;
  final String reasonText;
  final String primaryActionLabel;
  final LearningRecommendationRouteTarget primaryActionRouteTarget;
  final String? secondaryActionLabel;
  final LearningRecommendationRouteTarget? secondaryActionRouteTarget;
  final String? progressLabel;
  final double? progressValue;
  final String? contextBadgeLabel;
  final String secondarySuggestionsTitle;
  final List<LocalizedPathSuggestion> secondarySuggestions;
}

class LearningPathSequenceDefinition {
  const LearningPathSequenceDefinition({
    required this.pathId,
    required this.nextPathIds,
  });

  final String pathId;
  final List<String> nextPathIds;
}

class LearningPathRecommendationContext {
  const LearningPathRecommendationContext({
    required this.signals,
    required this.visiblePathsById,
  });

  final LearningSignals signals;
  final Map<String, GuidedLearningPath> visiblePathsById;
}
