import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:just_audio/just_audio.dart';

import '../models/salah_trainer_models.dart';

/// A segment resolved to a sound source and a wall-clock length, so the
/// controller can time the word highlight before playback starts.
class PreparedRecitation {
  const PreparedRecitation({
    required this.segment,
    required this.source,
    required this.durationMs,
  });

  final RecitationSegment segment;
  final SalahAudioSourceKind source;
  final int durationMs;
}

abstract class SalahAudioService {
  /// Resolves [segment] to a bundled clip, the device's Arabic voice, or
  /// silence, and loads it. Never throws: a missing clip degrades to speech.
  Future<PreparedRecitation> prepare(
    RecitationSegment segment, {
    bool slow = false,
  });

  /// Plays a prepared segment and completes when it ends or is stopped.
  Future<void> play(PreparedRecitation prepared);

  Future<void> stop();

  Future<void> dispose();
}

/// The set of bundled asset keys, read once from the manifest so a declared
/// recording slot only plays when its file actually shipped.
class SalahAudioAssetIndex {
  static Future<Set<String>>? _keysFuture;

  static Future<Set<String>> keys() {
    _keysFuture ??= _load();
    return _keysFuture!;
  }

  static Future<Set<String>> _load() async {
    try {
      // Flutter no longer ships AssetManifest.json — AssetManifest.bin is the
      // bundled form, and this API reads it regardless of encoding.
      final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
      return manifest.listAssets().toSet();
    } catch (_) {
      return <String>{};
    }
  }

  @visibleForTesting
  static void overrideKeys(Set<String>? keys) {
    _keysFuture = keys == null ? null : Future<Set<String>>.value(keys);
  }
}

class JustAudioSalahAudioService implements SalahAudioService {
  JustAudioSalahAudioService({
    AudioPlayer? player,
    FlutterTts? tts,
    Future<Set<String>> Function()? assetKeys,
  }) : _player = player ?? AudioPlayer(),
       _tts = tts ?? FlutterTts(),
       _assetKeys = assetKeys ?? SalahAudioAssetIndex.keys {
    _ready = _configure();
  }

  static const double _slowAssetSpeed = 0.75;

  final AudioPlayer _player;
  final FlutterTts _tts;
  final Future<Set<String>> Function() _assetKeys;
  late final Future<void> _ready;
  bool _ttsAvailable = false;

  Future<void> _configure() async {
    try {
      await _tts.setLanguage('ar');
      await _tts.setPitch(1.0);
      await _tts.setVolume(1.0);
      await _tts.awaitSpeakCompletion(true);
      final available = await _tts.isLanguageAvailable('ar');
      // Platforms that cannot answer report null; trust them and let speak()
      // fail quietly rather than muting every dhikr.
      _ttsAvailable = available != false;
    } catch (_) {
      _ttsAvailable = false;
    }
  }

  @override
  Future<PreparedRecitation> prepare(
    RecitationSegment segment, {
    bool slow = false,
  }) async {
    await _ready;
    await stop();
    final estimate = RecitationTimingModel.estimateSpokenMs(
      segment.arabicText,
      slow: slow,
    );
    final path = segment.audioAssetPath;
    if (path != null && path.isNotEmpty) {
      final keys = await _assetKeys();
      if (keys.contains(path)) {
        try {
          final duration = await _player.setAsset(path);
          await _player.setSpeed(slow ? _slowAssetSpeed : 1.0);
          final ms = duration?.inMilliseconds ?? 0;
          return PreparedRecitation(
            segment: segment,
            source: SalahAudioSourceKind.asset,
            durationMs: ms > 0
                ? (slow ? (ms / _slowAssetSpeed).round() : ms)
                : estimate,
          );
        } catch (_) {
          // A corrupt or unreadable clip falls through to speech.
        }
      }
    }
    if (_ttsAvailable && segment.arabicText.trim().isNotEmpty) {
      return PreparedRecitation(
        segment: segment,
        source: SalahAudioSourceKind.tts,
        durationMs: estimate,
      );
    }
    return PreparedRecitation(
      segment: segment,
      source: SalahAudioSourceKind.silent,
      durationMs: estimate,
    );
  }

  @override
  Future<void> play(PreparedRecitation prepared) async {
    switch (prepared.source) {
      case SalahAudioSourceKind.asset:
        await _player.play();
      case SalahAudioSourceKind.tts:
        try {
          await _tts.setSpeechRate(
            prepared.durationMs >
                    RecitationTimingModel.estimateSpokenMs(
                      prepared.segment.arabicText,
                    )
                ? 0.28
                : 0.42,
          );
          await _tts.speak(prepared.segment.arabicText);
        } catch (_) {
          await Future<void>.delayed(
            Duration(milliseconds: prepared.durationMs),
          );
        }
      case SalahAudioSourceKind.silent:
        await Future<void>.delayed(Duration(milliseconds: prepared.durationMs));
    }
  }

  @override
  Future<void> stop() async {
    await _player.stop();
    try {
      await _tts.stop();
    } catch (_) {
      // No speech engine on this platform.
    }
  }

  @override
  Future<void> dispose() async {
    await stop();
    await _player.dispose();
  }
}

final salahAudioServiceProvider = Provider<SalahAudioService>((ref) {
  final service = JustAudioSalahAudioService();
  ref.onDispose(() {
    unawaited(service.dispose());
  });
  return service;
});
