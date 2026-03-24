import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/arabic_learning_continuity_models.dart';
import '../domain/arabic_learning_quick_resume_models.dart';
import 'arabic_learning_continuity_provider.dart';
import 'arabic_learning_route_target_helpers.dart';

final arabicLearningQuickResumeSummaryProvider =
    Provider.family<ArabicLearningQuickResumeSummary, ArabicLearningAudience>((
      ref,
      audience,
    ) {
      final continuation = ref.watch(arabicLearningContinuationProvider(audience));
      final primaryLocation = arabicLearningRouteLocationForTarget(
        continuation.primaryTarget,
      );
      final reviewTarget = _reviewTargetForAudience(audience);
      final reviewLocation = arabicLearningRouteLocationForTarget(reviewTarget);

      return ArabicLearningQuickResumeSummary(
        audience: audience,
        primaryAction: switch (continuation.intent) {
          ArabicLearningContinuationIntent.start =>
            ArabicLearningQuickResumePrimaryAction.start,
          ArabicLearningContinuationIntent.review =>
            ArabicLearningQuickResumePrimaryAction.review,
          ArabicLearningContinuationIntent.resume ||
          ArabicLearningContinuationIntent.continueForward =>
            ArabicLearningQuickResumePrimaryAction.continueLearning,
        },
        primaryTarget: continuation.primaryTarget,
        primaryLocation: primaryLocation ?? _fallbackLocationForAudience(audience),
        primaryTitle: continuation.primaryTitle ?? 'Arabic',
        primarySubtitle: continuation.primarySubtitle,
        primaryArabicText: continuation.primaryArabicText,
        reviewTarget: reviewLocation == null ? null : reviewTarget,
        reviewLocation: reviewLocation,
        reviewTitle: 'Review',
        lastTouchedAt: continuation.lastTouchedAt,
      );
    });

String _fallbackLocationForAudience(ArabicLearningAudience audience) {
  switch (audience) {
    case ArabicLearningAudience.kids:
      return '/learn/kids/arabic';
    case ArabicLearningAudience.adult:
      return '/quran/arabic';
  }
}

ArabicLearningRouteTarget _reviewTargetForAudience(
  ArabicLearningAudience audience,
) {
  switch (audience) {
    case ArabicLearningAudience.kids:
      return const ArabicLearningRouteTarget(
        kind: ArabicLearningRouteTargetKind.goNamed,
        contentType: ArabicLearningContinuationContentType.review,
        canonicalItemId: 'kids_arabic_review',
        routeName: 'kidsArabicReview',
      );
    case ArabicLearningAudience.adult:
      return const ArabicLearningRouteTarget(
        kind: ArabicLearningRouteTargetKind.adultDailyReview,
        contentType: ArabicLearningContinuationContentType.review,
        canonicalItemId: 'adult_daily_review',
      );
  }
}
