import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:path_of_nur/features/journal/application/journal_provider.dart';
import 'package:path_of_nur/features/journal/presentation/journal_entry_detail_page.dart';
import 'package:path_of_nur/features/journal/presentation/journal_timeline_page.dart';
import 'package:path_of_nur/l10n/app_localizations.dart';
import 'package:path_of_nur/shared/persistence/app_database.dart';
import 'package:path_of_nur/shared/persistence/local_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<ProviderContainer> makeJournalTestContainer({
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
    ],
  );
}

void main() {
  testWidgets('journal empty state guides the first entry clearly', (
    tester,
  ) async {
    final container = await makeJournalTestContainer();
    addTearDown(container.dispose);

    final router = GoRouter(
      routes: <RouteBase>[
        GoRoute(
          path: '/',
          name: 'journalTimeline',
          builder: (context, state) =>
              const Material(child: JournalTimelinePage()),
        ),
        GoRoute(
          path: '/journal/create',
          name: 'journalCreate',
          builder: (context, state) =>
              const Scaffold(body: Text('Create Journal')),
        ),
        GoRoute(
          path: '/learn/notes',
          name: 'learnNotesLanding',
          builder: (context, state) =>
              const Scaffold(body: Text('Learn Notes')),
        ),
        GoRoute(
          path: '/quran/reflections',
          name: 'quranReflections',
          builder: (context, state) =>
              const Scaffold(body: Text('Quran Reflections')),
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
    expect(find.text(l10n.journalEmptyStateTitle), findsOneWidget);
    expect(find.text(l10n.journalEmptyStateSubtitle), findsOneWidget);
    expect(find.text(l10n.journalCreateAction), findsWidgets);
  });

  testWidgets('journal timeline opens entry detail and saves edits', (
    tester,
  ) async {
    final container = await makeJournalTestContainer();
    addTearDown(container.dispose);

    container
        .read(journalProvider.notifier)
        .addEntry(
          title: 'Moonlit memory',
          body: 'I wrote down a longer journal memory after evening study.',
          type: JournalEntryType.memory,
          linkedTopic: 'Night prayer',
          linkedQuranRef: '20:114',
          tags: const ['moon', 'study'],
        );
    final entryId = container.read(journalProvider).entries.first.id;

    final router = GoRouter(
      routes: <RouteBase>[
        GoRoute(
          path: '/',
          name: 'journalTimeline',
          builder: (context, state) =>
              const Material(child: JournalTimelinePage()),
        ),
        GoRoute(
          path: '/journal/entry/:entryId',
          name: 'journalEntryDetail',
          builder: (context, state) =>
              JournalEntryDetailPage(entryId: state.pathParameters['entryId']!),
        ),
        GoRoute(
          path: '/learn/notes',
          name: 'learnNotesLanding',
          builder: (context, state) =>
              const Scaffold(body: Text('Learn Notes')),
        ),
        GoRoute(
          path: '/quran/reflections',
          name: 'quranReflections',
          builder: (context, state) =>
              const Scaffold(body: Text('Quran Reflections')),
        ),
        GoRoute(
          path: '/journal/create',
          name: 'journalCreate',
          builder: (context, state) =>
              const Scaffold(body: Text('Create Journal')),
        ),
        GoRoute(
          path: '/quran/:surahNumber',
          name: 'quranReader',
          builder: (context, state) =>
              const Scaffold(body: Text('Quran Reader')),
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

    final entryTitle = find.text('Moonlit memory');
    expect(entryTitle, findsOneWidget);
    await tester.ensureVisible(entryTitle);
    await tester.pumpAndSettle();
    final entryInkWell = find.ancestor(
      of: entryTitle,
      matching: find.byType(InkWell),
    );
    await tester.tap(entryInkWell.first);
    await tester.pumpAndSettle();

    expect(find.byType(JournalEntryDetailPage), findsOneWidget);
    expect(find.text('Night prayer'), findsOneWidget);
    expect(find.textContaining('20:114'), findsOneWidget);

    final editAction = find.text('Edit entry');
    await tester.scrollUntilVisible(
      editAction,
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    await tester.tap(editAction);
    await tester.pumpAndSettle();

    final textFields = find.byType(TextField);
    expect(textFields, findsWidgets);
    await tester.enterText(textFields.at(0), 'Moonlit memory updated');
    await tester.enterText(
      textFields.at(1),
      'I rewrote this journal memory after revisiting the entry in detail.',
    );
    tester.testTextInput.hide();
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Save changes'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save changes'));
    await tester.pumpAndSettle();

    final updated = container.read(journalEntryByIdProvider(entryId));
    expect(updated, isNotNull);
    expect(updated!.title, 'Moonlit memory updated');
    expect(updated.body, contains('revisiting the entry'));
  });
}
