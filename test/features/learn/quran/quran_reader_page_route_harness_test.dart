import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_of_nur/features/learn/quran/application/quran_playback_orchestrator.dart';
import 'package:path_of_nur/features/learn/quran/application/quran_player_controller.dart';
import 'package:path_of_nur/features/learn/quran/application/quran_providers.dart';
import 'package:path_of_nur/features/learn/quran/application/quran_reader_playback_controller.dart';
import 'package:path_of_nur/features/learn/quran/data/quran_word_timing_repository.dart';
import 'package:path_of_nur/features/learn/quran/domain/quran_ayah.dart';
import 'package:path_of_nur/features/learn/quran/presentation/quran_reader_page.dart';
import 'package:path_of_nur/l10n/app_localizations.dart';
import 'package:path_of_nur/shared/persistence/local_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support/fake_quran_playback_feed.dart';
import 'support/fake_quran_word_timing_repository.dart';

class _FakeRoutePlayerController extends QuranPlayerController {
  _FakeRoutePlayerController(super.ref, super.player, this.feed);

  final FakeQuranPlaybackFeed feed;

  @override
  Future<void> pause() async {
    feed.update(playing: false, processingState: ProcessingState.ready);
    feed.emitPlayerState();
  }

  @override
  Future<void> startPreparedPlayback(
    QuranPreparedPlayback prepared, {
    required String reciterId,
    required double playbackSpeed,
    required bool includeMediaTags,
  }) async {
    feed.update(
      playing: true,
      hasPlaybackSource: true,
      currentIndex: prepared.initialLogicalIndex,
      position: prepared.initialPosition,
      duration: const Duration(seconds: 4),
      processingState: ProcessingState.ready,
    );
    feed.emitDuration();
    feed.emitIndex();
    feed.emitPosition();
    feed.emitPlayerState();
  }

  @override
  Future<bool> resumeCurrentPlayback() async {
    feed.update(playing: true, processingState: ProcessingState.ready);
    feed.emitPlayerState();
    return true;
  }

  @override
  Future<bool> switchReciter(String reciterId) async {
    ref.read(quranAudioSettingsProvider.notifier).setReciterId(reciterId);
    feed.emitPlayerState();
    return true;
  }
}

void main() {
  const ayahs = <QuranAyah>[
    QuranAyah(
      surahNumber: 1,
      ayahNumber: 1,
      arabic: 'بِسْمِ اللَّهِ',
      translation: 'In the name of Allah',
    ),
    QuranAyah(
      surahNumber: 1,
      ayahNumber: 2,
      arabic: 'الْحَمْدُ لِلَّهِ',
      translation: 'All praise is for Allah',
    ),
    QuranAyah(
      surahNumber: 1,
      ayahNumber: 3,
      arabic: 'الرَّحْمَٰنِ الرَّحِيمِ',
      translation: 'The Most Merciful, the Especially Merciful',
    ),
  ];

  Future<Widget> wrapReader({
    required FakeQuranPlaybackFeed feed,
    required FakeQuranWordTimingRepository timingRepository,
  }) async {
    SharedPreferences.setMockInitialValues(const <String, Object>{});
    final prefs = await SharedPreferences.getInstance();
    return ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        quranPlaybackFeedProvider.overrideWithValue(feed),
        quranWordTimingRepositoryProvider.overrideWithValue(timingRepository),
        quranPlayerControllerProvider.overrideWith(
          (ref) => _FakeRoutePlayerController(
            ref,
            ref.read(quranSharedAudioPlayerProvider),
            feed,
          ),
        ),
        quranSurahAyahsProvider(1).overrideWith((ref) async => ayahs),
      ],
      child: MaterialApp(
        localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: const QuranReaderPage(surahNumber: 1),
      ),
    );
  }

  testWidgets('real reader page reflects provider-driven playback state in visible transport UI', (
    tester,
  ) async {
    final feed = FakeQuranPlaybackFeed()
      ..update(
        playing: true,
        hasPlaybackSource: true,
        currentIndex: 0,
        position: const Duration(seconds: 1),
        duration: const Duration(seconds: 4),
        processingState: ProcessingState.ready,
      );
    final timingRepository = FakeQuranWordTimingRepository();
    addTearDown(feed.dispose);

    await tester.pumpWidget(
      await wrapReader(feed: feed, timingRepository: timingRepository),
    );
    final container = ProviderScope.containerOf(
      tester.element(find.byType(QuranReaderPage)),
    );
    await container.read(quranSurahAyahsProvider(1).future);
    container.read(quranActivePlaybackSessionProvider.notifier).state =
        const QuranActivePlaybackSession(
          surahNumber: 1,
          ayahNumbers: <int>[2],
          reciterId: 'husary',
          playbackSpeed: 1,
          includeMediaTags: true,
          isSurahMode: false,
        );
    feed.emitDuration();
    feed.emitIndex();
    feed.emitPosition();
    feed.emitPlayerState();
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('quran-reader-now-reciting-label')), findsOneWidget);
    expect(find.textContaining('Verse 1:2'), findsOneWidget);
    expect(find.byIcon(Icons.pause_circle_filled_rounded), findsOneWidget);

    feed.update(playing: false, processingState: ProcessingState.ready);
    feed.emitPlayerState();
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.play_circle_fill_rounded), findsOneWidget);
  });

  testWidgets('real reader page stays stable across timing-ready and timing-missing highlight states', (
    tester,
  ) async {
    final feed = FakeQuranPlaybackFeed()
      ..update(
        playing: true,
        hasPlaybackSource: true,
        currentIndex: 0,
        position: const Duration(milliseconds: 1200),
        duration: const Duration(seconds: 4),
        processingState: ProcessingState.ready,
      );
    final timingRepository = FakeQuranWordTimingRepository(
      timings: <String, List<QuranWordTimingSegment>>{
        'husary:1:2': const <QuranWordTimingSegment>[
          QuranWordTimingSegment(wordIndex: 0, startMs: 0, endMs: 900),
          QuranWordTimingSegment(wordIndex: 1, startMs: 901, endMs: 1800),
        ],
      },
    );
    addTearDown(feed.dispose);

    await tester.pumpWidget(
      await wrapReader(feed: feed, timingRepository: timingRepository),
    );
    final container = ProviderScope.containerOf(
      tester.element(find.byType(QuranReaderPage)),
    );
    await container.read(quranSurahAyahsProvider(1).future);
    await tester.pumpAndSettle();
    final ayahCardsFinder = find.byType(QuranAyahCard, skipOffstage: false);

    container.read(quranReaderSettingsProvider.notifier).setWordSyncHighlightBeta(true);
    container.read(quranActivePlaybackSessionProvider.notifier).state =
        const QuranActivePlaybackSession(
          surahNumber: 1,
          ayahNumbers: <int>[2],
          reciterId: 'husary',
          playbackSpeed: 1,
          includeMediaTags: true,
          isSurahMode: false,
        );
    feed.emitIndex();
    feed.emitPlayerState();
    feed.emitPosition();
    await tester.pumpAndSettle();

    expect(
      container.read(quranWordHighlightCoordinatorProvider(1)).activeWordIndex,
      1,
    );
    expect(find.byKey(const ValueKey('quran-reader-now-reciting-label')), findsOneWidget);
    expect(find.textContaining('Verse 1:2'), findsOneWidget);

    container.read(quranActivePlaybackSessionProvider.notifier).state =
        const QuranActivePlaybackSession(
          surahNumber: 1,
          ayahNumbers: <int>[1],
          reciterId: 'husary',
          playbackSpeed: 1,
          includeMediaTags: true,
          isSurahMode: false,
        );
    feed.update(currentIndex: 0, position: const Duration(milliseconds: 600));
    feed.emitIndex();
    feed.emitPlayerState();
    feed.emitPosition();
    await tester.pumpAndSettle();

    final highlightState = container.read(quranWordHighlightCoordinatorProvider(1));
    expect(highlightState.activeAyahKey, '1:1');
    expect(highlightState.activeWordIndex, isNull);
    expect(highlightState.mode, QuranWordHighlightMode.noTimingAvailable);
    expect(find.byKey(const ValueKey('quran-reader-now-reciting-label')), findsOneWidget);
    expect(find.textContaining('Verse 1:1'), findsOneWidget);
  });
}
