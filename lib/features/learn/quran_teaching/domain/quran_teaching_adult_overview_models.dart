import '../../../arabic/domain/arabic_learning_continuity_models.dart';
import '../../../arabic/domain/arabic_learning_progress_models.dart';

enum QuranTeachingAdultOverviewState { firstTime, inProgress, completed }

class QuranTeachingAdultOverviewSummary {
  const QuranTeachingAdultOverviewSummary({
    required this.state,
    required this.progress,
    required this.primaryTarget,
    this.reviewTarget,
    this.browseLettersTarget,
    this.browseWordsTarget,
  });

  final QuranTeachingAdultOverviewState state;
  final ArabicLearningProgressSummary progress;
  final ArabicLearningRouteTarget primaryTarget;
  final ArabicLearningRouteTarget? reviewTarget;
  final ArabicLearningRouteTarget? browseLettersTarget;
  final ArabicLearningRouteTarget? browseWordsTarget;
}
