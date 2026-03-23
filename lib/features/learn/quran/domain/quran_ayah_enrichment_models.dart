import 'quran_content_refs.dart';

enum QuranAyahEnrichmentDomain {
  tawhidBelief,
  worshipRemembrance,
  characterAdab,
  akhirahAccountability,
  signsInCreation,
  worldNature,
  prophetsLessons,
  guidanceDailyLife,
}

enum QuranAyahEnrichmentLessonType {
  coreLesson,
  reflection,
  practicalTakeaway,
  warning,
  reminder,
  connection,
}

enum QuranAyahEnrichmentTag {
  sabr,
  shukr,
  tawakkul,
  mercy,
  repentance,
  justice,
  sincerity,
  guidance,
  signs,
  creation,
  prophets,
  worship,
}

enum QuranAyahLinkStrength { direct, strongThematic, contextual }

enum QuranRelatedAyahLinkType {
  sameTheme,
  supportingInsight,
  continuation,
  contrast,
  worshipConnection,
  characterConnection,
  creationConnection,
  prophetConnection,
}

enum QuranAyahDisplayItemType {
  hadithReference,
  ayahInsight,
  signsInCreation,
  scientificReflection,
  worldCreationLesson,
  worshipLesson,
  characterLesson,
  prophetConnection,
  relatedAyah,
  reflectionPrompt,
  interpretationNote,
}

enum QuranAyahCautionLevel { none, interpretationSensitive, scientificCare }

class QuranAyahLocalizedContent {
  const QuranAyahLocalizedContent({
    this.titlesByLanguageCode = const <String, String>{},
    this.summariesByLanguageCode = const <String, String>{},
    this.bodiesByLanguageCode = const <String, String>{},
    this.reflectionPromptsByLanguageCode = const <String, List<String>>{},
  });

  final Map<String, String> titlesByLanguageCode;
  final Map<String, String> summariesByLanguageCode;
  final Map<String, String> bodiesByLanguageCode;
  final Map<String, List<String>> reflectionPromptsByLanguageCode;

  String titleForLanguage(String languageCode, String fallback) {
    return _localizedValue(titlesByLanguageCode, languageCode: languageCode) ??
        fallback;
  }

  String summaryForLanguage(String languageCode, String fallback) {
    return _localizedValue(
          summariesByLanguageCode,
          languageCode: languageCode,
        ) ??
        fallback;
  }

  String bodyForLanguage(String languageCode, String fallback) {
    return _localizedValue(bodiesByLanguageCode, languageCode: languageCode) ??
        fallback;
  }

  List<String> reflectionPromptsForLanguage(
    String languageCode,
    List<String> fallback,
  ) {
    return _localizedListValue(
          reflectionPromptsByLanguageCode,
          languageCode: languageCode,
        ) ??
        fallback;
  }
}

class QuranAyahEnrichmentEntry {
  const QuranAyahEnrichmentEntry({
    required this.id,
    required this.ref,
    required this.domain,
    required this.lessonType,
    required this.linkStrength,
    required this.title,
    required this.summary,
    required this.body,
    required this.tags,
    this.relatedRefs = const <QuranQuoteRef>[],
    this.relatedAyahs = const <QuranRelatedAyahLink>[],
    this.reflectionPrompts = const <String>[],
    this.sourceRouteName,
    this.pathParameters = const <String, String>{},
    this.queryParameters = const <String, String>{},
    this.interpretationNote,
    this.cautionNote,
    this.cautionLevel = QuranAyahCautionLevel.none,
    this.displayType,
    this.displayPriority = 100,
    this.localizedContent = const QuranAyahLocalizedContent(),
  });

  final String id;
  final QuranQuoteRef ref;
  final QuranAyahEnrichmentDomain domain;
  final QuranAyahEnrichmentLessonType lessonType;
  final QuranAyahLinkStrength linkStrength;
  final String title;
  final String summary;
  final String body;
  final List<QuranAyahEnrichmentTag> tags;
  final List<QuranQuoteRef> relatedRefs;
  final List<QuranRelatedAyahLink> relatedAyahs;
  final List<String> reflectionPrompts;
  final String? sourceRouteName;
  final Map<String, String> pathParameters;
  final Map<String, String> queryParameters;
  final String? interpretationNote;
  final String? cautionNote;
  final QuranAyahCautionLevel cautionLevel;
  final QuranAyahDisplayItemType? displayType;
  final int displayPriority;
  final QuranAyahLocalizedContent localizedContent;

  bool get hasAction => sourceRouteName != null;

  bool containsVerse(int surahNumber, int ayahNumber) {
    if (ref.surah != surahNumber) return false;
    final endAyah = ref.ayahEnd ?? ref.ayah;
    return ayahNumber >= ref.ayah && ayahNumber <= endAyah;
  }

  QuranAyahEnrichmentEntry localizedCopy(String languageCode) {
    final normalized = _normalizedLanguageCode(languageCode);
    if (normalized == 'en') return this;
    return QuranAyahEnrichmentEntry(
      id: id,
      ref: ref,
      domain: domain,
      lessonType: lessonType,
      linkStrength: linkStrength,
      title: localizedContent.titleForLanguage(normalized, title),
      summary: localizedContent.summaryForLanguage(normalized, summary),
      body: localizedContent.bodyForLanguage(normalized, body),
      tags: tags,
      relatedRefs: relatedRefs,
      relatedAyahs: relatedAyahs,
      reflectionPrompts: localizedContent.reflectionPromptsForLanguage(
        normalized,
        reflectionPrompts,
      ),
      sourceRouteName: sourceRouteName,
      pathParameters: pathParameters,
      queryParameters: queryParameters,
      interpretationNote: interpretationNote,
      cautionNote: cautionNote,
      cautionLevel: cautionLevel,
      displayType: displayType,
      displayPriority: displayPriority,
      localizedContent: localizedContent,
    );
  }
}

class QuranAyahDisplayItem {
  const QuranAyahDisplayItem({
    required this.id,
    required this.type,
    required this.title,
    required this.summary,
    required this.linkStrength,
    required this.displayPriority,
    this.sourceRouteName,
    this.pathParameters = const <String, String>{},
    this.queryParameters = const <String, String>{},
    this.cautionLevel = QuranAyahCautionLevel.none,
    this.sourceEnrichmentId,
    this.relatedRef,
    this.relatedAyahType,
    this.relatedReason,
  });

  final String id;
  final QuranAyahDisplayItemType type;
  final String title;
  final String summary;
  final QuranAyahLinkStrength linkStrength;
  final int displayPriority;
  final String? sourceRouteName;
  final Map<String, String> pathParameters;
  final Map<String, String> queryParameters;
  final QuranAyahCautionLevel cautionLevel;
  final String? sourceEnrichmentId;
  final QuranQuoteRef? relatedRef;
  final QuranRelatedAyahLinkType? relatedAyahType;
  final String? relatedReason;

  bool get hasAction => sourceRouteName != null;
}

class QuranRelatedAyahLink {
  const QuranRelatedAyahLink({
    required this.ref,
    required this.type,
    this.reason,
    this.linkStrength = QuranAyahLinkStrength.strongThematic,
  });

  final QuranQuoteRef ref;
  final QuranRelatedAyahLinkType type;
  final String? reason;
  final QuranAyahLinkStrength linkStrength;
}

class QuranAyahEnrichmentBrowseCategory {
  const QuranAyahEnrichmentBrowseCategory({
    required this.id,
    required this.domains,
    required this.entries,
  });

  final String id;
  final List<QuranAyahEnrichmentDomain> domains;
  final List<QuranAyahEnrichmentEntry> entries;

  int get count => entries.length;
}

class QuranAyahInsightPath {
  const QuranAyahInsightPath({
    required this.id,
    required this.titleKey,
    required this.descriptionKey,
    required this.domain,
    required this.entryIds,
    this.reflectionFocusKey,
  });

  final String id;
  final String titleKey;
  final String descriptionKey;
  final QuranAyahEnrichmentDomain domain;
  final List<String> entryIds;
  final String? reflectionFocusKey;

  int get count => entryIds.length;
}

class QuranAyahInsightResolvedPath {
  const QuranAyahInsightResolvedPath({
    required this.path,
    required this.entries,
  });

  final QuranAyahInsightPath path;
  final List<QuranAyahEnrichmentEntry> entries;

  int get count => entries.length;
}

extension QuranAyahLinkStrengthPriority on QuranAyahLinkStrength {
  int get priorityValue {
    return switch (this) {
      QuranAyahLinkStrength.direct => 0,
      QuranAyahLinkStrength.strongThematic => 1,
      QuranAyahLinkStrength.contextual => 2,
    };
  }
}

String _normalizedLanguageCode(String languageCode) {
  final normalized = languageCode.trim().toLowerCase();
  if (normalized.contains('-')) {
    return normalized.split('-').first;
  }
  if (normalized.contains('_')) {
    return normalized.split('_').first;
  }
  return normalized;
}

String? _localizedValue(
  Map<String, String> values, {
  required String languageCode,
}) {
  final normalized = _normalizedLanguageCode(languageCode);
  return values[languageCode] ??
      values[normalized] ??
      values[languageCode.toLowerCase()] ??
      values[_normalizedLanguageCode(languageCode.toLowerCase())];
}

List<String>? _localizedListValue(
  Map<String, List<String>> values, {
  required String languageCode,
}) {
  final normalized = _normalizedLanguageCode(languageCode);
  return values[languageCode] ??
      values[normalized] ??
      values[languageCode.toLowerCase()] ??
      values[_normalizedLanguageCode(languageCode.toLowerCase())];
}
