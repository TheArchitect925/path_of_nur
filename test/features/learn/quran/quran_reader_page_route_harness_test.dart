import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_of_nur/features/learn/quran/application/quran_playback_orchestrator.dart';
import 'package:path_of_nur/features/learn/quran/application/quran_player_controller.dart';
import 'package:path_of_nur/features/learn/quran/application/quran_providers.dart';
import 'package:path_of_nur/features/learn/quran/application/quran_reader_follow_mode_coordinator.dart';
import 'package:path_of_nur/features/learn/quran/application/quran_reader_playback_controller.dart';
import 'package:path_of_nur/features/learn/quran/application/quran_word_highlight_coordinator.dart';
import 'package:path_of_nur/features/learn/quran/application/quran_playback_policy.dart';
import 'package:path_of_nur/features/learn/quran/data/quran_audio_repository.dart';
import 'package:path_of_nur/features/learn/quran/domain/quran_audio_source_metadata.dart';
import 'package:path_of_nur/features/learn/quran/domain/quran_audio_resilience_models.dart';
import 'package:path_of_nur/features/learn/quran/data/quran_word_timing_repository.dart';
import 'package:path_of_nur/features/learn/quran/domain/quran_ayah.dart';
import 'package:path_of_nur/features/learn/quran/domain/bismillah_playback_mode.dart';
import 'package:path_of_nur/features/learn/quran/domain/quran_content_refs.dart';
import 'package:path_of_nur/features/learn/quran/domain/quran_playback_request.dart';
import 'package:path_of_nur/features/learn/quran/presentation/quran_reader_page.dart';
import 'package:path_of_nur/l10n/app_localizations.dart';
import 'package:path_of_nur/shared/application/daily_clock_provider.dart';
import 'package:path_of_nur/shared/persistence/local_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support/fake_quran_playback_feed.dart';
import 'support/fake_quran_word_timing_repository.dart';

class _FakeRoutePlayerController extends QuranPlayerController {
  _FakeRoutePlayerController(super.ref, super.player, this.feed);

  final FakeQuranPlaybackFeed feed;
  LoopMode lastLoopMode = LoopMode.off;
  List<int> lastPreparedAyahNumbers = const <int>[];

  @override
  Future<void> pause() async {
    feed.update(playing: false, processingState: ProcessingState.ready);
    feed.emitPlayerState();
  }

  @override
  Future<void> stop({bool preserveSession = true}) async {
    if (!preserveSession) {
      ref.read(quranActivePlaybackSessionProvider.notifier).state = null;
    }
    feed.update(
      playing: false,
      hasPlaybackSource: false,
      currentIndex: null,
      position: Duration.zero,
      duration: null,
      processingState: ProcessingState.idle,
    );
    feed.emitDuration();
    feed.emitIndex();
    feed.emitPosition();
    feed.emitPlayerState();
  }

  @override
  Future<bool> startPreparedPlayback(
    QuranPreparedPlayback prepared, {
    required String reciterId,
    required double playbackSpeed,
    required bool includeMediaTags,
    LoopMode loopMode = LoopMode.off,
  }) async {
    lastLoopMode = loopMode;
    final ayahNumbers = prepared.entries
        .map((entry) => entry.ayahNumber)
        .toList(growable: false);
    lastPreparedAyahNumbers = ayahNumbers;
    ref
        .read(quranActivePlaybackSessionProvider.notifier)
        .state = QuranActivePlaybackSession(
      surahNumber: prepared.request.surahNumber,
      ayahNumbers: ayahNumbers,
      reciterId: reciterId,
      playbackSpeed: playbackSpeed,
      includeMediaTags: includeMediaTags,
      isSurahMode: ayahNumbers.length > 1,
    );
    ref
        .read(quranRecitationSessionProvider.notifier)
        .save(
          surahNumber: prepared.request.surahNumber,
          ayahNumber: prepared.entries[prepared.initialLogicalIndex].ayahNumber,
          positionSeconds: prepared.initialPosition.inSeconds,
        );
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
    return true;
  }

  @override
  Future<bool> resumeCurrentPlayback() async {
    feed.update(playing: true, processingState: ProcessingState.ready);
    feed.emitPlayerState();
    return true;
  }

  @override
  Future<bool> playAyah({
    required int surahNumber,
    required int ayahNumber,
    Duration resumePosition = Duration.zero,
    QuranPlaybackReason playbackReason = QuranPlaybackReason.freshPlay,
    List<int>? ayahNumbers,
    bool pauseAfterStart = false,
  }) async {
    final resolvedAyahs =
        ayahNumbers ??
        (ref.read(quranSurahAyahsProvider(surahNumber)).valueOrNull ??
                const <QuranAyah>[])
            .map((item) => item.ayahNumber)
            .toList(growable: false);
    final targetIndex = resolvedAyahs.indexOf(ayahNumber);
    ref
        .read(quranActivePlaybackSessionProvider.notifier)
        .state = QuranActivePlaybackSession(
      surahNumber: surahNumber,
      ayahNumbers: resolvedAyahs,
      reciterId: ref.read(quranAudioSettingsProvider).reciterId,
      playbackSpeed: ref.read(quranAudioSettingsProvider).playbackSpeed,
      includeMediaTags: true,
      isSurahMode: resolvedAyahs.length > 1,
    );
    ref
        .read(quranRecitationSessionProvider.notifier)
        .save(
          surahNumber: surahNumber,
          ayahNumber: ayahNumber,
          positionSeconds: resumePosition.inSeconds,
        );
    feed.update(
      playing: !pauseAfterStart,
      hasPlaybackSource: true,
      currentIndex: targetIndex < 0 ? 0 : targetIndex,
      position: resumePosition,
      duration: const Duration(seconds: 4),
      processingState: ProcessingState.ready,
    );
    feed.emitDuration();
    feed.emitIndex();
    feed.emitPosition();
    feed.emitPlayerState();
    return true;
  }

  @override
  Future<bool> resumeStoredRecitationSession({
    bool restartFromSurah = false,
    bool pauseAfterStart = false,
  }) async {
    final stored = ref.read(quranRecitationSessionProvider);
    if (stored == null) {
      return false;
    }
    final ayahs =
        ref.read(quranSurahAyahsProvider(stored.surahNumber)).valueOrNull ??
        const <QuranAyah>[];
    final ayahNumbers = ayahs
        .map((item) => item.ayahNumber)
        .toList(growable: false);
    final targetAyah = restartFromSurah ? 1 : stored.ayahNumber;
    final targetIndex = ayahNumbers.indexOf(targetAyah);
    ref
        .read(quranActivePlaybackSessionProvider.notifier)
        .state = QuranActivePlaybackSession(
      surahNumber: stored.surahNumber,
      ayahNumbers: ayahNumbers,
      reciterId: ref.read(quranAudioSettingsProvider).reciterId,
      playbackSpeed: ref.read(quranAudioSettingsProvider).playbackSpeed,
      includeMediaTags: true,
      isSurahMode: true,
    );
    ref
        .read(quranRecitationSessionProvider.notifier)
        .save(
          surahNumber: stored.surahNumber,
          ayahNumber: targetAyah,
          positionSeconds: restartFromSurah ? 0 : stored.positionSeconds,
        );
    feed.update(
      playing: !pauseAfterStart,
      hasPlaybackSource: true,
      currentIndex: targetIndex < 0 ? 0 : targetIndex,
      position: restartFromSurah
          ? Duration.zero
          : Duration(seconds: stored.positionSeconds),
      duration: const Duration(seconds: 4),
      processingState: ProcessingState.ready,
    );
    feed.emitDuration();
    feed.emitIndex();
    feed.emitPosition();
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

class _FakeRoutePlaybackOrchestrator extends QuranPlaybackOrchestrator {
  _FakeRoutePlaybackOrchestrator()
    : super(
        audioRepository: QuranAudioRepository(),
        policy: const QuranPlaybackPolicy(),
      );

  @override
  Future<QuranPreparedPlayback> preparePlayback({
    required QuranPlaybackRequest request,
    required String reciterId,
    required List<int> ayahNumbers,
    BismillahPlaybackMode mode = defaultBismillahPlaybackMode,
  }) async {
    final entries = ayahNumbers
        .map(
          (ayahNumber) => QuranPreparedPlaybackEntry(
            source: 'fake://$reciterId/${request.surahNumber}/$ayahNumber',
            ayahNumber: ayahNumber,
            metadata: QuranAudioSourceMetadata(
              surahNumber: request.surahNumber,
              ayahNumber: ayahNumber,
              reciterId: reciterId,
              source: 'fake://$reciterId/${request.surahNumber}/$ayahNumber',
              sourceType: QuranPlaybackSourceType.remoteStream,
              sourceContainsBismillahAtStart: false,
              sourceId: const QuranAudioSourceId('fake.test'),
              isAyahGranular: true,
              includesBismillahInFatiha: true,
              includesBismillahAtSurahStarts: false,
              hasStandaloneBismillahClip: false,
              standaloneBismillahRef: QuranAudioRef(
                surah: 1,
                ayah: 1,
                reciterId: reciterId,
              ),
              surah9HasNoBismillahIntroInSource: true,
              notes: 'test',
              confidence: QuranAudioMetadataConfidence.confirmedFromCode,
              manualReviewNeeded: false,
            ),
          ),
        )
        .toList(growable: false);
    return QuranPreparedPlayback(
      request: request,
      entries: entries,
      initialLogicalIndex: ayahNumbers.indexOf(
        request.ayahNumber ?? ayahNumbers.first,
      ),
      initialPosition: request.resumePosition ?? Duration.zero,
      didPrependBismillah: false,
    );
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
    QuranReaderPage? page,
  }) async {
    SharedPreferences.setMockInitialValues(const <String, Object>{});
    final prefs = await SharedPreferences.getInstance();
    return ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        dailyNowProvider.overrideWith(
          (ref) => Stream.value(DateTime(2026, 4, 10)),
        ),
        quranPlaybackFeedProvider.overrideWithValue(feed),
        quranWordTimingRepositoryProvider.overrideWithValue(timingRepository),
        quranPlaybackOrchestratorProvider.overrideWithValue(
          _FakeRoutePlaybackOrchestrator(),
        ),
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
        home: page ?? const QuranReaderPage(surahNumber: 1),
      ),
    );
  }

  Future<void> disposeReaderHarness(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pumpAndSettle();
  }

  testWidgets(
    'real reader page reflects provider-driven playback state in visible transport UI',
    (tester) async {
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
      container
          .read(quranActivePlaybackSessionProvider.notifier)
          .state = const QuranActivePlaybackSession(
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

      expect(
        find.byKey(const ValueKey('quran-reader-now-reciting-label')),
        findsOneWidget,
      );
      expect(find.textContaining('Verse 1:2'), findsOneWidget);
      expect(find.byIcon(Icons.pause_circle_filled_rounded), findsOneWidget);

      feed.update(playing: false, processingState: ProcessingState.ready);
      feed.emitPlayerState();
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.play_circle_fill_rounded), findsOneWidget);

      await disposeReaderHarness(tester);
    },
  );

  testWidgets(
    'reader close button stops playback and closes the panel while keeping reader open',
    (tester) async {
      final feed = FakeQuranPlaybackFeed()
        ..update(
          playing: true,
          hasPlaybackSource: true,
          currentIndex: 1,
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
      container
          .read(quranActivePlaybackSessionProvider.notifier)
          .state = const QuranActivePlaybackSession(
        surahNumber: 1,
        ayahNumbers: <int>[1, 2, 3],
        reciterId: 'husary',
        playbackSpeed: 1,
        includeMediaTags: true,
        isSurahMode: true,
      );
      feed.emitDuration();
      feed.emitIndex();
      feed.emitPosition();
      feed.emitPlayerState();
      await tester.pumpAndSettle();

      expect(find.byType(QuranReaderPage), findsOneWidget);
      expect(
        find.byKey(const ValueKey('quran-reader-close-player')),
        findsOneWidget,
      );

      await tester.tap(find.byKey(const ValueKey('quran-reader-close-player')));
      await tester.pumpAndSettle();

      expect(find.byType(QuranReaderPage), findsOneWidget);
      expect(
        find.byKey(const ValueKey('quran-reader-close-player')),
        findsNothing,
      );
      expect(feed.playing, isFalse);
      expect(feed.hasPlaybackSource, isFalse);

      final ayahCardForPlay = find.byKey(
        const ValueKey('quran-ayah-card-1:2'),
        skipOffstage: false,
      );
      await tester.scrollUntilVisible(
        ayahCardForPlay,
        300,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();
      // Play moved into the tap-an-ayah details sheet in phase 7b.
      await tester.tap(ayahCardForPlay);
      await tester.pumpAndSettle();
      await tester.tap(
        find.byKey(const ValueKey('quran-reader-play-ayah-1:2')),
      );
      await tester.pumpAndSettle();

      expect(
        find.byKey(const ValueKey('quran-reader-close-player')),
        findsOneWidget,
      );
      expect(feed.hasPlaybackSource, isTrue);

      await disposeReaderHarness(tester);
    },
  );

  testWidgets(
    'real reader page stays stable across timing-ready and timing-missing highlight states',
    (tester) async {
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

      container
          .read(quranAudioSettingsProvider.notifier)
          .setReciterId('husary');
      container
          .read(quranReaderSettingsProvider.notifier)
          .setWordSyncHighlightBeta(true);
      container
          .read(quranActivePlaybackSessionProvider.notifier)
          .state = const QuranActivePlaybackSession(
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
        container
            .read(quranWordHighlightCoordinatorProvider(1))
            .activeWordIndex,
        1,
      );
      expect(
        find.byKey(const ValueKey('quran-reader-now-reciting-label')),
        findsOneWidget,
      );
      expect(find.textContaining('Verse 1:2'), findsOneWidget);

      container
          .read(quranActivePlaybackSessionProvider.notifier)
          .state = const QuranActivePlaybackSession(
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

      final highlightState = container.read(
        quranWordHighlightCoordinatorProvider(1),
      );
      expect(highlightState.activeAyahKey, '1:1');
      expect(highlightState.activeWordIndex, isNull);
      expect(highlightState.mode, QuranWordHighlightMode.noTimingAvailable);
      expect(
        find.byKey(const ValueKey('quran-reader-now-reciting-label')),
        findsOneWidget,
      );
      expect(find.textContaining('Verse 1:1'), findsOneWidget);

      await disposeReaderHarness(tester);
    },
  );

  testWidgets(
    'real reader page supports visible ayah tap playback and follow recovery',
    (tester) async {
      final feed = FakeQuranPlaybackFeed();
      final timingRepository = FakeQuranWordTimingRepository();
      addTearDown(feed.dispose);

      await tester.pumpWidget(
        await wrapReader(feed: feed, timingRepository: timingRepository),
      );
      final container = ProviderScope.containerOf(
        tester.element(find.byType(QuranReaderPage)),
      );
      await container.read(quranSurahAyahsProvider(1).future);
      await tester.pumpAndSettle();

      final ayahPlayButton = find.byKey(
        const ValueKey('quran-reader-play-ayah-1:2'),
        skipOffstage: false,
      );
      final ayahCard = find.byKey(
        const ValueKey('quran-ayah-card-1:2'),
        skipOffstage: false,
      );
      await tester.scrollUntilVisible(
        ayahCard,
        300,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();
      // Tapping the card now opens the details sheet; play lives inside it.
      await tester.tap(ayahCard);
      await tester.pumpAndSettle();
      await tester.tap(ayahPlayButton);
      await tester.pumpAndSettle();

      expect(feed.hasPlaybackSource, isTrue);
      expect(feed.currentIndex, 1);
      expect(find.byIcon(Icons.pause_circle_filled_rounded), findsOneWidget);

      feed.update(
        playing: false,
        hasPlaybackSource: false,
        currentIndex: null,
        position: Duration.zero,
        duration: null,
        processingState: ProcessingState.idle,
      );
      feed.emitDuration();
      feed.emitIndex();
      feed.emitPosition();
      feed.emitPlayerState();
      container.read(quranActivePlaybackSessionProvider.notifier).state = null;
      await tester.pumpAndSettle();

      await tester.scrollUntilVisible(
        ayahCard,
        300,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();
      await tester.tap(ayahCard);
      await tester.pumpAndSettle();
      await tester.tap(ayahPlayButton);
      await tester.pumpAndSettle();

      expect(feed.hasPlaybackSource, isTrue);
      expect(feed.currentIndex, 1);
      expect(find.byIcon(Icons.pause_circle_filled_rounded), findsOneWidget);

      await tester.tap(
        find.byKey(const ValueKey('quran-reader-play-pause-button')),
      );
      await tester.pumpAndSettle();
      expect(feed.playing, isFalse);

      await tester.tap(
        find.byKey(const ValueKey('quran-reader-play-pause-button')),
      );
      await tester.pumpAndSettle();
      expect(feed.playing, isTrue);

      await tester.drag(find.byType(CustomScrollView), const Offset(0, -300));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(
        container
            .read(quranReaderFollowModeCoordinatorProvider(1))
            .isTemporarilySuspended,
        isTrue,
      );
      expect(
        find.byKey(const ValueKey('quran-reader-return-to-current-ayah-pill')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey('quran-reader-return-to-current-ayah')),
        findsNothing,
      );

      await tester.tap(
        find.byKey(const ValueKey('quran-reader-return-to-current-ayah-pill')),
      );
      await tester.pumpAndSettle();
      // Let the programmatic return-to-ayah scroll retry timers finish so the
      // coordinator leaves its programmatic-scroll window before dragging.
      for (var i = 0; i < 30; i += 1) {
        await tester.pump(const Duration(milliseconds: 100));
      }

      expect(
        container
            .read(quranReaderFollowModeCoordinatorProvider(1))
            .isTemporarilySuspended,
        isFalse,
      );

      await tester.drag(find.byType(CustomScrollView), const Offset(0, -300));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(
        container
            .read(quranReaderFollowModeCoordinatorProvider(1))
            .isTemporarilySuspended,
        isTrue,
      );

      final ayahThreeCard = find.byKey(
        const ValueKey('quran-ayah-card-1:3'),
        skipOffstage: false,
      );
      await tester.scrollUntilVisible(
        ayahThreeCard,
        300,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();
      await tester.tap(ayahThreeCard);
      await tester.pumpAndSettle();
      await tester.tap(
        find.byKey(const ValueKey('quran-reader-play-ayah-1:3')),
      );
      await tester.pumpAndSettle();

      expect(feed.currentIndex, 2);
      expect(
        container
            .read(quranReaderFollowModeCoordinatorProvider(1))
            .isTemporarilySuspended,
        isFalse,
      );

      await disposeReaderHarness(tester);
    },
  );

  testWidgets(
    'reader continue listening card resumes from saved ayah or restarts the surah',
    (tester) async {
      final feed = FakeQuranPlaybackFeed();
      final timingRepository = FakeQuranWordTimingRepository();
      addTearDown(feed.dispose);

      await tester.pumpWidget(
        await wrapReader(feed: feed, timingRepository: timingRepository),
      );
      final container = ProviderScope.containerOf(
        tester.element(find.byType(QuranReaderPage)),
      );
      await container.read(quranSurahAyahsProvider(1).future);
      container
          .read(quranRecitationSessionProvider.notifier)
          .save(surahNumber: 1, ayahNumber: 3, positionSeconds: 18);
      await tester.pumpAndSettle();

      await tester.scrollUntilVisible(
        find.byKey(const ValueKey('quran-reader-continue-listening-card')),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();

      expect(
        find.byKey(const ValueKey('quran-reader-continue-listening-card')),
        findsOneWidget,
      );

      await tester.tap(
        find.byKey(const ValueKey('quran-reader-restart-surah-button')),
      );
      await tester.pumpAndSettle();
      expect(feed.currentIndex, 0);
      expect(feed.position, Duration.zero);

      feed.update(playing: false, processingState: ProcessingState.ready);
      feed.emitPlayerState();
      container
          .read(quranRecitationSessionProvider.notifier)
          .save(surahNumber: 1, ayahNumber: 3, positionSeconds: 18);
      await tester.pumpAndSettle();

      await tester.scrollUntilVisible(
        find.byKey(const ValueKey('quran-reader-resume-session-button')),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();

      await tester.ensureVisible(
        find.byKey(const ValueKey('quran-reader-resume-session-button')),
      );
      await tester.pump();
      await tester.tap(
        find.byKey(const ValueKey('quran-reader-resume-session-button')),
      );
      await tester.pumpAndSettle();
      expect(feed.currentIndex, 2);
      expect(feed.position, const Duration(seconds: 18));

      await disposeReaderHarness(tester);
    },
  );

  testWidgets(
    'reader settings surface renders regrouped sections and preserves key toggles',
    (tester) async {
      final feed = FakeQuranPlaybackFeed();
      final timingRepository = FakeQuranWordTimingRepository();
      addTearDown(feed.dispose);

      await tester.pumpWidget(
        await wrapReader(feed: feed, timingRepository: timingRepository),
      );
      final container = ProviderScope.containerOf(
        tester.element(find.byType(QuranReaderPage)),
      );
      await container.read(quranSurahAyahsProvider(1).future);
      await tester.pumpAndSettle();

      final scrollable = find.byType(Scrollable).first;
      await tester.scrollUntilVisible(
        find.byKey(const ValueKey('quran-reader-settings-toggle')),
        300,
        scrollable: scrollable,
      );
      await tester.pumpAndSettle();

      expect(find.text('Reading & Display'), findsOneWidget);

      await tester.tap(
        find.byKey(const ValueKey('quran-reader-setting-show-translation')),
      );
      await tester.pumpAndSettle();
      expect(
        container.read(quranReaderSettingsProvider).showTranslation,
        isFalse,
      );

      await tester.scrollUntilVisible(
        find.text('Audio & Playback'),
        300,
        scrollable: scrollable,
      );
      await tester.pumpAndSettle();
      expect(find.text('Audio & Playback'), findsOneWidget);

      await tester.scrollUntilVisible(
        find.text('Downloads & Offline'),
        300,
        scrollable: scrollable,
      );
      await tester.pumpAndSettle();
      expect(find.text('Downloads & Offline'), findsOneWidget);

      await tester.scrollUntilVisible(
        find.text('Study Tools'),
        300,
        scrollable: scrollable,
      );
      await tester.pumpAndSettle();
      expect(find.text('Study Tools'), findsOneWidget);

      await tester.scrollUntilVisible(
        find.text('Memorization & Review'),
        300,
        scrollable: scrollable,
      );
      await tester.pumpAndSettle();
      expect(find.text('Memorization & Review'), findsOneWidget);

      await tester.scrollUntilVisible(
        find.byKey(const ValueKey('quran-reader-settings-toggle')),
        -300,
        scrollable: scrollable,
      );
      await tester.pumpAndSettle();
      await tester.tap(
        find.byKey(const ValueKey('quran-reader-settings-toggle')),
      );
      await tester.pumpAndSettle();
      expect(find.text('Reading & Display'), findsNothing);

      await tester.tap(
        find.byKey(const ValueKey('quran-reader-settings-toggle')),
      );
      await tester.pumpAndSettle();
      expect(find.text('Reading & Display'), findsOneWidget);

      await disposeReaderHarness(tester);
    },
  );

  testWidgets(
    'route autoplay selection loop only plays the requested dua ayah range',
    (tester) async {
      final feed = FakeQuranPlaybackFeed();
      final timingRepository = FakeQuranWordTimingRepository();
      addTearDown(feed.dispose);

      await tester.pumpWidget(
        await wrapReader(
          feed: feed,
          timingRepository: timingRepository,
          page: const QuranReaderPage(
            surahNumber: 1,
            initialAyah: 2,
            endAyah: 3,
            autoPlay: true,
            autoPlayFocusedSelectionLoop: true,
          ),
        ),
      );
      final container = ProviderScope.containerOf(
        tester.element(find.byType(QuranReaderPage)),
      );
      final controller =
          container.read(quranPlayerControllerProvider)
              as _FakeRoutePlayerController;
      await container.read(quranSurahAyahsProvider(1).future);
      await tester.pumpAndSettle();
      // Advance the timers behind the initial-route scroll and autoplay chain,
      // which pumpAndSettle alone does not flush.
      for (var i = 0; i < 40; i += 1) {
        await tester.pump(const Duration(milliseconds: 100));
      }

      expect(feed.hasPlaybackSource, isTrue);
      expect(feed.currentIndex, 0);
      expect(controller.lastLoopMode, LoopMode.all);
      expect(controller.lastPreparedAyahNumbers, const <int>[2, 3]);

      await disposeReaderHarness(tester);
    },
  );
}
