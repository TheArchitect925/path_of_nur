import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

import '../domain/bedtime_story_models.dart';
import 'bedtime_active_learner_service.dart';
import 'bedtime_story_media_resolver.dart';
import 'bedtime_story_progress_service.dart';

final bedtimeStoryAudioControllerProvider =
    StateNotifierProvider<BedtimeStoryAudioController, BedtimeStoryAudioState>((
      ref,
    ) {
      final controller = BedtimeStoryAudioController(ref);
      ref.listen<String>(
        bedtimeActiveLearnerProvider.select((value) => value.learnerId),
        (previousLearnerId, nextLearnerId) =>
            unawaited(controller.stopForLearnerChange()),
      );
      ref.onDispose(() {
        unawaited(controller.close());
      });
      return controller;
    });

final bedtimeStoryAudioAvailabilityProvider =
    FutureProvider.family<bool, BedtimeStorySeed>((ref, story) {
      return ref
          .read(bedtimeStoryAudioControllerProvider.notifier)
          .isAudioAvailable(story);
    });

class BedtimeStoryAudioController
    extends StateNotifier<BedtimeStoryAudioState> {
  BedtimeStoryAudioController(this._ref)
    : _player = AudioPlayer(),
      super(const BedtimeStoryAudioState()) {
    _durationSub = _player.durationStream.listen(_handleDuration);
    _positionSub = _player.positionStream.listen(_handlePosition);
    _playerStateSub = _player.playerStateStream.listen(_handlePlayerState);
  }

  final Ref _ref;
  final AudioPlayer _player;
  final Map<String, BedtimeStoryResolvedAudio> _audioResolutionCache =
      <String, BedtimeStoryResolvedAudio>{};

  StreamSubscription<Duration?>? _durationSub;
  StreamSubscription<Duration>? _positionSub;
  StreamSubscription<PlayerState>? _playerStateSub;

  BedtimeStorySeed? _currentStory;
  int _lastPersistedSecond = -1;

  AudioPlayer get player => _player;

  Future<bool> isAudioAvailable(BedtimeStorySeed story) async {
    if (_audioResolutionCache.containsKey(story.id)) {
      return _audioResolutionCache[story.id]!.isAvailable;
    }
    final resolved = await BedtimeStoryMediaResolver.resolveAudio(story);
    _audioResolutionCache[story.id] = resolved;
    return resolved.isAvailable;
  }

  Future<bool> playStory(
    BedtimeStorySeed story, {
    bool autoplay = true,
    Duration? startAt,
  }) async {
    final previousStoryId = state.currentStoryId;
    state = state.copyWith(
      currentStoryId: story.id,
      isLoading: true,
      isCompleted: false,
      clearErrorMessage: true,
    );
    _currentStory = story;
    final resolved =
        _audioResolutionCache[story.id] ??
        await BedtimeStoryMediaResolver.resolveAudio(story);
    _audioResolutionCache[story.id] = resolved;
    if (!resolved.isAvailable) {
      state = state.copyWith(
        currentStoryId: story.id,
        playbackSource: resolved.playbackSource,
        isAssetAvailable: false,
        isLoading: false,
        isPlaying: false,
        totalDuration: story.estimatedDuration,
        currentPosition: startAt ?? Duration.zero,
      );
      return false;
    }

    final initialPosition = startAt ?? Duration.zero;
    try {
      final needsReload = previousStoryId != story.id;
      if (needsReload) {
        await _player.stop();
        await _player.setAsset(
          resolved.resolvedAssetPath!,
          initialPosition: initialPosition,
        );
      } else if (initialPosition > Duration.zero || state.isCompleted) {
        await _player.seek(initialPosition);
      }
      _ref
          .read(bedtimeStoryProgressProvider.notifier)
          .openStory(story.id, story: story);
      state = state.copyWith(
        currentStoryId: story.id,
        playbackSource: resolved.playbackSource,
        isAssetAvailable: true,
        isLoading: false,
        totalDuration: _player.duration ?? story.estimatedDuration,
        currentPosition: initialPosition,
        isCompleted: false,
      );
      if (autoplay) {
        await _player.play();
      }
      return true;
    } catch (error) {
      state = state.copyWith(
        currentStoryId: story.id,
        playbackSource: BedtimeStoryPlaybackSource.missingAsset,
        isAssetAvailable: false,
        isLoading: false,
        isPlaying: false,
        errorMessage: error.toString(),
      );
      return false;
    }
  }

  Future<void> pause() async {
    await _player.pause();
    _persistCurrentSnapshot();
  }

  Future<void> resume() async {
    if (!state.isAssetAvailable) {
      return;
    }
    await _player.play();
  }

  Future<void> restart() async {
    await _player.seek(Duration.zero);
    if (!state.isPlaying && state.isAssetAvailable) {
      await _player.play();
    }
  }

  Future<void> seek(Duration position) async {
    if (!state.isAssetAvailable) {
      return;
    }
    await _player.seek(position);
  }

  Future<void> stop() async {
    await _player.stop();
    _persistCurrentSnapshot();
    state = state.copyWith(
      isPlaying: false,
      isCompleted: false,
      isLoading: false,
      clearErrorMessage: true,
    );
  }

  Future<void> stopForLearnerChange() async {
    await _player.stop();
    _currentStory = null;
    _lastPersistedSecond = -1;
    state = const BedtimeStoryAudioState();
  }

  Future<void> close() async {
    _persistCurrentSnapshot();
    await _durationSub?.cancel();
    await _positionSub?.cancel();
    await _playerStateSub?.cancel();
    await _player.dispose();
  }

  void _handleDuration(Duration? duration) {
    if (duration == null) {
      return;
    }
    state = state.copyWith(totalDuration: duration);
  }

  void _handlePosition(Duration position) {
    final story = _currentStory;
    if (story == null) {
      return;
    }
    state = state.copyWith(
      currentPosition: position,
      lastPlayedAtIso: DateTime.now().toIso8601String(),
    );
    if (position.inSeconds != _lastPersistedSecond &&
        position.inSeconds % 2 == 0) {
      _lastPersistedSecond = position.inSeconds;
      _ref
          .read(bedtimeStoryProgressProvider.notifier)
          .recordPlaybackSnapshot(
            storyId: story.id,
            currentPosition: position,
            totalDuration: state.totalDuration > Duration.zero
                ? state.totalDuration
                : story.estimatedDuration,
            source: BedtimeStoryPlaybackSource.asset,
          );
    }
  }

  void _handlePlayerState(PlayerState playerState) {
    final nowIso = DateTime.now().toIso8601String();
    state = state.copyWith(
      isPlaying: playerState.playing,
      isLoading:
          playerState.processingState == ProcessingState.loading ||
          playerState.processingState == ProcessingState.buffering,
      lastPlayedAtIso: nowIso,
    );
    if (playerState.processingState == ProcessingState.completed) {
      final story = _currentStory;
      if (story != null) {
        _ref
            .read(bedtimeStoryProgressProvider.notifier)
            .recordPlaybackSnapshot(
              storyId: story.id,
              currentPosition: state.totalDuration > Duration.zero
                  ? state.totalDuration
                  : story.estimatedDuration,
              totalDuration: state.totalDuration > Duration.zero
                  ? state.totalDuration
                  : story.estimatedDuration,
              source: BedtimeStoryPlaybackSource.asset,
            );
        _ref
            .read(bedtimeStoryProgressProvider.notifier)
            .completeStory(story, completionSource: 'audio');
      }
      state = state.copyWith(
        isPlaying: false,
        isCompleted: true,
        currentPosition: state.totalDuration,
      );
    }
  }

  void _persistCurrentSnapshot() {
    final story = _currentStory;
    if (story == null || !state.isAssetAvailable) {
      return;
    }
    _ref
        .read(bedtimeStoryProgressProvider.notifier)
        .recordPlaybackSnapshot(
          storyId: story.id,
          currentPosition: state.currentPosition,
          totalDuration: state.totalDuration > Duration.zero
              ? state.totalDuration
              : story.estimatedDuration,
          source: BedtimeStoryPlaybackSource.asset,
        );
  }
}
