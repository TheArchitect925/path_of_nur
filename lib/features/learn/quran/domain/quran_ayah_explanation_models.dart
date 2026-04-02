import 'quran_reference_models.dart';

enum QuranAyahExplanationSourceType {
  quranCrossReference,
  hadithGrounding,
  classicalTafsir,
  simplifiedSummary,
  kidsSimplification,
}

enum QuranAyahExplanationEditorialStatus { draft, reviewed }

enum QuranAyahExplanationReviewStatus {
  draft,
  reviewed,
  verified,
  kidsReviewed,
  needsExpansion,
}

enum QuranAyahExplanationRolloutPack {
  foundations,
  commonSalahSurahs,
  beginnerCoreAyahs,
  kidsStarter,
  reflectionComfort,
}

class QuranAyahExplanationSourceRef {
  const QuranAyahExplanationSourceRef({
    required this.type,
    required this.title,
    this.note,
    this.group,
    this.editorialStatus = QuranAyahExplanationEditorialStatus.reviewed,
    this.confidence = 1.0,
  });

  final QuranAyahExplanationSourceType type;
  final String title;
  final String? note;
  final String? group;
  final QuranAyahExplanationEditorialStatus editorialStatus;
  final double confidence;
}

class QuranAyahExplanationLocalizedContent {
  const QuranAyahExplanationLocalizedContent({
    this.simpleSummariesByLanguageCode = const <String, String>{},
    this.standardExplanationsByLanguageCode = const <String, String>{},
    this.deepExplanationsByLanguageCode = const <String, String>{},
    this.kidsExplanationsByLanguageCode = const <String, String>{},
    this.keyLessonsByLanguageCode = const <String, List<String>>{},
    this.reflectionPromptsByLanguageCode = const <String, String>{},
  });

  final Map<String, String> simpleSummariesByLanguageCode;
  final Map<String, String> standardExplanationsByLanguageCode;
  final Map<String, String> deepExplanationsByLanguageCode;
  final Map<String, String> kidsExplanationsByLanguageCode;
  final Map<String, List<String>> keyLessonsByLanguageCode;
  final Map<String, String> reflectionPromptsByLanguageCode;

  String? simpleSummaryForLanguage(String languageCode) =>
      _localizedValue(simpleSummariesByLanguageCode, languageCode);

  String? standardExplanationForLanguage(String languageCode) =>
      _localizedValue(standardExplanationsByLanguageCode, languageCode);

  String? deepExplanationForLanguage(String languageCode) =>
      _localizedValue(deepExplanationsByLanguageCode, languageCode);

  String? kidsExplanationForLanguage(String languageCode) =>
      _localizedValue(kidsExplanationsByLanguageCode, languageCode);

  List<String>? keyLessonsForLanguage(String languageCode) =>
      _localizedListValue(keyLessonsByLanguageCode, languageCode);

  String? reflectionPromptForLanguage(String languageCode) =>
      _localizedValue(reflectionPromptsByLanguageCode, languageCode);
}

class QuranAyahExplanationEntry {
  const QuranAyahExplanationEntry({
    required this.surahNumber,
    required this.ayahNumber,
    required this.simpleSummary,
    required this.standardExplanation,
    this.deepExplanation,
    this.kidsExplanation,
    this.keyLessons = const <String>[],
    this.reflectionPrompt,
    this.sourceRefs = const <QuranAyahExplanationSourceRef>[],
    this.rolloutPack = QuranAyahExplanationRolloutPack.beginnerCoreAyahs,
    this.reviewStatus = QuranAyahExplanationReviewStatus.reviewed,
    this.localizedContent = const QuranAyahExplanationLocalizedContent(),
  });

  final int surahNumber;
  final int ayahNumber;
  final String simpleSummary;
  final String standardExplanation;
  final String? deepExplanation;
  final String? kidsExplanation;
  final List<String> keyLessons;
  final String? reflectionPrompt;
  final List<QuranAyahExplanationSourceRef> sourceRefs;
  final QuranAyahExplanationRolloutPack rolloutPack;
  final QuranAyahExplanationReviewStatus reviewStatus;
  final QuranAyahExplanationLocalizedContent localizedContent;

  String get ayahKey => '$surahNumber:$ayahNumber';
  bool get hasSimpleSummary => simpleSummary.trim().isNotEmpty;
  bool get hasStandardExplanation => standardExplanation.trim().isNotEmpty;
  bool get hasKidsExplanation => (kidsExplanation ?? '').trim().isNotEmpty;
  bool get hasDeepExplanation => (deepExplanation ?? '').trim().isNotEmpty;
  bool get hasReflectionPrompt => (reflectionPrompt ?? '').trim().isNotEmpty;
  bool get hasKeyLessons =>
      keyLessons.any((lesson) => lesson.trim().isNotEmpty);

  bool get hasClassicalTafsirGrounding => sourceRefs.any(
    (ref) =>
        ref.type == QuranAyahExplanationSourceType.classicalTafsir &&
        ref.editorialStatus == QuranAyahExplanationEditorialStatus.reviewed,
  );

  QuranAyahResolvedExplanation? resolve(
    QuranExplanationDetailLevel requestedDetail, {
    String languageCode = 'en',
  }) {
    if (requestedDetail == QuranExplanationDetailLevel.off) {
      return null;
    }

    final normalizedLanguageCode = _normalizedLanguageCode(languageCode);
    final localizedSimple =
        localizedContent.simpleSummaryForLanguage(normalizedLanguageCode) ??
        simpleSummary;
    final localizedStandard =
        localizedContent.standardExplanationForLanguage(
          normalizedLanguageCode,
        ) ??
        standardExplanation;
    final localizedDeep =
        localizedContent.deepExplanationForLanguage(normalizedLanguageCode) ??
        deepExplanation;
    final localizedKids =
        localizedContent.kidsExplanationForLanguage(normalizedLanguageCode) ??
        kidsExplanation;
    final localizedKeyLessons =
        localizedContent.keyLessonsForLanguage(normalizedLanguageCode) ??
        keyLessons;
    final localizedReflectionPrompt =
        localizedContent.reflectionPromptForLanguage(normalizedLanguageCode) ??
        reflectionPrompt;

    final candidates = switch (requestedDetail) {
      QuranExplanationDetailLevel.simple =>
        <(QuranExplanationDetailLevel, String?)>[
          (QuranExplanationDetailLevel.simple, localizedSimple),
          (QuranExplanationDetailLevel.standard, localizedStandard),
        ],
      QuranExplanationDetailLevel.standard =>
        <(QuranExplanationDetailLevel, String?)>[
          (QuranExplanationDetailLevel.standard, localizedStandard),
          (QuranExplanationDetailLevel.simple, localizedSimple),
        ],
      QuranExplanationDetailLevel.deep =>
        <(QuranExplanationDetailLevel, String?)>[
          (QuranExplanationDetailLevel.deep, localizedDeep),
          (QuranExplanationDetailLevel.standard, localizedStandard),
          (QuranExplanationDetailLevel.simple, localizedSimple),
        ],
      QuranExplanationDetailLevel.kids =>
        <(QuranExplanationDetailLevel, String?)>[
          (QuranExplanationDetailLevel.kids, localizedKids),
          (QuranExplanationDetailLevel.simple, localizedSimple),
          (QuranExplanationDetailLevel.standard, localizedStandard),
        ],
      QuranExplanationDetailLevel.off =>
        const <(QuranExplanationDetailLevel, String?)>[],
    };

    for (final candidate in candidates) {
      final detail = candidate.$1;
      final content = candidate.$2?.trim();
      if (content == null || content.isEmpty) {
        continue;
      }
      final filteredLessons = localizedKeyLessons
          .map((lesson) => lesson.trim())
          .where((lesson) => lesson.isNotEmpty)
          .toList(growable: false);
      final normalizedPrompt = localizedReflectionPrompt?.trim();
      return QuranAyahResolvedExplanation(
        surahNumber: surahNumber,
        ayahNumber: ayahNumber,
        requestedDetail: requestedDetail,
        resolvedDetail: detail,
        previewText: localizedSimple.trim().isEmpty ? content : localizedSimple,
        body: content,
        keyLessons: filteredLessons,
        reflectionPrompt: normalizedPrompt == null || normalizedPrompt.isEmpty
            ? null
            : normalizedPrompt,
        sourceRefs: sourceRefs,
        usedFallback: detail != requestedDetail,
        hasTrustedTafsirGrounding: hasClassicalTafsirGrounding,
      );
    }
    return null;
  }

  QuranAyahExplanationEntry copyWith({
    String? simpleSummary,
    String? standardExplanation,
    String? deepExplanation,
    bool clearDeepExplanation = false,
    String? kidsExplanation,
    bool clearKidsExplanation = false,
    List<String>? keyLessons,
    String? reflectionPrompt,
    bool clearReflectionPrompt = false,
    List<QuranAyahExplanationSourceRef>? sourceRefs,
    QuranAyahExplanationRolloutPack? rolloutPack,
    QuranAyahExplanationReviewStatus? reviewStatus,
    QuranAyahExplanationLocalizedContent? localizedContent,
  }) {
    return QuranAyahExplanationEntry(
      surahNumber: surahNumber,
      ayahNumber: ayahNumber,
      simpleSummary: simpleSummary ?? this.simpleSummary,
      standardExplanation: standardExplanation ?? this.standardExplanation,
      deepExplanation: clearDeepExplanation
          ? null
          : deepExplanation ?? this.deepExplanation,
      kidsExplanation: clearKidsExplanation
          ? null
          : kidsExplanation ?? this.kidsExplanation,
      keyLessons: keyLessons ?? this.keyLessons,
      reflectionPrompt: clearReflectionPrompt
          ? null
          : reflectionPrompt ?? this.reflectionPrompt,
      sourceRefs: sourceRefs ?? this.sourceRefs,
      rolloutPack: rolloutPack ?? this.rolloutPack,
      reviewStatus: reviewStatus ?? this.reviewStatus,
      localizedContent: localizedContent ?? this.localizedContent,
    );
  }
}

class QuranAyahResolvedExplanation {
  const QuranAyahResolvedExplanation({
    required this.surahNumber,
    required this.ayahNumber,
    required this.requestedDetail,
    required this.resolvedDetail,
    required this.previewText,
    required this.body,
    required this.keyLessons,
    required this.reflectionPrompt,
    required this.sourceRefs,
    required this.usedFallback,
    required this.hasTrustedTafsirGrounding,
  });

  final int surahNumber;
  final int ayahNumber;
  final QuranExplanationDetailLevel requestedDetail;
  final QuranExplanationDetailLevel resolvedDetail;
  final String previewText;
  final String body;
  final List<String> keyLessons;
  final String? reflectionPrompt;
  final List<QuranAyahExplanationSourceRef> sourceRefs;
  final bool usedFallback;
  final bool hasTrustedTafsirGrounding;
}

class QuranAyahExplanationCoverageSummary {
  const QuranAyahExplanationCoverageSummary({
    required this.surahNumber,
    required this.totalAyahs,
    required this.simpleReadyAyahs,
    required this.standardReadyAyahs,
    required this.kidsReadyAyahs,
    required this.deepReadyAyahs,
    required this.reviewedAyahs,
  });

  const QuranAyahExplanationCoverageSummary.empty({required this.surahNumber})
    : totalAyahs = 0,
      simpleReadyAyahs = 0,
      standardReadyAyahs = 0,
      kidsReadyAyahs = 0,
      deepReadyAyahs = 0,
      reviewedAyahs = 0;

  final int surahNumber;
  final int totalAyahs;
  final int simpleReadyAyahs;
  final int standardReadyAyahs;
  final int kidsReadyAyahs;
  final int deepReadyAyahs;
  final int reviewedAyahs;

  QuranAyahExplanationCoverageSummary addEntry(
    QuranAyahExplanationEntry entry,
  ) {
    return QuranAyahExplanationCoverageSummary(
      surahNumber: surahNumber,
      totalAyahs: totalAyahs + 1,
      simpleReadyAyahs: simpleReadyAyahs + (entry.hasSimpleSummary ? 1 : 0),
      standardReadyAyahs:
          standardReadyAyahs + (entry.hasStandardExplanation ? 1 : 0),
      kidsReadyAyahs: kidsReadyAyahs + (entry.hasKidsExplanation ? 1 : 0),
      deepReadyAyahs: deepReadyAyahs + (entry.hasDeepExplanation ? 1 : 0),
      reviewedAyahs:
          reviewedAyahs +
          (entry.sourceRefs.any(
                (ref) =>
                    ref.editorialStatus ==
                    QuranAyahExplanationEditorialStatus.reviewed,
              )
              ? 1
              : 0),
    );
  }
}

class QuranAyahExplanationManifestEntry {
  const QuranAyahExplanationManifestEntry({
    required this.surahNumber,
    required this.ayahNumber,
    required this.hasSimple,
    required this.hasStandard,
    required this.hasDeep,
    required this.hasKids,
    required this.hasReflectionPrompt,
    required this.hasKeyLessons,
    required this.hasSourceRefs,
    required this.rolloutPack,
    required this.reviewStatus,
  });

  final int surahNumber;
  final int ayahNumber;
  final bool hasSimple;
  final bool hasStandard;
  final bool hasDeep;
  final bool hasKids;
  final bool hasReflectionPrompt;
  final bool hasKeyLessons;
  final bool hasSourceRefs;
  final QuranAyahExplanationRolloutPack rolloutPack;
  final QuranAyahExplanationReviewStatus reviewStatus;
}

class QuranAyahExplanationPackDefinition {
  const QuranAyahExplanationPackDefinition({
    required this.pack,
    required this.title,
    required this.description,
    required this.expectedDetailLevels,
  });

  final QuranAyahExplanationRolloutPack pack;
  final String title;
  final String description;
  final List<QuranExplanationDetailLevel> expectedDetailLevels;
}

String? _localizedValue(Map<String, String> values, String languageCode) {
  if (languageCode.isEmpty) return null;
  return values[languageCode] ?? values[languageCode.split('_').first];
}

List<String>? _localizedListValue(
  Map<String, List<String>> values,
  String languageCode,
) {
  if (languageCode.isEmpty) return null;
  return values[languageCode] ?? values[languageCode.split('_').first];
}

String _normalizedLanguageCode(String languageCode) {
  return languageCode.trim().toLowerCase().replaceAll('-', '_');
}
