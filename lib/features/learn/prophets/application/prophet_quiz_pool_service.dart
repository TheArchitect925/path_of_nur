import '../data/seeded_prophet_detail_content.dart';
import '../data/seeded_prophet_quiz_questions.dart';
import '../data/seeded_prophets_data.dart';
import '../domain/prophet_detail_content.dart';
import '../domain/prophet_entry.dart';
import '../domain/prophet_quiz.dart';

class ProphetQuizPoolService {
  const ProphetQuizPoolService._();

  static List<ProphetQuizQuestion> buildExpandedPool() {
    final byId = {for (final prophet in seededProphets) prophet.id: prophet};
    final generated = <ProphetQuizQuestion>[];

    for (final detail in seededProphetDetailContent) {
      final prophet = byId[detail.prophetId];
      if (prophet == null) continue;
      generated.addAll(_questionsForProphet(prophet.id, detail, byId));
    }

    final deduped = <String, ProphetQuizQuestion>{
      for (final question in seededProphetQuizQuestions) question.id: question,
      for (final question in generated) question.id: question,
    };

    return deduped.values
        .map((question) => _enrichQuestion(question, byId))
        .toList(growable: false);
  }

  static ProphetQuizQuestion _enrichQuestion(
    ProphetQuizQuestion question,
    Map<String, ProphetEntry> byId,
  ) {
    final prophet = byId[question.relatedProphetId];
    if (prophet == null) return question;
    return ProphetQuizQuestion(
      id: question.id,
      mode: question.mode,
      difficulty: question.difficulty,
      category: question.category ?? question.effectiveCategory,
      eraId: question.eraId ?? prophet.eraGroup.name,
      tags: question.tags,
      isFeatured: question.isFeatured,
      questionText: question.questionText,
      options: question.options,
      correctAnswerIndex: question.correctAnswerIndex,
      explanation: question.explanation,
      relatedProphetId: question.relatedProphetId,
    );
  }

  static List<ProphetQuizQuestion> _questionsForProphet(
    String prophetId,
    ProphetDetailContent detail,
    Map<String, ProphetEntry> byId,
  ) {
    final prophet = byId[prophetId];
    if (prophet == null) return const [];

    final all = byId.values.toList(growable: false);

    final arabicDistractors = _pickDistinctNames(
      all,
      excludeId: prophetId,
      count: 3,
    );
    final qArabicOptions = <String>[prophet.name, ...arabicDistractors]..shuffle();

    final qEraOptions = _eraOptions(detail.eraTitle);

    final regionDistractors = _pickDistinctRegions(
      all,
      excludedRegion: detail.regionLabel,
      count: 3,
    );
    final qRegionOptions = <String>[detail.regionLabel, ...regionDistractors]
      ..shuffle();

    final reference = detail.quranReferences.isNotEmpty
        ? detail.quranReferences.first
        : null;
    final refDistractors = _pickReferenceNameDistractors(
      all,
      excludeId: prophetId,
      count: 3,
    );
    final qReferenceOptions = <String>[prophet.name, ...refDistractors]..shuffle();

    final questions = <ProphetQuizQuestion>[
      ProphetQuizQuestion(
        id: 'gen_${prophet.id}_arabic_name',
        mode: ProphetQuizMode.prophetIdentification,
        difficulty: ProphetQuizDifficulty.easy,
        category: ProphetQuizCategory.prophetIdentification,
        eraId: prophet.eraGroup.name,
        tags: ['arabic_name', 'coverage'],
        questionText: 'Which prophet has the Arabic name "${detail.arabicName}"?',
        options: qArabicOptions,
        correctAnswerIndex: qArabicOptions.indexOf(prophet.name),
        explanation:
            '${prophet.name} is identified in the app dataset with the Arabic name ${detail.arabicName}.',
        relatedProphetId: prophet.id,
      ),
      ProphetQuizQuestion(
        id: 'gen_${prophet.id}_era_group',
        mode: ProphetQuizMode.lessonRecognition,
        difficulty: ProphetQuizDifficulty.medium,
        category: ProphetQuizCategory.eraGrouping,
        eraId: prophet.eraGroup.name,
        tags: ['era', 'journey_of_revelation'],
        questionText: 'Which era grouping includes Prophet ${prophet.name}?',
        options: qEraOptions,
        correctAnswerIndex: qEraOptions.indexOf(detail.eraTitle),
        explanation:
            'Prophet ${prophet.name} is placed in the "${detail.eraTitle}" era in Journey of Revelation.',
        relatedProphetId: prophet.id,
      ),
      ProphetQuizQuestion(
        id: 'gen_${prophet.id}_region_association',
        mode: ProphetQuizMode.storyMatching,
        difficulty: ProphetQuizDifficulty.medium,
        category: ProphetQuizCategory.regionAssociation,
        eraId: prophet.eraGroup.name,
        tags: ['region', 'map_ready'],
        questionText:
            'Which region label is associated with Prophet ${prophet.name} in this learning set?',
        options: qRegionOptions,
        correctAnswerIndex: qRegionOptions.indexOf(detail.regionLabel),
        explanation:
            'The prophet profile for ${prophet.name} uses "${detail.regionLabel}" as the careful regional association.',
        relatedProphetId: prophet.id,
      ),
    ];

    if (reference != null) {
      questions.add(
        ProphetQuizQuestion(
          id: 'gen_${prophet.id}_reference_awareness',
          mode: ProphetQuizMode.quranReference,
          difficulty: ProphetQuizDifficulty.hard,
          category: ProphetQuizCategory.quranReferenceAwareness,
          eraId: prophet.eraGroup.name,
          tags: ['quran_reference', 'surah_${reference.surahNumber}'],
          questionText:
              'Which prophet is associated with ${reference.surahName} ${reference.surahNumber}:${reference.verseRange} in this section?',
          options: qReferenceOptions,
          correctAnswerIndex: qReferenceOptions.indexOf(prophet.name),
          explanation:
              '${reference.surahName} ${reference.surahNumber}:${reference.verseRange} is listed among references for ${prophet.name}.',
          relatedProphetId: prophet.id,
        ),
      );
    }

    return questions;
  }

  static List<String> _pickDistinctNames(
    List<ProphetEntry> prophets, {
    required String excludeId,
    required int count,
  }) {
    final names = <String>[];
    for (final prophet in prophets) {
      if (prophet.id == excludeId) continue;
      if (names.contains(prophet.name)) continue;
      names.add(prophet.name);
      if (names.length >= count) break;
    }
    return names;
  }

  static List<String> _pickDistinctRegions(
    List<ProphetEntry> prophets, {
    required String excludedRegion,
    required int count,
  }) {
    final regions = <String>[];
    for (final prophet in prophets) {
      final region = prophet.regionLabel;
      if (region == excludedRegion) continue;
      if (regions.contains(region)) continue;
      regions.add(region);
      if (regions.length >= count) break;
    }
    return regions;
  }

  static List<String> _pickReferenceNameDistractors(
    List<ProphetEntry> prophets, {
    required String excludeId,
    required int count,
  }) {
    final ids = <String>[];
    for (final prophet in prophets.reversed) {
      if (prophet.id == excludeId) continue;
      if (ids.contains(prophet.name)) continue;
      ids.add(prophet.name);
      if (ids.length >= count) break;
    }
    return ids;
  }

  static List<String> _eraOptions(String correctEra) {
    const allEras = <String>{
      'Early Humanity',
      'Early Civilizations',
      'Post-Flood Peoples',
      'Age of Ibrahim',
      'Children of Israel',
      'Later Israelite Prophets',
      'Final Messenger',
      'Later Prophetic Reminders',
    };
    final options = <String>{correctEra};
    for (final era in allEras) {
      if (options.length >= 4) break;
      if (era == correctEra) continue;
      options.add(era);
    }
    final list = options.toList()..shuffle();
    return list;
  }
}
