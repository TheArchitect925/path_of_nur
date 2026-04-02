import 'quran_ayah_action_models.dart';
import 'quran_content_refs.dart';
import 'quran_reference_models.dart';
import 'quran_user_intent_models.dart';

enum QuranPersonalizationSurface { home, quranHub, reader, growth, kidsReader }

enum QuranPersonalizationTimeSegment { morning, afternoon, evening, night }

enum QuranRecommendationReasonCode {
  continueReading,
  recentReflection,
  dailyAnchor,
  guidedPathFocus,
  prayerSupport,
  remembranceRhythm,
  memorizationReview,
  beginnerFriendly,
  kidsFriendly,
  keepMomentum,
  gentleForToday,
  growthFocus,
}

class QuranRecommendationSignalContribution {
  const QuranRecommendationSignalContribution({
    required this.reasonCode,
    required this.score,
    required this.debugLabel,
  });

  final QuranRecommendationReasonCode reasonCode;
  final int score;
  final String debugLabel;
}

class QuranPersonalizationProfile {
  const QuranPersonalizationProfile({
    required this.now,
    required this.dateKey,
    required this.timeSegment,
    required this.isKidsProfile,
    required this.readingStreak,
    required this.readingTimeTodaySeconds,
    required this.listeningTimeTodaySeconds,
    required this.recentAyahKeys,
    required this.bookmarkedAyahKeys,
    required this.reflectionAyahKeys,
    required this.memorizationAyahKeys,
    required this.memorizationDueAyahKeys,
    required this.completedActionAyahKeysToday,
    required this.actionStreak,
    required this.prayerCompletedToday,
    required this.dhikrSessionsLast7Days,
    required this.notesCount,
    required this.bookmarkCount,
    required this.reflectionCount,
    required this.selectedIntent,
    required this.activePathId,
    required this.suggestedPathId,
    required this.dailyAyahKey,
    required this.recentPrimaryAyahKeys,
    required this.dismissedAyahKeysToday,
  });

  final DateTime now;
  final String dateKey;
  final QuranPersonalizationTimeSegment timeSegment;
  final bool isKidsProfile;
  final int readingStreak;
  final int readingTimeTodaySeconds;
  final int listeningTimeTodaySeconds;
  final List<String> recentAyahKeys;
  final Set<String> bookmarkedAyahKeys;
  final Set<String> reflectionAyahKeys;
  final Set<String> memorizationAyahKeys;
  final Set<String> memorizationDueAyahKeys;
  final Set<String> completedActionAyahKeysToday;
  final int actionStreak;
  final int prayerCompletedToday;
  final int dhikrSessionsLast7Days;
  final int notesCount;
  final int bookmarkCount;
  final int reflectionCount;
  final QuranUserIntent? selectedIntent;
  final String? activePathId;
  final String? suggestedPathId;
  final String? dailyAyahKey;
  final List<String> recentPrimaryAyahKeys;
  final Set<String> dismissedAyahKeysToday;

  bool get hasHistory =>
      recentAyahKeys.isNotEmpty ||
      bookmarkedAyahKeys.isNotEmpty ||
      reflectionAyahKeys.isNotEmpty ||
      memorizationAyahKeys.isNotEmpty ||
      bookmarkCount > 0 ||
      reflectionCount > 0 ||
      notesCount > 0 ||
      readingStreak > 0;
}

class QuranRecommendationContext {
  const QuranRecommendationContext({
    required this.surface,
    required this.preferKids,
    this.currentRef,
  });

  final QuranPersonalizationSurface surface;
  final bool preferKids;
  final QuranQuoteRef? currentRef;
}

class QuranAdaptiveJourneySuggestion {
  const QuranAdaptiveJourneySuggestion({
    required this.pathId,
    required this.reasonCode,
    required this.routeName,
    required this.pathParameters,
  });

  final String pathId;
  final QuranRecommendationReasonCode reasonCode;
  final String routeName;
  final Map<String, String> pathParameters;
}

class QuranRecommendedAyah {
  const QuranRecommendedAyah({
    required this.ref,
    required this.reasonCode,
    required this.score,
    required this.matchedTags,
    required this.recommendedDetailLevel,
    required this.explanationPreview,
    required this.explanationBody,
    required this.actionRecommendation,
    required this.debugContributions,
    required this.freshnessPenaltyApplied,
    required this.isContinuationCandidate,
    this.suggestedJourney,
  });

  final QuranQuoteRef ref;
  final QuranRecommendationReasonCode reasonCode;
  final int score;
  final List<String> matchedTags;
  final QuranExplanationDetailLevel recommendedDetailLevel;
  final String explanationPreview;
  final String explanationBody;
  final QuranAyahActionRecommendation actionRecommendation;
  final List<QuranRecommendationSignalContribution> debugContributions;
  final bool freshnessPenaltyApplied;
  final bool isContinuationCandidate;
  final QuranAdaptiveJourneySuggestion? suggestedJourney;

  String get ayahKey => '${ref.surah}:${ref.ayah}';
}

class QuranRecommendationBundle {
  const QuranRecommendationBundle({
    required this.surface,
    required this.preferKids,
    required this.generatedDateKey,
    required this.primary,
    this.secondary,
    this.suggestedJourney,
  });

  final QuranPersonalizationSurface surface;
  final bool preferKids;
  final String generatedDateKey;
  final QuranRecommendedAyah primary;
  final QuranRecommendedAyah? secondary;
  final QuranAdaptiveJourneySuggestion? suggestedJourney;
}
