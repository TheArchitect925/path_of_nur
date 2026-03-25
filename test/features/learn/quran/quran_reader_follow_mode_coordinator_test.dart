import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_of_nur/features/learn/quran/application/quran_player_controller.dart';
import 'package:path_of_nur/features/learn/quran/application/quran_providers.dart';
import 'package:path_of_nur/features/learn/quran/application/quran_reader_follow_mode_coordinator.dart';
import 'package:path_of_nur/features/learn/quran/application/quran_reader_playback_controller.dart';
import 'package:path_of_nur/features/learn/quran/domain/quran_ayah.dart';
import 'package:path_of_nur/shared/persistence/local_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support/fake_quran_playback_feed.dart';

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
    QuranAyah(
      surahNumber: 1,
      ayahNumber: 3,
      arabic: 'الرَّحْمَٰنِ الرَّحِيمِ',
      translation: 'The Most Merciful, the Especially Merciful',
    ),
  ];

  Future<ProviderContainer> createContainer(FakeQuranPlaybackFeed feed) async {
    SharedPreferences.setMockInitialValues(const <String, Object>{});
    final prefs = await SharedPreferences.getInstance();
    final container = ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        quranPlaybackFeedProvider.overrideWithValue(feed),
        quranSurahAyahsProvider(1).overrideWith((ref) async => ayahs),
      ],
    );
    await container.read(quranSurahAyahsProvider(1).future);
    return container;
  }

  test('queues a scroll request when the active ayah changes', () async {
    final feed = FakeQuranPlaybackFeed()
      ..update(
        playing: true,
        hasPlaybackSource: true,
        currentIndex: 1,
        processingState: ProcessingState.ready,
      );
    final container = await createContainer(feed);
    final subscription = container.listen(
      quranReaderFollowModeCoordinatorProvider(1),
      (previous, next) {},
      fireImmediately: true,
    );
    addTearDown(() async {
      subscription.close();
      container.dispose();
      await feed.dispose();
    });

    container.read(quranActivePlaybackSessionProvider.notifier).state =
        const QuranActivePlaybackSession(
          surahNumber: 1,
          ayahNumbers: <int>[1, 2, 3],
          reciterId: 'husary',
          playbackSpeed: 1,
          includeMediaTags: true,
          isSurahMode: true,
        );
    feed.emitIndex();
    feed.emitPlayerState();
    await Future<void>.delayed(Duration.zero);

    final state = container.read(quranReaderFollowModeCoordinatorProvider(1));
    expect(state.followModeEnabled, isTrue);
    expect(state.activeAyahNumber, 2);
    expect(state.pendingScrollAyahNumber, 2);
    expect(state.shouldAutoScroll, isTrue);
  });

  test('manual scroll suspension blocks new follow scroll requests until resumed', () async {
    final feed = FakeQuranPlaybackFeed()
      ..update(
        playing: true,
        hasPlaybackSource: true,
        currentIndex: 0,
        processingState: ProcessingState.ready,
      );
    final container = await createContainer(feed);
    final subscription = container.listen(
      quranReaderFollowModeCoordinatorProvider(1),
      (previous, next) {},
      fireImmediately: true,
    );
    addTearDown(() async {
      subscription.close();
      container.dispose();
      await feed.dispose();
    });

    container.read(quranActivePlaybackSessionProvider.notifier).state =
        const QuranActivePlaybackSession(
          surahNumber: 1,
          ayahNumbers: <int>[1, 2, 3],
          reciterId: 'husary',
          playbackSpeed: 1,
          includeMediaTags: true,
          isSurahMode: true,
        );
    feed.emitIndex();
    feed.emitPlayerState();
    await Future<void>.delayed(Duration.zero);

    final notifier = container.read(
      quranReaderFollowModeCoordinatorProvider(1).notifier,
    );
    notifier.handleUserScrollInteraction();
    final suspended = container.read(quranReaderFollowModeCoordinatorProvider(1));
    final suspendedRequestVersion = suspended.scrollRequestVersion;

    feed.update(currentIndex: 2);
    feed.emitIndex();
    await Future<void>.delayed(Duration.zero);

    final state = container.read(quranReaderFollowModeCoordinatorProvider(1));
    expect(state.isTemporarilySuspended, isTrue);
    expect(state.activeAyahNumber, 3);
    expect(state.scrollRequestVersion, suspendedRequestVersion);
    expect(state.pendingScrollAyahNumber, isNull);
  });

  test('returning to the current ayah clears suspension and queues a fresh scroll', () async {
    final feed = FakeQuranPlaybackFeed()
      ..update(
        playing: true,
        hasPlaybackSource: true,
        currentIndex: 1,
        processingState: ProcessingState.ready,
      );
    final container = await createContainer(feed);
    final subscription = container.listen(
      quranReaderFollowModeCoordinatorProvider(1),
      (previous, next) {},
      fireImmediately: true,
    );
    addTearDown(() async {
      subscription.close();
      container.dispose();
      await feed.dispose();
    });

    container.read(quranActivePlaybackSessionProvider.notifier).state =
        const QuranActivePlaybackSession(
          surahNumber: 1,
          ayahNumbers: <int>[1, 2, 3],
          reciterId: 'husary',
          playbackSpeed: 1,
          includeMediaTags: true,
          isSurahMode: true,
        );
    feed.emitIndex();
    feed.emitPlayerState();
    await Future<void>.delayed(Duration.zero);

    final notifier = container.read(
      quranReaderFollowModeCoordinatorProvider(1).notifier,
    );
    notifier.handleUserScrollInteraction();
    notifier.requestReturnToCurrentAyah();

    final state = container.read(quranReaderFollowModeCoordinatorProvider(1));
    expect(state.isTemporarilySuspended, isFalse);
    expect(state.pendingScrollAyahNumber, 2);
    expect(state.canReturnToCurrentAyah, isFalse);
  });
}
