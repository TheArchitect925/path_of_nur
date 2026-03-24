import '../../divine_life_lessons/data/divine_life_lessons_data.dart';
import '../../divine_life_lessons/domain/divine_life_models.dart';
import '../../hadith/data/hadith_curriculum_data.dart';
import '../../prophets/data/seeded_prophets_data.dart';
import 'quran_theme_reference_seed_data.dart';
import 'seeded_quran_learning_data.dart';
import '../domain/quran_reference_models.dart';

QuranReferenceGraph buildQuranReferenceGraph() {
  final refs = <QuranReference>[];

  for (final lesson in divineLifeLessons) {
    final referenceLabel =
        '${lesson.surahNumber}:${lesson.ayahStart}'
        '${lesson.ayahEnd > lesson.ayahStart ? '-${lesson.ayahEnd}' : ''}';
    refs.add(
      QuranReference(
        id: 'qr_${lesson.surahNumber}_${lesson.ayahStart}_${lesson.ayahEnd}',
        surahNumber: lesson.surahNumber,
        surahName: lesson.surahName,
        ayahStart: lesson.ayahStart,
        ayahEnd: lesson.ayahEnd,
        referenceLabel: referenceLabel,
        topicTags: _topicTagsForLifeLesson(lesson.id),
        relatedProphetIds: _prophetLinksForLabel(referenceLabel),
        relatedLessonIds: [lesson.id],
        relatedHadithIds: _hadithLinksForLabel(referenceLabel),
        relatedJourneyIds: _journeyLinksForLabel(referenceLabel),
        keywords: _keywordsForLesson(lesson),
        contextSummary: lesson.shortSummary,
        importanceScore: lesson.featuredPriority,
        displayPriority: lesson.featuredPriority,
      ),
    );
  }

  for (final verse in seededQuranLearningVerses) {
    final id = 'qr_${verse.surah}_${verse.ayah}_${verse.ayah}';
    if (refs.any((item) => item.id == id)) continue;
    final referenceLabel = '${verse.surah}:${verse.ayah}';
    refs.add(
      QuranReference(
        id: id,
        surahNumber: verse.surah,
        surahName: _surahNameFor(verse.surah),
        ayahStart: verse.ayah,
        ayahEnd: verse.ayah,
        referenceLabel: referenceLabel,
        topicTags: _topicTagsForLearningVerse(verse.themeTag),
        relatedProphetIds: _prophetLinksForLabel(referenceLabel),
        relatedLessonIds: const <String>[],
        relatedHadithIds: _hadithLinksForLabel(referenceLabel),
        relatedJourneyIds: verse.pathIds,
        keywords:
            [
                  verse.themeTag ?? '',
                  ...verse.lessons,
                  ...verse.reflectionPrompts,
                  'quran',
                  'verse',
                ]
                .map((item) => item.trim().toLowerCase())
                .where((item) => item.isNotEmpty)
                .toSet()
                .toList(growable: false),
        contextSummary: verse.explanation,
        importanceScore: 72,
        displayPriority: 72,
      ),
    );
  }

  for (final seed in quranThemeReferenceSeeds) {
    final id = 'qr_${seed.surahNumber}_${seed.ayahStart}_${seed.ayahEnd}';
    if (refs.any((item) => item.id == id)) continue;
    refs.add(
      QuranReference(
        id: seed.id,
        surahNumber: seed.surahNumber,
        surahName: seed.surahName ?? _surahNameFor(seed.surahNumber),
        ayahStart: seed.ayahStart,
        ayahEnd: seed.ayahEnd,
        referenceLabel: seed.referenceLabel,
        topicTags: seed.topicTags,
        relatedProphetIds: seed.relatedProphetIds,
        relatedLessonIds: seed.relatedLessonIds,
        relatedHadithIds: seed.relatedHadithIds,
        relatedJourneyIds: seed.relatedJourneyIds,
        keywords:
            [
                  seed.referenceLabel,
                  ...seed.topicTags,
                  ...seed.keywords,
                ]
                .map((item) => item.trim().toLowerCase())
                .where((item) => item.isNotEmpty)
                .toSet()
                .toList(growable: false),
        contextSummary: seed.contextSummary,
        importanceScore: seed.importanceScore,
        displayPriority: seed.importanceScore,
      ),
    );
  }

  final dedupedByRange = <String, QuranReference>{};
  for (final ref in refs) {
    final key = '${ref.surahNumber}:${ref.ayahStart}-${ref.ayahEnd}';
    final existing = dedupedByRange[key];
    if (existing == null) {
      dedupedByRange[key] = ref;
      continue;
    }
    dedupedByRange[key] = QuranReference(
      id: existing.id,
      surahNumber: existing.surahNumber,
      surahName: existing.surahName,
      ayahStart: existing.ayahStart,
      ayahEnd: existing.ayahEnd,
      referenceLabel: existing.referenceLabel,
      topicTags: {
        ...existing.topicTags,
        ...ref.topicTags,
      }.toList(growable: false),
      relatedProphetIds: {
        ...existing.relatedProphetIds,
        ...ref.relatedProphetIds,
      }.toList(growable: false),
      relatedLessonIds: {
        ...existing.relatedLessonIds,
        ...ref.relatedLessonIds,
      }.toList(growable: false),
      relatedHadithIds: {
        ...existing.relatedHadithIds,
        ...ref.relatedHadithIds,
      }.toList(growable: false),
      relatedJourneyIds: {
        ...existing.relatedJourneyIds,
        ...ref.relatedJourneyIds,
      }.toList(growable: false),
      keywords: {...existing.keywords, ...ref.keywords}.toList(growable: false),
      contextSummary:
          existing.contextSummary.length >= ref.contextSummary.length
          ? existing.contextSummary
          : ref.contextSummary,
      importanceScore: existing.importanceScore >= ref.importanceScore
          ? existing.importanceScore
          : ref.importanceScore,
      displayPriority: existing.displayPriority >= ref.displayPriority
          ? existing.displayPriority
          : ref.displayPriority,
    );
  }

  final references = dedupedByRange.values.toList(growable: false)
    ..sort((a, b) => b.displayPriority.compareTo(a.displayPriority));

  final topics = _buildTopics(references);
  final nodes = _buildNodes(references);
  final edges = _buildEdges(references);

  final referenceById = <String, QuranReference>{
    for (final item in references) item.id: item,
  };

  final referenceIdsBySurah = <int, List<String>>{};
  final referenceIdsByTopic = <String, List<String>>{};
  final referenceIdsByKeyword = <String, List<String>>{};
  final referenceIdsByProphetMention = <String, List<String>>{};

  for (final item in references) {
    referenceIdsBySurah
        .putIfAbsent(item.surahNumber, () => <String>[])
        .add(item.id);
    for (final tag in item.topicTags) {
      referenceIdsByTopic.putIfAbsent(tag, () => <String>[]).add(item.id);
    }
    for (final keyword in item.keywords) {
      referenceIdsByKeyword.putIfAbsent(keyword, () => <String>[]).add(item.id);
    }
    for (final prophetId in item.relatedProphetIds) {
      referenceIdsByProphetMention
          .putIfAbsent(prophetId, () => <String>[])
          .add(item.id);
    }
  }

  return QuranReferenceGraph(
    references: references,
    topics: topics,
    nodes: nodes,
    edges: edges,
    referenceById: referenceById,
    referenceIdsBySurah: referenceIdsBySurah,
    referenceIdsByTopic: referenceIdsByTopic,
    referenceIdsByKeyword: referenceIdsByKeyword,
    referenceIdsByProphetMention: referenceIdsByProphetMention,
  );
}

String _surahNameFor(int surahNumber) {
  for (final lesson in divineLifeLessons) {
    if (lesson.surahNumber == surahNumber) return lesson.surahName;
  }
  return 'Surah $surahNumber';
}

List<String> _topicTagsForLifeLesson(String lessonId) {
  if (lessonId.contains('patience') || lessonId.contains('hardship')) {
    return const ['patience', 'trials', 'hope'];
  }
  if (lessonId.contains('gratitude')) return const ['gratitude', 'faith'];
  if (lessonId.contains('repent') || lessonId.contains('mistake')) {
    return const ['repentance', 'forgiveness', 'hope'];
  }
  if (lessonId.contains('justice')) return const ['justice', 'accountability'];
  if (lessonId.contains('knowledge') || lessonId.contains('reflect')) {
    return const ['knowledge', 'creation', 'guidance'];
  }
  if (lessonId.contains('prayer')) return const ['prayer', 'faith'];
  if (lessonId.contains('charity') || lessonId.contains('spend')) {
    return const ['charity', 'mercy'];
  }
  if (lessonId.contains('mercy') || lessonId.contains('forgiveness')) {
    return const ['mercy', 'forgiveness'];
  }
  if (lessonId.contains('accountability') || lessonId.contains('test')) {
    return const ['accountability', 'trials'];
  }
  return const ['guidance', 'faith'];
}

List<String> _topicTagsForLearningVerse(String? themeTag) {
  switch (themeTag) {
    case 'patience':
      return const ['patience', 'trials'];
    case 'justice':
      return const ['justice', 'guidance'];
    case 'repentance':
      return const ['repentance', 'forgiveness', 'hope'];
    case 'prayer':
      return const ['prayer', 'faith'];
    case 'faith':
      return const ['faith', 'guidance'];
    default:
      return const ['guidance'];
  }
}

List<String> _keywordsForLesson(DivineLifeLesson lesson) {
  final output = <String>{
    lesson.title.toLowerCase(),
    lesson.shortSummary.toLowerCase(),
    lesson.quranReference.toLowerCase(),
    lesson.themeId.toLowerCase(),
    ...lesson.tags.map((item) => item.toLowerCase()),
    ...lesson.situationIds.map((item) => item.toLowerCase()),
  };
  return output.toList(growable: false);
}

List<String> _prophetLinksForLabel(String label) {
  final map = <String, List<String>>{
    '12:87': ['yusuf'],
    '20:14': ['musa'],
    '3:159': ['muhammad'],
  };
  return map[label] ?? const <String>[];
}

List<String> _hadithLinksForLabel(String label) {
  final map = <String, List<String>>{
    '2:153': ['hardship-sabr-with-purpose'],
    '12:87': ['hardship-grief-with-hope'],
    '14:7': ['gratitude-seeing-blessings-daily'],
    '13:28': ['worship-dhikr-heart-anchor'],
    '3:159': ['hardship-tawakkul-with-effort'],
    '65:3': ['hardship-tawakkul-with-effort'],
    '94:5-6': ['hardship-sabr-with-purpose'],
    '39:53': ['hardship-grief-with-hope'],
    '66:8': ['worship-hidden-deeds'],
    '41:34': ['community-reconciling-hearts'],
    '2:83': ['speech-say-good-or-silent'],
    '49:11': ['char-adab-correction'],
    '49:12': ['speech-avoid-backbiting-harm'],
    '25:63': ['humility-lowering-ego'],
    '31:18': ['humility-lowering-ego'],
    '4:135': ['community-justice-with-mercy'],
    '5:8': ['community-justice-with-mercy'],
    '17:23': ['family-honoring-parents'],
    '2:271': ['mercy-care-for-poor'],
    '3:92': ['mercy-care-for-poor'],
    '3:134': ['hardship-managing-anger'],
    '91:9-10': ['humility-daily-self-accounting'],
    '2:238': ['worship-consistency-small-deeds'],
    '29:45': ['worship-consistency-small-deeds'],
    '3:190-191': ['world-kindness-to-animals'],
    '20:114': ['worship-intentions-weigh-actions'],
    '42:43': ['community-reconciling-hearts'],
    '67:2': ['life-value-of-time'],
    '99:7-8': ['life-remembering-death-balance'],
  };
  return map[label] ?? const <String>[];
}

List<String> _journeyLinksForLabel(String label) {
  if (label.startsWith('2:153') || label.startsWith('12:87')) {
    return const ['foundations_faith', 'character_quran', 'path_return_hope'];
  }
  if (label.startsWith('39:53') || label.startsWith('66:8')) {
    return const ['hereafter', 'path_return_hope'];
  }
  if (label.startsWith('3:159') || label.startsWith('65:3')) {
    return const ['foundations_faith', 'path_faith_foundations'];
  }
  if (label.startsWith('67:2') || label.startsWith('99:7')) {
    return const ['hereafter'];
  }
  return const <String>[];
}

List<QuranTopic> _buildTopics(List<QuranReference> references) {
  const seeds = <(String, String, String)>[
    (
      'patience',
      'Patience',
      'Steadiness and endurance through hardship with trust in Allah.',
    ),
    (
      'gratitude',
      'Gratitude',
      'Recognizing blessings and using them in obedience.',
    ),
    ('faith', 'Faith', 'Belief, sincerity, and devotion in all states.'),
    (
      'repentance',
      'Repentance',
      'Returning to Allah with humility and reform.',
    ),
    (
      'justice',
      'Justice',
      'Upholding fairness and truth, even under pressure.',
    ),
    ('mercy', 'Mercy', 'Compassion in conduct, forgiveness, and service.'),
    ('knowledge', 'Knowledge', 'Seeking beneficial knowledge with reflection.'),
    ('prayer', 'Prayer', 'Salah as protection, grounding, and transformation.'),
    ('creation', 'Creation', 'Reflecting on creation as signs of Allah.'),
    ('guidance', 'Guidance', 'Following revelation for clarity and direction.'),
    ('charity', 'Charity', 'Giving sincerely and supporting those in need.'),
    (
      'accountability',
      'Accountability',
      'Awareness of deeds and ultimate return.',
    ),
    ('trials', 'Trials', 'Understanding hardship as a test with purpose.'),
    ('hope', 'Hope', 'Rejecting despair and trusting Allah’s mercy.'),
    (
      'forgiveness',
      'Forgiveness',
      'Pardon, inner release, and moral strength.',
    ),
  ];

  final topics = <QuranTopic>[];
  for (final seed in seeds) {
    final refs = references
        .where((item) => item.topicTags.contains(seed.$1))
        .toList(growable: false);
    topics.add(
      QuranTopic(
        id: seed.$1,
        title: seed.$2,
        description: seed.$3,
        primaryReferenceId: refs.isEmpty ? null : refs.first.id,
        suggestedReaderMode: QuranReaderStudyMode.theme,
        verseReferences: refs.map((item) => item.id).toList(growable: false),
        relatedLessons: refs
            .expand((item) => item.relatedLessonIds)
            .toSet()
            .toList(growable: false),
        relatedHadith: refs
            .expand((item) => item.relatedHadithIds)
            .toSet()
            .toList(growable: false),
        relatedProphets: refs
            .expand((item) => item.relatedProphetIds)
            .toSet()
            .toList(growable: false),
      ),
    );
  }
  return topics;
}

List<QuranKnowledgeNode> _buildNodes(List<QuranReference> references) {
  final nodes = <QuranKnowledgeNode>[];

  for (final ref in references) {
    nodes.add(
      QuranKnowledgeNode(
        id: 'quran:${ref.id}',
        type: QuranGraphNodeType.quranVerse,
        title: 'Qur’an ${ref.referenceLabel}',
      ),
    );
  }

  final prophetIds = references
      .expand((item) => item.relatedProphetIds)
      .toSet();
  for (final prophet in seededProphets.where(
    (item) => prophetIds.contains(item.id),
  )) {
    nodes.add(
      QuranKnowledgeNode(
        id: 'prophet:${prophet.id}',
        type: QuranGraphNodeType.prophet,
        title: prophet.name,
      ),
    );
  }

  final hadithIds = references.expand((item) => item.relatedHadithIds).toSet();
  for (final lesson in hadithCurriculum.lessons.where(
    (item) => hadithIds.contains(item.id),
  )) {
    nodes.add(
      QuranKnowledgeNode(
        id: 'hadith:${lesson.id}',
        type: QuranGraphNodeType.hadith,
        title: lesson.title,
      ),
    );
  }

  final lifeIds = references.expand((item) => item.relatedLessonIds).toSet();
  for (final lesson in divineLifeLessons.where(
    (item) => lifeIds.contains(item.id),
  )) {
    nodes.add(
      QuranKnowledgeNode(
        id: 'life:${lesson.id}',
        type: QuranGraphNodeType.lifeLesson,
        title: lesson.title,
      ),
    );
  }

  final journeyIds = references
      .expand((item) => item.relatedJourneyIds)
      .toSet();
  for (final path in seededQuranLearningPaths.where(
    (item) => journeyIds.contains(item.id),
  )) {
    nodes.add(
      QuranKnowledgeNode(
        id: 'journey:${path.id}',
        type: QuranGraphNodeType.journey,
        title: path.title,
      ),
    );
  }

  return nodes;
}

List<QuranKnowledgeEdge> _buildEdges(List<QuranReference> references) {
  final edges = <QuranKnowledgeEdge>[];
  for (final ref in references) {
    final verseNodeId = 'quran:${ref.id}';
    for (final prophetId in ref.relatedProphetIds) {
      edges.add(
        QuranKnowledgeEdge(
          fromNodeId: verseNodeId,
          toNodeId: 'prophet:$prophetId',
          relation: 'mentions_or_theme',
        ),
      );
    }
    for (final hadithId in ref.relatedHadithIds) {
      edges.add(
        QuranKnowledgeEdge(
          fromNodeId: verseNodeId,
          toNodeId: 'hadith:$hadithId',
          relation: 'supports',
        ),
      );
    }
    for (final lessonId in ref.relatedLessonIds) {
      edges.add(
        QuranKnowledgeEdge(
          fromNodeId: verseNodeId,
          toNodeId: 'life:$lessonId',
          relation: 'applies_to_life_lesson',
        ),
      );
    }
    for (final journeyId in ref.relatedJourneyIds) {
      edges.add(
        QuranKnowledgeEdge(
          fromNodeId: verseNodeId,
          toNodeId: 'journey:$journeyId',
          relation: 'belongs_to_journey',
        ),
      );
    }
  }
  return edges;
}
