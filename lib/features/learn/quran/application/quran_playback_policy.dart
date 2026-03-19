import '../domain/bismillah_playback_mode.dart';
import '../domain/quran_audio_source_metadata.dart';
import '../domain/quran_playback_request.dart';

class QuranPlaybackPolicy {
  const QuranPlaybackPolicy();

  bool shouldPlayBismillahOnSurahTransition(
    int fromSurah,
    int toSurah,
    QuranAudioSourceMetadata metadata, {
    BismillahPlaybackMode mode = defaultBismillahPlaybackMode,
  }) {
    if (fromSurah == toSurah) {
      return false;
    }
    return shouldPlayBismillahBeforeEntry(
      metadata,
      mode: mode,
      isSurahTransition: true,
    );
  }

  bool shouldPlayBismillahBeforeEntry(
    QuranAudioSourceMetadata metadata, {
    BismillahPlaybackMode mode = defaultBismillahPlaybackMode,
    bool isSurahTransition = false,
  }) {
    switch (mode) {
      case BismillahPlaybackMode.disabled:
        return false;
      case BismillahPlaybackMode.sourceAware:
        if (isSurahTransition &&
            metadata.includesBismillahAtSurahStarts &&
            !metadata.surah9HasNoBismillahIntroInSource) {
          return false;
        }
        return !metadata.sourceContainsBismillahAtStart;
      case BismillahPlaybackMode.alwaysPrepend:
        return true;
    }
  }

  bool shouldPlayBismillahBefore(
    QuranPlaybackRequest request,
    QuranAudioSourceMetadata metadata, {
    BismillahPlaybackMode mode = defaultBismillahPlaybackMode,
  }) {
    if (request.isSurahTransition &&
        request.originatingSurahNumber != null &&
        request.originatingSurahNumber != request.targetSurahNumber) {
      return shouldPlayBismillahOnSurahTransition(
        request.originatingSurahNumber!,
        request.targetSurahNumber,
        metadata,
        mode: mode,
      );
    }
    return shouldPlayBismillahBeforeEntry(
      metadata,
      mode: mode,
      isSurahTransition: request.isSurahTransition,
    );
  }
}
