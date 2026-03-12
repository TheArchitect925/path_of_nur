enum QuranGraphNodeType { quranVerse, prophet, hadith, lifeLesson, journey }

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
    required this.verseReferences,
    required this.relatedLessons,
    required this.relatedHadith,
    required this.relatedProphets,
  });

  final String id;
  final String title;
  final String description;
  final List<String> verseReferences;
  final List<String> relatedLessons;
  final List<String> relatedHadith;
  final List<String> relatedProphets;
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
