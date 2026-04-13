import 'package:flutter/material.dart';

enum HadithDifficultyLevel { beginner, intermediate }

enum HadithTransliterationStatus {
  missing,
  trusted,
  unverified,
  reviewRequired,
}

enum HadithTransliterationReviewStatus { notReviewed, pending, approved }

enum HadithGradeCategory {
  muttafaqunAlayh,
  sahih,
  hasanSahih,
  hasan,
  balagh,
  weak,
  other,
  unknown,
}

enum HadithSourceProvenance { seeded, editorialOverride, imported, unknown }

class HadithGradeInfo {
  const HadithGradeInfo({
    required this.displayLabel,
    required this.normalizedLabel,
    required this.category,
  });

  final String displayLabel;
  final String normalizedLabel;
  final HadithGradeCategory category;

  bool get hasMetadata => normalizedLabel.isNotEmpty;
}

class HadithSourceCollectionInfo {
  const HadithSourceCollectionInfo({
    required this.id,
    required this.displayTitle,
    required this.normalizedTitle,
  });

  final String id;
  final String displayTitle;
  final String normalizedTitle;
}

class HadithSourceChapterInfo {
  const HadithSourceChapterInfo({
    required this.id,
    required this.title,
    required this.number,
  });

  final String id;
  final String title;
  final int number;
}

class HadithSourceMetadata {
  const HadithSourceMetadata({
    required this.collections,
    required this.primaryCollectionId,
    required this.primaryCollectionTitle,
    required this.displayCollectionTitle,
    required this.normalizedCollectionTitle,
    required this.referenceLabel,
    required this.normalizedReferenceLabel,
    required this.referenceKey,
    required this.hadithNumbers,
    required this.grade,
    required this.provenance,
    this.chapter,
    this.normalizedNarrator,
    this.importSource,
  });

  final List<HadithSourceCollectionInfo> collections;
  final String? primaryCollectionId;
  final String? primaryCollectionTitle;
  final String displayCollectionTitle;
  final String normalizedCollectionTitle;
  final HadithSourceChapterInfo? chapter;
  final String? referenceLabel;
  final String? normalizedReferenceLabel;
  final String referenceKey;
  final List<String> hadithNumbers;
  final String? normalizedNarrator;
  final HadithGradeInfo grade;
  final HadithSourceProvenance provenance;
  final String? importSource;

  bool get hasPrimaryCollection => primaryCollectionId != null;
}

class HadithTransliterationMetadata {
  const HadithTransliterationMetadata({
    required this.text,
    required this.source,
    required this.status,
    required this.reviewStatus,
    required this.reviewedAt,
    required this.referenceKey,
    required this.sourceVerified,
  });

  final String? text;
  final String? source;
  final HadithTransliterationStatus status;
  final HadithTransliterationReviewStatus reviewStatus;
  final String? reviewedAt;
  final String referenceKey;
  final bool sourceVerified;

  bool get hasText => (text ?? '').trim().isNotEmpty;
  bool get isTrusted =>
      status == HadithTransliterationStatus.trusted && hasText;
}

class HadithCategory {
  const HadithCategory({
    required this.id,
    required this.title,
    required this.subcategoryIds,
  });

  final String id;
  final String title;
  final List<String> subcategoryIds;
}

class HadithSubcategory {
  const HadithSubcategory({
    required this.id,
    required this.categoryId,
    required this.title,
  });

  final String id;
  final String categoryId;
  final String title;
}

class HadithTaxonomyAssignment {
  const HadithTaxonomyAssignment({
    required this.categoryId,
    required this.categoryTitle,
    required this.subcategoryId,
    required this.subcategoryTitle,
  });

  final String categoryId;
  final String categoryTitle;
  final String subcategoryId;
  final String subcategoryTitle;
}

class QuranConnection {
  const QuranConnection({
    required this.surahName,
    required this.surahNumber,
    required this.verseRange,
    required this.label,
  });

  final String surahName;
  final int surahNumber;
  final String verseRange;
  final String label;
}

class HadithEntry {
  const HadithEntry({
    required this.id,
    required this.themeId,
    required this.collectionIds,
    required this.title,
    required this.excerpt,
    required this.hadithText,
    this.englishText,
    this.arabicText,
    this.transliteration,
    this.sourceReferenceKey,
    this.transliterationSource,
    this.transliterationStatus = HadithTransliterationStatus.missing,
    this.transliterationReviewStatus =
        HadithTransliterationReviewStatus.notReviewed,
    this.transliterationReviewedAt,
    this.sourceUrl,
    this.translationSourceVerified = false,
    this.arabicMatnSourceVerified = false,
    this.transliterationSourceVerified = false,
    required this.source,
    this.sourceCollection,
    this.sourceReference,
    required this.grading,
    this.narrator,
    this.sourceCollectionIds = const <String>[],
    this.sourceCollectionId,
    this.sourceCollectionTitle,
    this.sourceChapterId,
    this.sourceChapterTitle,
    this.sourceChapterNumber,
    this.sourceHadithNumbers = const <String>[],
    this.sourceProvenance = HadithSourceProvenance.seeded,
    this.sourceImportSource,
    this.categoryId,
    this.categoryTitle,
    this.subcategoryId,
    this.subcategoryTitle,
    required this.tags,
    required this.quranConnections,
    required this.meaning,
    required this.lessons,
    required this.reflectionPrompts,
    required this.practiceAction,
    required this.relatedHadithIds,
    this.isDailyEligible = false,
    this.difficultyLevel = HadithDifficultyLevel.beginner,
    this.themeTag,
    this.recommendedDay,
    this.isEssential = false,
  });

  final String id;
  final String themeId;
  final List<String> collectionIds;
  final String title;
  final String excerpt;
  final String hadithText;
  final String? englishText;
  final String? arabicText;
  final String? transliteration;
  final String? sourceReferenceKey;
  final String? transliterationSource;
  final HadithTransliterationStatus transliterationStatus;
  final HadithTransliterationReviewStatus transliterationReviewStatus;
  final String? transliterationReviewedAt;
  final String? sourceUrl;
  final bool translationSourceVerified;
  final bool arabicMatnSourceVerified;
  final bool transliterationSourceVerified;
  final String source;
  final String? sourceCollection;
  final String? sourceReference;
  final String grading;
  final String? narrator;
  final List<String> sourceCollectionIds;
  final String? sourceCollectionId;
  final String? sourceCollectionTitle;
  final String? sourceChapterId;
  final String? sourceChapterTitle;
  final int? sourceChapterNumber;
  final List<String> sourceHadithNumbers;
  final HadithSourceProvenance sourceProvenance;
  final String? sourceImportSource;
  final String? categoryId;
  final String? categoryTitle;
  final String? subcategoryId;
  final String? subcategoryTitle;
  final List<String> tags;
  final List<QuranConnection> quranConnections;
  final String meaning;
  final List<String> lessons;
  final List<String> reflectionPrompts;
  final String practiceAction;
  final List<String> relatedHadithIds;
  final bool isDailyEligible;
  final HadithDifficultyLevel difficultyLevel;
  final String? themeTag;
  final String? recommendedDay;
  final bool isEssential;

  String get displaySourceCollection => sourceCollection ?? source;
  String get displaySourceCollectionTitle {
    final explicit = _normalizeSpacing(sourceCollectionTitle);
    if (explicit != null) return explicit;
    if (normalizedSourceCollections.isNotEmpty) {
      return normalizedSourceCollections.first.displayTitle;
    }
    return normalizedSourceCollectionTitle;
  }

  String? get displaySourceReference => sourceReference;
  String get displayEnglishText => englishText ?? hadithText;
  String get translation => displayEnglishText;
  String? get arabicMatn => arabicText;
  String? get transliteratedText => transliteration;
  String get canonicalSourceReferenceKey =>
      _normalizeSpacing(sourceReferenceKey) ??
      _buildCanonicalSourceReferenceKey(
        collectionId: primarySourceCollectionId,
        reference: normalizedSourceReference,
      );
  String get normalizedSourceCollection => normalizedSourceCollectionTitle;
  String get normalizedSourceCollectionTitle =>
      _normalizeSpacing(displaySourceCollection)!;
  String? get normalizedSourceReference {
    final value = _normalizeSpacing(displaySourceReference);
    if (value == null || value.isEmpty) return null;
    return value.replaceAll('–', '-');
  }

  String get normalizedGrading => standardizedGrade.normalizedLabel;
  HadithGradeInfo get standardizedGrade => _normalizeHadithGrade(grading);
  String? get normalizedNarrator {
    final value = narrator?.trim();
    if (value == null || value.isEmpty) return null;
    return value;
  }

  String? get normalizedNarratorName => _normalizeNarratorName(narrator);
  String? get normalizedSourceCollectionId {
    final value = _normalizeCollectionId(sourceCollectionId);
    return value.isEmpty ? null : value;
  }

  String? get normalizedSourceCollectionDisplayTitle =>
      _normalizeSpacing(sourceCollectionTitle);
  String? get normalizedCategoryId => _normalizeCollectionId(categoryId);
  String? get normalizedSubcategoryId => _normalizeCollectionId(subcategoryId);
  String? get displayCategoryTitle => _normalizeSpacing(categoryTitle);
  String? get displaySubcategoryTitle => _normalizeSpacing(subcategoryTitle);
  bool get hasCanonicalCategoryMetadata =>
      normalizedCategoryId != null && displayCategoryTitle != null;
  bool get hasCanonicalSubcategoryMetadata =>
      normalizedSubcategoryId != null && displaySubcategoryTitle != null;
  HadithTaxonomyAssignment? get taxonomyAssignment {
    final category = normalizedCategoryId;
    final categoryLabel = displayCategoryTitle;
    final subcategory = normalizedSubcategoryId;
    final subcategoryLabel = displaySubcategoryTitle;
    if (category == null ||
        categoryLabel == null ||
        subcategory == null ||
        subcategoryLabel == null) {
      return null;
    }
    return HadithTaxonomyAssignment(
      categoryId: category,
      categoryTitle: categoryLabel,
      subcategoryId: subcategory,
      subcategoryTitle: subcategoryLabel,
    );
  }

  List<HadithSourceCollectionInfo> get normalizedSourceCollections {
    final explicitIds = sourceCollectionIds
        .map(_normalizeCollectionId)
        .where((item) => item.isNotEmpty)
        .toList(growable: false);
    final displayTitles = _splitCollectionTitles(displaySourceCollection);
    if (explicitIds.isNotEmpty) {
      final results = <HadithSourceCollectionInfo>[];
      for (var index = 0; index < explicitIds.length; index += 1) {
        final id = explicitIds[index];
        final title = index < displayTitles.length
            ? displayTitles[index]
            : _titleFromCollectionId(id);
        results.add(
          HadithSourceCollectionInfo(
            id: id,
            displayTitle: title,
            normalizedTitle: _normalizeSpacing(title)!,
          ),
        );
      }
      return List<HadithSourceCollectionInfo>.unmodifiable(results);
    }

    return List<HadithSourceCollectionInfo>.unmodifiable(
      displayTitles.map((title) {
        return HadithSourceCollectionInfo(
          id: _canonicalCollectionIdFromTitle(title),
          displayTitle: title,
          normalizedTitle: _normalizeSpacing(title)!,
        );
      }),
    );
  }

  String? get primarySourceCollectionId =>
      normalizedSourceCollectionId ??
      (normalizedSourceCollections.isEmpty
          ? null
          : normalizedSourceCollections.first.id);

  String get primarySourceCollectionTitle =>
      normalizedSourceCollectionDisplayTitle ??
      (normalizedSourceCollections.isEmpty
          ? normalizedSourceCollectionTitle
          : normalizedSourceCollections.first.displayTitle);

  int? get normalizedSourceChapterNumber =>
      sourceChapterNumber ?? _extractChapterNumber(normalizedSourceReference);

  String? get normalizedSourceChapterTitle {
    final explicit = _normalizeSpacing(sourceChapterTitle);
    if (explicit != null && explicit.isNotEmpty) return explicit;
    final number = normalizedSourceChapterNumber;
    if (number == null) return null;
    final reference = normalizedSourceReference ?? '';
    final keyword = RegExp(
      r'(book|chapter)\s+' + number.toString() + r'\b',
      caseSensitive: false,
    ).firstMatch(reference);
    if (keyword == null) return null;
    return _normalizeSpacing(keyword.group(0));
  }

  String? get normalizedSourceChapterId {
    final explicit = _normalizeCollectionId(sourceChapterId);
    if (explicit.isNotEmpty) return explicit;
    final title = normalizedSourceChapterTitle;
    if (title == null || title.isEmpty) return null;
    return _slugify(title);
  }

  List<String> get normalizedSourceHadithNumbers {
    final explicit = sourceHadithNumbers
        .map(_normalizeSpacing)
        .whereType<String>()
        .where((item) => item.isNotEmpty)
        .toList(growable: false);
    if (explicit.isNotEmpty) {
      return List<String>.unmodifiable(explicit);
    }
    return List<String>.unmodifiable(
      _extractHadithNumbers(normalizedSourceReference),
    );
  }

  String? get primaryHadithNumber => normalizedSourceHadithNumbers.isEmpty
      ? null
      : normalizedSourceHadithNumbers.first;

  HadithSourceMetadata get sourceMetadata => HadithSourceMetadata(
    collections: normalizedSourceCollections,
    primaryCollectionId: primarySourceCollectionId,
    primaryCollectionTitle: primarySourceCollectionTitle,
    displayCollectionTitle: displaySourceCollection,
    normalizedCollectionTitle: normalizedSourceCollectionTitle,
    chapter: normalizedSourceChapterNumber == null
        ? null
        : HadithSourceChapterInfo(
            id:
                normalizedSourceChapterId ??
                'chapter_${normalizedSourceChapterNumber!}',
            title:
                normalizedSourceChapterTitle ??
                'Chapter ${normalizedSourceChapterNumber!}',
            number: normalizedSourceChapterNumber!,
          ),
    referenceLabel: displaySourceReference,
    normalizedReferenceLabel: normalizedSourceReference,
    referenceKey: canonicalSourceReferenceKey,
    hadithNumbers: normalizedSourceHadithNumbers,
    normalizedNarrator: normalizedNarratorName,
    grade: standardizedGrade,
    provenance: sourceProvenance,
    importSource: effectiveSourceImportSource,
  );

  HadithTransliterationMetadata get transliterationMetadata =>
      HadithTransliterationMetadata(
        text: transliteratedText,
        source: _normalizeSpacing(transliterationSource),
        status: hasTransliteration
            ? transliterationStatus
            : HadithTransliterationStatus.missing,
        reviewStatus: transliterationReviewStatus,
        reviewedAt: _normalizeSpacing(transliterationReviewedAt),
        referenceKey: canonicalSourceReferenceKey,
        sourceVerified: transliterationSourceVerified,
      );

  String? get effectiveSourceImportSource {
    final explicit = _normalizeSpacing(sourceImportSource);
    if (explicit != null && explicit.isNotEmpty) return explicit;
    return switch (sourceProvenance) {
      HadithSourceProvenance.seeded => 'seeded_hadith_foundation_data',
      HadithSourceProvenance.editorialOverride => 'editorial_hadith_override',
      HadithSourceProvenance.imported => null,
      HadithSourceProvenance.unknown => null,
    };
  }

  String get sourceLabel {
    final parts = <String>[normalizedSourceCollectionTitle];
    if (normalizedSourceReference != null) {
      parts.add(normalizedSourceReference!);
    }
    return parts.join(' • ');
  }

  bool get hasArabicMatn => (arabicMatn ?? '').trim().isNotEmpty;
  bool get hasTransliteration => (transliteratedText ?? '').trim().isNotEmpty;
  bool get hasSourceCollectionMetadata =>
      normalizedSourceCollectionTitle.isNotEmpty ||
      normalizedSourceCollections.isNotEmpty;
  bool get hasSourceReferenceMetadata => normalizedSourceReference != null;
  bool get hasGradingMetadata => standardizedGrade.hasMetadata;
  bool get hasVerifiedTranslation =>
      translationSourceVerified && translation.trim().isNotEmpty;
  bool get hasVerifiedArabicMatn => arabicMatnSourceVerified && hasArabicMatn;
  bool get hasVerifiedTransliteration =>
      transliterationSourceVerified && hasTransliteration;
  bool get isSourceBacked => sourceUrl != null && sourceUrl!.trim().isNotEmpty;
  bool get isLaunchReady =>
      hasVerifiedTranslation &&
      hasVerifiedArabicMatn &&
      hasSourceReferenceMetadata &&
      hasGradingMetadata;

  HadithEntry copyWith({
    String? title,
    String? excerpt,
    String? meaning,
    List<String>? lessons,
    List<String>? reflectionPrompts,
    String? practiceAction,
    List<String>? tags,
    List<String>? sourceCollectionIds,
    String? sourceCollectionId,
    String? sourceCollectionTitle,
    String? sourceChapterId,
    String? sourceChapterTitle,
    int? sourceChapterNumber,
    List<String>? sourceHadithNumbers,
    HadithSourceProvenance? sourceProvenance,
    String? sourceImportSource,
    String? categoryId,
    String? categoryTitle,
    String? subcategoryId,
    String? subcategoryTitle,
  }) {
    return HadithEntry(
      id: id,
      themeId: themeId,
      collectionIds: collectionIds,
      title: title ?? this.title,
      excerpt: excerpt ?? this.excerpt,
      hadithText: hadithText,
      englishText: englishText,
      arabicText: arabicText,
      transliteration: transliteration,
      sourceReferenceKey: sourceReferenceKey,
      transliterationSource: transliterationSource,
      transliterationStatus: transliterationStatus,
      transliterationReviewStatus: transliterationReviewStatus,
      transliterationReviewedAt: transliterationReviewedAt,
      sourceUrl: sourceUrl,
      translationSourceVerified: translationSourceVerified,
      arabicMatnSourceVerified: arabicMatnSourceVerified,
      transliterationSourceVerified: transliterationSourceVerified,
      source: source,
      sourceCollection: sourceCollection,
      sourceReference: sourceReference,
      grading: grading,
      narrator: narrator,
      sourceCollectionIds: sourceCollectionIds ?? this.sourceCollectionIds,
      sourceCollectionId: sourceCollectionId ?? this.sourceCollectionId,
      sourceCollectionTitle:
          sourceCollectionTitle ?? this.sourceCollectionTitle,
      sourceChapterId: sourceChapterId ?? this.sourceChapterId,
      sourceChapterTitle: sourceChapterTitle ?? this.sourceChapterTitle,
      sourceChapterNumber: sourceChapterNumber ?? this.sourceChapterNumber,
      sourceHadithNumbers: sourceHadithNumbers ?? this.sourceHadithNumbers,
      sourceProvenance: sourceProvenance ?? this.sourceProvenance,
      sourceImportSource: sourceImportSource ?? this.sourceImportSource,
      categoryId: categoryId ?? this.categoryId,
      categoryTitle: categoryTitle ?? this.categoryTitle,
      subcategoryId: subcategoryId ?? this.subcategoryId,
      subcategoryTitle: subcategoryTitle ?? this.subcategoryTitle,
      tags: tags ?? this.tags,
      quranConnections: quranConnections,
      meaning: meaning ?? this.meaning,
      lessons: lessons ?? this.lessons,
      reflectionPrompts: reflectionPrompts ?? this.reflectionPrompts,
      practiceAction: practiceAction ?? this.practiceAction,
      relatedHadithIds: relatedHadithIds,
      isDailyEligible: isDailyEligible,
      difficultyLevel: difficultyLevel,
      themeTag: themeTag,
      recommendedDay: recommendedDay,
      isEssential: isEssential,
    );
  }
}

class HadithTheme {
  const HadithTheme({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.icon,
    required this.hadithIds,
    required this.quranAnchors,
    this.isFeatured = false,
  });

  final String id;
  final String title;
  final String subtitle;
  final String description;
  final IconData icon;
  final List<String> hadithIds;
  final List<QuranConnection> quranAnchors;
  final bool isFeatured;
}

class HadithCollection {
  const HadithCollection({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.hadithIds,
  });

  final String id;
  final String title;
  final String subtitle;
  final String description;
  final List<String> hadithIds;
}

String? _normalizeSpacing(String? raw) {
  final value = raw?.trim();
  if (value == null || value.isEmpty) return null;
  return value.replaceAll(RegExp(r'\s+'), ' ');
}

String? _normalizeNarratorName(String? raw) {
  final value = raw?.trim();
  if (value == null || value.isEmpty) return null;
  final withoutHonorific = value
      .replaceAll(RegExp(r'\s*\([^)]*\)\s*'), ' ')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();
  return withoutHonorific.isEmpty ? null : withoutHonorific;
}

HadithGradeInfo _normalizeHadithGrade(String raw) {
  final display = _normalizeSpacing(raw) ?? '';
  if (display.isEmpty) {
    return const HadithGradeInfo(
      displayLabel: '',
      normalizedLabel: '',
      category: HadithGradeCategory.unknown,
    );
  }

  final normalized = display.toLowerCase();
  if (normalized.contains('muttafaqun')) {
    return HadithGradeInfo(
      displayLabel: display,
      normalizedLabel: 'muttafaqun_alayh',
      category: HadithGradeCategory.muttafaqunAlayh,
    );
  }
  if (normalized.contains('hasan sahih')) {
    return HadithGradeInfo(
      displayLabel: display,
      normalizedLabel: 'hasan_sahih',
      category: HadithGradeCategory.hasanSahih,
    );
  }
  if (normalized.contains("da'if") ||
      normalized.contains('daif') ||
      normalized.contains('weak')) {
    return HadithGradeInfo(
      displayLabel: display,
      normalizedLabel: 'weak',
      category: HadithGradeCategory.weak,
    );
  }
  if (normalized.contains('balagh')) {
    return HadithGradeInfo(
      displayLabel: display,
      normalizedLabel: 'balagh',
      category: HadithGradeCategory.balagh,
    );
  }
  if (normalized.contains('hasan')) {
    return HadithGradeInfo(
      displayLabel: display,
      normalizedLabel: 'hasan',
      category: HadithGradeCategory.hasan,
    );
  }
  if (normalized.contains('sahih')) {
    return HadithGradeInfo(
      displayLabel: display,
      normalizedLabel: 'sahih',
      category: HadithGradeCategory.sahih,
    );
  }
  return HadithGradeInfo(
    displayLabel: display,
    normalizedLabel: _slugify(display),
    category: HadithGradeCategory.other,
  );
}

List<String> _splitCollectionTitles(String raw) {
  return raw
      .split(RegExp(r'\s*/\s*'))
      .map(_normalizeSpacing)
      .whereType<String>()
      .toList(growable: false);
}

String _normalizeCollectionId(String? raw) {
  final value = raw?.trim() ?? '';
  if (value.isEmpty) return '';
  return _slugify(value);
}

String _canonicalCollectionIdFromTitle(String title) {
  const canonicalMap = <String, String>{
    'sahih al-bukhari': 'sahih_al_bukhari',
    'sahih muslim': 'sahih_muslim',
    "jami' al-tirmidhi": 'jami_al_tirmidhi',
    'jami al-tirmidhi': 'jami_al_tirmidhi',
    'sunan abi dawud': 'sunan_abi_dawud',
    "sunan al-nasa'i": 'sunan_al_nasai',
    'sunan al-nasai': 'sunan_al_nasai',
    'sunan ibn majah': 'sunan_ibn_majah',
    'ibn majah': 'sunan_ibn_majah',
    'muwatta malik': 'muwatta_malik',
  };
  final normalizedTitle = title.toLowerCase().trim();
  return canonicalMap[normalizedTitle] ?? _slugify(title);
}

String _titleFromCollectionId(String raw) {
  return raw
      .split('_')
      .where((part) => part.isNotEmpty)
      .map((part) => '${part[0].toUpperCase()}${part.substring(1)}')
      .join(' ');
}

int? _extractChapterNumber(String? reference) {
  if (reference == null || reference.isEmpty) return null;
  final match = RegExp(
    r'(?:book|chapter)\s+(\d+)',
    caseSensitive: false,
  ).firstMatch(reference);
  if (match == null) return null;
  return int.tryParse(match.group(1) ?? '');
}

List<String> _extractHadithNumbers(String? reference) {
  if (reference == null || reference.isEmpty) return const <String>[];
  final segments = reference
      .split(RegExp(r'\s*/\s*'))
      .map(_normalizeSpacing)
      .whereType<String>();
  final values = <String>[];
  for (final segment in segments) {
    final hadithMatch = RegExp(
      r'hadith\s+(\d+(?:-\d+)?)',
      caseSensitive: false,
    ).firstMatch(segment);
    if (hadithMatch != null) {
      values.add(hadithMatch.group(1)!);
      continue;
    }
    final trailingNumber = RegExp(r'(\d+(?:-\d+)?)$').firstMatch(segment);
    if (trailingNumber != null) {
      values.add(trailingNumber.group(1)!);
    }
  }
  return values.toSet().toList(growable: false);
}

String _slugify(String raw) {
  return raw
      .toLowerCase()
      .replaceAll(RegExp(r"[’'`]+"), '')
      .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
      .replaceAll(RegExp(r'_+'), '_')
      .replaceAll(RegExp(r'^_|_$'), '');
}

String _buildCanonicalSourceReferenceKey({
  required String? collectionId,
  required String? reference,
}) {
  final normalizedCollection = _normalizeCollectionId(collectionId);
  final normalizedReference = _slugify(_normalizeSpacing(reference) ?? '');
  if (normalizedCollection.isEmpty && normalizedReference.isEmpty) {
    return '';
  }
  if (normalizedCollection.isEmpty) {
    return normalizedReference;
  }
  if (normalizedReference.isEmpty) {
    return normalizedCollection;
  }
  return [normalizedCollection, normalizedReference].join('__');
}
