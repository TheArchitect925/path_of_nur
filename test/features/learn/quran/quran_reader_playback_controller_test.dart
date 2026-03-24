import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_of_nur/features/learn/quran/application/quran_player_controller.dart';
import 'package:path_of_nur/features/learn/quran/application/quran_providers.dart';
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

  test('starts idle with no active playback source', () async {
    final feed = FakeQuranPlaybackFeed();
    final container = await createContainer(feed);
    addTearDown(() async {
      container.dispose();
      await feed.dispose();
    });

    final state = container.read(quranReaderPlaybackControllerProvider(1));

    expect(state.status, QuranReaderPlaybackStatus.idle);
    expect(state.hasPlayback, isFalse);
    expect(state.activeAyahKey, isNull);
  });

  test('maps active ayah and now-playing metadata from live surah playback', () async {
    final feed = FakeQuranPlaybackFeed()
      ..update(
        playing: true,
        hasPlaybackSource: true,
        currentIndex: 1,
        position: const Duration(seconds: 12),
        duration: const Duration(seconds: 90),
        processingState: ProcessingState.ready,
      );
    final container = await createContainer(feed);
    addTearDown(() async {
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
    feed.emitPosition();
    await Future<void>.delayed(Duration.zero);

    final state = container.read(quranReaderPlaybackControllerProvider(1));
    expect(state.status, QuranReaderPlaybackStatus.playing);
    expect(state.activeAyahKey, '1:2');
    expect(state.activeSurahNumber, 1);
    expect(state.activeAyahNumber, 2);
  });

  test('pause and resume transitions stay normalized', () async {
    final feed = FakeQuranPlaybackFeed()
      ..update(
        playing: true,
        hasPlaybackSource: true,
        currentIndex: 0,
        processingState: ProcessingState.ready,
      );
    final container = await createContainer(feed);
    addTearDown(() async {
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

    expect(
      container.read(quranReaderPlaybackControllerProvider(1)).status,
      QuranReaderPlaybackStatus.playing,
    );

    feed.update(playing: false, processingState: ProcessingState.ready);
    feed.emitPlayerState();
    await Future<void>.delayed(Duration.zero);

    expect(
      container.read(quranReaderPlaybackControllerProvider(1)).status,
      QuranReaderPlaybackStatus.paused,
    );

    feed.update(playing: true, processingState: ProcessingState.ready);
    feed.emitPlayerState();
    await Future<void>.delayed(Duration.zero);

    expect(
      container.read(quranReaderPlaybackControllerProvider(1)).status,
      QuranReaderPlaybackStatus.playing,
    );
  });

  test('stored recitation session remains available without presenting active playback', () async {
    final feed = FakeQuranPlaybackFeed();
    final container = await createContainer(feed);
    addTearDown(() async {
      container.dispose();
      await feed.dispose();
    });

    container
        .read(quranRecitationSessionProvider.notifier)
        .save(surahNumber: 1, ayahNumber: 3, positionSeconds: 18);
    await Future<void>.delayed(Duration.zero);

    final state = container.read(quranReaderPlaybackControllerProvider(1));
    expect(state.activeAyahKey, isNull);
    expect(state.storedSession?.positionSeconds, 18);
  });

  test('reciter metadata follows settings changes without losing active ayah', () async {
    final feed = FakeQuranPlaybackFeed()
      ..update(
        playing: true,
        hasPlaybackSource: true,
        currentIndex: 1,
        processingState: ProcessingState.ready,
      );
    final container = await createContainer(feed);
    addTearDown(() async {
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

    container.read(quranAudioSettingsProvider.notifier).setReciterId('alafasy');
    await Future<void>.delayed(Duration.zero);

    final state = container.read(quranReaderPlaybackControllerProvider(1));
    expect(state.activeAyahKey, '1:2');
    expect(state.reciterId, 'alafasy');
    expect(state.reciterName.toLowerCase(), contains('afasy'));
  });
}
