import 'arabic_learning_continuity_models.dart';

class ArabicLearningRecentActivity {
  const ArabicLearningRecentActivity({
    required this.contentType,
    required this.itemId,
    required this.title,
    this.arabicText,
    this.occurredAt,
  });

  final ArabicLearningContinuationContentType contentType;
  final String itemId;
  final String title;
  final String? arabicText;
  final DateTime? occurredAt;
}

class ArabicLearningProgressSummary {
  const ArabicLearningProgressSummary({
    required this.audience,
    required this.hasStarted,
    required this.totalLetters,
    required this.engagedLetters,
    required this.totalWords,
    required this.engagedWords,
    required this.totalPhrases,
    required this.engagedPhrases,
    required this.continuation,
    this.reviewSuggestion,
    this.recentActivity,
    this.currentStreakDays,
    this.completedLessons,
    this.totalLessons,
  });

  final ArabicLearningAudience audience;
  final bool hasStarted;
  final int totalLetters;
  final int engagedLetters;
  final int totalWords;
  final int engagedWords;
  final int totalPhrases;
  final int engagedPhrases;
  final ArabicLearningContinuationSummary continuation;
  final ArabicLearningReviewSuggestion? reviewSuggestion;
  final ArabicLearningRecentActivity? recentActivity;
  final int? currentStreakDays;
  final int? completedLessons;
  final int? totalLessons;

  double get overallProgress {
    final segments = <double>[
      totalLetters == 0 ? 0 : engagedLetters / totalLetters,
      totalWords == 0 ? 0 : engagedWords / totalWords,
      totalPhrases == 0 ? 0 : engagedPhrases / totalPhrases,
    ];
    return segments.reduce((sum, value) => sum + value) / segments.length;
  }
}
