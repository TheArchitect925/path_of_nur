import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/learn/quran/application/quran_providers.dart';
import 'package:path_of_nur/features/learn/quran/application/quran_reader_playback_controller.dart';
import 'package:path_of_nur/features/learn/quran/domain/quran_ayah.dart';
import 'package:path_of_nur/features/learn/quran/presentation/quran_reader_page.dart';
import 'package:path_of_nur/l10n/app_localizations.dart';
import 'package:path_of_nur/shared/application/daily_clock_provider.dart';
import 'package:path_of_nur/shared/persistence/local_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support/fake_quran_playback_feed.dart';
import 'support/fake_quran_word_timing_repository.dart';

const _fatiha = <QuranAyah>[
  QuranAyah(
    surahNumber: 1,
    ayahNumber: 1,
    arabic: 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
    translation: 'In the name of Allah, the Most Merciful.',
  ),
];

const _ikhlas = <QuranAyah>[
  QuranAyah(
    surahNumber: 112,
    ayahNumber: 1,
    arabic: 'قُلْ هُوَ اللَّهُ أَحَدٌ',
    translation: 'Say, He is Allah, the One.',
  ),
];

/// The page under the reader. It watches the reading stats, so a stats write
/// made while the reader's element is being unmounted would mark it dirty
/// inside the locked tree — the case the deferred flush exists for.
class _StatsHome extends ConsumerWidget {
  const _StatsHome();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(quranReadingStatsProvider);
    return Scaffold(
      body: Column(
        children: [
          Text('sessions ${stats.totalSessions}'),
          TextButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const QuranReaderPage(surahNumber: 1),
              ),
            ),
            child: const Text('open reader'),
          ),
        ],
      ),
    );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late DateTime now;

  Future<ProviderContainer> pumpApp(
    WidgetTester tester, {
    Widget home = const _StatsHome(),
  }) async {
    await tester.binding.setSurfaceSize(const Size(1200, 2600));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final feed = FakeQuranPlaybackFeed();
    addTearDown(feed.dispose);
    SharedPreferences.setMockInitialValues(const <String, Object>{});
    final prefs = await SharedPreferences.getInstance();
    final container = ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        dailyNowProvider.overrideWith(
          (ref) => Stream.value(DateTime(2026, 4, 10)),
        ),
        quranReaderNowProvider.overrideWithValue(() => now),
        quranPlaybackFeedProvider.overrideWithValue(feed),
        quranWordTimingRepositoryProvider.overrideWithValue(
          FakeQuranWordTimingRepository(),
        ),
        quranSurahAyahsProvider(1).overrideWith((ref) async => _fatiha),
        quranSurahAyahsProvider(112).overrideWith((ref) async => _ikhlas),
      ],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: home,
        ),
      ),
    );
    await tester.pumpAndSettle();
    return container;
  }

  Future<void> openReader(WidgetTester tester) async {
    await tester.tap(find.text('open reader'));
    await tester.pumpAndSettle();
    expect(find.byType(QuranReaderPage), findsOneWidget);
  }

  Future<void> closeReader(WidgetTester tester) async {
    Navigator.of(tester.element(find.byType(QuranReaderPage))).pop();
    await tester.pumpAndSettle();
    expect(find.byType(QuranReaderPage), findsNothing);
  }

  testWidgets('closing the reader after a real read logs the session', (
    tester,
  ) async {
    now = DateTime(2026, 4, 10, 20, 15);
    final container = await pumpApp(tester);
    expect(find.text('sessions 0'), findsOneWidget);

    await openReader(tester);
    now = now.add(const Duration(seconds: 42));
    await closeReader(tester);

    // dispose used to call ref.read and throw "Cannot use "ref" after the
    // widget was disposed", which also dropped the session.
    expect(tester.takeException(), isNull);

    final stats = container.read(quranReadingStatsProvider);
    expect(stats.totalSessions, 1);
    expect(stats.totalReadingSeconds, 42);
    expect(stats.secondsForDay('2026-04-10'), 42);
    expect(stats.lastSessionEndedAtIso, now.toIso8601String());

    // Persisted, not just held in memory: a fresh notifier reads it back.
    final reloaded = QuranReadingStatsNotifier(
      container.read(localStoreProvider),
    );
    addTearDown(reloaded.dispose);
    expect(reloaded.state.totalSessions, 1);
    expect(reloaded.state.totalReadingSeconds, 42);

    // The page underneath heard about it.
    expect(find.text('sessions 1'), findsOneWidget);
  });

  testWidgets('a glance under fifteen seconds logs nothing', (tester) async {
    now = DateTime(2026, 4, 10, 20, 15);
    final container = await pumpApp(tester);

    await openReader(tester);
    now = now.add(const Duration(seconds: 10));
    await closeReader(tester);

    expect(tester.takeException(), isNull);
    expect(container.read(quranReadingStatsProvider).totalSessions, 0);
    expect(find.text('sessions 0'), findsOneWidget);
  });

  testWidgets('each visit to the reader is its own session', (tester) async {
    now = DateTime(2026, 4, 10, 20, 15);
    final container = await pumpApp(tester);

    await openReader(tester);
    now = now.add(const Duration(seconds: 30));
    await closeReader(tester);
    expect(tester.takeException(), isNull);

    now = now.add(const Duration(minutes: 5));
    await openReader(tester);
    now = now.add(const Duration(seconds: 20));
    await closeReader(tester);
    expect(tester.takeException(), isNull);

    final stats = container.read(quranReadingStatsProvider);
    expect(stats.totalSessions, 2);
    // The five minutes away from the reader are not counted.
    expect(stats.totalReadingSeconds, 50);
    expect(find.text('sessions 2'), findsOneWidget);
  });

  // What the binding delivers on the way out and back in. A phone walks
  // through inactive and hidden to paused; a browser stops at hidden when
  // the tab is hidden and never reports paused.
  const trips =
      <String, (List<AppLifecycleState> away, List<AppLifecycleState> back)>{
        'the app is backgrounded': (
          [AppLifecycleState.paused],
          [AppLifecycleState.resumed],
        ),
        'the phone walks through every state': (
          [
            AppLifecycleState.inactive,
            AppLifecycleState.hidden,
            AppLifecycleState.paused,
          ],
          [
            AppLifecycleState.hidden,
            AppLifecycleState.inactive,
            AppLifecycleState.resumed,
          ],
        ),
        'the browser tab is hidden': (
          [AppLifecycleState.inactive, AppLifecycleState.hidden],
          [AppLifecycleState.inactive, AppLifecycleState.resumed],
        ),
      };

  for (final MapEntry(key: trip, value: (away, back)) in trips.entries) {
    testWidgets('time away is not reading when $trip', (tester) async {
      now = DateTime(2026, 4, 10, 20, 15);
      final container = await pumpApp(tester);

      await openReader(tester);
      now = now.add(const Duration(seconds: 20));
      away.forEach(tester.binding.handleAppLifecycleStateChanged);
      now = now.add(const Duration(minutes: 30));
      back.forEach(tester.binding.handleAppLifecycleStateChanged);
      now = now.add(const Duration(seconds: 25));
      await closeReader(tester);

      expect(tester.takeException(), isNull);
      final stats = container.read(quranReadingStatsProvider);
      expect(stats.totalSessions, 1);
      // The twenty seconds before leaving and the twenty-five after coming
      // back; the half hour away is not counted.
      expect(stats.totalReadingSeconds, 45);
      expect(find.text('sessions 1'), findsOneWidget);
    });
  }

  testWidgets('switching surah in place logs the first surah as a session', (
    tester,
  ) async {
    now = DateTime(2026, 4, 10, 20, 15);
    final surah = ValueNotifier<int>(1);
    addTearDown(surah.dispose);
    final container = await pumpApp(
      tester,
      home: ValueListenableBuilder<int>(
        valueListenable: surah,
        builder: (context, number, _) => QuranReaderPage(surahNumber: number),
      ),
    );

    now = now.add(const Duration(seconds: 25));
    // Same page, new surah: didUpdateWidget flushes, and a provider write
    // there is refused just as it is in dispose.
    surah.value = 112;
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    final stats = container.read(quranReadingStatsProvider);
    expect(stats.totalSessions, 1);
    expect(stats.totalReadingSeconds, 25);
  });
}
