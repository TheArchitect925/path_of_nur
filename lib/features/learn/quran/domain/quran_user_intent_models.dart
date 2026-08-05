import 'quran_guided_learning_path_models.dart';
import 'quran_reference_models.dart';

enum QuranUserIntent { understand, reflect, memorize, themes, guidedPath }

extension QuranUserIntentWire on QuranUserIntent {
  String get wireName => switch (this) {
    QuranUserIntent.understand => 'understand',
    QuranUserIntent.reflect => 'reflect',
    QuranUserIntent.memorize => 'memorize',
    QuranUserIntent.themes => 'themes',
    QuranUserIntent.guidedPath => 'guided_path',
  };

  static QuranUserIntent? tryParse(String? raw) {
    return switch (raw?.trim().toLowerCase()) {
      'understand' => QuranUserIntent.understand,
      'reflect' => QuranUserIntent.reflect,
      'memorize' => QuranUserIntent.memorize,
      'themes' => QuranUserIntent.themes,
      'guided_path' => QuranUserIntent.guidedPath,
      _ => null,
    };
  }
}

QuranReaderStudyMode quranPreferredReaderModeForIntent(
  QuranUserIntent intent, {
  bool hasHighlightedTopic = false,
}) {
  return switch (intent) {
    QuranUserIntent.understand => QuranReaderStudyMode.study,
    QuranUserIntent.reflect => QuranReaderStudyMode.reflection,
    QuranUserIntent.memorize => QuranReaderStudyMode.memorization,
    QuranUserIntent.themes =>
      hasHighlightedTopic
          ? QuranReaderStudyMode.theme
          : QuranReaderStudyMode.study,
    QuranUserIntent.guidedPath => QuranReaderStudyMode.study,
  };
}

QuranGuidedLearningPathType? quranPreferredPathTypeForIntent(
  QuranUserIntent intent,
) {
  return switch (intent) {
    QuranUserIntent.understand =>
      QuranGuidedLearningPathType.beginnerUnderstanding,
    QuranUserIntent.reflect => QuranGuidedLearningPathType.reflectionJourney,
    QuranUserIntent.memorize => QuranGuidedLearningPathType.memorizationSupport,
    QuranUserIntent.themes => QuranGuidedLearningPathType.themeStudy,
    QuranUserIntent.guidedPath => null,
  };
}
