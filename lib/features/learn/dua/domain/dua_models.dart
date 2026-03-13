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
}

@immutable
class DuaItem {
  const DuaItem({
    required this.id,
    required this.category,
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
  final String category;
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

  bool get hasContent =>
      arabic.trim().isNotEmpty ||
      transliteration.trim().isNotEmpty ||
      translation.trim().isNotEmpty;

  bool get isQuran => sourceType.trim().toLowerCase() == 'quran';
  bool get isSunnah => sourceType.trim().toLowerCase() == 'sunnah';

  String get subcategoryLabel => _titleize(subcategory);
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
    required this.subcategories,
  });

  final String id;
  final String label;
  final int completeCount;
  final int stubCount;
  final Map<String, int> subcategories;

  int get totalCount => completeCount + stubCount;
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
  if (raw.trim().isEmpty) return raw;
  return raw
      .split('_')
      .where((part) => part.isNotEmpty)
      .map((part) => '${part[0].toUpperCase()}${part.substring(1)}')
      .join(' ');
}
