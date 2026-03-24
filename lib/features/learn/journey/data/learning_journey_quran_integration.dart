import '../../quran/domain/quran_reference_models.dart';
import '../domain/learning_journey_lesson_models.dart';
import 'learning_journey_lesson_content.dart';
import 'learning_journey_registry.dart';
import 'learning_journey_theme_mapping.dart';

class LearningJourneyQuranContextEntry {
  const LearningJourneyQuranContextEntry({
    required this.journeyId,
    required this.stageId,
    required this.surahNumber,
    required this.ayahNumber,
    this.endAyahNumber,
    this.topicId,
    this.readerMode,
    this.connectionStrength,
    this.suggestedLearningPathId,
  });

  final String journeyId;
  final String stageId;
  final int surahNumber;
  final int ayahNumber;
  final int? endAyahNumber;
  final String? topicId;
  final QuranReaderStudyMode? readerMode;
  final QuranConnectionStrength? connectionStrength;
  final String? suggestedLearningPathId;

  bool containsVerse(int surahNumber, int ayahNumber) {
    if (surahNumber != this.surahNumber) return false;
    final effectiveEnd = endAyahNumber ?? this.ayahNumber;
    return ayahNumber >= this.ayahNumber && ayahNumber <= effectiveEnd;
  }

  String get referenceLabel {
    final effectiveEnd = endAyahNumber;
    if (effectiveEnd == null || effectiveEnd <= ayahNumber) {
      return '$surahNumber:$ayahNumber';
    }
    return '$surahNumber:$ayahNumber-$effectiveEnd';
  }

  Map<String, String> toReaderQueryParameters() {
    final output = <String, String>{
      'ayah': ayahNumber.toString(),
      'journeyId': journeyId,
      'stageId': stageId,
    };
    final effectiveEnd = endAyahNumber;
    if (effectiveEnd != null && effectiveEnd >= ayahNumber) {
      output['endAyah'] = effectiveEnd.toString();
    }
    final safeTopicId = topicId?.trim();
    if (safeTopicId?.isNotEmpty ?? false) {
      output['topicId'] = safeTopicId!;
    }
    final safeMode = readerMode?.wireName;
    if (safeMode != null && safeMode.isNotEmpty) {
      output['mode'] = safeMode;
    }
    return output;
  }
}

const _legacyReverseJourneyStageAllowlist = <String>{
  'quran-read',
  'quran-themes',
  'fatihah-read',
  'short-surahs-meaning',
};

final _curatedJourneyQuranEntries = _buildCuratedJourneyQuranEntries();

LearningJourneyQuranContextEntry? learningJourneyQuranContextForStage(
  String stageId,
) {
  return _curatedJourneyQuranEntries[stageId];
}

List<LearningJourneyQuranContextEntry> learningJourneyQuranReverseLinksForVerse(
  int surahNumber,
  int ayahNumber,
) {
  final entries = <LearningJourneyQuranContextEntry>[];
  final seenStageIds = <String>{};

  void addStageEntry(String stageId) {
    final entry = learningJourneyQuranContextForStage(stageId);
    if (entry == null || !entry.containsVerse(surahNumber, ayahNumber)) return;
    if (!seenStageIds.add(entry.stageId)) return;
    entries.add(entry);
  }

  for (final mapping in learningJourneyThemeMappingsForVerse(
    surahNumber,
    ayahNumber,
  )) {
    addStageEntry(mapping.stageId);
  }

  for (final stageId in _legacyReverseJourneyStageAllowlist) {
    addStageEntry(stageId);
  }

  return entries;
}

Map<String, LearningJourneyQuranContextEntry>
_buildCuratedJourneyQuranEntries() {
  final entries = <String, LearningJourneyQuranContextEntry>{};
  for (final journey in LearningJourneyRegistry.journeys) {
    for (final stageId in journey.stageIds) {
      final stage = LearningJourneyRegistry.stageById(stageId);
      if (stage == null) continue;
      final mapping = learningJourneyThemeMappingForStage(stageId);
      final lesson = LearningJourneyLessonContentRegistry.rawLessonForStage(
        stageId,
      );
      final parsedRef = mapping == null
          ? (lesson == null ? null : _primaryQuranReferenceForLesson(lesson))
          : null;
      if (mapping == null && parsedRef == null) continue;
      entries[stageId] = LearningJourneyQuranContextEntry(
        journeyId: journey.id,
        stageId: stageId,
        surahNumber: mapping?.surahNumber ?? parsedRef!.surahNumber,
        ayahNumber: mapping?.ayahNumber ?? parsedRef!.ayahNumber,
        endAyahNumber: mapping?.endAyahNumber ?? parsedRef?.endAyahNumber,
        topicId: mapping?.primaryTopicId,
        readerMode: mapping?.suggestedReaderMode,
        connectionStrength: mapping?.connectionStrength,
        suggestedLearningPathId: mapping?.suggestedLearningPathId,
      );
    }
  }
  return entries;
}

_ParsedQuranReference? _primaryQuranReferenceForLesson(
  LearningJourneyLessonContent lesson,
) {
  for (final raw in lesson.quranReferences) {
    final parsed = _parseQuranReference(raw);
    if (parsed != null) return parsed;
  }
  return null;
}

_ParsedQuranReference? _parseQuranReference(String raw) {
  final match = RegExp(r'(\d+):(\d+)(?:-(\d+))?').firstMatch(raw);
  if (match == null) return null;
  final surahNumber = int.tryParse(match.group(1) ?? '');
  final ayahNumber = int.tryParse(match.group(2) ?? '');
  final endAyahNumber = int.tryParse(match.group(3) ?? '');
  if (surahNumber == null || ayahNumber == null) return null;
  return _ParsedQuranReference(
    surahNumber: surahNumber,
    ayahNumber: ayahNumber,
    endAyahNumber: endAyahNumber,
  );
}

class _ParsedQuranReference {
  const _ParsedQuranReference({
    required this.surahNumber,
    required this.ayahNumber,
    this.endAyahNumber,
  });

  final int surahNumber;
  final int ayahNumber;
  final int? endAyahNumber;
}
