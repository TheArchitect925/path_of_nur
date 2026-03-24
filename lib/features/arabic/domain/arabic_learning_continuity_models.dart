enum ArabicLearningAudience { kids, adult }

enum ArabicLearningContinuationIntent { start, resume, continueForward, review }

enum ArabicLearningContinuationContentType {
  letter,
  word,
  phrase,
  lesson,
  review,
}

enum ArabicLearningRouteTargetKind {
  goNamed,
  adultLesson,
  adultModule,
  adultBeginnerWords,
  adultDailyReview,
}

class ArabicLearningRouteTarget {
  const ArabicLearningRouteTarget({
    required this.kind,
    required this.contentType,
    required this.canonicalItemId,
    this.routeName,
    this.pathParameters = const <String, String>{},
    this.queryParameters = const <String, String>{},
    this.lessonId,
    this.moduleId,
    this.wordId,
  });

  final ArabicLearningRouteTargetKind kind;
  final ArabicLearningContinuationContentType contentType;
  final String canonicalItemId;
  final String? routeName;
  final Map<String, String> pathParameters;
  final Map<String, String> queryParameters;
  final String? lessonId;
  final String? moduleId;
  final String? wordId;
}

class ArabicLearningContinuationSummary {
  const ArabicLearningContinuationSummary({
    required this.audience,
    required this.intent,
    required this.contentType,
    required this.primaryTarget,
    required this.primaryItemId,
    this.primaryTitle,
    this.primarySubtitle,
    this.primaryArabicText,
    this.lastTouchedAt,
    this.secondaryIntent,
    this.secondaryTarget,
  });

  final ArabicLearningAudience audience;
  final ArabicLearningContinuationIntent intent;
  final ArabicLearningContinuationContentType contentType;
  final ArabicLearningRouteTarget primaryTarget;
  final String primaryItemId;
  final String? primaryTitle;
  final String? primarySubtitle;
  final String? primaryArabicText;
  final DateTime? lastTouchedAt;
  final ArabicLearningContinuationIntent? secondaryIntent;
  final ArabicLearningRouteTarget? secondaryTarget;
}

class ArabicLearningReviewSuggestion {
  const ArabicLearningReviewSuggestion({
    required this.audience,
    required this.intent,
    required this.contentType,
    required this.target,
    required this.itemId,
    this.title,
    this.subtitle,
    this.arabicText,
    this.lastTouchedAt,
  });

  final ArabicLearningAudience audience;
  final ArabicLearningContinuationIntent intent;
  final ArabicLearningContinuationContentType contentType;
  final ArabicLearningRouteTarget target;
  final String itemId;
  final String? title;
  final String? subtitle;
  final String? arabicText;
  final DateTime? lastTouchedAt;
}

class ArabicLearningReviewSummary {
  const ArabicLearningReviewSummary({
    required this.audience,
    required this.primarySuggestion,
    this.secondarySuggestions = const <ArabicLearningReviewSuggestion>[],
  });

  final ArabicLearningAudience audience;
  final ArabicLearningReviewSuggestion primarySuggestion;
  final List<ArabicLearningReviewSuggestion> secondarySuggestions;
}
