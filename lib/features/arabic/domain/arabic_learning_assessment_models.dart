import 'arabic_learning_continuity_models.dart';

enum ArabicLearningAssessmentQuestionType { seeChoose, hearChoose }

class ArabicLearningAssessmentOption {
  const ArabicLearningAssessmentOption({
    required this.id,
    required this.title,
    this.arabicText,
    this.transliteration,
    this.meaning,
  });

  final String id;
  final String title;
  final String? arabicText;
  final String? transliteration;
  final String? meaning;
}

class ArabicLearningAssessmentQuestion {
  const ArabicLearningAssessmentQuestion({
    required this.questionId,
    required this.itemId,
    required this.contentType,
    required this.type,
    required this.correctOptionId,
    required this.followUpTarget,
    required this.title,
    required this.options,
    this.arabicPrompt,
    this.transliteration,
    this.meaning,
    this.audioPlaybackId,
    this.audioAssetPath,
    this.audioAlternateAssetPaths = const <String>[],
    this.audioFallbackText,
  });

  final String questionId;
  final String itemId;
  final ArabicLearningContinuationContentType contentType;
  final ArabicLearningAssessmentQuestionType type;
  final String correctOptionId;
  final ArabicLearningRouteTarget followUpTarget;
  final String title;
  final String? arabicPrompt;
  final String? transliteration;
  final String? meaning;
  final String? audioPlaybackId;
  final String? audioAssetPath;
  final List<String> audioAlternateAssetPaths;
  final String? audioFallbackText;
  final List<ArabicLearningAssessmentOption> options;
}

class ArabicLearningAssessmentSession {
  const ArabicLearningAssessmentSession({
    required this.audience,
    required this.questions,
    required this.continueTarget,
    this.reviewSuggestion,
  });

  final ArabicLearningAudience audience;
  final List<ArabicLearningAssessmentQuestion> questions;
  final ArabicLearningRouteTarget continueTarget;
  final ArabicLearningReviewSuggestion? reviewSuggestion;

  bool get isEmpty => questions.isEmpty;
}
