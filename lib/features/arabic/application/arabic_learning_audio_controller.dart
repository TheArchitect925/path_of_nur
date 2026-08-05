import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:just_audio/just_audio.dart';

import '../../../shared/persistence/local_store.dart';
import '../data/arabic_audio_manifest.dart';
import '../domain/arabic_beginner_content_models.dart';
import '../domain/arabic_learning_audio_models.dart';
import 'arabic_learning_asset_bundle.dart';

const _arabicLearningSlowPlaybackKey = 'arabic.learning.audio.slow.v1';
const _normalAssetPlaybackSpeed = 1.0;
const _slowAssetPlaybackSpeed = 0.72;
const _normalTtsPlaybackSpeed = 0.35;
const _slowTtsPlaybackSpeed = 0.22;

abstract class ArabicLearningAudioBackend {
  Future<bool> playAsset(String path, {required double speed});
  Future<bool> speakText(String text, {required double rate});
  Future<void> stop();
  Future<void> dispose();
}

class LiveArabicLearningAudioBackend implements ArabicLearningAudioBackend {
  LiveArabicLearningAudioBackend({AudioPlayer? player, FlutterTts? tts})
    : _player = player ?? AudioPlayer(),
      _tts = tts ?? FlutterTts();

  final AudioPlayer _player;
  final FlutterTts _tts;
  bool _ttsConfigured = false;

  Future<void> _ensureTtsConfigured(double rate) async {
    if (!_ttsConfigured) {
      await _tts.setLanguage('ar');
      await _tts.setPitch(1.0);
      await _tts.setVolume(1.0);
      await _tts.awaitSpeakCompletion(true);
      _ttsConfigured = true;
    }
    await _tts.setSpeechRate(rate);
  }

  @override
  Future<bool> playAsset(String path, {required double speed}) async {
    try {
      await _tts.stop();
      await _player.stop();
      await _player.setSpeed(speed);
      await _player.setAsset(path);
      await _player.play();
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<bool> speakText(String text, {required double rate}) async {
    if (text.trim().isEmpty) {
      return false;
    }
    try {
      await _player.stop();
      await _ensureTtsConfigured(rate);
      await _tts.stop();
      await _tts.speak(text);
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<void> stop() async {
    await _player.stop();
    await _tts.stop();
  }

  @override
  Future<void> dispose() async {
    await _player.dispose();
    await _tts.stop();
  }
}

final arabicLearningAudioBackendProvider = Provider<ArabicLearningAudioBackend>(
  (ref) {
    final backend = LiveArabicLearningAudioBackend();
    ref.onDispose(() {
      unawaited(backend.dispose());
    });
    return backend;
  },
);

class ArabicLearningAudioController
    extends StateNotifier<ArabicLearningAudioState> {
  ArabicLearningAudioController(this._store, this._backend, this._assetBundle)
    : super(
        ArabicLearningAudioState(
          playbackSpeed: _store.getBool(_arabicLearningSlowPlaybackKey) == true
              ? ArabicLearningPlaybackSpeed.slow
              : ArabicLearningPlaybackSpeed.normal,
        ),
      );

  final LocalStore _store;
  final ArabicLearningAudioBackend _backend;
  final ArabicLearningAssetBundle _assetBundle;
  int _playbackRunId = 0;

  double get _assetSpeed =>
      state.playbackSpeed == ArabicLearningPlaybackSpeed.slow
      ? _slowAssetPlaybackSpeed
      : _normalAssetPlaybackSpeed;

  double get _ttsRate => state.playbackSpeed == ArabicLearningPlaybackSpeed.slow
      ? _slowTtsPlaybackSpeed
      : _normalTtsPlaybackSpeed;

  Future<void> setPlaybackSpeed(ArabicLearningPlaybackSpeed speed) async {
    if (state.playbackSpeed == speed) {
      return;
    }
    state = state.copyWith(playbackSpeed: speed);
    await _store.setBool(
      _arabicLearningSlowPlaybackKey,
      speed == ArabicLearningPlaybackSpeed.slow,
    );
  }

  Future<bool> playLetterByCanonicalId(String letterId) async {
    final entry = arabicLetterAudioByCanonicalId(letterId);
    if (entry == null) {
      return false;
    }
    return playResolvedAudio(
      playbackId: 'letter:$letterId',
      primaryAssetPath: entry.assetPath,
      alternateAssetPaths: entry.alternateAssetPaths,
      fallbackText: entry.spokenTextAr,
    );
  }

  Future<bool> playBeginnerWord(ArabicBeginnerWordEntry word) {
    return playResolvedAudio(
      playbackId: 'word:${word.id}',
      primaryAssetPath: word.audioAssetPath,
      fallbackText: word.arabicText,
    );
  }

  Future<bool> playBeginnerPhrase(ArabicBeginnerPhraseEntry phrase) {
    return playResolvedAudio(
      playbackId: 'phrase:${phrase.id}',
      primaryAssetPath: phrase.audioAssetPath,
      fallbackText: phrase.arabicText,
    );
  }

  Future<bool> playText({required String playbackId, required String text}) {
    return playResolvedAudio(playbackId: playbackId, fallbackText: text);
  }

  Future<bool> playResolvedAudio({
    required String playbackId,
    String? primaryAssetPath,
    List<String> alternateAssetPaths = const <String>[],
    String? fallbackText,
  }) async {
    final runId = ++_playbackRunId;
    state = state.copyWith(activePlaybackId: playbackId, isPlaying: true);
    await _backend.stop();

    final candidates = <String>[
      if (primaryAssetPath != null && primaryAssetPath.isNotEmpty)
        primaryAssetPath,
      ...alternateAssetPaths.where((path) => path.isNotEmpty),
    ];

    final availableCandidates = await _assetBundle.availableAssets(candidates);
    await _assetBundle.prewarmAssets(availableCandidates.take(1));

    for (final path in availableCandidates) {
      final played = await _backend.playAsset(path, speed: _assetSpeed);
      if (played) {
        _finishPlayback(runId);
        return true;
      }
      if (_playbackRunId != runId) {
        return true;
      }
    }

    final playedFallback =
        fallbackText != null && fallbackText.trim().isNotEmpty
        ? await _backend.speakText(fallbackText, rate: _ttsRate)
        : false;
    if (_playbackRunId == runId) {
      _finishPlayback(runId);
    }
    return playedFallback;
  }

  Future<void> stop() async {
    _playbackRunId += 1;
    await _backend.stop();
    state = state.copyWith(isPlaying: false, clearActivePlaybackId: true);
  }

  void _finishPlayback(int runId) {
    if (_playbackRunId != runId) {
      return;
    }
    state = state.copyWith(isPlaying: false, clearActivePlaybackId: true);
  }
}

final arabicLearningAudioControllerProvider =
    StateNotifierProvider<
      ArabicLearningAudioController,
      ArabicLearningAudioState
    >((ref) {
      return ArabicLearningAudioController(
        ref.watch(localStoreProvider),
        ref.watch(arabicLearningAudioBackendProvider),
        ref.watch(arabicLearningAssetBundleProvider),
      );
    });
