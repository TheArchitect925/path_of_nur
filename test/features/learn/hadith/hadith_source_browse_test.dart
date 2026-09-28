import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:path_of_nur/app/routes/learn/learn_content_domain_routes.dart';
import 'package:path_of_nur/features/editorial_dashboard/application/editorial_content_versions_provider.dart';
import 'package:path_of_nur/features/learn/hadith/application/hadith_foundation_repository.dart';
import 'package:path_of_nur/features/learn/hadith/data/generated_hadith_foundation_data.dart';
import 'package:path_of_nur/features/learn/hadith/domain/hadith_foundation_models.dart';
import 'package:path_of_nur/l10n/app_localizations.dart';
import 'package:path_of_nur/shared/persistence/local_store.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Hadith source browse', () {
    test(
      'source collections and chapter groupings use verified public entries',
      () {
        final hidden = HadithEntry(
          id: 'hidden_source_entry',
          themeId: generatedHadithEntries.first.themeId,
          collectionIds: generatedHadithEntries.first.collectionIds,
          title: 'Hidden source entry',
          excerpt: generatedHadithEntries.first.excerpt,
          hadithText: generatedHadithEntries.first.hadithText,
          englishText: 'This should not appear in source browse.',
          arabicText: generatedHadithEntries.first.arabicText,
          transliteration: generatedHadithEntries.first.transliteration,
          sourceUrl: generatedHadithEntries.first.sourceUrl,
          translationSourceVerified: false,
          arabicMatnSourceVerified: false,
          transliterationSourceVerified:
              generatedHadithEntries.first.transliterationSourceVerified,
          source: generatedHadithEntries.first.source,
          sourceCollection: 'Hidden Collection',
          sourceReference: '999',
          grading: 'Sahih',
          narrator: generatedHadithEntries.first.narrator,
          sourceCollectionIds: const <String>['hidden_collection'],
          sourceCollectionId: 'hidden_collection',
          sourceCollectionTitle: 'Hidden Collection',
          tags: generatedHadithEntries.first.tags,
          quranConnections: generatedHadithEntries.first.quranConnections,
          meaning: generatedHadithEntries.first.meaning,
          lessons: generatedHadithEntries.first.lessons,
          reflectionPrompts: generatedHadithEntries.first.reflectionPrompts,
          practiceAction: generatedHadithEntries.first.practiceAction,
          relatedHadithIds: generatedHadithEntries.first.relatedHadithIds,
        );

        final container = ProviderContainer(
          overrides: [
            editorialHadithEntriesProvider.overrideWith(
              (ref) => <HadithEntry>[...generatedHadithEntries, hidden],
            ),
          ],
        );
        addTearDown(container.dispose);

        final collections = container.read(
          hadithSourceBrowseCollectionsProvider,
        );
        final riyad = collections.firstWhere(
          (collection) => collection.id == 'riyad_as_salihin',
        );
        final bukhari = collections.firstWhere(
          (collection) => collection.id == 'sahih_al_bukhari',
        );
        final riyadChapters = container.read(
          hadithSourceBrowseChaptersProvider('riyad_as_salihin'),
        );
        final bukhariChapters = container.read(
          hadithSourceBrowseChaptersProvider('sahih_al_bukhari'),
        );
        final riyadEntries = container.read(
          hadithEntriesForSourceCollectionProvider('riyad_as_salihin'),
        );
        final riyadChapterEntryTotal = riyadChapters.fold<int>(
          0,
          (sum, chapter) => sum + chapter.entryCount,
        );

        expect(
          collections.any((collection) => collection.id == 'hidden_collection'),
          isFalse,
        );
        expect(riyad.entryCount, greaterThan(800));
        expect(riyad.chapterCount, greaterThan(0));
        expect(riyadChapters, isNotEmpty);
        expect(
          riyadChapters.any(
            (chapter) => chapter.title == 'The Book of Virtues',
          ),
          isTrue,
        );
        expect(
          riyadChapters.map((chapter) => chapter.id).toSet().length,
          riyadChapters.length,
        );
        expect(riyadChapterEntryTotal, riyadEntries.length);
        expect(bukhari.chapterCount, 1);
        expect(bukhariChapters, hasLength(1));
        expect(bukhariChapters.first.isFallback, isTrue);
      },
    );

    testWidgets(
      'source and chapter browse routes open the canonical hadith reader',
      (tester) async {
        SharedPreferences.setMockInitialValues({});
        final prefs = await SharedPreferences.getInstance();
        final router = GoRouter(
          initialLocation: '/learn/hadith/source/sahih_al_bukhari',
          routes: buildLearnContentDomainRoutes(),
        );

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              sharedPreferencesProvider.overrideWithValue(prefs),
              editorialHadithEntriesProvider.overrideWith(
                (ref) => generatedHadithEntries,
              ),
            ],
            child: MaterialApp.router(
              routerConfig: router,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: AppLocalizations.supportedLocales,
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Sahih al-Bukhari'), findsWidgets);
        expect(find.text('General chapter'), findsOneWidget);

        await tester.tap(find.text('General chapter'));
        await tester.pumpAndSettle();

        expect(find.text('General chapter'), findsWidgets);

        // Tapping an entry expands its full text inline; the explicit open
        // action pushes the canonical hadith reader.
        await tester.tap(find.text('Actions Are by Intentions').first);
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.open_in_new_rounded).first);
        await tester.pumpAndSettle();

        expect(find.text('Source'), findsOneWidget);
        expect(find.text('Sahih al-Bukhari'), findsOneWidget);
      },
    );
  });
}
