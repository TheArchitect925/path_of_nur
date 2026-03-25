import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_of_nur/core/reminders/quran_live_activity_service.dart';
import 'package:path_of_nur/features/learn/quran/application/quran_player_controller.dart';
import 'package:path_of_nur/features/learn/quran/application/quran_providers.dart';
import 'package:path_of_nur/features/learn/quran/application/quran_reader_playback_controller.dart';
import 'package:path_of_nur/features/learn/quran/domain/quran_audio_resilience_models.dart';
import 'package:path_of_nur/l10n/app_localizations.dart';
import 'package:path_of_nur/shared/persistence/local_store.dart';
import 'package:path_of_nur/shared/widgets/app_scaffold.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FakeMiniPlayerController extends QuranPlayerController {
  _FakeMiniPlayerController(super.ref, super.player);

  bool paused = false;
  bool stopped = false;
  bool resumed = false;
  bool retried = false;
  bool replayedCurrentAyah = false;
  final List<int> relativeAyahOffsets = <int>[];
  final List<int> adjacentSurahOffsets = <int>[];
  final List<Duration> seekPositions = <Duration>[];

  @override
  Future<void> pause() async {
    paused = true;
  }

  @override
  Future<void> stop({bool preserveSession = true}) async {
    stopped = true;
  }

  @override
  Future<bool> resumeCurrentPlayback() async {
    resumed = true;
    return true;
  }

  @override
  Future<bool> retryCurrentPlayback() async {
    retried = true;
    return true;
  }

  @override
  Future<bool> playRelativeAyah(int offset) async {
    relativeAyahOffsets.add(offset);
    return true;
  }

  @override
  Future<bool> playAdjacentSurah(int offset) async {
    adjacentSurahOffsets.add(offset);
    return true;
  }

  @override
  Future<void> seek(Duration position, {int? index}) async {
    seekPositions.add(position);
  }

  @override
  Future<bool> replayCurrentAyah() async {
    replayedCurrentAyah = true;
    return true;
  }
}

class _FakeQuranLiveActivityService extends QuranLiveActivityService {
  bool supported = true;
  int updateCount = 0;
  int endCount = 0;
  Map<String, Object?>? lastPayload;

  @override
  Future<bool> isSupported() async => supported;

  @override
  Future<void> updatePlaybackCard({
    required int surahNumber,
    required String surahName,
    required String surahArabicName,
    required int ayahNumber,
    required String reciterName,
    required bool isPlaying,
    required int elapsedSeconds,
    required int totalSeconds,
  }) async {
    updateCount += 1;
    lastPayload = <String, Object?>{
      'surahNumber': surahNumber,
      'surahName': surahName,
      'surahArabicName': surahArabicName,
      'ayahNumber': ayahNumber,
      'reciterName': reciterName,
      'isPlaying': isPlaying,
      'elapsedSeconds': elapsedSeconds,
      'totalSeconds': totalSeconds,
    };
  }

  @override
  Future<void> endPlaybackCard() async {
    endCount += 1;
  }
}

void main() {
  testWidgets('shell playback pill appears for active Qur’an playback and expands into the full player sheet', (
    tester,
  ) async {
    late _FakeMiniPlayerController controller;
    SharedPreferences.setMockInitialValues(const <String, Object>{});
    final prefs = await SharedPreferences.getInstance();
    final router = GoRouter(
      initialLocation: '/home',
      routes: [
        GoRoute(
          path: '/home',
          name: 'home',
          builder: (context, state) => const AppShellScaffold(
            currentLocation: '/home',
            child: Center(child: Text('Home')),
          ),
        ),
        GoRoute(
          path: '/quran/surah/:surahNumber',
          name: 'quranReader',
          builder: (context, state) => Scaffold(
            body: Text(
              'Reader ${state.pathParameters['surahNumber']}:${state.uri.queryParameters['ayah'] ?? '-'}',
            ),
          ),
        ),
        GoRoute(
          path: '/quran/focus-recitation',
          name: 'quranFocusRecitation',
          builder: (context, state) => Scaffold(
            body: Text(
              'Focus ${state.uri.queryParameters['surah'] ?? '-'}:${state.uri.queryParameters['ayah'] ?? '-'}',
            ),
          ),
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          quranGlobalPlaybackStateProvider.overrideWithValue(
            const QuranReaderPlaybackState(
              pageSurahNumber: 1,
              reciterId: 'husary',
              reciterName: 'Husary',
              activeSurahNumber: 1,
              activeAyahKey: '1:2',
              activeAyahNumber: 2,
              hasPlayback: true,
              isPlaying: true,
              status: QuranReaderPlaybackStatus.playing,
              canPause: true,
              canPlay: false,
              canGoNextAyah: true,
              canGoNextSurah: true,
              nextAyahNumber: 3,
              nextSurahNumber: 2,
            ),
          ),
          quranPlayerControllerProvider.overrideWith(
            (ref) => controller = _FakeMiniPlayerController(ref, AudioPlayer()),
          ),
        ],
        child: MaterialApp.router(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: router,
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.byKey(const ValueKey('quran-shell-player-pill')), findsOneWidget);
    expect(
      find.byKey(const ValueKey('quran-shell-player-pill-content')),
      findsOneWidget,
    );

    await tester.tap(find.byKey(const ValueKey('quran-shell-player-pill')));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('quran-global-player-sheet')), findsOneWidget);
    expect(find.byKey(const ValueKey('quran-shell-player-pill')), findsNothing);
    expect(
      find.byKey(const ValueKey('quran-global-player-collapse')),
      findsOneWidget,
    );
    expect(find.byKey(const ValueKey('quran-reader-follow-toggle')), findsNothing);
    expect(
      find.byKey(const ValueKey('quran-global-player-open-focus-mode')),
      findsOneWidget,
    );

    await tester.tap(find.byKey(const ValueKey('quran-reader-play-pause-button')));
    await tester.pump();
    expect(controller.paused, isTrue);

    await tester.tap(find.byKey(const ValueKey('quran-reader-next-ayah')));
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('quran-reader-next-surah')));
    await tester.pump();
    expect(controller.relativeAyahOffsets, <int>[1]);
    expect(controller.adjacentSurahOffsets, <int>[1]);

    await tester.tap(find.byKey(const ValueKey('quran-reader-forward-15')));
    await tester.pump();
    expect(controller.seekPositions, isNotEmpty);

    await tester.tap(find.byKey(const ValueKey('quran-reader-close-player')));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('quran-global-player-sheet')), findsNothing);
    expect(find.byKey(const ValueKey('quran-shell-player-pill')), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('quran-shell-player-pill')));
    await tester.pumpAndSettle();
    await tester.fling(
      find.byKey(const ValueKey('quran-global-player-sheet')),
      const Offset(0, 420),
      1800,
      warnIfMissed: false,
    );
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('quran-global-player-sheet')), findsNothing);

    await tester.tap(find.byKey(const ValueKey('quran-shell-player-pill')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('quran-global-player-open-reader')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 250));
    expect(find.text('Reader 1:2'), findsOneWidget);

    router.go('/home');
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('quran-shell-player-pill')));
    await tester.pumpAndSettle();
    await tester.tap(
      find.byKey(const ValueKey('quran-global-player-open-focus-mode')),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 250));
    expect(find.text('Focus 1:2'), findsOneWidget);
  });

  testWidgets('shell playback pill stays visible when playback failed', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues(const <String, Object>{});
    final prefs = await SharedPreferences.getInstance();
    final router = GoRouter(
      initialLocation: '/home',
      routes: [
        GoRoute(
          path: '/home',
          name: 'home',
          builder: (context, state) => const AppShellScaffold(
            currentLocation: '/home',
            child: Center(child: Text('Home')),
          ),
        ),
        GoRoute(
          path: '/quran/surah/:surahNumber',
          name: 'quranReader',
          builder: (context, state) => const SizedBox.shrink(),
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          quranGlobalPlaybackStateProvider.overrideWithValue(
            const QuranReaderPlaybackState(
              pageSurahNumber: 1,
              reciterId: 'husary',
              reciterName: 'Husary',
              activeSurahNumber: 1,
              hasPlayback: true,
              status: QuranReaderPlaybackStatus.idle,
              canPause: false,
              canPlay: false,
              canRetryFromFailure: true,
              failureType: QuranPlaybackFailureType.networkUnavailable,
            ),
          ),
        ],
        child: MaterialApp.router(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: router,
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.textContaining('network'), findsOneWidget);
    expect(find.byKey(const ValueKey('quran-shell-player-pill')), findsOneWidget);
  });

  testWidgets('shell playback pill hides while focus recitation mode is open', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues(const <String, Object>{});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          quranFocusRecitationOpenProvider.overrideWith(
            (ref) => true,
          ),
          quranGlobalPlaybackStateProvider.overrideWithValue(
            const QuranReaderPlaybackState(
              pageSurahNumber: 1,
              reciterId: 'husary',
              reciterName: 'Husary',
              activeSurahNumber: 1,
              activeAyahKey: '1:2',
              activeAyahNumber: 2,
              hasPlayback: true,
              isPlaying: true,
              status: QuranReaderPlaybackStatus.playing,
              canPause: true,
            ),
          ),
        ],
        child: const MaterialApp(
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: AppShellScaffold(
            currentLocation: '/home',
            child: Scaffold(body: Text('Home')),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('quran-shell-player-pill')), findsNothing);
  });

  testWidgets('shell updates Qur’an live activity while browsing outside the reader', (
    tester,
  ) async {
    final fakeLiveActivity = _FakeQuranLiveActivityService();
    final playbackStateProvider = StateProvider<QuranReaderPlaybackState>(
      (ref) => const QuranReaderPlaybackState(
        pageSurahNumber: 1,
        reciterId: 'husary',
        reciterName: 'Husary',
        activeSurahNumber: 1,
        activeAyahKey: '1:2',
        activeAyahNumber: 2,
        hasPlayback: true,
        isPlaying: true,
        status: QuranReaderPlaybackStatus.playing,
        position: Duration(seconds: 9),
        duration: Duration(seconds: 45),
      ),
    );

    SharedPreferences.setMockInitialValues(const <String, Object>{});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          quranLiveActivityServiceProvider.overrideWithValue(fakeLiveActivity),
          quranGlobalPlaybackStateProvider.overrideWith(
            (ref) => ref.watch(playbackStateProvider),
          ),
        ],
        child: const MaterialApp(
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: AppShellScaffold(
            currentLocation: '/home',
            child: SizedBox.shrink(),
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    expect(fakeLiveActivity.updateCount, 1);
    expect(fakeLiveActivity.lastPayload?['surahNumber'], 1);
    expect(fakeLiveActivity.lastPayload?['ayahNumber'], 2);

    final container = ProviderScope.containerOf(
      tester.element(find.byType(AppShellScaffold)),
    );
    container.read(playbackStateProvider.notifier).state =
        const QuranReaderPlaybackState(
          pageSurahNumber: 1,
          reciterId: 'husary',
          reciterName: 'Husary',
          hasPlayback: false,
          isPlaying: false,
          status: QuranReaderPlaybackStatus.idle,
        );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    expect(fakeLiveActivity.endCount, 1);
  });
}
