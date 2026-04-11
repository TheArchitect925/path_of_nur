import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:path_of_nur/features/content_linking/application/editorial_relation_providers.dart';
import 'package:path_of_nur/features/content_linking/domain/editorial_relation_models.dart';
import 'package:path_of_nur/features/editorial_dashboard/application/editorial_content_versions_provider.dart';
import 'package:path_of_nur/features/learn/hadith/data/seeded_hadith_foundation_data.dart';
import 'package:path_of_nur/features/learn/hadith/domain/hadith_foundation_models.dart';
import 'package:path_of_nur/shared/persistence/local_store.dart';

void main() {
  group('editorial relation providers', () {
    test('build canonical quran, hadith, dua, and world relations', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final container = ProviderContainer(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      );
      addTearDown(container.dispose);

      final entries = await container.read(
        editorialRelationEntriesProvider.future,
      );

      expect(
        entries.any(
          (entry) =>
              entry.source ==
                  const EditorialRelationContentRef.quran('qr_2_153_153') &&
              entry.target ==
                  const EditorialRelationContentRef.hadith(
                    'whoever_remains_patient',
                  ) &&
              entry.type == EditorialRelationType.reinforces,
        ),
        isTrue,
      );
      expect(
        entries.any(
          (entry) =>
              entry.source ==
                  const EditorialRelationContentRef.hadith('repentance_joy') &&
              entry.target ==
                  const EditorialRelationContentRef.dua(
                    'quran_007_023_we_wronged_ourselves',
                  ) &&
              entry.type == EditorialRelationType.relatedDua,
        ),
        isTrue,
      );
      expect(
        entries.any(
          (entry) =>
              entry.target.domain == EditorialRelationDomain.worldCreation &&
              entry.type == EditorialRelationType.relatedCreationSign,
        ),
        isTrue,
      );
    });

    test('resolve hadith links into canonical quran and dua targets', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final container = ProviderContainer(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      );
      addTearDown(container.dispose);

      final links = await container.read(
        editorialResolvedLinksForNodeProvider(
          const EditorialRelationContentRef.hadith('whoever_remains_patient'),
        ).future,
      );

      expect(
        links.any(
          (link) =>
              link.domain == EditorialRelationDomain.dua &&
              link.targetId == 'quran_002_250_pour_patience' &&
              link.routeName == 'learnDuaDetail',
        ),
        isTrue,
      );
      expect(
        links.any(
          (link) =>
              link.domain == EditorialRelationDomain.quran &&
              link.referenceId == 'qr_2_153_153' &&
              link.routeName == 'quranReader',
        ),
        isTrue,
      );
    });

    test('resolve canonical hadith and dua links for a quran verse', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final container = ProviderContainer(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      );
      addTearDown(container.dispose);

      final patienceLinks = await container.read(
        editorialResolvedLinksForQuranVerseProvider((
          surahNumber: 2,
          ayahNumber: 153,
        )).future,
      );
      final duaLinks = await container.read(
        editorialResolvedLinksForQuranVerseProvider((
          surahNumber: 20,
          ayahNumber: 114,
        )).future,
      );

      expect(
        patienceLinks.any(
          (link) =>
              link.domain == EditorialRelationDomain.hadith &&
              link.targetId == 'whoever_remains_patient' &&
              link.routeName == 'hadithLessonDetail',
        ),
        isTrue,
      );
      expect(
        duaLinks.any(
          (link) =>
              link.domain == EditorialRelationDomain.dua &&
              link.targetId == 'quran_020_114_increase_knowledge' &&
              link.routeName == 'learnDuaDetail',
        ),
        isTrue,
      );
    });

    test('supports generic learn content targets with stable ids', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final container = ProviderContainer(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          seededEditorialRelationEntriesProvider.overrideWithValue([
            const EditorialRelationEntry(
              source: EditorialRelationContentRef.hadith('intentions_core'),
              target: EditorialRelationContentRef.learnContent(
                'daily_knowledge:home',
              ),
              type: EditorialRelationType.readerFollowUp,
              origin: EditorialRelationOrigin.seededEditorial,
            ),
          ]),
        ],
      );
      addTearDown(container.dispose);

      final links = await container.read(
        editorialResolvedLinksForNodeProvider(
          const EditorialRelationContentRef.hadith('intentions_core'),
        ).future,
      );

      expect(
        links.any(
          (link) =>
              link.domain == EditorialRelationDomain.learnContent &&
              link.targetId == 'daily_knowledge:home' &&
              link.routeName == 'learnDailyKnowledgeHub',
        ),
        isTrue,
      );
    });

    test(
      'non-public hadith entries do not resolve through relations',
      () async {
        SharedPreferences.setMockInitialValues({});
        final prefs = await SharedPreferences.getInstance();
        final hiddenHadith = seededHadithEntries.first
            .copyWith(title: 'Internal hidden hadith')
            .copyWith(
              sourceCollectionIds: const ['internal_hidden'],
              sourceCollectionId: 'internal_hidden',
              sourceCollectionTitle: 'Internal Hidden Collection',
              sourceHadithNumbers: const ['999'],
            );
        final unpublishedHadith = HadithEntry(
          id: 'internal_hidden_hadith',
          themeId: hiddenHadith.themeId,
          collectionIds: hiddenHadith.collectionIds,
          title: hiddenHadith.title,
          excerpt: hiddenHadith.excerpt,
          hadithText: hiddenHadith.hadithText,
          englishText: hiddenHadith.englishText,
          arabicText: hiddenHadith.arabicText,
          transliteration: hiddenHadith.transliteration,
          sourceUrl: hiddenHadith.sourceUrl,
          translationSourceVerified: false,
          arabicMatnSourceVerified: false,
          transliterationSourceVerified:
              hiddenHadith.transliterationSourceVerified,
          source: hiddenHadith.source,
          sourceCollection: hiddenHadith.sourceCollection,
          sourceReference: hiddenHadith.sourceReference,
          grading: '',
          narrator: hiddenHadith.narrator,
          sourceCollectionIds: hiddenHadith.sourceCollectionIds,
          sourceCollectionId: hiddenHadith.sourceCollectionId,
          sourceCollectionTitle: hiddenHadith.sourceCollectionTitle,
          sourceChapterId: hiddenHadith.sourceChapterId,
          sourceChapterTitle: hiddenHadith.sourceChapterTitle,
          sourceChapterNumber: hiddenHadith.sourceChapterNumber,
          sourceHadithNumbers: hiddenHadith.sourceHadithNumbers,
          sourceProvenance: hiddenHadith.sourceProvenance,
          sourceImportSource: hiddenHadith.sourceImportSource,
          categoryId: hiddenHadith.categoryId,
          categoryTitle: hiddenHadith.categoryTitle,
          subcategoryId: hiddenHadith.subcategoryId,
          subcategoryTitle: hiddenHadith.subcategoryTitle,
          tags: hiddenHadith.tags,
          quranConnections: hiddenHadith.quranConnections,
          meaning: hiddenHadith.meaning,
          lessons: hiddenHadith.lessons,
          reflectionPrompts: hiddenHadith.reflectionPrompts,
          practiceAction: hiddenHadith.practiceAction,
          relatedHadithIds: hiddenHadith.relatedHadithIds,
          isDailyEligible: false,
          difficultyLevel: hiddenHadith.difficultyLevel,
          themeTag: hiddenHadith.themeTag,
          recommendedDay: hiddenHadith.recommendedDay,
          isEssential: false,
        );

        final container = ProviderContainer(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(prefs),
            editorialHadithEntriesProvider.overrideWith(
              (ref) => [...seededHadithEntries, unpublishedHadith],
            ),
            seededEditorialRelationEntriesProvider.overrideWithValue([
              const EditorialRelationEntry(
                source: EditorialRelationContentRef.learnContent(
                  'daily_knowledge:home',
                ),
                target: EditorialRelationContentRef.hadith(
                  'internal_hidden_hadith',
                ),
                type: EditorialRelationType.readerFollowUp,
                origin: EditorialRelationOrigin.seededEditorial,
              ),
            ]),
          ],
        );
        addTearDown(container.dispose);

        final links = await container.read(
          editorialResolvedLinksForNodeProvider(
            const EditorialRelationContentRef.learnContent(
              'daily_knowledge:home',
            ),
          ).future,
        );

        expect(
          links.where((link) => link.domain == EditorialRelationDomain.hadith),
          isEmpty,
        );
      },
    );
  });
}
