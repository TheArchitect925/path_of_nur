import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:path_of_nur/features/search/application/all_search_repository.dart';
import 'package:path_of_nur/features/search/presentation/all_search_page.dart';
import 'package:path_of_nur/l10n/app_localizations.dart';
import 'package:path_of_nur/shared/persistence/local_store.dart';

void main() {
  testWidgets(
    'all search shows empty-state suggestions and safe navigation to hadith detail',
    (tester) async {
      SharedPreferences.setMockInitialValues({
        'search.all.recentQueries.v1':
            '[{"query":"mercy","updatedAtIso":"2026-04-11T00:00:00.000Z"}]',
      });
      final prefs = await SharedPreferences.getInstance();
      final router = _buildRouter();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(prefs),
            allSearchResultsProvider.overrideWith(
              (ref) async => const AllSearchGroupedResults(
                query: 'intentions',
                sections: [
                  AllSearchSection(
                    domain: AllSearchDomain.quran,
                    results: [],
                    viewAllRouteName: 'quranSearch',
                  ),
                  AllSearchSection(
                    domain: AllSearchDomain.hadith,
                    results: [
                      AllSearchResult(
                        domain: AllSearchDomain.hadith,
                        id: 'intentions_core',
                        title: 'Actions Are by Intentions',
                        subtitle: 'Sahih al-Bukhari',
                        snippet: 'Actions are by intentions.',
                        highlightTerms: ['intentions'],
                        routeName: 'hadithLessonDetail',
                        pathParameters: {'lessonId': 'intentions_core'},
                      ),
                    ],
                    viewAllRouteName: 'hadithSearch',
                  ),
                  AllSearchSection(
                    domain: AllSearchDomain.dua,
                    results: [],
                    viewAllRouteName: 'learnDuaHub',
                  ),
                  AllSearchSection(
                    domain: AllSearchDomain.learn,
                    results: [],
                    viewAllRouteName: 'learnExploreAllKnowledge',
                  ),
                ],
              ),
            ),
          ],
          child: _buildTestApp(router),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('All Search'), findsOneWidget);
      expect(find.text('Suggestions'), findsOneWidget);
      expect(find.text('Recent searches'), findsOneWidget);
      expect(find.text('mercy'), findsWidgets);

      await tester.tap(find.text('intentions').first);
      await tester.pumpAndSettle();

      expect(find.text('Hadith'), findsOneWidget);
      expect(find.text('Actions Are by Intentions'), findsOneWidget);

      await tester.tap(find.text('Actions Are by Intentions'));
      await tester.pumpAndSettle();

      expect(find.text('Hadith detail intentions_core'), findsOneWidget);
    },
  );

  testWidgets('all search no-results state gives guided suggestions', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final router = _buildRouter(initialLocation: '/search?q=noresults');

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          allSearchResultsProvider.overrideWith(
            (ref) async => const AllSearchGroupedResults(
              query: 'noresults',
              sections: [
                AllSearchSection(
                  domain: AllSearchDomain.quran,
                  results: [],
                  viewAllRouteName: 'quranSearch',
                ),
                AllSearchSection(
                  domain: AllSearchDomain.hadith,
                  results: [],
                  viewAllRouteName: 'hadithSearch',
                ),
                AllSearchSection(
                  domain: AllSearchDomain.dua,
                  results: [],
                  viewAllRouteName: 'learnDuaHub',
                ),
                AllSearchSection(
                  domain: AllSearchDomain.learn,
                  results: [],
                  viewAllRouteName: 'learnExploreAllKnowledge',
                ),
              ],
            ),
          ),
        ],
        child: _buildTestApp(router),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('No results yet'), findsOneWidget);
    expect(find.text('Try a shorter or broader phrase.'), findsOneWidget);
    expect(
      find.text('You can also jump into a domain search for more depth.'),
      findsOneWidget,
    );
  });
}

GoRouter _buildRouter({String initialLocation = '/search'}) {
  return GoRouter(
    initialLocation: initialLocation,
    routes: [
      GoRoute(
        path: '/search',
        name: 'allSearch',
        pageBuilder: (context, state) => MaterialPage(
          child: AllSearchPage(
            initialQuery: state.uri.queryParameters['q'] ?? '',
          ),
        ),
      ),
      GoRoute(
        path: '/learn/hadith/lesson/:lessonId',
        name: 'hadithLessonDetail',
        pageBuilder: (context, state) => MaterialPage(
          child: Scaffold(
            body: Text(
              'Hadith detail ${state.pathParameters['lessonId'] ?? ''}',
            ),
          ),
        ),
      ),
      GoRoute(
        path: '/quran/search',
        name: 'quranSearch',
        pageBuilder: (context, state) =>
            const MaterialPage(child: Scaffold(body: Text('Quran search'))),
      ),
      GoRoute(
        path: '/learn/hadith/search',
        name: 'hadithSearch',
        pageBuilder: (context, state) =>
            const MaterialPage(child: Scaffold(body: Text('Hadith search'))),
      ),
      GoRoute(
        path: '/learn/duas',
        name: 'learnDuaHub',
        pageBuilder: (context, state) =>
            const MaterialPage(child: Scaffold(body: Text('Dua hub'))),
      ),
      GoRoute(
        path: '/learn/explore',
        name: 'learnExploreAllKnowledge',
        pageBuilder: (context, state) =>
            const MaterialPage(child: Scaffold(body: Text('Learn explore'))),
      ),
    ],
  );
}

Widget _buildTestApp(GoRouter router) {
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
