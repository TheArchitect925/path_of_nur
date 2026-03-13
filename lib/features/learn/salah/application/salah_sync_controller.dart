import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/salah_trainer_models.dart';
import 'salah_audio_service.dart';
import 'salah_trainer_provider.dart';

class SurahPlaybackController extends StateNotifier<SurahPlaybackState> {
  SurahPlaybackController(this._ref, this.surahId)
    : super(
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
  Timer? _timer;
  int _session = 0;

  SurahModel? get _surah => _ref.read(salahTrainerSurahByIdProvider(surahId));

  void setCurrentAyahIndex(int value) {
    state = state.copyWith(
      currentAyahIndex: value.clamp(0, (_surah?.verses.length ?? 1) - 1),
      currentWordIndex: -1,
      positionMs: 0,
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
      await _playVerse(session, verse);
      if (session != _session) return;
      if (state.pauseAfterAyah && i < state.repeatCount - 1) {
        await Future<void>.delayed(const Duration(milliseconds: 900));
      }
    }
    if (session != _session) return;
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
      final verse = surah.verses[index];
      await _playVerse(session, verse);
      if (session != _session) return;
      final shouldPause =
          mode == SurahLearningMode.repeat || state.pauseAfterAyah;
      if (shouldPause && index < surah.verses.length - 1) {
        state = state.copyWith(isPlaying: false);
        return;
      }
    }
    if (session != _session) return;
    state = state.copyWith(isPlaying: false);
  }

  Future<void> _playVerse(int session, SurahVerseModel verse) async {
    _startWordTimer(
      session,
      verse.audio.timing,
      totalDurationMs: verse.audio.totalDurationMs,
    );
    await _ref
        .read(salahAudioServiceProvider)
        .playAyah(verse, slow: state.slowMode);
  }

  void _startWordTimer(
    int session,
    RecitationTimingModel timing, {
    required int totalDurationMs,
  }) {
    _timer?.cancel();
    if (timing.wordTimings.isEmpty) {
      state = state.copyWith(currentWordIndex: 0, positionMs: 0);
      return;
    }
    state = state.copyWith(currentWordIndex: 0, positionMs: 0);
    final stopwatch = Stopwatch()..start();
    _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (session != _session) {
        timer.cancel();
        return;
      }
      final elapsed = stopwatch.elapsedMilliseconds;
      var activeWord = timing.wordTimings.length - 1;
      for (var i = 0; i < timing.wordTimings.length; i += 1) {
        final item = timing.wordTimings[i];
        if (elapsed < item.startMs) {
          activeWord = i;
          break;
        }
        if (elapsed >= item.startMs && elapsed <= item.endMs) {
          activeWord = i;
          break;
        }
      }
      state = state.copyWith(
        currentWordIndex: activeWord,
        positionMs: elapsed.clamp(0, totalDurationMs),
      );
      if (elapsed >= totalDurationMs) {
        timer.cancel();
      }
    });
  }

  Future<void> pause() async {
    _session += 1;
    _timer?.cancel();
    state = state.copyWith(isPlaying: false);
    await _ref.read(salahAudioServiceProvider).stop();
  }

  @override
  void dispose() {
    _timer?.cancel();
    unawaited(_ref.read(salahAudioServiceProvider).stop());
    super.dispose();
  }
}

class GuidedPrayerSyncController extends StateNotifier<GuidedPrayerSyncState> {
  GuidedPrayerSyncController(this._ref, this.args)
    : super(
        const GuidedPrayerSyncState(
          isPlaying: false,
          currentStepIndex: 0,
          currentWordIndex: -1,
          positionMs: 0,
          activePosture: PrayerPostureType.qiyam,
        ),
      );

  final Ref _ref;
  final ({SalahPrayerId prayerId, String surahId}) args;
  Timer? _timer;
  int _session = 0;

  List<GuidedPrayerStep> get _steps =>
      _ref.read(salahGuidedStepsProvider(args));

  void setCurrentStep(int index) {
    final steps = _steps;
    if (steps.isEmpty) return;
    final clamped = index.clamp(0, steps.length - 1);
    final step = steps[clamped];
    state = state.copyWith(
      currentStepIndex: clamped,
      currentWordIndex: -1,
      positionMs: 0,
      activePosture: step.step.posture,
    );
  }

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
      await Future<void>.delayed(
        Duration(milliseconds: steps[index].step.pauseAfterMs),
      );
    }
    if (session != _session) return;
    state = state.copyWith(isPlaying: false);
    _ref
        .read(salahTrainerProgressProvider.notifier)
        .completePrayer(args.prayerId);
  }

  Future<void> repeatCurrent() async {
    final steps = _steps;
    if (steps.isEmpty) return;
    final session = ++_session;
    state = state.copyWith(isPlaying: true);
    await _playStep(session, steps[state.currentStepIndex]);
    if (session == _session) {
      state = state.copyWith(isPlaying: false);
    }
  }

  Future<void> _playStep(int session, GuidedPrayerStep guidedStep) async {
    final step = guidedStep.step;
    final totalDurationMs = _estimateDuration(step);
    final timing = _timingForStep(step, totalDurationMs);
    _timer?.cancel();
    final stopwatch = Stopwatch()..start();
    _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (session != _session) {
        timer.cancel();
        return;
      }
      final elapsed = stopwatch.elapsedMilliseconds;
      var activeWord = timing.wordTimings.isEmpty
          ? -1
          : timing.wordTimings.length - 1;
      for (var i = 0; i < timing.wordTimings.length; i += 1) {
        final item = timing.wordTimings[i];
        if (elapsed < item.startMs) {
          activeWord = i;
          break;
        }
        if (elapsed >= item.startMs && elapsed <= item.endMs) {
          activeWord = i;
          break;
        }
      }
      state = state.copyWith(
        currentWordIndex: activeWord,
        positionMs: elapsed.clamp(0, totalDurationMs),
        activePosture: step.posture,
      );
      if (elapsed >= totalDurationMs) {
        timer.cancel();
      }
    });

    await _ref.read(salahAudioServiceProvider).playStep(step);
  }

  int _estimateDuration(PrayerStepModel step) {
    final words = step.arabicText
        .trim()
        .split(RegExp(r'\s+'))
        .where((item) => item.isNotEmpty)
        .length;
    return 900 + (words * 300);
  }

  RecitationTimingModel _timingForStep(
    PrayerStepModel step,
    int totalDurationMs,
  ) {
    final arabicWords = step.arabicText
        .trim()
        .split(RegExp(r'\s+'))
        .where((item) => item.isNotEmpty)
        .toList(growable: false);
    final transliterationWords = step.transliteration
        .trim()
        .split(RegExp(r'\s+'))
        .where((item) => item.isNotEmpty)
        .toList(growable: false);
    final translationWords = step.translation
        .trim()
        .split(RegExp(r'\s+'))
        .where((item) => item.isNotEmpty)
        .toList(growable: false);
    if (arabicWords.isEmpty) {
      return RecitationTimingModel(
        totalDurationMs: totalDurationMs,
        wordTimings: const [],
      );
    }
    final width = (totalDurationMs / arabicWords.length).round();
    final words = <RecitationWordTimingModel>[];
    for (var i = 0; i < arabicWords.length; i += 1) {
      words.add(
        RecitationWordTimingModel(
          wordId: '${step.id}-$i',
          arabicText: arabicWords[i],
          transliteration: i < transliterationWords.length
              ? transliterationWords[i]
              : '',
          translation: i < translationWords.length ? translationWords[i] : '',
          startMs: width * i,
          endMs: i == arabicWords.length - 1
              ? totalDurationMs
              : width * (i + 1),
        ),
      );
    }
    return RecitationTimingModel(
      totalDurationMs: totalDurationMs,
      wordTimings: words,
    );
  }

  Future<void> pause() async {
    _session += 1;
    _timer?.cancel();
    state = state.copyWith(isPlaying: false);
    await _ref.read(salahAudioServiceProvider).stop();
  }

  @override
  void dispose() {
    _timer?.cancel();
    unawaited(_ref.read(salahAudioServiceProvider).stop());
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
