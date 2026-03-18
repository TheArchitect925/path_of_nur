import 'package:flutter_test/flutter_test.dart';

import 'package:path_of_nur/features/learn/quran/application/quran_providers.dart';
import 'package:path_of_nur/features/learn/quran/data/quran_audio_repository.dart';
import 'package:path_of_nur/shared/persistence/local_store.dart';

import '../../../test_helpers/app_test_harness.dart';

void main() {
  test('quran audio settings provider exposes stable defaults', () async {
    final container = await makeTestContainer();
    addTearDown(container.dispose);

    final state = container.read(quranAudioSettingsProvider);
    expect(state.playbackSpeed, 1.0);
    expect(state.ayahLoopCount, 1);
    expect(state.backgroundPlaybackEnabled, isTrue);
    expect(state.reciterId, 'husary');
  });

  test('quran audio settings sanitize invalid stored values on load', () async {
    final container = await makeTestContainer();
    addTearDown(container.dispose);
    final store = container.read(localStoreProvider);

    store.setJsonMap('learn.quran.audioSettings', <String, dynamic>{
      'playbackSpeed': 5.0,
      'ayahLoopCount': 99,
      'reciterId': 'missing-reciter',
      'backgroundPlaybackEnabled': false,
    });

    final state = container.read(quranAudioSettingsProvider);

    expect(state.playbackSpeed, 1.2);
    expect(state.ayahLoopCount, 12);
    expect(state.reciterId, QuranAudioRepository.reciters.first.id);
    expect(state.backgroundPlaybackEnabled, isFalse);
  });

  test(
    'quran audio settings notifier clamps and persists valid changes',
    () async {
      final container = await makeTestContainer();
      addTearDown(container.dispose);
      final notifier = container.read(quranAudioSettingsProvider.notifier);
      final store = container.read(localStoreProvider);

      notifier.setPlaybackSpeed(0.2);
      notifier.setAyahLoopCount(30);
      notifier.setReciterId('not-a-reciter');
      notifier.setBackgroundPlaybackEnabled(false);

      final state = container.read(quranAudioSettingsProvider);
      final saved = store.getJsonMap('learn.quran.audioSettings');

      expect(state.playbackSpeed, 0.6);
      expect(state.ayahLoopCount, 12);
      expect(state.reciterId, 'husary');
      expect(state.backgroundPlaybackEnabled, isFalse);
      expect(saved?['playbackSpeed'], 0.6);
      expect(saved?['ayahLoopCount'], 12);
      expect(saved?['backgroundPlaybackEnabled'], isFalse);
    },
  );
}
