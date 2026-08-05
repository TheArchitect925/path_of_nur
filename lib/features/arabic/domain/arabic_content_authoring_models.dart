import 'arabic_learning_continuity_models.dart';
import 'arabic_learning_lesson_pack_models.dart';

enum ArabicContentUnitType {
  letter,
  word,
  phrase,
  review,
  module,
  quranBridgeSnippet,
  quranShortSurah,
}

class ArabicContentUnit {
  const ArabicContentUnit({
    required this.id,
    required this.audience,
    required this.type,
    required this.target,
    required this.sortOrder,
    this.title,
    this.subtitle,
    this.arabicText,
    this.transliteration,
    this.summary,
    this.audioAssetPath,
    this.sourceReference,
    this.keywords = const <String>[],
    this.relatedLetterIds = const <String>[],
    this.relatedWordIds = const <String>[],
    this.relatedPhraseIds = const <String>[],
    this.isAvailable = true,
  });

  final String id;
  final ArabicLearningAudience audience;
  final ArabicContentUnitType type;
  final ArabicLearningRouteTarget target;
  final int sortOrder;
  final String? title;
  final String? subtitle;
  final String? arabicText;
  final String? transliteration;
  final String? summary;
  final String? audioAssetPath;
  final String? sourceReference;
  final List<String> keywords;
  final List<String> relatedLetterIds;
  final List<String> relatedWordIds;
  final List<String> relatedPhraseIds;
  final bool isAvailable;
}

class ArabicContentPackComposition {
  const ArabicContentPackComposition({
    required this.id,
    required this.audience,
    required this.type,
    required this.sortOrder,
    required this.contentUnitIds,
    this.searchKeywords = const <String>[],
  });

  final String id;
  final ArabicLearningAudience audience;
  final ArabicLearningLessonPackType type;
  final int sortOrder;
  final List<String> contentUnitIds;
  final List<String> searchKeywords;
}

String arabicLetterContentUnitId(String letterId) => 'letter:$letterId';

String arabicWordContentUnitId(String wordId) => 'word:$wordId';

String arabicPhraseContentUnitId(String phraseId) => 'phrase:$phraseId';

String arabicReviewContentUnitId(String reviewId) => 'review:$reviewId';

String arabicModuleContentUnitId(String moduleId) => 'module:$moduleId';

String arabicBridgeContentUnitId(String bridgeId) => 'bridge:$bridgeId';

String arabicShortSurahContentUnitId(int surahNumber) =>
    'short_surah:$surahNumber';
