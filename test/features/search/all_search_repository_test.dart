import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:path_of_nur/features/editorial_dashboard/application/editorial_content_versions_provider.dart';
import 'package:path_of_nur/features/learn/hadith/data/seeded_hadith_foundation_data.dart';
import 'package:path_of_nur/features/learn/hadith/domain/hadith_foundation_models.dart';
import 'package:path_of_nur/features/search/application/all_search_repository.dart';
import 'package:path_of_nur/shared/persistence/local_store.dart';

void main() {
  group('All search repository', () {
    test(
      'federated search returns grouped sections with canonical handoff',
      () async {
        SharedPreferences.setMockInitialValues({});
        final prefs = await SharedPreferences.getInstance();
        final container = ProviderContainer(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(prefs),
            editorialHadithEntriesProvider.overrideWith(
              (ref) => seededHadithEntries,
            ),
          ],
        );
        addTearDown(container.dispose);

        final grouped = await container.read(
          allSearchResultsForRequestProvider(
            const AllSearchRequest(query: 'mercy'),
          ).future,
        );

        expect(grouped.sections, hasLength(4));
        expect(grouped.sections.map((section) => section.domain), [
          AllSearchDomain.quran,
          AllSearchDomain.hadith,
          AllSearchDomain.dua,
          AllSearchDomain.learn,
        ]);
        expect(grouped.sections.map((section) => section.viewAllRouteName), [
          'quranSearch',
          'hadithSearch',
          'learnDuaHub',
          'learnExploreAllKnowledge',
        ]);
      },
    );

    test(
      'hadith results still come only from verified public entries',
      () async {
        SharedPreferences.setMockInitialValues({});
        final prefs = await SharedPreferences.getInstance();
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
            sharedPreferencesProvider.overrideWithValue(prefs),
            editorialHadithEntriesProvider.overrideWith(
              (ref) => <HadithEntry>[safeEntry, unsafeEntry],
            ),
          ],
        );
        addTearDown(container.dispose);

        final grouped = await container.read(
          allSearchResultsForRequestProvider(
            const AllSearchRequest(query: 'intentions'),
          ).future,
        );
        final hadithSection = grouped.sections.firstWhere(
          (section) => section.domain == AllSearchDomain.hadith,
        );

        expect(
          hadithSection.results.map((result) => result.id),
          contains('intentions_core'),
        );
        expect(
          hadithSection.results.map((result) => result.id),
          isNot(contains('unsafe_hidden_entry')),
        );
      },
    );
  });
}
