import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:path_of_nur/features/arabic/application/arabic_learning_audio_controller.dart';
import 'package:path_of_nur/features/arabic/application/arabic_learning_asset_bundle.dart';
import 'package:path_of_nur/features/arabic/data/arabic_beginner_content_catalog.dart';
import 'package:path_of_nur/features/arabic/domain/arabic_learning_audio_models.dart';
import 'package:path_of_nur/shared/persistence/local_store.dart';

import '../../test_helpers/app_test_harness.dart';

class _FakeArabicLearningAudioBackend implements ArabicLearningAudioBackend {
  _FakeArabicLearningAudioBackend({this.playableAssets = const <String>{}});

  final Set<String> playableAssets;
  final List<String> playedAssets = <String>[];
  final List<String> spokenTexts = <String>[];
  int stopCount = 0;

  @override
  Future<void> dispose() async {}

  @override
  Future<bool> playAsset(String path, {required double speed}) async {
    playedAssets.add(path);
    return playableAssets.contains(path);
  }

  @override
  Future<bool> speakText(String text, {required double rate}) async {
    spokenTexts.add(text);
    return true;
  }

  @override
  Future<void> stop() async {
    stopCount += 1;
  }
}

class _FakeArabicLearningAssetBundle implements ArabicLearningAssetBundle {
  _FakeArabicLearningAssetBundle(this._availableAssets);

  final Set<String> _availableAssets;
  final List<String> prewarmedAssets = <String>[];

  @override
  Future<Set<String>> assetKeys() async => _availableAssets;

  @override
  Future<List<String>> availableAssets(Iterable<String> candidates) async {
    return candidates
        .where((path) => _availableAssets.contains(path))
        .toList(growable: false);
  }

  @override
  Future<String?> firstAvailableAsset(Iterable<String> candidates) async {
    for (final candidate in candidates) {
      if (_availableAssets.contains(candidate)) {
        return candidate;
      }
    }
    return null;
  }

  @override
  Future<void> prewarmAssets(Iterable<String> assetPaths) async {
    prewarmedAssets.addAll(
      assetPaths.where((path) => _availableAssets.contains(path)),
    );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'shared Arabic audio controller defaults to normal speed and persists slow mode',
    () async {
      final backend = _FakeArabicLearningAudioBackend();
      final bundle = _FakeArabicLearningAssetBundle(const <String>{});
      final container = await makeTestContainer(
        overrides: <Override>[
          arabicLearningAudioBackendProvider.overrideWithValue(backend),
          arabicLearningAssetBundleProvider.overrideWithValue(bundle),
        ],
      );
      addTearDown(container.dispose);

      expect(
        container.read(arabicLearningAudioControllerProvider).playbackSpeed,
        ArabicLearningPlaybackSpeed.normal,
      );

      await container
          .read(arabicLearningAudioControllerProvider.notifier)
          .setPlaybackSpeed(ArabicLearningPlaybackSpeed.slow);

      expect(
        container.read(arabicLearningAudioControllerProvider).playbackSpeed,
        ArabicLearningPlaybackSpeed.slow,
      );
      expect(
        container
            .read(localStoreProvider)
            .getBool('arabic.learning.audio.slow.v1'),
        isTrue,
      );
    },
  );

  test(
    'shared Arabic audio controller prefers bundled word audio and falls back to Arabic text',
    () async {
      final backend = _FakeArabicLearningAudioBackend(
        playableAssets: <String>{'assets/audio/quran_teacher/words/noor.mp3'},
      );
      final bundle = _FakeArabicLearningAssetBundle(<String>{
        'assets/audio/quran_teacher/words/noor.mp3',
      });
      final container = await makeTestContainer(
        overrides: <Override>[
          arabicLearningAudioBackendProvider.overrideWithValue(backend),
          arabicLearningAssetBundleProvider.overrideWithValue(bundle),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(
        arabicLearningAudioControllerProvider.notifier,
      );

      await notifier.playBeginnerWord(arabicSharedBeginnerWordById('noor')!);
      await notifier.playBeginnerWord(arabicSharedBeginnerWordById('qalam')!);

      expect(
        backend.playedAssets,
        contains('assets/audio/quran_teacher/words/noor.mp3'),
      );
      expect(
        bundle.prewarmedAssets,
        contains('assets/audio/quran_teacher/words/noor.mp3'),
      );
      expect(backend.spokenTexts, contains('قلم'));
      expect(
        container.read(arabicLearningAudioControllerProvider).isPlaying,
        isFalse,
      );
    },
  );

  test(
    'shared Arabic audio controller skips missing assets and falls back calmly',
    () async {
      final backend = _FakeArabicLearningAudioBackend(
        playableAssets: const <String>{},
      );
      final bundle = _FakeArabicLearningAssetBundle(const <String>{});
      final container = await makeTestContainer(
        overrides: <Override>[
          arabicLearningAudioBackendProvider.overrideWithValue(backend),
          arabicLearningAssetBundleProvider.overrideWithValue(bundle),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(
        arabicLearningAudioControllerProvider.notifier,
      );
      final played = await notifier.playBeginnerPhrase(
        arabicSharedMiniPhraseById('bismillah')!,
      );

      expect(played, isTrue);
      expect(backend.playedAssets, isEmpty);
      expect(backend.spokenTexts, contains('بِسْمِ اللّٰهِ'));
    },
  );
}
