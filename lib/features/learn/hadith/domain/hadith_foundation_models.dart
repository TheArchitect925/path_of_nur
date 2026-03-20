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
    this.transliteration,
    this.sourceUrl,
    this.translationSourceVerified = false,
    this.arabicMatnSourceVerified = false,
    this.transliterationSourceVerified = false,
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
  final String? transliteration;
  final String? sourceUrl;
  final bool translationSourceVerified;
  final bool arabicMatnSourceVerified;
  final bool transliterationSourceVerified;
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
  String get translation => displayEnglishText;
  String? get arabicMatn => arabicText;
  String? get transliteratedText => transliteration;
  String get sourceLabel {
    final parts = <String>[displaySourceCollection];
    if (displaySourceReference != null &&
        displaySourceReference!.trim().isNotEmpty) {
      parts.add(displaySourceReference!.trim());
    }
    return parts.join(' • ');
  }

  bool get hasArabicMatn => (arabicMatn ?? '').trim().isNotEmpty;
  bool get hasTransliteration => (transliteratedText ?? '').trim().isNotEmpty;
  bool get hasVerifiedTranslation =>
      translationSourceVerified && translation.trim().isNotEmpty;
  bool get hasVerifiedArabicMatn => arabicMatnSourceVerified && hasArabicMatn;
  bool get hasVerifiedTransliteration =>
      transliterationSourceVerified && hasTransliteration;
  bool get isSourceBacked => sourceUrl != null && sourceUrl!.trim().isNotEmpty;
  bool get isLaunchReady =>
      hasVerifiedTranslation &&
      hasVerifiedArabicMatn &&
      displaySourceReference != null &&
      displaySourceReference!.trim().isNotEmpty;
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
