import 'package:flutter/material.dart';

enum CreationParentCategory { animals, plants, landscape, water, sky }

enum CreationCategoryId {
  animals,
  birds,
  insects,
  plants,
  trees,
  water,
  mountains,
  landscape,
  sky,
}

class CreationCategory {
  const CreationCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.parentCategory,
    required this.description,
    required this.verseIds,
    required this.tags,
    required this.colorTheme,
  });

  final CreationCategoryId id;
  final String name;
  final IconData icon;
  final CreationParentCategory parentCategory;
  final String description;
  final List<String> verseIds;
  final List<String> tags;
  final Color colorTheme;
}

class CreationVerse {
  const CreationVerse({
    required this.id,
    required this.ayahReference,
    required this.translation,
    required this.reflection,
    required this.categoryTags,
    this.arabicText,
  });

  final String id;
  final String ayahReference;
  final String? arabicText;
  final String translation;
  final String reflection;
  final List<String> categoryTags;
}

class CreationObservation {
  const CreationObservation({
    required this.id,
    required this.timestamp,
    required this.categoryId,
    required this.aiConfidence,
    required this.selectedVerseId,
    required this.isFavorite,
    this.locationName,
    this.latitude,
    this.longitude,
    this.imagePath,
    this.userReflection,
  });

  final String id;
  final DateTime timestamp;
  final String? locationName;
  final double? latitude;
  final double? longitude;
  final CreationCategoryId categoryId;
  final double aiConfidence;
  final String? imagePath;
  final String selectedVerseId;
  final String? userReflection;
  final bool isFavorite;

  CreationObservation copyWith({
    String? locationName,
    double? latitude,
    double? longitude,
    CreationCategoryId? categoryId,
    double? aiConfidence,
    String? imagePath,
    String? selectedVerseId,
    String? userReflection,
    bool? isFavorite,
    bool clearImagePath = false,
    bool clearReflection = false,
  }) {
    return CreationObservation(
      id: id,
      timestamp: timestamp,
      locationName: locationName ?? this.locationName,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      categoryId: categoryId ?? this.categoryId,
      aiConfidence: aiConfidence ?? this.aiConfidence,
      imagePath: clearImagePath ? null : (imagePath ?? this.imagePath),
      selectedVerseId: selectedVerseId ?? this.selectedVerseId,
      userReflection: clearReflection
          ? null
          : (userReflection ?? this.userReflection),
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'timestamp': timestamp.toIso8601String(),
    'locationName': locationName,
    'latitude': latitude,
    'longitude': longitude,
    'categoryId': categoryId.name,
    'aiConfidence': aiConfidence,
    'imagePath': imagePath,
    'selectedVerseId': selectedVerseId,
    'userReflection': userReflection,
    'isFavorite': isFavorite,
  };

  static CreationObservation? fromJson(dynamic raw) {
    if (raw is! Map) return null;
    final id = raw['id']?.toString();
    final timestamp = DateTime.tryParse(raw['timestamp']?.toString() ?? '');
    final categoryName = raw['categoryId']?.toString();
    final selectedVerseId = raw['selectedVerseId']?.toString();
    if (id == null ||
        timestamp == null ||
        categoryName == null ||
        selectedVerseId == null) {
      return null;
    }
    CreationCategoryId? category;
    for (final item in CreationCategoryId.values) {
      if (item.name == categoryName) {
        category = item;
        break;
      }
    }
    if (category == null) return null;
    return CreationObservation(
      id: id,
      timestamp: timestamp,
      locationName: raw['locationName']?.toString(),
      latitude: (raw['latitude'] as num?)?.toDouble(),
      longitude: (raw['longitude'] as num?)?.toDouble(),
      categoryId: category,
      aiConfidence: (raw['aiConfidence'] as num?)?.toDouble() ?? 0,
      imagePath: raw['imagePath']?.toString(),
      selectedVerseId: selectedVerseId,
      userReflection: raw['userReflection']?.toString(),
      isFavorite: raw['isFavorite'] == true,
    );
  }
}

class CreationDetection {
  const CreationDetection({
    required this.categoryId,
    required this.confidence,
    required this.detectedAt,
    this.rawLabel,
  });

  final CreationCategoryId categoryId;
  final String? rawLabel;
  final double confidence;
  final DateTime detectedAt;
}
