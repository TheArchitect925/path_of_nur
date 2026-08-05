import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_of_nur/features/learn/quran/application/quran_player_controller.dart';
import 'package:path_of_nur/features/learn/quran/application/quran_providers.dart';
import 'package:path_of_nur/features/learn/quran/application/quran_reader_playback_controller.dart';
import 'package:path_of_nur/features/learn/quran/application/quran_word_highlight_coordinator.dart';
import 'package:path_of_nur/features/learn/quran/data/quran_word_timing_repository.dart';
import 'package:path_of_nur/features/learn/quran/domain/quran_ayah.dart';
import 'package:path_of_nur/shared/persistence/local_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support/fake_quran_playback_feed.dart';
import 'support/fake_quran_word_timing_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

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
  ];

  Future<ProviderContainer> createContainer({
    required FakeQuranPlaybackFeed feed,
    required FakeQuranWordTimingRepository timingRepository,
  }) async {
    SharedPreferences.setMockInitialValues(const <String, Object>{});
    final prefs = await SharedPreferences.getInstance();
    final container = ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        quranPlaybackFeedProvider.overrideWithValue(feed),
        quranWordTimingRepositoryProvider.overrideWithValue(timingRepository),
        quranSurahAyahsProvider(1).overrideWith((ref) async => ayahs),
      ],
    );
    await container.read(quranSurahAyahsProvider(1).future);
    return container;
  }

  test('stays inactive when no active ayah is playing', () async {
    final feed = FakeQuranPlaybackFeed();
    final timingRepository = FakeQuranWordTimingRepository();
    final container = await createContainer(
      feed: feed,
      timingRepository: timingRepository,
    );
    final subscription = container.listen(
      quranWordHighlightCoordinatorProvider(1),
      (previous, next) {},
      fireImmediately: true,
    );
    addTearDown(() async {
      subscription.close();
      container.dispose();
      await feed.dispose();
    });

    final state = container.read(quranWordHighlightCoordinatorProvider(1));
    expect(state.mode, QuranWordHighlightMode.inactive);
    expect(state.activeWordIndex, isNull);
  });

  test('derives active word index when precise timing exists', () async {
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
    final container = await createContainer(
      feed: feed,
      timingRepository: timingRepository,
    );
    final subscription = container.listen(
      quranWordHighlightCoordinatorProvider(1),
      (previous, next) {},
      fireImmediately: true,
    );
    addTearDown(() async {
      subscription.close();
      container.dispose();
      await feed.dispose();
    });

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
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);

    final state = container.read(quranWordHighlightCoordinatorProvider(1));
    expect(state.activeAyahKey, '1:2');
    expect(state.mode, QuranWordHighlightMode.wordHighlightReady);
    expect(state.activeWordIndex, 1);
  });

  test(
    'degrades to ayah-only highlight when timing data is unavailable',
    () async {
      final feed = FakeQuranPlaybackFeed()
        ..update(
          playing: true,
          hasPlaybackSource: true,
          currentIndex: 0,
          position: const Duration(milliseconds: 800),
          duration: const Duration(seconds: 4),
          processingState: ProcessingState.ready,
        );
      final timingRepository = FakeQuranWordTimingRepository();
      final container = await createContainer(
        feed: feed,
        timingRepository: timingRepository,
      );
      final subscription = container.listen(
        quranWordHighlightCoordinatorProvider(1),
        (previous, next) {},
        fireImmediately: true,
      );
      addTearDown(() async {
        subscription.close();
        container.dispose();
        await feed.dispose();
      });

      container
          .read(quranReaderSettingsProvider.notifier)
          .setWordSyncHighlightBeta(true);
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
      feed.emitIndex();
      feed.emitPlayerState();
      feed.emitPosition();
      await Future<void>.delayed(Duration.zero);
      await Future<void>.delayed(Duration.zero);
      await Future<void>.delayed(Duration.zero);

      final state = container.read(quranWordHighlightCoordinatorProvider(1));
      expect(state.activeAyahKey, '1:1');
      expect(state.mode, QuranWordHighlightMode.noTimingAvailable);
      expect(state.activeWordIndex, isNull);
    },
  );

  test('reloads timing when reciter changes during active playback', () async {
    final feed = FakeQuranPlaybackFeed()
      ..update(
        playing: true,
        hasPlaybackSource: true,
        currentIndex: 0,
        position: const Duration(milliseconds: 300),
        duration: const Duration(seconds: 4),
        processingState: ProcessingState.ready,
      );
    final timingRepository = FakeQuranWordTimingRepository(
      timings: <String, List<QuranWordTimingSegment>>{
        'husary:1:2': const <QuranWordTimingSegment>[
          QuranWordTimingSegment(wordIndex: 0, startMs: 0, endMs: 500),
        ],
        'alafasy:1:2': const <QuranWordTimingSegment>[
          QuranWordTimingSegment(wordIndex: 1, startMs: 0, endMs: 500),
        ],
      },
    );
    final container = await createContainer(
      feed: feed,
      timingRepository: timingRepository,
    );
    final subscription = container.listen(
      quranWordHighlightCoordinatorProvider(1),
      (previous, next) {},
      fireImmediately: true,
    );
    addTearDown(() async {
      subscription.close();
      container.dispose();
      await feed.dispose();
    });

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
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);

    expect(
      container.read(quranWordHighlightCoordinatorProvider(1)).activeWordIndex,
      0,
    );

    container.read(quranAudioSettingsProvider.notifier).setReciterId('alafasy');
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);

    final state = container.read(quranWordHighlightCoordinatorProvider(1));
    expect(state.activeWordIndex, 1);
    expect(
      timingRepository.requests,
      containsAll(<String>['husary:1:2', 'alafasy:1:2']),
    );
  });
}
