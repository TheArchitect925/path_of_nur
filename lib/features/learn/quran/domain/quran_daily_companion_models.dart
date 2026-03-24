import '../application/quran_reference_graph_provider.dart';
import '../application/quran_daily_reflection_provider.dart';
import 'quran_guided_learning_path_models.dart';
import 'quran_learning_models.dart';
import 'quran_reference_models.dart';
import 'quran_user_intent_models.dart';

enum QuranDailyLoopSelectionSource { curatedRotation, journeyTheme }

class QuranDailyLoopJourneyContext {
  const QuranDailyLoopJourneyContext({
    required this.journeyId,
    required this.stageId,
    required this.topicIds,
    required this.connectionStrength,
    required this.suggestedReaderMode,
    this.suggestedLearningPathId,
  });

  final String journeyId;
  final String stageId;
  final List<String> topicIds;
  final QuranConnectionStrength connectionStrength;
  final QuranReaderStudyMode suggestedReaderMode;
  final String? suggestedLearningPathId;

  String? get primaryTopicId => topicIds.isEmpty ? null : topicIds.first;
}

class QuranDailyCompanionSummary {
  const QuranDailyCompanionSummary({
    required this.reflection,
    required this.meaningCue,
    required this.practicalTakeaway,
    required this.relatedLinks,
    required this.themes,
    required this.memorizationEntry,
    required this.activeIntent,
    required this.preferredReaderMode,
    required this.continuePath,
    required this.suggestedPath,
    required this.selectionSource,
    required this.journeyContext,
  });

  final QuranDailyReflectionSummary reflection;
  final String meaningCue;
  final String practicalTakeaway;
  final List<QuranRelatedKnowledgeLink> relatedLinks;
  final List<QuranTopic> themes;
  final MemorizationProgress? memorizationEntry;
  final QuranUserIntent? activeIntent;
  final QuranReaderStudyMode preferredReaderMode;
  final QuranGuidedLearningPath? continuePath;
  final QuranGuidedLearningPath? suggestedPath;
  final QuranDailyLoopSelectionSource selectionSource;
  final QuranDailyLoopJourneyContext? journeyContext;

  bool get isMemorized => memorizationEntry != null;
}
