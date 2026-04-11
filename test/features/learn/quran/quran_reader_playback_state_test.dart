import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/learn/quran/application/quran_player_controller.dart';
import 'package:path_of_nur/features/learn/quran/application/quran_reader_playback_state.dart';
import 'package:path_of_nur/features/learn/quran/domain/quran_ayah.dart';

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

  group('resolveQuranReaderPlaybackAyahKey', () {
    test('prefers current player index during surah playback', () {
      final key = resolveQuranReaderPlaybackAyahKey(
        currentSurahNumber: 1,
        isSurahPlaybackMode: true,
        surahPlaybackAyahs: ayahs,
        playerIndex: 2,
        fallbackAyahKey: '1:1',
        activeSession: const QuranActivePlaybackSession(
          surahNumber: 1,
          ayahNumbers: <int>[1, 2, 3],
          reciterId: 'husary',
          playbackSpeed: 1,
          includeMediaTags: true,
          isSurahMode: true,
        ),
      );

      expect(key, '1:3');
    });

    test(
      'falls back to remembered single-ayah session when local state drifted',
      () {
        final key = resolveQuranReaderPlaybackAyahKey(
          currentSurahNumber: 1,
          isSurahPlaybackMode: false,
          surahPlaybackAyahs: const <QuranAyah>[],
          playerIndex: 0,
          fallbackAyahKey: null,
          activeSession: const QuranActivePlaybackSession(
            surahNumber: 1,
            ayahNumbers: <int>[2],
            reciterId: 'husary',
            playbackSpeed: 1,
            includeMediaTags: true,
            isSurahMode: false,
          ),
        );

        expect(key, '1:2');
      },
    );

    test(
      'uses an explicit fallback ayah instead of snapping to the first session ayah when player index is temporarily unavailable',
      () {
        final key = resolveQuranReaderPlaybackAyahKey(
          currentSurahNumber: 1,
          isSurahPlaybackMode: true,
          surahPlaybackAyahs: const <QuranAyah>[],
          playerIndex: null,
          fallbackAyahKey: '1:3',
          activeSession: const QuranActivePlaybackSession(
            surahNumber: 1,
            ayahNumbers: <int>[1, 2, 3],
            reciterId: 'husary',
            playbackSpeed: 1,
            includeMediaTags: true,
            isSurahMode: true,
          ),
        );

        expect(key, '1:3');
      },
    );
  });

  test(
    'resolveQuranReaderPlaybackAyah maps the resolved key back to the ayah',
    () {
      final ayah = resolveQuranReaderPlaybackAyah(ayahs: ayahs, ayahKey: '1:2');

      expect(ayah, isNotNull);
      expect(ayah!.ayahNumber, 2);
    },
  );
}
