import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:path_of_nur/features/journal/application/journal_provider.dart';
import 'package:path_of_nur/features/journal/presentation/journal_entry_detail_page.dart';
import 'package:path_of_nur/features/learn/content/presentation/learn_notes_browse_page.dart';
import 'package:path_of_nur/features/learn/content/presentation/learn_notes_landing_page.dart';
import 'package:path_of_nur/features/learn/presentation/data/learn_category_catalog.dart';
import 'package:path_of_nur/features/learn/quran/application/quran_providers.dart';
import 'package:path_of_nur/features/learn/quran/application/quran_reflections_provider.dart';
import 'package:path_of_nur/features/learn/quran/domain/quran_content_refs.dart';
import 'package:path_of_nur/features/learn/quran/domain/quran_reflection_entry.dart';
import 'package:path_of_nur/l10n/app_localizations.dart';
import 'package:path_of_nur/shared/application/daily_clock_provider.dart';
import 'package:path_of_nur/shared/persistence/app_database.dart';
import 'package:path_of_nur/shared/persistence/local_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<ProviderContainer> makeNotesTestContainer({
  Map<String, Object> seed = const <String, Object>{},
}) async {
  SharedPreferences.setMockInitialValues(<String, Object>{
    'app.onboardingCompleted': true,
    ...seed,
  });
  final prefs = await SharedPreferences.getInstance();
  final database = AppDatabase.inMemory();
  return ProviderContainer(
    overrides: <Override>[
      sharedPreferencesProvider.overrideWithValue(prefs),
      appDatabaseProvider.overrideWithValue(database),
      dailyNowProvider.overrideWith(
        (ref) => Stream<DateTime>.value(DateTime.parse('2026-03-23T12:00:00')),
      ),
    ],
  );
}

void main() {
  test(
    'learning hub notes category stays wired to canonical notes landing route',
    () {
      final notesItem = LearnCategoryCatalog.items.firstWhere(
        (item) => item.id == 'notes',
      );

      expect(notesItem.routeName, 'learnNotesLanding');
    },
  );

  testWidgets(
    'notes landing exposes browse all and unified category visibility',
    (tester) async {
      final container = await makeNotesTestContainer();
      addTearDown(container.dispose);

      container
          .read(quranNotesProvider.notifier)
          .addNote(surahNumber: 2, ayahNumber: 255, text: 'Ayat al-Kursi note');
      container
          .read(journalProvider.notifier)
          .addEntry(
            title: 'Evening reflection',
            body: 'A short reflection after study.',
            type: JournalEntryType.reflection,
          );
      container
          .read(quranReflectionsProvider.notifier)
          .save(
            ref: const QuranQuoteRef(surah: 2, ayah: 255),
            sourceType: QuranReflectionSourceType.dailyAyah,
            title: 'Ayat al-Kursi reflection',
            summary: 'A saved Qur’an reflection.',
          );

      final router = GoRouter(
        routes: <RouteBase>[
          GoRoute(
            path: '/',
            name: 'learnNotesLanding',
            builder: (context, state) =>
                const Material(child: LearnNotesLandingPage()),
          ),
          GoRoute(
            path: '/browse',
            name: 'learnNotesBrowseAll',
            builder: (context, state) =>
                const Material(child: LearnNotesBrowsePage()),
          ),
          GoRoute(
            path: '/quran-notes',
            name: 'quranNotes',
            builder: (context, state) =>
                const Scaffold(body: Text('Quran Notes')),
          ),
          GoRoute(
            path: '/journal',
            name: 'journalTimeline',
            builder: (context, state) =>
                const Scaffold(body: Text('Journal Timeline')),
          ),
          GoRoute(
            path: '/journal/entry/:entryId',
            name: 'journalEntryDetail',
            builder: (context, state) => JournalEntryDetailPage(
              entryId: state.pathParameters['entryId']!,
            ),
          ),
          GoRoute(
            path: '/quran-reflections',
            name: 'quranReflections',
            builder: (context, state) =>
                const Scaffold(body: Text('Quran Reflections')),
          ),
          GoRoute(
            path: '/quran-bookmarks',
            name: 'quranBookmarks',
            builder: (context, state) =>
                const Scaffold(body: Text('Quran Bookmarks')),
          ),
          GoRoute(
            path: '/quran-explorer',
            name: 'quranExplorer',
            builder: (context, state) =>
                const Scaffold(body: Text('Quran Explorer')),
          ),
        ],
      );
      addTearDown(router.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp.router(
            routerConfig: router,
            localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      await tester.pump(const Duration(milliseconds: 200));

      await tester.scrollUntilVisible(
        find.byKey(const Key('learnNotesQuranReflectionsCard')),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pump();

      expect(
        find.byKey(const Key('learnNotesQuranReflectionsCard')),
        findsOneWidget,
      );
      expect(find.text('Journal'), findsOneWidget);

      await tester.tap(find.byKey(const Key('learnNotesQuranReflectionsCard')));
      await tester.pumpAndSettle();

      expect(find.text('Quran Reflections'), findsOneWidget);

      router.go('/');
      await tester.pumpAndSettle();

      router.go('/browse');
      await tester.pumpAndSettle();

      expect(find.byType(LearnNotesBrowsePage), findsOneWidget);
      expect(find.text('Ayat al-Kursi note'), findsWidgets);
      expect(find.text('Evening reflection'), findsOneWidget);

      await tester.tap(find.text('Evening reflection'));
      await tester.pumpAndSettle();

      expect(find.byType(JournalEntryDetailPage), findsOneWidget);
      expect(find.text('Evening reflection'), findsWidgets);
    },
  );

  testWidgets('notes browse empty state feels intentional', (tester) async {
    final container = await makeNotesTestContainer();
    addTearDown(container.dispose);

    final router = GoRouter(
      routes: <RouteBase>[
        GoRoute(
          path: '/',
          name: 'learnNotesBrowseAll',
          builder: (context, state) =>
              const Material(child: LearnNotesBrowsePage()),
        ),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(
          routerConfig: router,
          localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
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

    final l10n = await AppLocalizations.delegate.load(const Locale('en'));
    expect(find.text(l10n.learnNotesBrowseEmptyTitle), findsOneWidget);
    expect(find.text(l10n.learnNotesBrowseEmpty), findsOneWidget);
  });
}
