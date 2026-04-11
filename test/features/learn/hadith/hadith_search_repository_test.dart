import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:path_of_nur/features/editorial_dashboard/application/editorial_content_versions_provider.dart';
import 'package:path_of_nur/features/learn/hadith/application/hadith_search_repository.dart';
import 'package:path_of_nur/features/learn/hadith/application/hadith_search_support.dart';
import 'package:path_of_nur/features/learn/hadith/data/generated_hadith_foundation_data.dart';
import 'package:path_of_nur/features/learn/hadith/data/seeded_hadith_foundation_data.dart';
import 'package:path_of_nur/features/learn/hadith/domain/hadith_foundation_models.dart';
import 'package:path_of_nur/shared/persistence/local_store.dart';

void main() {
  group('Hadith search foundation', () {
    test(
      'text and source searches resolve through the public verified subset',
      () {
        final safeEntry = seededHadithEntries.firstWhere(
          (entry) => entry.id == 'intentions_core',
        );
        final unsafeEntry = HadithEntry(
          id: 'unsafe_hidden_entry',
          themeId: safeEntry.themeId,
          collectionIds: safeEntry.collectionIds,
          title: 'Hidden trust record',
          excerpt: safeEntry.excerpt,
          hadithText: safeEntry.hadithText,
          englishText: 'This hidden trust record should never surface.',
          arabicText: safeEntry.arabicText,
          transliteration: safeEntry.transliteration,
          sourceUrl: safeEntry.sourceUrl,
          translationSourceVerified: false,
          arabicMatnSourceVerified: false,
          transliterationSourceVerified:
              safeEntry.transliterationSourceVerified,
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
            editorialHadithEntriesProvider.overrideWith(
              (ref) => <HadithEntry>[safeEntry, unsafeEntry],
            ),
          ],
        );
        addTearDown(container.dispose);

        final textResults = container.read(
          hadithSearchResultsForRequestProvider(
            const HadithSearchRequest(query: 'intentions'),
          ),
        );
        final sourceResults = container.read(
          hadithSearchResultsForRequestProvider(
            const HadithSearchRequest(
              query: 'bukhari',
              filter: HadithSearchFilter.source,
            ),
          ),
        );

        expect(
          textResults.map((result) => result.entry.id),
          contains('intentions_core'),
        );
        expect(
          textResults.map((result) => result.entry.id),
          isNot(contains('unsafe_hidden_entry')),
        );
        expect(
          sourceResults.every(
            (result) =>
                result.entry.displaySourceCollectionTitle == 'Sahih al-Bukhari',
          ),
          isTrue,
        );
      },
    );

    test('category, subcategory, and grade filters use canonical metadata', () {
      final container = ProviderContainer(
        overrides: [
          editorialHadithEntriesProvider.overrideWith(
            (ref) => seededHadithEntries,
          ),
        ],
      );
      addTearDown(container.dispose);

      final categoryResults = container.read(
        hadithSearchResultsForRequestProvider(
          const HadithSearchRequest(
            query: 'Faith',
            filter: HadithSearchFilter.category,
          ),
        ),
      );
      final subcategoryResults = container.read(
        hadithSearchResultsForRequestProvider(
          const HadithSearchRequest(
            query: 'Intention',
            filter: HadithSearchFilter.subcategory,
          ),
        ),
      );
      final gradeResults = container.read(
        hadithSearchResultsForRequestProvider(
          const HadithSearchRequest(
            query: 'Sahih',
            filter: HadithSearchFilter.grade,
          ),
        ),
      );

      expect(categoryResults, isNotEmpty);
      expect(
        categoryResults.every(
          (result) => result.entry.normalizedCategoryId == 'faith',
        ),
        isTrue,
      );
      expect(subcategoryResults, isNotEmpty);
      expect(
        subcategoryResults.every(
          (result) =>
              result.entry.normalizedSubcategoryId == 'intention_sincerity',
        ),
        isTrue,
      );
      expect(gradeResults, isNotEmpty);
      expect(
        gradeResults.every(
          (result) =>
              result.result.matchedField == HadithSearchMatchField.grade,
        ),
        isTrue,
      );
      expect(
        gradeResults.any(
          (result) =>
              result.entry.standardizedGrade.displayLabel.toLowerCase() ==
              'sahih',
        ),
        isTrue,
      );
    });

    test(
      'expanded verified corpus remains searchable by canonical source collections',
      () {
        final container = ProviderContainer(
          overrides: [
            editorialHadithEntriesProvider.overrideWith(
              (ref) => generatedHadithEntries,
            ),
          ],
        );
        addTearDown(container.dispose);

        final nawawiResults = container.read(
          hadithSearchResultsForRequestProvider(
            const HadithSearchRequest(
              query: 'nawawi',
              filter: HadithSearchFilter.source,
            ),
          ),
        );
        final riyadResults = container.read(
          hadithSearchResultsForRequestProvider(
            const HadithSearchRequest(
              query: 'riyad',
              filter: HadithSearchFilter.source,
            ),
          ),
        );

        expect(nawawiResults, isNotEmpty);
        expect(
          nawawiResults.every(
            (result) =>
                result.entry.displaySourceCollectionTitle ==
                '40 Hadith an-Nawawi',
          ),
          isTrue,
        );

        expect(riyadResults, isNotEmpty);
        expect(
          riyadResults.every(
            (result) =>
                result.entry.displaySourceCollectionTitle ==
                'Riyad as-Salihin',
          ),
          isTrue,
        );
      },
    );

    test('recent searches are deduplicated, persisted, and keep filter context', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final container = ProviderContainer(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(hadithRecentSearchesProvider.notifier);
      notifier.addSearch('intentions');
      notifier.addSearch('sincerity', filter: HadithSearchFilter.category);
      notifier.addSearch(' Intentions ', filter: HadithSearchFilter.source);

      final recents = container.read(hadithRecentSearchesProvider);
      expect(recents, hasLength(2));
      expect(recents.first.query, 'Intentions');
      expect(recents.first.filter, HadithSearchFilter.source);
      expect(
        recents.where(
          (item) => normalizeHadithSearchText(item.query) == 'intentions',
        ),
        hasLength(1),
      );

      final stored = prefs.getString('learn.hadith.recentSearches.v1');
      expect(stored, isNotNull);
      expect(stored, contains('Intentions'));
    });

    test('snippet and highlight metadata stay focused on matched search terms', () {
      const metadata = HadithSearchPresentationMetadata(
        snippetText: '',
        highlightTerms: <String>[],
      );
      expect(metadata.highlightTerms, isEmpty);

      final built = buildHadithSearchPresentationMetadata(
        field: HadithSearchMatchField.translation,
        query: 'patient',
        sourceText:
            'Whoever remains patient, Allah will make him patient and give him a great reward.',
      );

      expect(built.snippetText.toLowerCase(), contains('patient'));
      expect(
        built.highlightTerms.map((term) => term.toLowerCase()),
        contains('patient'),
      );
    });
  });
}
