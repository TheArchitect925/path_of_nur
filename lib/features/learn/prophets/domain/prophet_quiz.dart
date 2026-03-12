enum ProphetQuizMode {
  prophetIdentification,
  timelineOrder,
  storyMatching,
  quranReference,
  lessonRecognition,
}

enum ProphetQuizDifficulty { easy, medium, hard }

enum ProphetQuizCategory {
  prophetIdentification,
  storyRecognition,
  lessonRecognition,
  timelinePlacement,
  eraGrouping,
  regionAssociation,
  quranReferenceAwareness,
  comparison,
  coreMessagePattern,
}

class ProphetQuizQuestion {
  const ProphetQuizQuestion({
    required this.id,
    required this.mode,
    required this.difficulty,
    required this.questionText,
    required this.options,
    required this.correctAnswerIndex,
    required this.explanation,
    required this.relatedProphetId,
    this.category,
    this.eraId,
    this.tags = const <String>[],
    this.isFeatured = false,
  });

  final String id;
  final ProphetQuizMode mode;
  final ProphetQuizDifficulty difficulty;
  final String questionText;
  final List<String> options;
  final int correctAnswerIndex;
  final String explanation;
  final String relatedProphetId;
  final ProphetQuizCategory? category;
  final String? eraId;
  final List<String> tags;
  final bool isFeatured;

  ProphetQuizCategory get effectiveCategory {
    if (category != null) return category!;
    switch (mode) {
      case ProphetQuizMode.prophetIdentification:
        return ProphetQuizCategory.prophetIdentification;
      case ProphetQuizMode.timelineOrder:
        return ProphetQuizCategory.timelinePlacement;
      case ProphetQuizMode.storyMatching:
        return ProphetQuizCategory.storyRecognition;
      case ProphetQuizMode.quranReference:
        return ProphetQuizCategory.quranReferenceAwareness;
      case ProphetQuizMode.lessonRecognition:
        return ProphetQuizCategory.lessonRecognition;
    }
  }
}

class ProphetQuizResult {
  const ProphetQuizResult({required this.score, required this.total});

  final int score;
  final int total;

  double get accuracy => total == 0 ? 0 : score / total;
}
