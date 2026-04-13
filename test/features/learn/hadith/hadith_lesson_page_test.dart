import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:path_of_nur/features/editorial_dashboard/application/editorial_content_versions_provider.dart';
import 'package:path_of_nur/features/learn/hadith/application/hadith_reader_share_service.dart';
import 'package:path_of_nur/features/learn/hadith/data/seeded_hadith_foundation_data.dart';
import 'package:path_of_nur/features/learn/hadith/domain/hadith_foundation_models.dart';
import 'package:path_of_nur/features/learn/hadith/presentation/hadith_lesson_page.dart';
import 'package:path_of_nur/l10n/app_localizations.dart';
import 'package:path_of_nur/shared/persistence/local_store.dart';

void main() {
  group('HadithLessonPage', () {
    testWidgets(
      'reader shows source, reference, grade, narrator, and related sections',
      (tester) async {
        SharedPreferences.setMockInitialValues({});
        final prefs = await SharedPreferences.getInstance();

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              sharedPreferencesProvider.overrideWithValue(prefs),
              editorialHadithEntriesProvider.overrideWith(
                (ref) => seededHadithEntries,
              ),
            ],
            child: MaterialApp(
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: AppLocalizations.supportedLocales,
              home: const HadithLessonPage(lessonId: 'intentions_core'),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Source'), findsOneWidget);
        expect(find.text('Sahih al-Bukhari'), findsOneWidget);
        expect(find.text('Reference'), findsWidgets);
        expect(find.text('Hadith 1'), findsOneWidget);
        expect(find.text('Grade'), findsOneWidget);
        expect(find.text('Sahih'), findsWidgets);
        expect(find.text('Narrated by'), findsOneWidget);
        expect(find.text('Umar ibn al-Khattab'), findsOneWidget);
        expect(find.text('Source provenance'), findsOneWidget);
        expect(find.text('Curated foundation record'), findsOneWidget);
        await tester.scrollUntilVisible(find.textContaining('connection'), 300);
        await tester.pumpAndSettle();
        expect(find.textContaining('connection'), findsOneWidget);
        await tester.scrollUntilVisible(
          find.text('Religion Is Sincere Counsel'),
          300,
        );
        await tester.pumpAndSettle();
        expect(find.text('Religion Is Sincere Counsel'), findsOneWidget);
      },
    );

    testWidgets('save action toggles from the reader page', (tester) async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(prefs),
            editorialHadithEntriesProvider.overrideWith(
              (ref) => seededHadithEntries,
            ),
          ],
          child: MaterialApp(
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            home: const HadithLessonPage(lessonId: 'intentions_core'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.scrollUntilVisible(find.text('Save'), 300);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 3));

      expect(
        prefs.getString('learn.hadith.saved.v2'),
        contains('intentions_core'),
      );
    });

    testWidgets('subcategory chip opens the canonical subcategory route', (
      tester,
    ) async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final router = _buildTestRouter(
        initialLocation: '/hadith/intentions_core',
        prefs: prefs,
      );

      await tester.pumpWidget(_buildRouterApp(router));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Intention & Sincerity'));
      await tester.pumpAndSettle();

      expect(find.text('subcategory:intention_sincerity'), findsOneWidget);
    });

    testWidgets('source chapter row opens the canonical chapter route', (
      tester,
    ) async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final router = _buildTestRouter(
        initialLocation: '/hadith/sent_to_perfect_character',
        prefs: prefs,
      );

      await tester.pumpWidget(_buildRouterApp(router));
      await tester.pumpAndSettle();

      await tester.scrollUntilVisible(find.text('Chapter 47 • Book 47'), 300);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Chapter 47 • Book 47'));
      await tester.pumpAndSettle();

      expect(find.text('chapter:muwatta_malik:book_47'), findsOneWidget);
    });

    testWidgets('provenance row opens the trusted-source explainer sheet', (
      tester,
    ) async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(prefs),
            editorialHadithEntriesProvider.overrideWith(
              (ref) => seededHadithEntries,
            ),
          ],
          child: MaterialApp(
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            home: const HadithLessonPage(lessonId: 'intentions_core'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.scrollUntilVisible(
        find.text('Curated foundation record'),
        300,
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Curated foundation record'));
      await tester.pumpAndSettle();

      expect(find.text('Why this source is trusted'), findsOneWidget);
      expect(find.textContaining('reviewable trusted-source context'), findsOneWidget);
    });

    testWidgets('chapter row shows chapter position context when available', (
      tester,
    ) async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final baseEntry = seededHadithEntries.firstWhere(
        (item) => item.id == 'sent_to_perfect_character',
      );
      final chapterCompanion = HadithEntry(
        id: 'sent_to_perfect_character_followup',
        themeId: baseEntry.themeId,
        collectionIds: baseEntry.collectionIds,
        title: 'Character Continues',
        excerpt: baseEntry.excerpt,
        hadithText: baseEntry.hadithText,
        englishText: baseEntry.englishText,
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
        source: 'Muwatta Malik Book 47, Hadith 9',
        sourceCollection: baseEntry.sourceCollection,
        sourceReference: 'Book 47, Hadith 9',
        grading: baseEntry.grading,
        narrator: baseEntry.narrator,
        sourceCollectionIds: baseEntry.sourceCollectionIds,
        sourceCollectionId: baseEntry.sourceCollectionId,
        sourceCollectionTitle: baseEntry.sourceCollectionTitle,
        sourceChapterId: baseEntry.sourceChapterId,
        sourceChapterTitle: baseEntry.sourceChapterTitle,
        sourceChapterNumber: baseEntry.sourceChapterNumber,
        sourceHadithNumbers: const ['9'],
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

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(prefs),
            editorialHadithEntriesProvider.overrideWith(
              (ref) => <HadithEntry>[
                ...seededHadithEntries.where(
                  (item) => item.id != chapterCompanion.id,
                ),
                chapterCompanion,
              ],
            ),
          ],
          child: MaterialApp(
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            home: const HadithLessonPage(
              lessonId: 'sent_to_perfect_character',
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.scrollUntilVisible(find.text('Chapter 47 • Book 47'), 300);
      await tester.pumpAndSettle();

      expect(find.text('Hadith 1 of 2 in this chapter'), findsOneWidget);
    });

    testWidgets('reader surfaces canonical related duas with relation labels', (
      tester,
    ) async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(prefs),
            editorialHadithEntriesProvider.overrideWith(
              (ref) => seededHadithEntries,
            ),
          ],
          child: MaterialApp(
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            home: const HadithLessonPage(lessonId: 'repentance_joy'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.scrollUntilVisible(find.text('Related Duas'), 300);
      await tester.pumpAndSettle();

      expect(find.text('Related Duas'), findsOneWidget);
      expect(find.text('Supplication of repentance'), findsOneWidget);
      expect(find.text('Related dua'), findsOneWidget);
    });

    test(
      'share text keeps source, reference, grade, and narrator separate',
      () {
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

        expect(text, contains('Source: Sahih al-Bukhari'));
        expect(text, contains('Reference: Hadith 1'));
        expect(text, contains('Grade: Sahih'));
        expect(text, contains('Narrated by: Umar ibn al-Khattab'));
        expect(text, contains(entry.translation.trim()));
      },
    );
  });
}

Widget _buildRouterApp(GoRouter router) {
  return MaterialApp.router(
    routerConfig: router,
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: AppLocalizations.supportedLocales,
  );
}

GoRouter _buildTestRouter({
  required String initialLocation,
  required SharedPreferences prefs,
}) {
  return GoRouter(
    initialLocation: initialLocation,
    routes: [
      GoRoute(
        path: '/hadith/:lessonId',
        builder: (context, state) => ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(prefs),
            editorialHadithEntriesProvider.overrideWith(
              (ref) => seededHadithEntries,
            ),
          ],
          child: HadithLessonPage(
            lessonId: state.pathParameters['lessonId']!,
          ),
        ),
      ),
      GoRoute(
        path: '/learn/hadith/subcategory/:subcategoryId',
        name: 'hadithSubcategoryDetail',
        builder: (context, state) => Scaffold(
          body: Text('subcategory:${state.pathParameters['subcategoryId']}'),
        ),
      ),
      GoRoute(
        path: '/learn/hadith/source/:sourceId',
        name: 'hadithSourceDetail',
        builder: (context, state) => Scaffold(
          body: Text('source:${state.pathParameters['sourceId']}'),
        ),
      ),
      GoRoute(
        path: '/learn/hadith/source/:sourceId/chapter/:chapterId',
        name: 'hadithSourceChapterDetail',
        builder: (context, state) => Scaffold(
          body: Text(
            'chapter:${state.pathParameters['sourceId']}:${state.pathParameters['chapterId']}',
          ),
        ),
      ),
      GoRoute(
        path: '/learn/hadith/narrator/:narratorId',
        name: 'hadithNarratorDetail',
        builder: (context, state) => Scaffold(
          body: Text('narrator:${state.pathParameters['narratorId']}'),
        ),
      ),
      GoRoute(
        path: '/learn/hadith/lesson/:lessonId',
        name: 'hadithLessonDetail',
        builder: (context, state) => ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(prefs),
            editorialHadithEntriesProvider.overrideWith(
              (ref) => seededHadithEntries,
            ),
          ],
          child: HadithLessonPage(
            lessonId: state.pathParameters['lessonId']!,
          ),
        ),
      ),
      GoRoute(
        path: '/journal/create',
        name: 'journalCreate',
        builder: (context, state) => const Scaffold(body: Text('journal')),
      ),
    ],
  );
}
