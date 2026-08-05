class WuduStep {
  const WuduStep({
    required this.id,
    required this.number,
    required this.title,
    required this.subtitle,
    required this.iconKey,
    required this.imageAssetPath,
    this.quizKeywords = const <String>[],
    this.teachingNote,
  });

  final String id;
  final int number;
  final String title;
  final String subtitle;
  final String iconKey;
  final String imageAssetPath;
  final List<String> quizKeywords;
  final String? teachingNote;
}

enum WuduQuizPromptType { whatComesNext, identifyStep, orderStep }

class WuduQuizSeed {
  const WuduQuizSeed({
    required this.id,
    required this.type,
    required this.targetStepId,
    required this.relatedStepIds,
  });

  final String id;
  final WuduQuizPromptType type;
  final String targetStepId;
  final List<String> relatedStepIds;
}

enum WuduQuizQuestionType { stepOrder, whatComesNext, identifyValidStep, adab }

class WuduQuizOption {
  const WuduQuizOption({required this.id, required this.label});

  final String id;
  final String label;
}

class WuduQuizQuestion {
  const WuduQuizQuestion({
    required this.id,
    required this.type,
    required this.questionText,
    required this.options,
    required this.correctOptionId,
    required this.explanation,
  });

  final String id;
  final WuduQuizQuestionType type;
  final String questionText;
  final List<WuduQuizOption> options;
  final String correctOptionId;
  final String explanation;
}

class WuduQuizContent {
  const WuduQuizContent({
    required this.title,
    required this.subtitle,
    required this.introTitle,
    required this.introSubtitle,
    required this.summaryTitle,
    required this.summarySubtitle,
    required this.questions,
  });

  final String title;
  final String subtitle;
  final String introTitle;
  final String introSubtitle;
  final String summaryTitle;
  final String summarySubtitle;
  final List<WuduQuizQuestion> questions;
}

class WuduDua {
  const WuduDua({
    required this.arabic,
    required this.transliteration,
    required this.translation,
  });

  final String arabic;
  final String transliteration;
  final String translation;
}

class WuduContent {
  const WuduContent({
    required this.heroTitle,
    required this.heroSubtitle,
    required this.introTitle,
    required this.introSubtitle,
    required this.whyWuduMatters,
    required this.quranVerse,
    required this.quranReference,
    required this.quranReferenceLabel,
    required this.quranReferenceSubtitle,
    required this.stepsTitle,
    required this.stepsSubtitle,
    required this.checklistTitle,
    required this.checklistSubtitle,
    required this.completionTitle,
    required this.completionBody,
    required this.completionNote,
    required this.reviewSummary,
    required this.steps,
    required this.quizSeeds,
    required this.quizContent,
    required this.afterWuduDua,
    required this.learningNote,
  });

  final String heroTitle;
  final String heroSubtitle;
  final String introTitle;
  final String introSubtitle;
  final String whyWuduMatters;
  final String quranVerse;
  final String quranReference;
  final String quranReferenceLabel;
  final String quranReferenceSubtitle;
  final String stepsTitle;
  final String stepsSubtitle;
  final String checklistTitle;
  final String checklistSubtitle;
  final String completionTitle;
  final String completionBody;
  final String completionNote;
  final String reviewSummary;
  final List<WuduStep> steps;
  final List<WuduQuizSeed> quizSeeds;
  final WuduQuizContent quizContent;
  final WuduDua afterWuduDua;
  final String learningNote;
}
