import 'learning_journey_models.dart';

class LearningJourneyLessonContent {
  const LearningJourneyLessonContent({
    required this.stageId,
    required this.title,
    required this.introduction,
    required this.sections,
    required this.keyTakeaways,
    required this.reflectionPrompt,
    this.quranReferences = const <String>[],
    this.sourceReferences = const <String>[],
    this.invocations = const <LearningJourneyLessonInvocation>[],
    this.relatedTools = const <LearningJourneyToolLink>[],
    this.continueJourneyIds = const <String>[],
    this.relatedJourneyIds = const <String>[],
    this.actionStep,
    this.reviewSuggestion,
    this.showDhikrCounterAction = false,
  });

  final String stageId;
  final String title;
  final String introduction;
  final List<LearningJourneyLessonSection> sections;
  final List<String> keyTakeaways;
  final String reflectionPrompt;
  final List<String> quranReferences;
  final List<String> sourceReferences;
  final List<LearningJourneyLessonInvocation> invocations;
  final List<LearningJourneyToolLink> relatedTools;
  final List<String> continueJourneyIds;
  final List<String> relatedJourneyIds;
  final String? actionStep;
  final String? reviewSuggestion;
  final bool showDhikrCounterAction;
}

class LearningJourneyLessonSection {
  const LearningJourneyLessonSection({
    required this.title,
    required this.body,
    this.bullets = const <String>[],
  });

  final String title;
  final String body;
  final List<String> bullets;
}

class LearningJourneyLessonInvocation {
  const LearningJourneyLessonInvocation({
    required this.title,
    required this.arabic,
    required this.transliteration,
    required this.meaning,
    required this.context,
    required this.sourceReference,
  });

  final String title;
  final String arabic;
  final String transliteration;
  final String meaning;
  final String context;
  final String sourceReference;
}
