import 'package:flutter_test/flutter_test.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_of_nur/features/learn/quran/application/quran_audio_resilience.dart';
import 'package:path_of_nur/features/learn/quran/domain/quran_audio_resilience_models.dart';

void main() {
  test('classifies network playback errors', () {
    final failure = classifyQuranPlaybackFailure(
      error: PlayerException(500, 'SocketException: network unreachable', 0),
      sourceType: QuranPlaybackSourceType.remoteStream,
    );

    expect(failure, QuranPlaybackFailureType.networkUnavailable);
  });

  test('classifies corrupt local playback errors', () {
    final failure = classifyQuranPlaybackFailure(
      error: PlayerException(500, 'Decoder failed on corrupt file', 0),
      sourceType: QuranPlaybackSourceType.localDownload,
    );

    expect(failure, QuranPlaybackFailureType.sourceCorrupt);
  });

  test('classifies reciter-switch failures explicitly', () {
    final failure = classifyQuranPlaybackFailure(
      error: PlayerException(404, 'source missing', 0),
      sourceType: QuranPlaybackSourceType.remoteStream,
      duringReciterSwitch: true,
    );

    expect(failure, QuranPlaybackFailureType.reciterUnavailable);
  });
}
