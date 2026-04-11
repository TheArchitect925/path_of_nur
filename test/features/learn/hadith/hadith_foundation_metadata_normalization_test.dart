import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:path_of_nur/features/editorial_dashboard/application/editorial_content_versions_provider.dart';
import 'package:path_of_nur/features/learn/hadith/application/hadith_foundation_repository.dart';
import 'package:path_of_nur/features/learn/hadith/data/seeded_hadith_foundation_data.dart';
import 'package:path_of_nur/features/learn/hadith/data/hadith_taxonomy.dart';
import 'package:path_of_nur/features/learn/hadith/domain/hadith_foundation_models.dart';

void main() {
  group('Hadith foundation metadata normalization', () {
    test(
      'single-source entries expose normalized source and narrator metadata',
      () {
        final entry = seededHadithEntries.first;

        expect(entry.primarySourceCollectionId, 'sahih_al_bukhari');
        expect(entry.primarySourceCollectionTitle, 'Sahih al-Bukhari');
        expect(entry.displaySourceCollectionTitle, 'Sahih al-Bukhari');
        expect(
          entry.normalizedSourceCollections.map((item) => item.id),
          <String>['sahih_al_bukhari'],
        );
        expect(entry.normalizedSourceHadithNumbers, <String>['1']);
        expect(entry.primaryHadithNumber, '1');
        expect(entry.normalizedNarratorName, 'Umar ibn al-Khattab');
        expect(entry.standardizedGrade.category, HadithGradeCategory.sahih);
        expect(entry.standardizedGrade.normalizedLabel, 'sahih');
        expect(
          entry.sourceMetadata.importSource,
          'seeded_hadith_foundation_data',
        );
        final taxonomy = resolveHadithTaxonomyAssignment(entry);
        expect(taxonomy, isNotNull);
        expect(taxonomy!.categoryId, hadithCategoryFaithId);
        expect(taxonomy.subcategoryId, hadithSubcategoryIntentionSincerityId);
      },
    );

    test(
      'multi-source and structured references normalize deterministically',
      () {
        final combined = seededHadithEntries.firstWhere(
          (entry) =>
              entry.sourceCollection == 'Sahih al-Bukhari / Sahih Muslim' &&
              entry.sourceReference == 'Bukhari 52 / Muslim 1599',
        );
        final bookStructured = seededHadithEntries.firstWhere(
          (entry) =>
              entry.sourceCollection == 'Muwatta Malik' &&
              entry.sourceReference == 'Book 47, Hadith 8',
        );

        expect(
          combined.normalizedSourceCollections.map((item) => item.id),
          <String>['sahih_al_bukhari', 'sahih_muslim'],
        );
        expect(combined.normalizedSourceHadithNumbers, <String>['52', '1599']);
        expect(
          combined.standardizedGrade.category,
          HadithGradeCategory.muttafaqunAlayh,
        );

        expect(bookStructured.primarySourceCollectionId, 'muwatta_malik');
        expect(bookStructured.primarySourceCollectionTitle, 'Muwatta Malik');
        expect(bookStructured.normalizedSourceChapterNumber, 47);
        expect(bookStructured.normalizedSourceChapterTitle, 'Book 47');
        expect(bookStructured.primaryHadithNumber, '8');
        expect(
          bookStructured.standardizedGrade.category,
          HadithGradeCategory.balagh,
        );
      },
    );

    test(
      'canonical repository returns normalized entries without widening public surfacing',
      () {
        final safeEntry = seededHadithEntries.first;
        final unsafeEntry = HadithEntry(
          id: 'missing_grade',
          themeId: safeEntry.themeId,
          collectionIds: safeEntry.collectionIds,
          title: safeEntry.title,
          excerpt: safeEntry.excerpt,
          hadithText: safeEntry.hadithText,
          englishText: safeEntry.englishText,
          arabicText: safeEntry.arabicText,
          transliteration: safeEntry.transliteration,
          sourceUrl: safeEntry.sourceUrl,
          translationSourceVerified: true,
          arabicMatnSourceVerified: true,
          transliterationSourceVerified:
              safeEntry.transliterationSourceVerified,
          source: safeEntry.source,
          sourceCollection: 'Sahih al-Bukhari / Sahih Muslim',
          sourceReference: 'Bukhari 52 / Muslim 1599',
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
            editorialHadithEntriesProvider.overrideWith(
              (ref) => <HadithEntry>[safeEntry, unsafeEntry],
            ),
          ],
        );
        addTearDown(container.dispose);

        final allEntries = container.read(hadithAllEntriesProvider);
        final publicEntries = container.read(hadithPublicEntriesProvider);
        final normalizedSafe = allEntries.firstWhere(
          (entry) => entry.id == safeEntry.id,
        );
        final normalizedUnsafe = allEntries.firstWhere(
          (entry) => entry.id == unsafeEntry.id,
        );

        expect(normalizedSafe.sourceCollectionIds, isNotEmpty);
        expect(normalizedSafe.sourceCollectionId, 'sahih_al_bukhari');
        expect(normalizedSafe.sourceCollectionTitle, 'Sahih al-Bukhari');
        expect(normalizedSafe.sourceHadithNumbers, isNotEmpty);
        expect(normalizedSafe.hasGradingMetadata, isTrue);
        expect(normalizedSafe.normalizedCategoryId, isNotNull);
        expect(normalizedSafe.normalizedSubcategoryId, isNotNull);
        expect(normalizedSafe.hasCanonicalCategoryMetadata, isTrue);
        expect(normalizedSafe.hasCanonicalSubcategoryMetadata, isTrue);
        expect(normalizedSafe.primarySourceCollectionTitle, 'Sahih al-Bukhari');
        expect(normalizedSafe.displaySourceReference, isNotEmpty);
        expect(normalizedSafe.standardizedGrade.displayLabel, isNotEmpty);

        expect(normalizedUnsafe.sourceCollectionIds, <String>[
          'sahih_al_bukhari',
          'sahih_muslim',
        ]);
        expect(normalizedUnsafe.sourceCollectionId, 'sahih_al_bukhari');
        expect(normalizedUnsafe.sourceCollectionTitle, 'Sahih al-Bukhari');
        expect(normalizedUnsafe.sourceHadithNumbers, <String>['52', '1599']);
        expect(normalizedUnsafe.hasGradingMetadata, isFalse);
        expect(normalizedUnsafe.normalizedCategoryId, hadithCategoryFaithId);
        expect(
          normalizedUnsafe.normalizedSubcategoryId,
          hadithSubcategoryIntentionSincerityId,
        );
        expect(publicEntries.map((entry) => entry.id), <String>[safeEntry.id]);
      },
    );

    test(
      'public entries expose deterministic category and subcategory providers',
      () {
        final container = ProviderContainer(
          overrides: [
            editorialHadithEntriesProvider.overrideWith(
              (ref) => seededHadithEntries,
            ),
          ],
        );
        addTearDown(container.dispose);

        final publicEntries = container.read(hadithEntriesProvider);
        final categories = container.read(hadithCategoriesProvider);
        final subcategories = container.read(hadithSubcategoriesProvider);

        expect(publicEntries, isNotEmpty);
        expect(
          publicEntries.every((entry) => entry.hasCanonicalCategoryMetadata),
          isTrue,
        );
        expect(
          publicEntries.every((entry) => entry.hasCanonicalSubcategoryMetadata),
          isTrue,
        );
        expect(
          publicEntries.every(
            (entry) => entry.primarySourceCollectionId != null,
          ),
          isTrue,
        );
        expect(
          publicEntries.every(
            (entry) =>
                entry.sourceCollectionTitle != null &&
                entry.sourceCollectionTitle!.trim().isNotEmpty,
          ),
          isTrue,
        );
        expect(categories.map((category) => category.id), contains('faith'));
        expect(
          subcategories.map((subcategory) => subcategory.id),
          contains(hadithSubcategoryPrayerPresenceId),
        );

        final faithEntries = container.read(
          hadithEntriesForCategoryProvider(hadithCategoryFaithId),
        );
        final prayerEntries = container.read(
          hadithEntriesForSubcategoryProvider(
            hadithSubcategoryPrayerPresenceId,
          ),
        );

        expect(faithEntries, isNotEmpty);
        expect(
          faithEntries.every(
            (entry) => entry.normalizedCategoryId == hadithCategoryFaithId,
          ),
          isTrue,
        );
        expect(prayerEntries, isNotEmpty);
        expect(
          prayerEntries.every(
            (entry) =>
                entry.normalizedSubcategoryId ==
                hadithSubcategoryPrayerPresenceId,
          ),
          isTrue,
        );
      },
    );
  });
}
