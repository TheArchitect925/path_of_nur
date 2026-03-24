import 'arabic_learning_continuity_models.dart';

enum ArabicLearningQuickResumePrimaryAction { start, continueLearning, review }

class ArabicLearningQuickResumeSummary {
  const ArabicLearningQuickResumeSummary({
    required this.audience,
    required this.primaryAction,
    required this.primaryTarget,
    required this.primaryLocation,
    required this.primaryTitle,
    this.primarySubtitle,
    this.primaryArabicText,
    this.reviewTarget,
    this.reviewLocation,
    this.reviewTitle,
    this.lastTouchedAt,
  });

  final ArabicLearningAudience audience;
  final ArabicLearningQuickResumePrimaryAction primaryAction;
  final ArabicLearningRouteTarget primaryTarget;
  final String primaryLocation;
  final String primaryTitle;
  final String? primarySubtitle;
  final String? primaryArabicText;
  final ArabicLearningRouteTarget? reviewTarget;
  final String? reviewLocation;
  final String? reviewTitle;
  final DateTime? lastTouchedAt;

  bool get isFirstTime =>
      primaryAction == ArabicLearningQuickResumePrimaryAction.start;

  bool get hasReviewAction =>
      reviewTarget != null && reviewLocation != null && reviewTitle != null;
}
