import '../domain/quran_ayah.dart';
import 'quran_player_controller.dart';

String quranPlaybackAyahKey({
  required int surahNumber,
  required int ayahNumber,
}) => '$surahNumber:$ayahNumber';

String? resolveQuranReaderPlaybackAyahKey({
  required int currentSurahNumber,
  required bool isSurahPlaybackMode,
  required List<QuranAyah> surahPlaybackAyahs,
  required int? playerIndex,
  required String? fallbackAyahKey,
  required QuranActivePlaybackSession? activeSession,
}) {
  if (isSurahPlaybackMode) {
    if (playerIndex != null &&
        playerIndex >= 0 &&
        playerIndex < surahPlaybackAyahs.length) {
      final ayah = surahPlaybackAyahs[playerIndex];
      return quranPlaybackAyahKey(
        surahNumber: ayah.surahNumber,
        ayahNumber: ayah.ayahNumber,
      );
    }
    if (_isValidAyahKey(fallbackAyahKey)) {
      return fallbackAyahKey;
    }
    if (activeSession != null &&
        activeSession.isSurahMode &&
        activeSession.surahNumber == currentSurahNumber &&
        playerIndex != null &&
        playerIndex >= 0 &&
        playerIndex < activeSession.ayahNumbers.length) {
      return quranPlaybackAyahKey(
        surahNumber: currentSurahNumber,
        ayahNumber: activeSession.ayahNumbers[playerIndex],
      );
    }
    return null;
  }

  if (_isValidAyahKey(fallbackAyahKey)) {
    return fallbackAyahKey;
  }

  if (activeSession != null &&
      !activeSession.isSurahMode &&
      activeSession.surahNumber == currentSurahNumber &&
      activeSession.ayahNumbers.length == 1) {
    return quranPlaybackAyahKey(
      surahNumber: currentSurahNumber,
      ayahNumber: activeSession.ayahNumbers.first,
    );
  }

  return null;
}

QuranAyah? resolveQuranReaderPlaybackAyah({
  required List<QuranAyah> ayahs,
  required String? ayahKey,
}) {
  if (!_isValidAyahKey(ayahKey)) {
    return null;
  }
  final parts = ayahKey!.split(':');
  final surahNumber = int.tryParse(parts[0]);
  final ayahNumber = int.tryParse(parts[1]);
  if (surahNumber == null || ayahNumber == null) {
    return null;
  }
  for (final ayah in ayahs) {
    if (ayah.surahNumber == surahNumber && ayah.ayahNumber == ayahNumber) {
      return ayah;
    }
  }
  return null;
}

bool _isValidAyahKey(String? value) {
  if (value == null || value.isEmpty) {
    return false;
  }
  final parts = value.split(':');
  if (parts.length != 2) {
    return false;
  }
  return int.tryParse(parts[0]) != null && int.tryParse(parts[1]) != null;
}
