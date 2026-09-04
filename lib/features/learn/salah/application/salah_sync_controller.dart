import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/salah_trainer_data.dart';
import '../models/salah_trainer_models.dart';
import 'salah_audio_service.dart';
import 'salah_guided_settings_provider.dart';
import 'salah_trainer_provider.dart';

/// Waits for real time in the app and for nothing in tests.
typedef SalahTrainerSleep = Future<void> Function(Duration duration);

final salahTrainerSleepProvider = Provider<SalahTrainerSleep>(
  (ref) =>
      (duration) => Future<void>.delayed(duration),
);

/// Drives the word highlight while a segment plays. Shared by both
/// controllers so the surah practice page and the guided flow track a clip
/// the same way.
class _WordTicker {
  Timer? _timer;

  void start({
    required RecitationTimingModel timing,
    required bool Function() isCurrent,
    required void Function(int wordIndex, int positionMs) onTick,
  }) {
    stop();
    if (timing.isEmpty) return;
    final stopwatch = Stopwatch()..start();
    _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (!isCurrent()) {
        timer.cancel();
        return;
      }
      final elapsed = stopwatch.elapsedMilliseconds;
      onTick(
        timing.activeWordAt(elapsed),
        elapsed.clamp(0, timing.totalDurationMs),
      );
      if (elapsed >= timing.totalDurationMs) {
        timer.cancel();
      }
    });
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
  }
}

class SurahPlaybackController extends StateNotifier<SurahPlaybackState> {
  SurahPlaybackController(this._ref, this.surahId)
    : _audio = _ref.read(salahAudioServiceProvider),
      _sleep = _ref.read(salahTrainerSleepProvider),
      super(
        const SurahPlaybackState(
          isPlaying: false,
          currentAyahIndex: 0,
          currentWordIndex: -1,
          positionMs: 0,
          repeatCount: 1,
          pauseAfterAyah: false,
          slowMode: false,
        ),
      );

  final Ref _ref;
  final String surahId;
  final _WordTicker _ticker = _WordTicker();
  // Captured at construction: dispose() runs after the container is gone.
  final SalahAudioService _audio;
  final SalahTrainerSleep _sleep;
  int _session = 0;

  SurahModel? get _surah => _ref.read(salahTrainerSurahByIdProvider(surahId));

  void setCurrentAyahIndex(int value) {
    state = state.copyWith(
      currentAyahIndex: value.clamp(0, (_surah?.verses.length ?? 1) - 1),
      currentWordIndex: -1,
      positionMs: 0,
      clearActiveTiming: true,
    );
  }

  void setRepeatCount(int value) {
    state = state.copyWith(repeatCount: value.clamp(1, 5));
  }

  void setPauseAfterAyah(bool value) {
    state = state.copyWith(pauseAfterAyah: value);
  }

  void setSlowMode(bool value) {
    state = state.copyWith(slowMode: value);
  }

  Future<void> playCurrentAyah() async {
    final surah = _surah;
    if (surah == null) return;
    final verse = surah.verses[state.currentAyahIndex];
    final session = ++_session;
    state = state.copyWith(isPlaying: true, positionMs: 0, currentWordIndex: 0);
    for (var i = 0; i < state.repeatCount; i += 1) {
      if (session != _session) return;
      await _playVerse(session, surah, verse);
      if (session != _session) return;
      if (state.pauseAfterAyah && i < state.repeatCount - 1) {
        await _sleep(const Duration(milliseconds: 900));
      }
    }
    if (session != _session) return;
    _ticker.stop();
    state = state.copyWith(isPlaying: false);
  }

  Future<void> playSurah({required SurahLearningMode mode}) async {
    final surah = _surah;
    if (surah == null) return;
    final session = ++_session;
    state = state.copyWith(isPlaying: true);
    for (
      var index = state.currentAyahIndex;
      index < surah.verses.length;
      index += 1
    ) {
      if (session != _session) return;
      state = state.copyWith(
        currentAyahIndex: index,
        currentWordIndex: 0,
        positionMs: 0,
      );
      await _playVerse(session, surah, surah.verses[index]);
      if (session != _session) return;
      final shouldPause =
          mode == SurahLearningMode.repeat || state.pauseAfterAyah;
      if (shouldPause && index < surah.verses.length - 1) {
        _ticker.stop();
        state = state.copyWith(isPlaying: false);
        return;
      }
    }
    if (session != _session) return;
    _ticker.stop();
    state = state.copyWith(isPlaying: false);
  }

  Future<void> _playVerse(
    int session,
    SurahModel surah,
    SurahVerseModel verse,
  ) async {
    final segment = verse.toSegment(surah.id);
    final prepared = await _audio.prepare(segment, slow: state.slowMode);
    if (session != _session) return;
    final timing = RecitationTimingModel.estimate(
      idPrefix: segment.id,
      arabic: segment.arabicText,
      transliteration: segment.transliteration,
      translation: segment.translation,
      totalDurationMs: prepared.durationMs,
    );
    state = state.copyWith(
      activeTiming: timing,
      sourceKind: prepared.source,
      currentWordIndex: 0,
      positionMs: 0,
    );
    _ticker.start(
      timing: timing,
      isCurrent: () => session == _session,
      onTick: (wordIndex, positionMs) {
        state = state.copyWith(
          currentWordIndex: wordIndex,
          positionMs: positionMs,
        );
      },
    );
    await _audio.play(prepared);
    _ticker.stop();
  }

  Future<void> pause() async {
    _session += 1;
    _ticker.stop();
    state = state.copyWith(isPlaying: false);
    await _audio.stop();
  }

  @override
  void dispose() {
    _session += 1;
    _ticker.stop();
    unawaited(_audio.stop());
    super.dispose();
  }
}

class GuidedPrayerSyncController extends StateNotifier<GuidedPrayerSyncState> {
  GuidedPrayerSyncController(this._ref, this.args)
    : _audio = _ref.read(salahAudioServiceProvider),
      _sleep = _ref.read(salahTrainerSleepProvider),
      super(
        const GuidedPrayerSyncState(
          isPlaying: false,
          currentStepIndex: 0,
          currentWordIndex: -1,
          positionMs: 0,
          activePosture: PrayerPostureType.qiyam,
        ),
      );

  static const Duration _repeatGap = Duration(milliseconds: 350);
  static const Duration _takbirGap = Duration(milliseconds: 250);
  static const int _holdTickMs = 100;

  final Ref _ref;
  final ({SalahPrayerId prayerId, String surahId}) args;
  final _WordTicker _ticker = _WordTicker();
  // Captured at construction: dispose() runs after the container is gone.
  final SalahAudioService _audio;
  final SalahTrainerSleep _sleep;
  int _session = 0;

  List<GuidedPrayerStep> get _steps =>
      _ref.read(salahGuidedStepsProvider(args));
  SalahGuidedSettings get _settings => _ref.read(salahGuidedSettingsProvider);

  /// Moves to [index] and remembers it so the prayer can be resumed later.
  void setCurrentStep(int index) {
    final steps = _steps;
    if (steps.isEmpty) return;
    final clamped = index.clamp(0, steps.length - 1);
    final step = steps[clamped];
    state = state.copyWith(
      currentStepIndex: clamped,
      currentSegmentIndex: 0,
      currentWordIndex: -1,
      positionMs: 0,
      repeatIteration: 1,
      phase: GuidedStepPhase.idle,
      holdRemainingMs: 0,
      activePosture: step.step.posture,
      clearActiveTiming: true,
    );
    _ref
        .read(salahTrainerProgressProvider.notifier)
        .saveGuidedSession(
          prayerId: args.prayerId,
          surahId: args.surahId,
          stepIndex: clamped,
          totalSteps: steps.length,
        );
  }

  /// Plays from the current step to the end, resting in each posture for
  /// its hold time, then records the prayer as completed.
  Future<void> playAll() async {
    final steps = _steps;
    if (steps.isEmpty) return;
    final session = ++_session;
    state = state.copyWith(isPlaying: true);
    for (var index = state.currentStepIndex; index < steps.length; index += 1) {
      if (session != _session) return;
      setCurrentStep(index);
      await _playStep(session, steps[index]);
      if (session != _session) return;
      await _hold(session, steps[index].step);
      if (session != _session) return;
    }
    _ticker.stop();
    state = state.copyWith(
      isPlaying: false,
      phase: GuidedStepPhase.completed,
      holdRemainingMs: 0,
    );
    _ref
        .read(salahTrainerProgressProvider.notifier)
        .completePrayer(args.prayerId);
  }

  /// Recites the current step once more without moving on.
  Future<void> repeatCurrent() async {
    final steps = _steps;
    if (steps.isEmpty) return;
    final session = ++_session;
    state = state.copyWith(isPlaying: true, holdRemainingMs: 0);
    await _playStep(session, steps[state.currentStepIndex]);
    if (session != _session) return;
    _ticker.stop();
    state = state.copyWith(isPlaying: false, phase: GuidedStepPhase.idle);
  }

  Future<void> _playStep(int session, GuidedPrayerStep guidedStep) async {
    final step = guidedStep.step;
    if (step.entryTakbir) {
      state = state.copyWith(
        phase: GuidedStepPhase.entryTakbir,
        activePosture: step.posture,
      );
      await _playSegment(session, salahTakbirSegment, highlight: false);
      if (session != _session) return;
      await _sleep(_takbirGap);
      if (session != _session) return;
    }
    if (step.isSilent) {
      state = state.copyWith(
        phase: GuidedStepPhase.reciting,
        currentWordIndex: -1,
        clearActiveTiming: true,
      );
      return;
    }
    final repeats = step.isTasbih ? _settings.tasbihRepeats : 1;
    for (var pass = 1; pass <= repeats; pass += 1) {
      if (session != _session) return;
      state = state.copyWith(
        phase: GuidedStepPhase.reciting,
        repeatIteration: pass,
      );
      for (var i = 0; i < step.segments.length; i += 1) {
        if (session != _session) return;
        state = state.copyWith(currentSegmentIndex: i);
        await _playSegment(session, step.segments[i]);
      }
      if (pass < repeats) {
        await _sleep(_repeatGap);
      }
    }
  }

  Future<void> _playSegment(
    int session,
    RecitationSegment segment, {
    bool highlight = true,
  }) async {
    final prepared = await _audio.prepare(segment);
    if (session != _session) return;
    if (highlight) {
      final timing = RecitationTimingModel.estimate(
        idPrefix: segment.id,
        arabic: segment.arabicText,
        transliteration: segment.transliteration,
        translation: segment.translation,
        totalDurationMs: prepared.durationMs,
      );
      state = state.copyWith(
        activeTiming: timing,
        sourceKind: prepared.source,
        currentWordIndex: 0,
        positionMs: 0,
      );
      _ticker.start(
        timing: timing,
        isCurrent: () => session == _session,
        onTick: (wordIndex, positionMs) {
          state = state.copyWith(
            currentWordIndex: wordIndex,
            positionMs: positionMs,
          );
        },
      );
    } else {
      state = state.copyWith(sourceKind: prepared.source);
    }
    await _audio.play(prepared);
    _ticker.stop();
  }

  /// Rests in the posture, counting the hold down so the page can show it.
  Future<void> _hold(int session, PrayerStepModel step) async {
    final total = (step.pauseAfterMs * _settings.pace.holdMultiplier).round();
    var remaining = total;
    state = state.copyWith(
      phase: GuidedStepPhase.holding,
      holdRemainingMs: remaining,
    );
    while (remaining > 0) {
      final slice = remaining < _holdTickMs ? remaining : _holdTickMs;
      await _sleep(Duration(milliseconds: slice));
      if (session != _session) return;
      remaining -= slice;
      state = state.copyWith(holdRemainingMs: remaining);
    }
  }

  Future<void> pause() async {
    _session += 1;
    _ticker.stop();
    state = state.copyWith(
      isPlaying: false,
      phase: GuidedStepPhase.idle,
      holdRemainingMs: 0,
    );
    await _audio.stop();
  }

  @override
  void dispose() {
    _session += 1;
    _ticker.stop();
    unawaited(_audio.stop());
    super.dispose();
  }
}

final surahPlaybackControllerProvider = StateNotifierProvider.autoDispose
    .family<SurahPlaybackController, SurahPlaybackState, String>((
      ref,
      surahId,
    ) {
      return SurahPlaybackController(ref, surahId);
    });

final guidedPrayerSyncControllerProvider = StateNotifierProvider.autoDispose
    .family<
      GuidedPrayerSyncController,
      GuidedPrayerSyncState,
      ({SalahPrayerId prayerId, String surahId})
    >((ref, args) {
      return GuidedPrayerSyncController(ref, args);
    });
