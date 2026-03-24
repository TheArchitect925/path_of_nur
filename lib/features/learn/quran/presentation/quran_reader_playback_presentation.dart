import '../../../../l10n/app_localizations.dart';
import '../application/quran_reader_playback_controller.dart';

String? buildQuranReaderNowPlayingLabel({
  required AppLocalizations l10n,
  required QuranReaderPlaybackState playbackState,
  required Map<int, dynamic> surahMap,
}) {
  final surahNumber = playbackState.activeSurahNumber;
  final ayahNumber = playbackState.activeAyahNumber;
  if (surahNumber == null || ayahNumber == null) {
    return null;
  }

  final surahArabicName = surahMap[surahNumber]?.arabicName as String?;
  final surahLabel =
      surahArabicName == null || surahArabicName.isEmpty
      ? l10n.quranReaderNowPlayingFallbackSurahLabel(surahNumber)
      : surahArabicName;

  return l10n.quranReaderNowPlayingLabel(
    surahLabel,
    '$surahNumber:$ayahNumber',
  );
}
