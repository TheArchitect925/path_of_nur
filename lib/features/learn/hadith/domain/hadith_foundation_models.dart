import 'package:flutter/material.dart';

enum HadithDifficultyLevel { beginner, intermediate }

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
    required this.source,
    this.sourceCollection,
    this.sourceReference,
    required this.grading,
    this.narrator,
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
  final String source;
  final String? sourceCollection;
  final String? sourceReference;
  final String grading;
  final String? narrator;
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
  String? get displaySourceReference => sourceReference;
  String get displayEnglishText => englishText ?? hadithText;
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
