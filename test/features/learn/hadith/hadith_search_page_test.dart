import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:path_of_nur/app/routes/learn/learn_content_domain_routes.dart';
import 'package:path_of_nur/features/editorial_dashboard/application/editorial_content_versions_provider.dart';
import 'package:path_of_nur/features/learn/hadith/domain/hadith_foundation_models.dart';
import 'package:path_of_nur/features/learn/hadith/data/seeded_hadith_foundation_data.dart';
import 'package:path_of_nur/l10n/app_localizations.dart';
import 'package:path_of_nur/shared/persistence/local_store.dart';

void main() {
  testWidgets(
    'search page shows verified results and opens the canonical hadith reader',
    (tester) async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final router = GoRouter(
        initialLocation: '/learn/hadith/search?q=intentions',
        routes: buildLearnContentDomainRoutes(),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(prefs),
            editorialHadithEntriesProvider.overrideWith(
              (ref) => seededHadithEntries,
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

      expect(find.text('Search Hadith'), findsOneWidget);
      expect(find.text('Actions Are by Intentions'), findsWidgets);

      await tester.tap(find.text('Actions Are by Intentions').first);
      await tester.pumpAndSettle();

      expect(find.text('Source'), findsOneWidget);
      expect(find.text('Sahih al-Bukhari'), findsOneWidget);
      expect(find.text('Grade'), findsOneWidget);
    },
  );

  testWidgets(
    'search page shows recents and suggestions, and suggestion taps trigger canonical search',
    (tester) async {
      SharedPreferences.setMockInitialValues({
        'learn.hadith.recentSearches.v1':
            '[{"query":"mercy","filter":"all","updatedAtIso":"2026-04-11T00:00:00.000Z"}]',
      });
      final prefs = await SharedPreferences.getInstance();
      final router = GoRouter(
        initialLocation: '/learn/hadith/search',
        routes: buildLearnContentDomainRoutes(),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(prefs),
            editorialHadithEntriesProvider.overrideWith(
              (ref) => seededHadithEntries,
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

      expect(find.text('Recent searches'), findsOneWidget);
      expect(find.text('Suggestions'), findsOneWidget);
      expect(find.text('mercy'), findsWidgets);

      await tester.tap(find.text('intentions').first);
      await tester.pumpAndSettle();

      expect(find.text('Text matches'), findsOneWidget);
      expect(find.text('Actions Are by Intentions'), findsWidgets);
    },
  );

  testWidgets(
    'search page empty and no-result states show guided polish copy',
    (tester) async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final router = GoRouter(
        initialLocation: '/learn/hadith/search?q=zzzznotfound',
        routes: buildLearnContentDomainRoutes(),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(prefs),
            editorialHadithEntriesProvider.overrideWith(
              (ref) => seededHadithEntries,
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

      expect(find.text('No hadith found'), findsOneWidget);
      expect(find.text('Try a broader phrase.'), findsOneWidget);
      expect(
        find.text('Try a source book like Riyad as-Salihin.'),
        findsOneWidget,
      );
      expect(find.text('Try a category such as Character.'), findsOneWidget);
    },
  );

  testWidgets('recent search chips rerun the canonical hadith search path', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({
      'learn.hadith.recentSearches.v1':
          '[{"query":"mercy","filter":"all","updatedAtIso":"2026-04-11T00:00:00.000Z"}]',
    });
    final prefs = await SharedPreferences.getInstance();
    final router = GoRouter(
      initialLocation: '/learn/hadith/search',
      routes: buildLearnContentDomainRoutes(),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          editorialHadithEntriesProvider.overrideWith(
            (ref) => seededHadithEntries,
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

    await tester.tap(find.text('mercy').first);
    await tester.pumpAndSettle();

    expect(find.text('Text matches'), findsOneWidget);
    expect(find.text('Source'), findsWidgets);
  });

  testWidgets(
    'search page surfaces chapter metadata matches through the canonical source filter',
    (tester) async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final router = GoRouter(
        initialLocation:
            '/learn/hadith/search?q=Foundations%20of%20Intention&filter=source',
        routes: buildLearnContentDomainRoutes(),
      );
      final chapterIndexedEntry = seededHadithEntries
          .firstWhere((entry) => entry.id == 'intentions_core')
          .copyWith(
            sourceChapterId: 'foundations_of_intention',
            sourceChapterTitle: 'Foundations of Intention',
            sourceChapterNumber: 7,
          );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(prefs),
            editorialHadithEntriesProvider.overrideWith(
              (ref) => <HadithEntry>[chapterIndexedEntry],
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

      expect(find.text('Chapter match'), findsOneWidget);
      expect(find.text('Actions Are by Intentions'), findsWidgets);
    },
  );
}
