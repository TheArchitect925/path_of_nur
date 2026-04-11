import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:path_of_nur/features/learn/hadith/application/hadith_foundation_repository.dart';
import 'package:path_of_nur/features/learn/hadith/application/hadith_public_content_policy.dart';
import 'package:path_of_nur/features/learn/hadith/data/seeded_hadith_foundation_data.dart';
import 'package:path_of_nur/features/learn/hadith/domain/hadith_foundation_models.dart';

void main() {
  group('Hadith public content policy', () {
    test('canonical public provider uses centralized verified-only policy', () {
      final safeEntry = seededHadithEntries.first;
      final unsafeEntry = HadithEntry(
        id: 'unsafe_entry',
        themeId: safeEntry.themeId,
        collectionIds: safeEntry.collectionIds,
        title: 'Unsafe entry',
        excerpt: safeEntry.excerpt,
        hadithText: safeEntry.hadithText,
        englishText: safeEntry.englishText,
        arabicText: safeEntry.arabicText,
        transliteration: safeEntry.transliteration,
        sourceUrl: null,
        translationSourceVerified: false,
        arabicMatnSourceVerified: false,
        transliterationSourceVerified: false,
        source: safeEntry.source,
        sourceCollection: safeEntry.sourceCollection,
        sourceReference: '',
        grading: '',
        narrator: safeEntry.narrator,
        tags: safeEntry.tags,
        quranConnections: safeEntry.quranConnections,
        meaning: safeEntry.meaning,
        lessons: safeEntry.lessons,
        reflectionPrompts: safeEntry.reflectionPrompts,
        practiceAction: safeEntry.practiceAction,
        relatedHadithIds: safeEntry.relatedHadithIds,
      );

      final container = ProviderContainer(
        overrides: [
          hadithAllEntriesProvider.overrideWith(
            (ref) => <HadithEntry>[safeEntry, unsafeEntry],
          ),
        ],
      );
      addTearDown(container.dispose);

      final policy = container.read(hadithPublicContentPolicyProvider);
      final allEntries = container.read(hadithAllEntriesProvider);
      final publicEntries = container.read(hadithPublicEntriesProvider);

      expect(allEntries.length, 2);
      expect(policy.allowsDefaultPublicSurfacing(safeEntry), isTrue);
      expect(policy.allowsDefaultPublicSurfacing(unsafeEntry), isFalse);
      expect(publicEntries.map((entry) => entry.id), <String>[safeEntry.id]);
      expect(
        container.read(hadithEntryByIdProvider(safeEntry.id))?.id,
        safeEntry.id,
      );
      expect(container.read(hadithEntryByIdProvider(unsafeEntry.id)), isNull);
      expect(
        container.read(hadithAllEntryByIdProvider(unsafeEntry.id))?.id,
        unsafeEntry.id,
      );
    });

    test('public themes and collections only expose safe entries', () {
      final safeEntry = seededHadithEntries.first;
      final unsafeEntry = HadithEntry(
        id: 'unsafe_entry',
        themeId: safeEntry.themeId,
        collectionIds: safeEntry.collectionIds,
        title: 'Unsafe entry',
        excerpt: safeEntry.excerpt,
        hadithText: safeEntry.hadithText,
        englishText: safeEntry.englishText,
        arabicText: safeEntry.arabicText,
        transliteration: safeEntry.transliteration,
        sourceUrl: null,
        translationSourceVerified: true,
        arabicMatnSourceVerified: false,
        transliterationSourceVerified: false,
        source: safeEntry.source,
        sourceCollection: safeEntry.sourceCollection,
        sourceReference: safeEntry.sourceReference,
        grading: safeEntry.grading,
        narrator: safeEntry.narrator,
        tags: safeEntry.tags,
        quranConnections: safeEntry.quranConnections,
        meaning: safeEntry.meaning,
        lessons: safeEntry.lessons,
        reflectionPrompts: safeEntry.reflectionPrompts,
        practiceAction: safeEntry.practiceAction,
        relatedHadithIds: safeEntry.relatedHadithIds,
      );

      final container = ProviderContainer(
        overrides: [
          hadithAllEntriesProvider.overrideWith(
            (ref) => <HadithEntry>[safeEntry, unsafeEntry],
          ),
        ],
      );
      addTearDown(container.dispose);

      final themes = container.read(hadithThemesProvider);
      final collections = container.read(hadithCollectionsProvider);
      final themedEntries = container.read(
        hadithEntriesForThemeProvider(safeEntry.themeId),
      );
      final collectionEntries = container.read(
        hadithEntriesForCollectionProvider(safeEntry.collectionIds.first),
      );

      expect(themes, isNotEmpty);
      expect(collections, isNotEmpty);
      expect(themedEntries.map((entry) => entry.id), <String>[safeEntry.id]);
      expect(collectionEntries.map((entry) => entry.id), <String>[
        safeEntry.id,
      ]);
    });
  });
}
