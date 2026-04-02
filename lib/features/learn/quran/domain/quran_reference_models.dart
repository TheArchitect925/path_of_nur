enum QuranGraphNodeType { quranVerse, prophet, hadith, lifeLesson, journey }

enum QuranKnowledgeType {
  quranDirect,
  hadith,
  theme,
  character,
  seerah,
  journey,
  signsWorld,
  reflection,
  worship,
  lifeLesson,
}

enum QuranConnectionStrength { direct, strong, related, reflective }

extension QuranConnectionStrengthPriority on QuranConnectionStrength {
  int get priorityValue {
    return switch (this) {
      QuranConnectionStrength.direct => 0,
      QuranConnectionStrength.strong => 1,
      QuranConnectionStrength.related => 2,
      QuranConnectionStrength.reflective => 3,
    };
  }
}

enum QuranReaderStudyMode {
  reading,
  reflection,
  study,
  memorization,
  theme;

  String get wireName => switch (this) {
    QuranReaderStudyMode.reading => 'reading',
    QuranReaderStudyMode.reflection => 'reflection',
    QuranReaderStudyMode.study => 'study',
    QuranReaderStudyMode.memorization => 'memorization',
    QuranReaderStudyMode.theme => 'theme',
  };

  static QuranReaderStudyMode? tryParse(String? raw) {
    return switch (raw?.trim().toLowerCase()) {
      'reading' => QuranReaderStudyMode.reading,
      'reflection' => QuranReaderStudyMode.reflection,
      'study' => QuranReaderStudyMode.study,
      'memorization' => QuranReaderStudyMode.memorization,
      'theme' => QuranReaderStudyMode.theme,
      _ => null,
    };
  }
}

enum QuranExplanationDetailLevel {
  off,
  simple,
  standard,
  deep,
  kids;

  String get wireName => switch (this) {
    QuranExplanationDetailLevel.off => 'off',
    QuranExplanationDetailLevel.simple => 'simple',
    QuranExplanationDetailLevel.standard => 'standard',
    QuranExplanationDetailLevel.deep => 'deep',
    QuranExplanationDetailLevel.kids => 'kids',
  };

  static QuranExplanationDetailLevel? tryParse(String? raw) {
    return switch (raw?.trim().toLowerCase()) {
      'off' => QuranExplanationDetailLevel.off,
      'simple' => QuranExplanationDetailLevel.simple,
      'standard' => QuranExplanationDetailLevel.standard,
      'deep' => QuranExplanationDetailLevel.deep,
      'kids' => QuranExplanationDetailLevel.kids,
      _ => null,
    };
  }
}

class QuranReference {
  const QuranReference({
    required this.id,
    required this.surahNumber,
    required this.surahName,
    required this.ayahStart,
    required this.ayahEnd,
    required this.referenceLabel,
    required this.topicTags,
    required this.relatedProphetIds,
    required this.relatedLessonIds,
    required this.relatedHadithIds,
    required this.relatedJourneyIds,
    required this.keywords,
    required this.contextSummary,
    required this.importanceScore,
    required this.displayPriority,
  });

  final String id;
  final int surahNumber;
  final String surahName;
  final int ayahStart;
  final int ayahEnd;
  final String referenceLabel;
  final List<String> topicTags;
  final List<String> relatedProphetIds;
  final List<String> relatedLessonIds;
  final List<String> relatedHadithIds;
  final List<String> relatedJourneyIds;
  final List<String> keywords;
  final String contextSummary;
  final int importanceScore;
  final int displayPriority;

  String get verseKey => '$surahNumber:$ayahStart-$ayahEnd';

  bool containsAyah(int ayah) => ayah >= ayahStart && ayah <= ayahEnd;
}

class QuranKnowledgeNode {
  const QuranKnowledgeNode({
    required this.id,
    required this.type,
    required this.title,
  });

  final String id;
  final QuranGraphNodeType type;
  final String title;
}

class QuranKnowledgeEdge {
  const QuranKnowledgeEdge({
    required this.fromNodeId,
    required this.toNodeId,
    required this.relation,
  });

  final String fromNodeId;
  final String toNodeId;
  final String relation;
}

class QuranTopic {
  const QuranTopic({
    required this.id,
    required this.title,
    required this.description,
    required this.primaryReferenceId,
    required this.suggestedReaderMode,
    required this.verseReferences,
    required this.relatedLessons,
    required this.relatedHadith,
    required this.relatedProphets,
    this.relatedSurahNumbers = const <int>[],
    this.relatedRoutes = const <QuranTopicRouteTarget>[],
    this.searchKeywords = const <String>[],
    this.suggestedPathId,
  });

  final String id;
  final String title;
  final String description;
  final String? primaryReferenceId;
  final QuranReaderStudyMode suggestedReaderMode;
  final List<String> verseReferences;
  final List<String> relatedLessons;
  final List<String> relatedHadith;
  final List<String> relatedProphets;
  final List<int> relatedSurahNumbers;
  final List<QuranTopicRouteTarget> relatedRoutes;
  final List<String> searchKeywords;
  final String? suggestedPathId;
}

enum QuranTopicRouteKind {
  characterCompanion,
  seerahCompanion,
  dailyWisdomCompanion,
  dailyCompanion,
  hadith,
  life,
  world,
  prophets,
  guidedPath,
  memorizationReview,
  quranTheme,
  ayahInsightsDomain,
  ayahInsightPath,
  surahInsights,
}

class QuranTopicRouteTarget {
  const QuranTopicRouteTarget({
    required this.kind,
    required this.routeName,
    this.pathParameters = const <String, String>{},
    this.queryParameters = const <String, String>{},
  });

  final QuranTopicRouteKind kind;
  final String routeName;
  final Map<String, String> pathParameters;
  final Map<String, String> queryParameters;
}

class QuranReferenceGraph {
  const QuranReferenceGraph({
    required this.references,
    required this.topics,
    required this.nodes,
    required this.edges,
    required this.referenceById,
    required this.referenceIdsBySurah,
    required this.referenceIdsByTopic,
    required this.referenceIdsByKeyword,
    required this.referenceIdsByProphetMention,
  });

  final List<QuranReference> references;
  final List<QuranTopic> topics;
  final List<QuranKnowledgeNode> nodes;
  final List<QuranKnowledgeEdge> edges;
  final Map<String, QuranReference> referenceById;
  final Map<int, List<String>> referenceIdsBySurah;
  final Map<String, List<String>> referenceIdsByTopic;
  final Map<String, List<String>> referenceIdsByKeyword;
  final Map<String, List<String>> referenceIdsByProphetMention;
}
