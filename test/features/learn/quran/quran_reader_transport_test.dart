import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/learn/quran/application/quran_reader_transport.dart';
import 'package:path_of_nur/features/learn/quran/domain/quran_ayah.dart';

void main() {
  const ayahs = <QuranAyah>[
    QuranAyah(surahNumber: 1, ayahNumber: 1, arabic: 'a', translation: 'a'),
    QuranAyah(surahNumber: 1, ayahNumber: 2, arabic: 'b', translation: 'b'),
    QuranAyah(surahNumber: 1, ayahNumber: 3, arabic: 'c', translation: 'c'),
  ];

  test('resolves active ayah index from surah playback player index', () {
    final index = resolveQuranReaderActiveAyahIndex(
      ayahs: ayahs,
      isSurahPlaybackMode: true,
      playerIndex: 1,
      currentAyahKey: '1:3',
    );

    expect(index, 1);
  });

  test('falls back to ayah key when not in surah playback mode', () {
    final index = resolveQuranReaderActiveAyahIndex(
      ayahs: ayahs,
      isSurahPlaybackMode: false,
      playerIndex: null,
      currentAyahKey: '1:3',
    );

    expect(index, 2);
  });

  test('transport actions stay within current surah boundaries', () {
    expect(
      resolveQuranReaderTransportIndex(
        ayahCount: ayahs.length,
        currentIndex: 0,
        action: QuranReaderTransportAction.previousAyah,
      ),
      0,
    );
    expect(
      resolveQuranReaderTransportIndex(
        ayahCount: ayahs.length,
        currentIndex: 1,
        action: QuranReaderTransportAction.restartAyah,
      ),
      1,
    );
    expect(
      resolveQuranReaderTransportIndex(
        ayahCount: ayahs.length,
        currentIndex: 2,
        action: QuranReaderTransportAction.nextAyah,
      ),
      2,
    );
  });
}
