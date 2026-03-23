import '../domain/quran_ayah.dart';

enum QuranReaderTransportAction { previousAyah, restartAyah, nextAyah }

int? resolveQuranReaderActiveAyahIndex({
  required List<QuranAyah> ayahs,
  required bool isSurahPlaybackMode,
  required int? playerIndex,
  required String? currentAyahKey,
}) {
  if (ayahs.isEmpty) return null;
  if (isSurahPlaybackMode &&
      playerIndex != null &&
      playerIndex >= 0 &&
      playerIndex < ayahs.length) {
    return playerIndex;
  }
  if (currentAyahKey == null || currentAyahKey.isEmpty) return null;
  final parts = currentAyahKey.split(':');
  if (parts.length != 2) return null;
  final surahNumber = int.tryParse(parts[0]);
  final ayahNumber = int.tryParse(parts[1]);
  if (surahNumber == null || ayahNumber == null) return null;
  for (var index = 0; index < ayahs.length; index += 1) {
    final ayah = ayahs[index];
    if (ayah.surahNumber == surahNumber && ayah.ayahNumber == ayahNumber) {
      return index;
    }
  }
  return null;
}

int? resolveQuranReaderTransportIndex({
  required int ayahCount,
  required int? currentIndex,
  required QuranReaderTransportAction action,
}) {
  if (ayahCount <= 0 || currentIndex == null) return null;
  final clampedCurrent = currentIndex.clamp(0, ayahCount - 1);
  switch (action) {
    case QuranReaderTransportAction.previousAyah:
      return clampedCurrent == 0 ? 0 : clampedCurrent - 1;
    case QuranReaderTransportAction.restartAyah:
      return clampedCurrent;
    case QuranReaderTransportAction.nextAyah:
      return clampedCurrent >= ayahCount - 1
          ? ayahCount - 1
          : clampedCurrent + 1;
  }
}
