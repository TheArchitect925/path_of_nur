import 'package:flutter_test/flutter_test.dart';

import 'package:path_of_nur/features/learn/hadith/application/hadith_reader_share_service.dart';
import 'package:path_of_nur/features/learn/hadith/data/seeded_hadith_foundation_data.dart';
import 'package:path_of_nur/features/learn/hadith/domain/hadith_foundation_models.dart';

void main() {
  group('HadithReaderShareService', () {
    test('reader share text preserves the richer metadata layout', () {
      final entry = seededHadithEntries.firstWhere(
        (item) => item.id == 'intentions_core',
      );

      final text = HadithReaderShareService.buildReaderShareText(
        entry: entry,
        sourceLabel: 'Source',
        referenceLabel: 'Reference',
        formattedReference: 'Hadith 1',
        gradeLabel: 'Grade',
        narratorLabel: 'Narrated by',
        translationLabel: 'Translation',
      );

      expect(text, contains(entry.title.trim()));
      expect(text, contains('Source: Sahih al-Bukhari'));
      expect(text, contains('Reference: Hadith 1'));
      expect(text, contains('Grade: Sahih'));
      expect(text, contains('Narrated by: Umar ibn al-Khattab'));
      expect(text, contains('Translation: ${entry.translation.trim()}'));
    });

    test(
      'compact share text prefers the excerpt and keeps metadata concise',
      () {
        final entry = seededHadithEntries.firstWhere(
          (item) => item.id == 'intentions_core',
        );

        final text = HadithReaderShareService.buildCompactShareText(
          entry: entry,
          formattedReference: 'Hadith 1',
        );

        expect(text, contains(entry.title.trim()));
        expect(text, contains(entry.excerpt.trim()));
        expect(text, contains('Sahih al-Bukhari • Hadith 1 • Sahih'));
        expect(text.contains('Translation:'), isFalse);
      },
    );

    test('compact share text falls back to a trimmed translation excerpt', () {
      final baseEntry = seededHadithEntries.first;
      final longTranslation = List.filled(
        12,
        'This share fallback keeps the compact format short while still giving enough context.',
      ).join(' ');
      final entry = HadithEntry(
        id: '${baseEntry.id}_fallback',
        themeId: baseEntry.themeId,
        collectionIds: baseEntry.collectionIds,
        title: baseEntry.title,
        excerpt: '',
        hadithText: baseEntry.hadithText,
        englishText: longTranslation,
        arabicText: baseEntry.arabicText,
        transliteration: baseEntry.transliteration,
        sourceReferenceKey: baseEntry.sourceReferenceKey,
        transliterationSource: baseEntry.transliterationSource,
        transliterationStatus: baseEntry.transliterationStatus,
        transliterationReviewStatus: baseEntry.transliterationReviewStatus,
        transliterationReviewedAt: baseEntry.transliterationReviewedAt,
        sourceUrl: baseEntry.sourceUrl,
        translationSourceVerified: baseEntry.translationSourceVerified,
        arabicMatnSourceVerified: baseEntry.arabicMatnSourceVerified,
        transliterationSourceVerified: baseEntry.transliterationSourceVerified,
        source: baseEntry.source,
        sourceCollection: baseEntry.sourceCollection,
        sourceReference: baseEntry.sourceReference,
        grading: baseEntry.grading,
        narrator: baseEntry.narrator,
        sourceCollectionIds: baseEntry.sourceCollectionIds,
        sourceCollectionId: baseEntry.sourceCollectionId,
        sourceCollectionTitle: baseEntry.sourceCollectionTitle,
        sourceChapterId: baseEntry.sourceChapterId,
        sourceChapterTitle: baseEntry.sourceChapterTitle,
        sourceChapterNumber: baseEntry.sourceChapterNumber,
        sourceHadithNumbers: baseEntry.sourceHadithNumbers,
        sourceProvenance: baseEntry.sourceProvenance,
        sourceImportSource: baseEntry.sourceImportSource,
        categoryId: baseEntry.categoryId,
        categoryTitle: baseEntry.categoryTitle,
        subcategoryId: baseEntry.subcategoryId,
        subcategoryTitle: baseEntry.subcategoryTitle,
        tags: baseEntry.tags,
        quranConnections: baseEntry.quranConnections,
        meaning: baseEntry.meaning,
        lessons: baseEntry.lessons,
        reflectionPrompts: baseEntry.reflectionPrompts,
        practiceAction: baseEntry.practiceAction,
        relatedHadithIds: baseEntry.relatedHadithIds,
        isDailyEligible: baseEntry.isDailyEligible,
        difficultyLevel: baseEntry.difficultyLevel,
        themeTag: baseEntry.themeTag,
        recommendedDay: baseEntry.recommendedDay,
        isEssential: baseEntry.isEssential,
      );

      final text = HadithReaderShareService.buildCompactShareText(
        entry: entry,
        formattedReference: 'Hadith 1',
      );

      expect(text, contains('...'));
      expect(text.length < longTranslation.length, isTrue);
    });

    test('compact share text stays within the short-share budget matrix', () {
      final excerptBacked = seededHadithEntries.firstWhere(
        (item) => item.id == 'intentions_core',
      );
      final fallbackBase = seededHadithEntries.first;
      final longTranslation = List.filled(
        12,
        'This share fallback keeps the compact format short while still giving enough context.',
      ).join(' ');
      final translationFallback = HadithEntry(
        id: '${fallbackBase.id}_budget',
        themeId: fallbackBase.themeId,
        collectionIds: fallbackBase.collectionIds,
        title: fallbackBase.title,
        excerpt: '',
        hadithText: fallbackBase.hadithText,
        englishText: longTranslation,
        arabicText: fallbackBase.arabicText,
        transliteration: fallbackBase.transliteration,
        sourceReferenceKey: fallbackBase.sourceReferenceKey,
        transliterationSource: fallbackBase.transliterationSource,
        transliterationStatus: fallbackBase.transliterationStatus,
        transliterationReviewStatus: fallbackBase.transliterationReviewStatus,
        transliterationReviewedAt: fallbackBase.transliterationReviewedAt,
        sourceUrl: fallbackBase.sourceUrl,
        translationSourceVerified: fallbackBase.translationSourceVerified,
        arabicMatnSourceVerified: fallbackBase.arabicMatnSourceVerified,
        transliterationSourceVerified:
            fallbackBase.transliterationSourceVerified,
        source: fallbackBase.source,
        sourceCollection: fallbackBase.sourceCollection,
        sourceReference: fallbackBase.sourceReference,
        grading: fallbackBase.grading,
        narrator: fallbackBase.narrator,
        sourceCollectionIds: fallbackBase.sourceCollectionIds,
        sourceCollectionId: fallbackBase.sourceCollectionId,
        sourceCollectionTitle: fallbackBase.sourceCollectionTitle,
        sourceChapterId: fallbackBase.sourceChapterId,
        sourceChapterTitle: fallbackBase.sourceChapterTitle,
        sourceChapterNumber: fallbackBase.sourceChapterNumber,
        sourceHadithNumbers: fallbackBase.sourceHadithNumbers,
        sourceProvenance: fallbackBase.sourceProvenance,
        sourceImportSource: fallbackBase.sourceImportSource,
        categoryId: fallbackBase.categoryId,
        categoryTitle: fallbackBase.categoryTitle,
        subcategoryId: fallbackBase.subcategoryId,
        subcategoryTitle: fallbackBase.subcategoryTitle,
        tags: fallbackBase.tags,
        quranConnections: fallbackBase.quranConnections,
        meaning: fallbackBase.meaning,
        lessons: fallbackBase.lessons,
        reflectionPrompts: fallbackBase.reflectionPrompts,
        practiceAction: fallbackBase.practiceAction,
        relatedHadithIds: fallbackBase.relatedHadithIds,
        isDailyEligible: fallbackBase.isDailyEligible,
        difficultyLevel: fallbackBase.difficultyLevel,
        themeTag: fallbackBase.themeTag,
        recommendedDay: fallbackBase.recommendedDay,
        isEssential: fallbackBase.isEssential,
      );

      final compactExcerptText = HadithReaderShareService.buildCompactShareText(
        entry: excerptBacked,
        formattedReference: 'Hadith 1',
      );
      final compactFallbackText =
          HadithReaderShareService.buildCompactShareText(
            entry: translationFallback,
            formattedReference: 'Hadith 1',
          );
      final readerText = HadithReaderShareService.buildReaderShareText(
        entry: excerptBacked,
        sourceLabel: 'Source',
        referenceLabel: 'Reference',
        formattedReference: 'Hadith 1',
        gradeLabel: 'Grade',
        narratorLabel: 'Narrated by',
        translationLabel: 'Translation',
      );

      expect(compactExcerptText.length, lessThanOrEqualTo(240));
      expect(compactFallbackText.length, lessThanOrEqualTo(320));
      expect(compactExcerptText.length, lessThan(readerText.length));
      expect(compactFallbackText.length, lessThan(readerText.length));
    });

    test('compact and reader share outputs keep distinct roles', () {
      final entry = seededHadithEntries.firstWhere(
        (item) => item.id == 'intentions_core',
      );

      final compactText = HadithReaderShareService.buildCompactShareText(
        entry: entry,
        formattedReference: 'Hadith 1',
      );
      final readerText = HadithReaderShareService.buildReaderShareText(
        entry: entry,
        sourceLabel: 'Source',
        referenceLabel: 'Reference',
        formattedReference: 'Hadith 1',
        gradeLabel: 'Grade',
        narratorLabel: 'Narrated by',
        translationLabel: 'Translation',
      );

      expect(compactText, contains(entry.excerpt.trim()));
      expect(compactText, isNot(contains('Translation:')));
      expect(compactText, isNot(contains('Narrated by:')));

      expect(readerText, contains('Translation: ${entry.translation.trim()}'));
      expect(readerText, contains('Narrated by: Umar ibn al-Khattab'));
      expect(readerText.split('\n\n').length, greaterThan(compactText.split('\n\n').length));
    });
  });
}
