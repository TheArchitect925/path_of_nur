import '../../arabic/domain/arabic_learning_continuity_models.dart';
import '../../arabic/domain/arabic_learning_progress_models.dart';

class KidsArabicParentOverviewSummary {
  const KidsArabicParentOverviewSummary({
    required this.hasStarted,
    required this.lettersLearned,
    required this.wordsPracticed,
    required this.phrasesHeard,
    required this.practicedToday,
    required this.reviewNeededCount,
    required this.continuation,
    this.recentActivity,
    this.reviewSuggestion,
    this.latestAchievementId,
    this.latestCompletedLetterId,
  });

  final bool hasStarted;
  final int lettersLearned;
  final int wordsPracticed;
  final int phrasesHeard;
  final bool practicedToday;
  final int reviewNeededCount;
  final ArabicLearningContinuationSummary continuation;
  final ArabicLearningRecentActivity? recentActivity;
  final ArabicLearningReviewSuggestion? reviewSuggestion;
  final String? latestAchievementId;
  final String? latestCompletedLetterId;

  bool get hasFinishedCurrentBeginnerSet =>
      hasStarted &&
      lettersLearned >= 28 &&
      wordsPracticed > 0 &&
      reviewNeededCount == 0;
}
