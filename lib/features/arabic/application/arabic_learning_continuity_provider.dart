import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/arabic_learning_continuity_models.dart';
import 'arabic_learning_review_provider.dart';

final arabicLearningContinuationProvider =
    Provider.family<ArabicLearningContinuationSummary, ArabicLearningAudience>((
      ref,
      audience,
    ) {
      final review = ref.watch(arabicLearningReviewProvider(audience));
      final primary = review.primarySuggestion;
      final secondary = review.secondarySuggestions.isEmpty
          ? null
          : review.secondarySuggestions.first;
      return ArabicLearningContinuationSummary(
        audience: review.audience,
        intent: primary.intent,
        contentType: primary.contentType,
        primaryTarget: primary.target,
        primaryItemId: primary.itemId,
        primaryTitle: primary.title,
        primarySubtitle: primary.subtitle,
        primaryArabicText: primary.arabicText,
        lastTouchedAt: primary.lastTouchedAt,
        secondaryIntent: secondary?.intent,
        secondaryTarget: secondary?.target,
      );
    });
