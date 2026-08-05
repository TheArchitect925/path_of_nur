import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

import '../domain/kids_dua_learning_models.dart';

class KidsDuaResolvedAudio {
  const KidsDuaResolvedAudio({
    required this.variant,
    required this.resolvedAssetPath,
  });

  final KidsDuaAudioVariant variant;
  final String? resolvedAssetPath;

  bool get isAvailable => resolvedAssetPath != null;
}

class KidsDuaAudioState {
  const KidsDuaAudioState({
    this.currentDuaId,
    this.currentVariantId,
    this.activeSegmentId,
    this.currentPosition = Duration.zero,
    this.totalDuration = Duration.zero,
    this.isPlaying = false,
    this.isLoading = false,
    this.isCompleted = false,
    this.isAudioAvailable = false,
    this.isSegmentFallback = false,
    this.errorMessage,
  });

  final String? currentDuaId;
  final String? currentVariantId;
  final String? activeSegmentId;
  final Duration currentPosition;
  final Duration totalDuration;
  final bool isPlaying;
  final bool isLoading;
  final bool isCompleted;
  final bool isAudioAvailable;
  final bool isSegmentFallback;
  final String? errorMessage;

  KidsDuaAudioState copyWith({
    String? currentDuaId,
    bool clearCurrentDuaId = false,
    String? currentVariantId,
    bool clearCurrentVariantId = false,
    String? activeSegmentId,
    bool clearActiveSegmentId = false,
    Duration? currentPosition,
    Duration? totalDuration,
    bool? isPlaying,
    bool? isLoading,
    bool? isCompleted,
    bool? isAudioAvailable,
    bool? isSegmentFallback,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return KidsDuaAudioState(
      currentDuaId: clearCurrentDuaId
          ? null
          : (currentDuaId ?? this.currentDuaId),
      currentVariantId: clearCurrentVariantId
          ? null
          : (currentVariantId ?? this.currentVariantId),
      activeSegmentId: clearActiveSegmentId
          ? null
          : (activeSegmentId ?? this.activeSegmentId),
      currentPosition: currentPosition ?? this.currentPosition,
      totalDuration: totalDuration ?? this.totalDuration,
      isPlaying: isPlaying ?? this.isPlaying,
      isLoading: isLoading ?? this.isLoading,
      isCompleted: isCompleted ?? this.isCompleted,
      isAudioAvailable: isAudioAvailable ?? this.isAudioAvailable,
      isSegmentFallback: isSegmentFallback ?? this.isSegmentFallback,
      errorMessage: clearErrorMessage
          ? null
          : (errorMessage ?? this.errorMessage),
    );
  }
}

final kidsDuaAudioControllerProvider =
    StateNotifierProvider<KidsDuaAudioController, KidsDuaAudioState>((ref) {
      final controller = KidsDuaAudioController();
      ref.onDispose(() {
        unawaited(controller.close());
      });
      return controller;
    });

final kidsDuaAudioAvailabilityProvider =
    FutureProvider.family<bool, KidsDuaAudioVariant>((ref, variant) async {
      return (await KidsDuaAudioResolver.resolveVariant(variant)).isAvailable;
    });

class KidsDuaAudioController extends StateNotifier<KidsDuaAudioState> {
  KidsDuaAudioController()
    : _player = AudioPlayer(),
      super(const KidsDuaAudioState()) {
    _durationSub = _player.durationStream.listen((duration) {
      state = state.copyWith(totalDuration: duration ?? Duration.zero);
    });
    _positionSub = _player.positionStream.listen((position) {
      state = state.copyWith(currentPosition: position);
    });
    _playerStateSub = _player.playerStateStream.listen((playerState) {
      final completed =
          playerState.processingState == ProcessingState.completed;
      state = state.copyWith(
        isPlaying: playerState.playing,
        isCompleted: completed,
      );
    });
  }

  final AudioPlayer _player;
  StreamSubscription<Duration?>? _durationSub;
  StreamSubscription<Duration>? _positionSub;
  StreamSubscription<PlayerState>? _playerStateSub;

  Future<bool> playVariant(
    KidsDuaAudioVariant variant, {
    required String duaId,
    String? activeSegmentId,
    bool isSegmentFallback = false,
  }) async {
    state = state.copyWith(
      currentDuaId: duaId,
      currentVariantId: variant.variantId,
      activeSegmentId: activeSegmentId,
      isLoading: true,
      isCompleted: false,
      isSegmentFallback: isSegmentFallback,
      clearErrorMessage: true,
    );
    final resolved = await KidsDuaAudioResolver.resolveVariant(variant);
    if (!resolved.isAvailable) {
      state = state.copyWith(
        currentDuaId: duaId,
        currentVariantId: variant.variantId,
        activeSegmentId: activeSegmentId,
        isLoading: false,
        isPlaying: false,
        isAudioAvailable: false,
        totalDuration: Duration(seconds: variant.estimatedDurationSeconds),
      );
      return false;
    }
    try {
      await _player.stop();
      await _player.setAsset(resolved.resolvedAssetPath!);
      state = state.copyWith(
        currentDuaId: duaId,
        currentVariantId: variant.variantId,
        activeSegmentId: activeSegmentId,
        isLoading: false,
        isAudioAvailable: true,
        totalDuration:
            _player.duration ??
            Duration(seconds: variant.estimatedDurationSeconds),
      );
      await _player.play();
      return true;
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        isPlaying: false,
        isAudioAvailable: false,
        errorMessage: 'play_failed',
      );
      return false;
    }
  }

  Future<void> pause() => _player.pause();

  Future<void> resume() => _player.play();

  Future<void> restart() async {
    await _player.seek(Duration.zero);
    await _player.play();
  }

  Future<void> setRepeatWhole(bool enabled) async {
    await _player.setLoopMode(enabled ? LoopMode.one : LoopMode.off);
  }

  Future<void> clearSegmentHighlight() async {
    state = state.copyWith(
      clearActiveSegmentId: true,
      isSegmentFallback: false,
    );
  }

  Future<void> close() async {
    await _durationSub?.cancel();
    await _positionSub?.cancel();
    await _playerStateSub?.cancel();
    await _player.dispose();
  }
}

class KidsDuaAudioResolver {
  static Future<Set<String>>? _assetKeysFuture;

  static Future<Set<String>> _assetKeys() {
    _assetKeysFuture ??= _loadAssetKeys();
    return _assetKeysFuture!;
  }

  static Future<Set<String>> _loadAssetKeys() async {
    final raw = await rootBundle.loadString('AssetManifest.json');
    final decoded = json.decode(raw);
    if (decoded is! Map<String, dynamic>) {
      return <String>{};
    }
    return decoded.keys.toSet();
  }

  static Future<KidsDuaResolvedAudio> resolveVariant(
    KidsDuaAudioVariant variant,
  ) async {
    final keys = await _assetKeys();
    return KidsDuaResolvedAudio(
      variant: variant,
      resolvedAssetPath: keys.contains(variant.assetPath)
          ? variant.assetPath
          : null,
    );
  }
}
