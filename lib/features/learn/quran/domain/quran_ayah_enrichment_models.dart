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

  bool get hasAction => sourceRouteName != null;

  bool containsVerse(int surahNumber, int ayahNumber) {
    if (ref.surah != surahNumber) return false;
    final endAyah = ref.ayahEnd ?? ref.ayah;
    return ayahNumber >= ref.ayah && ayahNumber <= endAyah;
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
