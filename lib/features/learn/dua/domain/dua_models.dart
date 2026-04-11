import 'package:flutter/foundation.dart';

@immutable
class DuaDataset {
  const DuaDataset({
    required this.version,
    required this.app,
    required this.datasetName,
    required this.notes,
    required this.totalItems,
    required this.completeItems,
    required this.stubItems,
    required this.categoryLabels,
    this.primaryCategoryLabels = const <String, String>{},
    required this.items,
  });

  final String version;
  final String app;
  final String datasetName;
  final List<String> notes;
  final int totalItems;
  final int completeItems;
  final int stubItems;
  final Map<String, String> categoryLabels;
  final Map<String, String> primaryCategoryLabels;
  final List<DuaItem> items;

  factory DuaDataset.fromJson(Map<String, dynamic> json) {
    final counts =
        (json['counts'] as Map?)?.cast<String, dynamic>() ??
        const <String, dynamic>{};
    final labels =
        (json['category_labels'] as Map?)?.map(
          (key, value) => MapEntry(key.toString(), value.toString()),
        ) ??
        const <String, String>{};
    final primaryLabels =
        (json['primary_category_labels'] as Map?)?.map(
          (key, value) => MapEntry(key.toString(), value.toString()),
        ) ??
        const <String, String>{};
    final rawItems = (json['items'] as List?) ?? const [];
    return DuaDataset(
      version: json['version']?.toString() ?? '',
      app: json['app']?.toString() ?? '',
      datasetName: json['dataset_name']?.toString() ?? '',
      notes: rawStringList(json['notes']),
      totalItems: _asInt(counts['total_items']),
      completeItems: _asInt(counts['complete_items']),
      stubItems: _asInt(counts['stub_items']),
      categoryLabels: labels,
      primaryCategoryLabels: primaryLabels,
      items: rawItems
          .whereType<Map>()
          .map((item) => DuaItem.fromJson(item.cast<String, dynamic>()))
          .toList(growable: false),
    );
  }

  List<DuaItem> get verifiedItems => items
      .where((item) => item.completionStatus == DuaCompletionStatus.complete)
      .toList(growable: false);

  String categoryLabel(String categoryId) {
    return categoryLabels[categoryId] ?? _titleize(categoryId);
  }

  String primaryCategoryLabel(String categoryId) {
    return primaryCategoryLabels[categoryId] ?? _titleize(categoryId);
  }
}

@immutable
class DuaItem {
  const DuaItem({
    required this.id,
    required this.category,
    this.primaryCategory = '',
    this.secondaryCategories = const <String>[],
    this.timeContexts = const <String>[],
    this.dateContexts = const <String>[],
    this.weatherContexts = const <String>[],
    this.locationContexts = const <String>[],
    this.prayerContexts = const <String>[],
    this.situationContexts = const <String>[],
    this.surfaceEligibility = const <String>[],
    this.priorityScore = 0,
    required this.subcategory,
    required this.title,
    required this.arabic,
    required this.transliteration,
    required this.translation,
    required this.whenToSay,
    required this.sourceType,
    required this.sourceRef,
    required this.difficulty,
    required this.tags,
    required this.audioKey,
    required this.isCore,
    required this.verificationStatus,
    required this.completionStatus,
  });

  final String id;
  @Deprecated('Use primaryCategory instead.')
  final String category;
  final String primaryCategory;
  final List<String> secondaryCategories;
  final List<String> timeContexts;
  final List<String> dateContexts;
  final List<String> weatherContexts;
  final List<String> locationContexts;
  final List<String> prayerContexts;
  final List<String> situationContexts;
  final List<String> surfaceEligibility;
  final int priorityScore;
  final String subcategory;
  final String title;
  final String arabic;
  final String transliteration;
  final String translation;
  final String whenToSay;
  final String sourceType;
  final String sourceRef;
  final DuaDifficulty difficulty;
  final List<String> tags;
  final String audioKey;
  final bool isCore;
  final String verificationStatus;
  final DuaCompletionStatus completionStatus;

  factory DuaItem.fromJson(Map<String, dynamic> json) {
    return DuaItem(
      id: json['id']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      primaryCategory:
          json['primary_category']?.toString() ??
          json['category']?.toString() ??
          '',
      secondaryCategories: rawStringList(json['secondary_categories']),
      timeContexts: rawStringList(json['time_contexts']),
      dateContexts: rawStringList(json['date_contexts']),
      weatherContexts: rawStringList(json['weather_contexts']),
      locationContexts: rawStringList(json['location_contexts']),
      prayerContexts: rawStringList(json['prayer_contexts']),
      situationContexts: rawStringList(json['situation_contexts']),
      surfaceEligibility: rawStringList(json['surface_eligibility']),
      priorityScore: _asInt(json['priority_score']),
      subcategory: json['subcategory']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      arabic: json['arabic']?.toString() ?? '',
      transliteration: json['transliteration']?.toString() ?? '',
      translation: json['translation']?.toString() ?? '',
      whenToSay: json['when_to_say']?.toString() ?? '',
      sourceType: json['source_type']?.toString() ?? '',
      sourceRef: json['source_ref']?.toString() ?? '',
      difficulty: DuaDifficultyX.fromValue(json['difficulty']?.toString()),
      tags: rawStringList(json['tags']),
      audioKey: json['audio_key']?.toString() ?? '',
      isCore: json['is_core'] == true,
      verificationStatus: json['verification_status']?.toString() ?? '',
      completionStatus: DuaCompletionStatusX.fromValue(
        json['completion_status']?.toString(),
      ),
    );
  }

  DuaItem copyWith({
    String? category,
    String? primaryCategory,
    List<String>? secondaryCategories,
    List<String>? timeContexts,
    List<String>? dateContexts,
    List<String>? weatherContexts,
    List<String>? locationContexts,
    List<String>? prayerContexts,
    List<String>? situationContexts,
    List<String>? surfaceEligibility,
    int? priorityScore,
    String? subcategory,
    String? title,
    String? arabic,
    String? transliteration,
    String? translation,
    String? whenToSay,
    String? sourceType,
    String? sourceRef,
    DuaDifficulty? difficulty,
    List<String>? tags,
    String? audioKey,
    bool? isCore,
    String? verificationStatus,
    DuaCompletionStatus? completionStatus,
  }) {
    return DuaItem(
      id: id,
      category: category ?? this.category,
      primaryCategory: primaryCategory ?? this.primaryCategory,
      secondaryCategories: secondaryCategories ?? this.secondaryCategories,
      timeContexts: timeContexts ?? this.timeContexts,
      dateContexts: dateContexts ?? this.dateContexts,
      weatherContexts: weatherContexts ?? this.weatherContexts,
      locationContexts: locationContexts ?? this.locationContexts,
      prayerContexts: prayerContexts ?? this.prayerContexts,
      situationContexts: situationContexts ?? this.situationContexts,
      surfaceEligibility: surfaceEligibility ?? this.surfaceEligibility,
      priorityScore: priorityScore ?? this.priorityScore,
      subcategory: subcategory ?? this.subcategory,
      title: title ?? this.title,
      arabic: arabic ?? this.arabic,
      transliteration: transliteration ?? this.transliteration,
      translation: translation ?? this.translation,
      whenToSay: whenToSay ?? this.whenToSay,
      sourceType: sourceType ?? this.sourceType,
      sourceRef: sourceRef ?? this.sourceRef,
      difficulty: difficulty ?? this.difficulty,
      tags: tags ?? this.tags,
      audioKey: audioKey ?? this.audioKey,
      isCore: isCore ?? this.isCore,
      verificationStatus: verificationStatus ?? this.verificationStatus,
      completionStatus: completionStatus ?? this.completionStatus,
    );
  }

  bool get hasContent =>
      arabic.trim().isNotEmpty ||
      transliteration.trim().isNotEmpty ||
      translation.trim().isNotEmpty;

  bool get isQuran => sourceType.trim().toLowerCase() == 'quran';
  bool get isSunnah => sourceType.trim().toLowerCase() == 'sunnah';
  String get effectivePrimaryCategory =>
      primaryCategory.trim().isEmpty ? category : primaryCategory;
  bool get isVerifiedStrong => verificationStatus == 'verified_strong';
  bool get isVerifiedGeneral => verificationStatus == 'verified_general';
  bool get needsReview => verificationStatus == 'needs_review';
  bool get excludeFromDefaultSurface =>
      verificationStatus == 'exclude_from_default_surface';
  bool get isDefaultSurfaceEligible => isVerifiedStrong || isVerifiedGeneral;

  String get subcategoryLabel => _titleize(subcategory);

  List<String> get discoveryCategories {
    final values = <String>[];
    void addIfMissing(String value) {
      final normalized = value.trim();
      if (normalized.isEmpty || values.contains(normalized)) return;
      values.add(normalized);
    }

    addIfMissing(category);
    addIfMissing(effectivePrimaryCategory);
    for (final secondaryCategory in secondaryCategories) {
      addIfMissing(secondaryCategory);
    }
    return List<String>.unmodifiable(values);
  }

  bool matchesCategoryId(String categoryId) {
    final normalized = categoryId.trim().toLowerCase();
    if (normalized.isEmpty) return true;
    return discoveryCategories.any(
      (value) => value.trim().toLowerCase() == normalized,
    );
  }

  String searchableText({
    required String categoryLabel,
    String? primaryCategoryLabel,
    Iterable<String> secondaryCategoryLabels = const <String>[],
  }) {
    return _joinSearchParts(<String>[
      title,
      arabic,
      transliteration,
      translation,
      whenToSay,
      sourceType,
      sourceRef,
      category,
      categoryLabel,
      effectivePrimaryCategory,
      primaryCategoryLabel ?? _titleize(effectivePrimaryCategory),
      ...secondaryCategories,
      ...secondaryCategoryLabels,
      subcategory,
      subcategoryLabel,
      verificationStatus,
      ...tags,
    ]);
  }

  bool matchesQuery(
    String query, {
    required String categoryLabel,
    String? primaryCategoryLabel,
    Iterable<String> secondaryCategoryLabels = const <String>[],
  }) {
    if (query.trim().isEmpty) return true;
    return searchableText(
      categoryLabel: categoryLabel,
      primaryCategoryLabel: primaryCategoryLabel,
      secondaryCategoryLabels: secondaryCategoryLabels,
    ).contains(query.trim().toLowerCase());
  }
}

enum DuaDifficulty { beginner, intermediate, advanced }

enum DuaCompletionStatus { complete, stub }

extension DuaDifficultyX on DuaDifficulty {
  static DuaDifficulty fromValue(String? value) {
    switch ((value ?? '').trim().toLowerCase()) {
      case 'intermediate':
        return DuaDifficulty.intermediate;
      case 'advanced':
        return DuaDifficulty.advanced;
      case 'beginner':
      default:
        return DuaDifficulty.beginner;
    }
  }

  String get label {
    switch (this) {
      case DuaDifficulty.beginner:
        return 'Beginner';
      case DuaDifficulty.intermediate:
        return 'Intermediate';
      case DuaDifficulty.advanced:
        return 'Advanced';
    }
  }
}

extension DuaCompletionStatusX on DuaCompletionStatus {
  static DuaCompletionStatus fromValue(String? value) {
    switch ((value ?? '').trim().toLowerCase()) {
      case 'stub':
        return DuaCompletionStatus.stub;
      case 'complete':
      default:
        return DuaCompletionStatus.complete;
    }
  }
}

@immutable
class DuaCategorySummary {
  const DuaCategorySummary({
    required this.id,
    required this.label,
    required this.completeCount,
    required this.stubCount,
    required this.searchableText,
    required this.subcategories,
  });

  final String id;
  final String label;
  final int completeCount;
  final int stubCount;
  final String searchableText;
  final List<DuaSubcategorySummary> subcategories;

  int get totalCount => completeCount + stubCount;

  bool matchesQuery(String query) {
    if (query.trim().isEmpty) return true;
    return searchableText.contains(query.trim().toLowerCase());
  }
}

@immutable
class DuaSubcategorySummary {
  const DuaSubcategorySummary({
    required this.id,
    required this.label,
    required this.completeCount,
    required this.stubCount,
    required this.searchableText,
  });

  final String id;
  final String label;
  final int completeCount;
  final int stubCount;
  final String searchableText;

  int get totalCount => completeCount + stubCount;

  bool matchesQuery(String query) {
    if (query.trim().isEmpty) return true;
    return searchableText.contains(query.trim().toLowerCase());
  }
}

List<String> rawStringList(Object? value) {
  final raw = value as List?;
  if (raw == null) return const <String>[];
  return raw.map((entry) => entry.toString()).toList(growable: false);
}

int _asInt(Object? value) {
  if (value is int) return value;
  return int.tryParse(value?.toString() ?? '') ?? 0;
}

String _titleize(String raw) {
  return raw
      .split('_')
      .where((part) => part.isNotEmpty)
      .map((part) => '${part[0].toUpperCase()}${part.substring(1)}')
      .join(' ');
}

String _joinSearchParts(Iterable<String> values) {
  return values
      .map((value) => value.trim().toLowerCase())
      .where((value) => value.isNotEmpty)
      .join(' ');
}
