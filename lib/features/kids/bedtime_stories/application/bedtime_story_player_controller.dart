import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/persistence/local_store.dart';
import '../domain/bedtime_story_models.dart';
import '../domain/bedtime_story_queue_models.dart';
import 'bedtime_active_learner_service.dart';
import 'bedtime_story_audio_service.dart';
import 'bedtime_story_progress_service.dart';
import 'bedtime_story_repository.dart';

final bedtimeStoryQueueControllerProvider =
    StateNotifierProvider<BedtimeStoryQueueController, BedtimeStoryQueueState>((
      ref,
    ) {
      final controller = BedtimeStoryQueueController(ref);
      ref.listen<String>(
        bedtimeActiveLearnerProvider.select((value) => value.learnerId),
        (_, next) => unawaited(controller.updateActiveLearner(next)),
      );
      ref.listen<BedtimeStoryAudioState>(
        bedtimeStoryAudioControllerProvider,
        controller.handleAudioStateChanged,
      );
      ref.onDispose(controller.dispose);
      return controller;
    });

final bedtimeStorySleepTimerProvider =
    StateNotifierProvider<
      BedtimeStorySleepTimerController,
      BedtimeStorySleepTimerState
    >((ref) {
      final controller = BedtimeStorySleepTimerController(ref);
      ref.listen<String>(
        bedtimeActiveLearnerProvider.select((value) => value.learnerId),
        (previousLearnerId, nextLearnerId) => controller.clear(),
      );
      ref.onDispose(controller.dispose);
      return controller;
    });

final bedtimeStoryCurrentQueueStoryProvider = Provider<BedtimeStorySeed?>((
  ref,
) {
  final queueState = ref.watch(bedtimeStoryQueueControllerProvider);
  final storyId = queueState.currentStoryId;
  if (storyId == null) {
    return null;
  }
  return ref.watch(bedtimeStoryByIdProvider(storyId));
});

final bedtimeStoryNextQueueStoryProvider = Provider<BedtimeStorySeed?>((ref) {
  final queueState = ref.watch(bedtimeStoryQueueControllerProvider);
  if (!queueState.hasNext) {
    return null;
  }
  final nextId = queueState.storyIds[queueState.currentIndex + 1];
  return ref.watch(bedtimeStoryByIdProvider(nextId));
});

class BedtimeStoryQueueController
    extends StateNotifier<BedtimeStoryQueueState> {
  BedtimeStoryQueueController(this._ref)
    : _store = _ref.read(localStoreProvider),
      _activeLearnerId = _ref.read(bedtimeActiveLearnerProvider).learnerId,
      super(
        BedtimeStoryQueueState.fromJson(
          _ref
              .read(localStoreProvider)
              .getJsonMap(
                bedtimeStoryQueueStorageKeyForLearner(
                  _ref.read(bedtimeActiveLearnerProvider).learnerId,
                ),
              ),
        ),
      );

  final Ref _ref;
  final LocalStore _store;
  String _activeLearnerId;
  bool _handledCompletion = false;

  Future<void> startSingleStory(
    BedtimeStorySeed story, {
    bool autoplay = true,
  }) async {
    _setQueue(
      storyIds: <String>[story.id],
      currentIndex: 0,
      queueType: BedtimeStoryQueueType.singleStory,
    );
    if (autoplay) {
      await playCurrent();
    }
  }

  Future<void> startSeriesFrom(
    BedtimeStorySeed story, {
    bool autoplay = true,
  }) async {
    final stories = _ref
        .read(bedtimeStoryRepositoryProvider)
        .storiesForProphet(story.prophetId);
    final queueStories = stories
        .where((item) => item.partNumber >= story.partNumber)
        .map((item) => item.id)
        .toList(growable: false);
    _setQueue(
      storyIds: queueStories,
      currentIndex: 0,
      queueType: BedtimeStoryQueueType.continueSeries,
    );
    if (autoplay) {
      await playCurrent();
    }
  }

  Future<void> startTonightStory() async {
    final repository = _ref.read(bedtimeStoryRepositoryProvider);
    final continueStory = repository.continueStory();
    final selected = continueStory ?? repository.tonightStory();
    if (selected == null) {
      return;
    }
    if (selected.isMultipart) {
      await startSeriesFrom(selected);
      return;
    }
    await startSingleStory(selected);
  }

  Future<void> playStoryWithBestQueue(BedtimeStorySeed story) async {
    if (story.isMultipart) {
      await startSeriesFrom(story);
      return;
    }
    await startSingleStory(story);
  }

  Future<void> playCurrent({bool restartCompleted = false}) async {
    final storyId = state.currentStoryId;
    if (storyId == null) {
      return;
    }
    final story = _ref.read(bedtimeStoryByIdProvider(storyId));
    if (story == null) {
      return;
    }
    final progress = _ref
        .read(bedtimeStoryProgressProvider.notifier)
        .progressFor(story.id);
    final startAt = progress.isCompleted && !restartCompleted
        ? Duration.zero
        : Duration(milliseconds: progress.currentPositionMs);
    _handledCompletion = false;
    await _ref
        .read(bedtimeStoryAudioControllerProvider.notifier)
        .playStory(story, autoplay: true, startAt: startAt);
  }

  Future<void> togglePlayPause() async {
    final audio = _ref.read(bedtimeStoryAudioControllerProvider);
    final audioController = _ref.read(
      bedtimeStoryAudioControllerProvider.notifier,
    );
    if (audio.isPlaying) {
      await audioController.pause();
      return;
    }
    if (audio.currentStoryId == state.currentStoryId &&
        audio.currentPosition > Duration.zero) {
      await audioController.resume();
      return;
    }
    await playCurrent();
  }

  Future<void> next() async {
    if (!state.hasNext) {
      return;
    }
    state = state.copyWith(
      currentIndex: state.currentIndex + 1,
      lastUpdatedAtIso: DateTime.now().toIso8601String(),
    );
    _persist();
    await playCurrent(restartCompleted: true);
  }

  Future<void> previous() async {
    final audio = _ref.read(bedtimeStoryAudioControllerProvider);
    if (audio.currentPosition > const Duration(seconds: 5)) {
      await _ref.read(bedtimeStoryAudioControllerProvider.notifier).restart();
      return;
    }
    if (!state.hasPrevious) {
      await _ref.read(bedtimeStoryAudioControllerProvider.notifier).restart();
      return;
    }
    state = state.copyWith(
      currentIndex: state.currentIndex - 1,
      lastUpdatedAtIso: DateTime.now().toIso8601String(),
    );
    _persist();
    await playCurrent(restartCompleted: true);
  }

  Future<void> seekBy(Duration delta) async {
    final audio = _ref.read(bedtimeStoryAudioControllerProvider);
    final target = audio.currentPosition + delta;
    final bounded = target < Duration.zero ? Duration.zero : target;
    await _ref.read(bedtimeStoryAudioControllerProvider.notifier).seek(bounded);
  }

  void setAutoplayEnabled(bool enabled) {
    state = state.copyWith(
      autoplayEnabled: enabled,
      lastUpdatedAtIso: DateTime.now().toIso8601String(),
    );
    _persist();
  }

  void clearQueue() {
    state = const BedtimeStoryQueueState();
    _persist();
  }

  Future<void> updateActiveLearner(String learnerId) async {
    if (learnerId == _activeLearnerId) {
      return;
    }
    _activeLearnerId = learnerId;
    _handledCompletion = false;
    await _ref
        .read(bedtimeStoryAudioControllerProvider.notifier)
        .stopForLearnerChange();
    state = BedtimeStoryQueueState.fromJson(
      _store.getJsonMap(bedtimeStoryQueueStorageKeyForLearner(learnerId)),
    );
  }

  void handleAudioStateChanged(
    BedtimeStoryAudioState? previous,
    BedtimeStoryAudioState next,
  ) {
    final currentStoryId = state.currentStoryId;
    if (currentStoryId == null) {
      return;
    }
    if (next.currentStoryId != null &&
        !state.storyIds.contains(next.currentStoryId)) {
      _setQueue(
        storyIds: <String>[next.currentStoryId!],
        currentIndex: 0,
        queueType: BedtimeStoryQueueType.singleStory,
      );
      return;
    }
    if (next.currentStoryId != currentStoryId) {
      return;
    }
    if (next.isCompleted &&
        previous?.isCompleted != true &&
        !_handledCompletion) {
      _handledCompletion = true;
      final sleepTimer = _ref.read(bedtimeStorySleepTimerProvider);
      if (sleepTimer.mode == BedtimeStorySleepTimerMode.endOfStory) {
        _ref.read(bedtimeStorySleepTimerProvider.notifier).clear();
        return;
      }
      if (state.autoplayEnabled && state.hasNext) {
        unawaited(nextStoryAfterCompletion());
      }
      return;
    }
    if (!next.isCompleted) {
      _handledCompletion = false;
    }
  }

  Future<void> nextStoryAfterCompletion() async {
    if (!state.hasNext) {
      return;
    }
    await next();
  }

  void _setQueue({
    required List<String> storyIds,
    required int currentIndex,
    required BedtimeStoryQueueType queueType,
  }) {
    state = state.copyWith(
      storyIds: storyIds,
      currentIndex: currentIndex,
      queueType: queueType,
      lastUpdatedAtIso: DateTime.now().toIso8601String(),
    );
    _persist();
  }

  void _persist() {
    _store.setJsonMap(
      bedtimeStoryQueueStorageKeyForLearner(_activeLearnerId),
      state.toJson(),
    );
  }
}

class BedtimeStorySleepTimerController
    extends StateNotifier<BedtimeStorySleepTimerState> {
  BedtimeStorySleepTimerController(this._ref)
    : super(const BedtimeStorySleepTimerState());

  final Ref _ref;
  Timer? _timer;

  void setDurationMinutes(int minutes) {
    _timer?.cancel();
    state = BedtimeStorySleepTimerState(
      mode: BedtimeStorySleepTimerMode.duration,
      durationMinutes: minutes,
      remainingSeconds: minutes * 60,
      startedAtIso: DateTime.now().toIso8601String(),
    );
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      final nextRemaining = (state.remainingSeconds ?? 0) - 1;
      if (nextRemaining <= 0) {
        timer.cancel();
        await _ref.read(bedtimeStoryAudioControllerProvider.notifier).pause();
        clear();
        return;
      }
      state = state.copyWith(remainingSeconds: nextRemaining);
    });
  }

  void setEndOfStory() {
    _timer?.cancel();
    state = BedtimeStorySleepTimerState(
      mode: BedtimeStorySleepTimerMode.endOfStory,
      startedAtIso: DateTime.now().toIso8601String(),
    );
  }

  void clear() {
    _timer?.cancel();
    _timer = null;
    state = const BedtimeStorySleepTimerState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
