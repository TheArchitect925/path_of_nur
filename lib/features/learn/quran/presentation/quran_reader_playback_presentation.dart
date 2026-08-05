import '../../../../l10n/app_localizations.dart';
import '../application/quran_reader_playback_controller.dart';
import '../domain/quran_audio_resilience_models.dart';

String? buildQuranReaderNowPlayingLabel({
  required AppLocalizations l10n,
  required QuranReaderPlaybackState playbackState,
  required Map<int, dynamic> surahMap,
}) {
  final surahNumber = playbackState.activeSurahNumber;
  final ayahNumber = playbackState.activeAyahNumber;
  final resolvedSurahNumber =
      surahNumber ?? playbackState.storedSession?.surahNumber;
  final resolvedAyahNumber =
      ayahNumber ?? playbackState.storedSession?.ayahNumber;
  if (resolvedSurahNumber == null || resolvedAyahNumber == null) {
    return null;
  }

  final surahArabicName = surahMap[resolvedSurahNumber]?.arabicName as String?;
  final surahLabel = surahArabicName == null || surahArabicName.isEmpty
      ? l10n.quranReaderNowPlayingFallbackSurahLabel(resolvedSurahNumber)
      : surahArabicName;

  return l10n.quranReaderNowPlayingLabel(
    surahLabel,
    '$resolvedSurahNumber:$resolvedAyahNumber',
  );
}

String buildQuranPlaybackStatusLabel({
  required AppLocalizations l10n,
  required QuranReaderPlaybackState playbackState,
}) {
  if (playbackState.failureType != null) {
    return switch (playbackState.failureType!) {
      QuranPlaybackFailureType.networkUnavailable =>
        l10n.quranPlaybackFailureNetworkUnavailable,
      QuranPlaybackFailureType.sourceMissing =>
        l10n.quranPlaybackFailureSourceMissing,
      QuranPlaybackFailureType.sourceCorrupt =>
        l10n.quranPlaybackFailureSourceCorrupt,
      QuranPlaybackFailureType.reciterUnavailable =>
        l10n.quranPlaybackFailureReciterUnavailable,
      QuranPlaybackFailureType.bufferingTimeout =>
        l10n.quranPlaybackFailureBufferingTimeout,
      QuranPlaybackFailureType.sessionRestoreFailed =>
        l10n.quranPlaybackFailureSessionRestore,
      QuranPlaybackFailureType.unknown => l10n.quranPlaybackFailureUnknown,
    };
  }

  if (playbackState.sourceResolutionState ==
      QuranPlaybackSourceResolutionState.preparingTransition) {
    return l10n.accessibilityPreparingPlayback;
  }
  if (playbackState.sourceResolutionState ==
      QuranPlaybackSourceResolutionState.buffering) {
    return l10n.quranPlaybackStatusBuffering;
  }
  if (playbackState.sourceResolutionState ==
      QuranPlaybackSourceResolutionState.resolving) {
    return l10n.quranPlaybackStatusResolving;
  }
  if (playbackState.didApplyFallback) {
    return switch (playbackState.activeSourceType) {
      QuranPlaybackSourceType.localDownload =>
        l10n.quranPlaybackFallbackUsingDownloaded,
      QuranPlaybackSourceType.remoteStream =>
        l10n.quranPlaybackFallbackUsingStream,
      QuranPlaybackSourceType.unavailable => l10n.quranPlaybackFailureUnknown,
    };
  }
  return playbackState.isPlaying
      ? l10n.shellQuranMiniPlayerPlaying
      : l10n.shellQuranMiniPlayerPaused;
}

String? buildQuranPlaybackSourceStatusLabel({
  required AppLocalizations l10n,
  required QuranReaderPlaybackState playbackState,
}) {
  if (playbackState.failureType != null) {
    return buildQuranPlaybackStatusLabel(
      l10n: l10n,
      playbackState: playbackState,
    );
  }
  if (playbackState.sourceResolutionState ==
      QuranPlaybackSourceResolutionState.preparingTransition) {
    return l10n.accessibilityPreparingPlayback;
  }
  if (playbackState.sourceResolutionState ==
      QuranPlaybackSourceResolutionState.buffering) {
    return l10n.quranPlaybackStatusBuffering;
  }
  if (playbackState.sourceResolutionState ==
      QuranPlaybackSourceResolutionState.resolving) {
    return l10n.quranPlaybackStatusResolving;
  }
  if (playbackState.didApplyFallback) {
    return buildQuranPlaybackStatusLabel(
      l10n: l10n,
      playbackState: playbackState,
    );
  }
  return null;
}
