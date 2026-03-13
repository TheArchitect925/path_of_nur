import 'package:flutter/foundation.dart';

enum FaqDifficulty { beginner, intermediate, advanced }

extension FaqDifficultyX on FaqDifficulty {
  static FaqDifficulty fromValue(String? value) {
    switch ((value ?? '').trim().toLowerCase()) {
      case 'intermediate':
        return FaqDifficulty.intermediate;
      case 'advanced':
        return FaqDifficulty.advanced;
      case 'beginner':
      default:
        return FaqDifficulty.beginner;
    }
  }

  String get label {
    switch (this) {
      case FaqDifficulty.beginner:
        return 'Beginner';
      case FaqDifficulty.intermediate:
        return 'Intermediate';
      case FaqDifficulty.advanced:
        return 'Advanced';
    }
  }
}

@immutable
class FaqItem {
  const FaqItem({
    required this.id,
    required this.category,
    required this.question,
    required this.shortAnswer,
    required this.answer,
    required this.quranRefs,
    required this.hadithRefs,
    required this.misconceptionTag,
    required this.relatedTopics,
    required this.difficulty,
    required this.isFeatured,
  });

  final String id;
  final String category;
  final String question;
  final String shortAnswer;
  final String answer;
  final List<String> quranRefs;
  final List<String> hadithRefs;
  final String? misconceptionTag;
  final List<String> relatedTopics;
  final FaqDifficulty difficulty;
  final bool isFeatured;

  factory FaqItem.fromJson(Map<String, dynamic> json) {
    return FaqItem(
      id: json['id']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      question: json['question']?.toString() ?? '',
      shortAnswer: json['short_answer']?.toString() ?? '',
      answer: json['answer']?.toString() ?? '',
      quranRefs: _stringList(json['quran_refs']),
      hadithRefs: _stringList(json['hadith_refs']),
      misconceptionTag: _nullableString(json['misconception_tag']),
      relatedTopics: _stringList(json['related_topics']),
      difficulty: FaqDifficultyX.fromValue(json['difficulty']?.toString()),
      isFeatured: json['is_featured'] == true,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'category': category,
    'question': question,
    'short_answer': shortAnswer,
    'answer': answer,
    'quran_refs': quranRefs,
    'hadith_refs': hadithRefs,
    'misconception_tag': misconceptionTag,
    'related_topics': relatedTopics,
    'difficulty': difficulty.name,
    'is_featured': isFeatured,
  };

  String get misconceptionLabel {
    final raw = misconceptionTag;
    if (raw == null || raw.trim().isEmpty) return '';
    return raw
        .split('_')
        .where((part) => part.isNotEmpty)
        .map((part) => '${part[0].toUpperCase()}${part.substring(1)}')
        .join(' ');
  }
}

@immutable
class FaqDataset {
  const FaqDataset({
    required this.version,
    required this.app,
    required this.datasetName,
    required this.notes,
    required this.categoryLabels,
    required this.fields,
    required this.items,
  });

  final String version;
  final String app;
  final String datasetName;
  final List<String> notes;
  final Map<String, String> categoryLabels;
  final List<String> fields;
  final List<FaqItem> items;

  factory FaqDataset.fromJson(Map<String, dynamic> json) {
    final rawItems = (json['items'] as List?) ?? const [];
    final rawLabels =
        (json['category_labels'] as Map?)?.map(
          (key, value) => MapEntry(key.toString(), value.toString()),
        ) ??
        const <String, String>{};
    return FaqDataset(
      version: json['version']?.toString() ?? '',
      app: json['app']?.toString() ?? '',
      datasetName: json['dataset_name']?.toString() ?? '',
      notes: _stringList(json['notes']),
      categoryLabels: rawLabels,
      fields: _stringList(json['fields']),
      items: rawItems
          .whereType<Map>()
          .map((item) => FaqItem.fromJson(item.cast<String, dynamic>()))
          .toList(growable: false),
    );
  }

  String categoryLabel(String categoryId) {
    return categoryLabels[categoryId] ?? categoryId;
  }
}

@immutable
class FaqCategorySummary {
  const FaqCategorySummary({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.questionCount,
    required this.featuredCount,
  });

  final String id;
  final String title;
  final String subtitle;
  final int questionCount;
  final int featuredCount;
}

List<String> _stringList(Object? value) {
  final list = value as List?;
  if (list == null) return const <String>[];
  return list.map((entry) => entry.toString()).toList(growable: false);
}

String? _nullableString(Object? value) {
  final raw = value?.toString();
  if (raw == null || raw.trim().isEmpty || raw.toLowerCase() == 'null') {
    return null;
  }
  return raw;
}
