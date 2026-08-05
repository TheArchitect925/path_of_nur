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

  test('global playback state exposes transport and repeat metadata', () async {
    final feed = FakeQuranPlaybackFeed()
      ..update(
        playing: true,
        hasPlaybackSource: true,
        currentIndex: 1,
        position: const Duration(seconds: 8),
        duration: const Duration(seconds: 90),
        processingState: ProcessingState.ready,
      );
    final container = await createContainer(feed);
    addTearDown(() async {
      container.dispose();
      await feed.dispose();
    });

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
    container
        .read(quranAudioSettingsProvider.notifier)
        .setRepeatRange(startAyah: 2, endAyah: 3);
    container.read(quranAudioSettingsProvider.notifier).setAyahLoopCount(3);
    feed.emitIndex();
    feed.emitPlayerState();
    feed.emitPosition();
    await Future<void>.delayed(Duration.zero);

    final state = container.read(quranGlobalPlaybackStateProvider);
    expect(state.activeAyahKey, '1:2');
    expect(state.canPause, isTrue);
    expect(state.canGoPreviousAyah, isTrue);
    expect(state.canGoNextAyah, isTrue);
    expect(state.previousAyahNumber, 1);
    expect(state.nextAyahNumber, 3);
    expect(state.canGoNextSurah, isTrue);
    expect(state.hasRepeatConfigured, isTrue);
    expect(state.repeatStartAyah, 2);
    expect(state.repeatEndAyah, 3);
    expect(state.ayahLoopCount, 3);
  });
}
