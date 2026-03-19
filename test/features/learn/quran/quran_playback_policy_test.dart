import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/learn/quran/application/quran_playback_policy.dart';
import 'package:path_of_nur/features/learn/quran/domain/bismillah_playback_mode.dart';
import 'package:path_of_nur/features/learn/quran/domain/quran_audio_source_metadata.dart';
import 'package:path_of_nur/features/learn/quran/domain/quran_content_refs.dart';
import 'package:path_of_nur/features/learn/quran/domain/quran_playback_request.dart';

QuranAudioSourceMetadata _metadata({
  required bool sourceContainsBismillahAtStart,
  bool includesBismillahAtSurahStarts = false,
}) {
  return QuranAudioSourceMetadata(
    surahNumber: 2,
    ayahNumber: 1,
    reciterId: 'husary',
    source: 'https://example.test/002001.mp3',
    sourceContainsBismillahAtStart: sourceContainsBismillahAtStart,
    sourceId: const QuranAudioSourceId('example.husary'),
    isAyahGranular: true,
    includesBismillahInFatiha: true,
    includesBismillahAtSurahStarts: includesBismillahAtSurahStarts,
    hasStandaloneBismillahClip: false,
    standaloneBismillahRef: const QuranAudioRef(
      surah: 1,
      ayah: 1,
      reciterId: 'husary',
    ),
    surah9HasNoBismillahIntroInSource: false,
    confidence: QuranAudioMetadataConfidence.unknownNeedsManualReview,
    manualReviewNeeded: true,
  );
}

void main() {
  const policy = QuranPlaybackPolicy();

  test('surah transition prepends Bismillah in alwaysPrepend mode', () {
    final shouldPlay = policy.shouldPlayBismillahBefore(
      const QuranPlaybackRequest(
        surahNumber: 2,
        ayahNumber: 1,
        playbackReason: QuranPlaybackReason.jump,
        isSurahEntry: true,
        isSurahTransition: true,
        originatingSurahNumber: 1,
      ),
      _metadata(sourceContainsBismillahAtStart: false),
    );

    expect(shouldPlay, isTrue);
  });

  test(
    'sourceAware mode avoids duplicate Bismillah on surah transition when source embeds it',
    () {
      final shouldPlay = policy.shouldPlayBismillahBefore(
        const QuranPlaybackRequest(
          surahNumber: 2,
          ayahNumber: 1,
          playbackReason: QuranPlaybackReason.jump,
          isSurahEntry: true,
          isSurahTransition: true,
          originatingSurahNumber: 1,
        ),
        _metadata(
          sourceContainsBismillahAtStart: true,
          includesBismillahAtSurahStarts: true,
        ),
        mode: BismillahPlaybackMode.sourceAware,
      );

      expect(shouldPlay, isFalse);
    },
  );
}
