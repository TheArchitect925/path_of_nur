import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import 'quran_player_controller.dart';

class QuranFocusRecitationSessionState {
  const QuranFocusRecitationSessionState({this.repeatCurrentAyah = false});

  final bool repeatCurrentAyah;

  QuranFocusRecitationSessionState copyWith({bool? repeatCurrentAyah}) {
    return QuranFocusRecitationSessionState(
      repeatCurrentAyah: repeatCurrentAyah ?? this.repeatCurrentAyah,
    );
  }
}

enum QuranFocusRecitationSleepTimerMode { off, duration }

class QuranFocusRecitationSleepTimerState {
  const QuranFocusRecitationSleepTimerState({
    this.mode = QuranFocusRecitationSleepTimerMode.off,
    this.durationSeconds,
    this.remainingSeconds,
    this.startedAtIso,
  });

  final QuranFocusRecitationSleepTimerMode mode;
  final int? durationSeconds;
  final int? remainingSeconds;
  final String? startedAtIso;

  bool get isActive => mode != QuranFocusRecitationSleepTimerMode.off;

  Duration get remainingDuration =>
      Duration(seconds: remainingSeconds?.clamp(0, 24 * 60 * 60) ?? 0);

  QuranFocusRecitationSleepTimerState copyWith({
    QuranFocusRecitationSleepTimerMode? mode,
    int? durationSeconds,
    bool clearDurationSeconds = false,
    int? remainingSeconds,
    bool clearRemainingSeconds = false,
    String? startedAtIso,
    bool clearStartedAtIso = false,
  }) {
    return QuranFocusRecitationSleepTimerState(
      mode: mode ?? this.mode,
      durationSeconds: clearDurationSeconds
          ? null
          : (durationSeconds ?? this.durationSeconds),
      remainingSeconds: clearRemainingSeconds
          ? null
          : (remainingSeconds ?? this.remainingSeconds),
      startedAtIso: clearStartedAtIso
          ? null
          : (startedAtIso ?? this.startedAtIso),
    );
  }
}

abstract class QuranFocusRecitationWakeLock {
  Future<void> setEnabled(bool enabled);
}

class QuranFocusRecitationWakelockPlus implements QuranFocusRecitationWakeLock {
  const QuranFocusRecitationWakelockPlus();

  @override
  Future<void> setEnabled(bool enabled) {
    return WakelockPlus.toggle(enable: enabled);
  }
}

class QuranFocusRecitationSessionController
    extends StateNotifier<QuranFocusRecitationSessionState> {
  QuranFocusRecitationSessionController(this._ref)
    : super(const QuranFocusRecitationSessionState());

  final Ref _ref;

  Future<void> setRepeatCurrentAyah(bool value) async {
    if (state.repeatCurrentAyah == value) {
      return;
    }
    state = state.copyWith(repeatCurrentAyah: value);
    await _ref
        .read(quranPlayerControllerProvider)
        .setRepeatCurrentAyahEnabled(value);
  }

  Future<void> clearForExit() async {
    _ref.read(quranFocusRecitationSleepTimerProvider.notifier).clear();
    await setRepeatCurrentAyah(false);
  }
}

class QuranFocusRecitationSleepTimerController
    extends StateNotifier<QuranFocusRecitationSleepTimerState> {
  QuranFocusRecitationSleepTimerController(this._ref)
    : super(const QuranFocusRecitationSleepTimerState());

  final Ref _ref;
  Timer? _timer;

  void setDuration(Duration duration) {
    final safeSeconds = duration.inSeconds.clamp(1, 24 * 60 * 60);
    _timer?.cancel();
    state = QuranFocusRecitationSleepTimerState(
      mode: QuranFocusRecitationSleepTimerMode.duration,
      durationSeconds: safeSeconds,
      remainingSeconds: safeSeconds,
      startedAtIso: DateTime.now().toIso8601String(),
    );
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      final nextRemaining = (state.remainingSeconds ?? 0) - 1;
      if (nextRemaining <= 0) {
        timer.cancel();
        await _ref.read(quranPlayerControllerProvider).pause();
        clear();
        return;
      }
      state = state.copyWith(remainingSeconds: nextRemaining);
    });
  }

  void setDurationMinutes(int minutes) {
    setDuration(Duration(minutes: minutes.clamp(1, 24 * 60)));
  }

  void clear() {
    _timer?.cancel();
    _timer = null;
    state = const QuranFocusRecitationSleepTimerState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

final quranFocusRecitationWakeLockProvider =
    Provider<QuranFocusRecitationWakeLock>((ref) {
      return const QuranFocusRecitationWakelockPlus();
    });

final quranFocusRecitationSessionProvider =
    StateNotifierProvider<
      QuranFocusRecitationSessionController,
      QuranFocusRecitationSessionState
    >((ref) {
      return QuranFocusRecitationSessionController(ref);
    });

final quranFocusRecitationSleepTimerProvider =
    StateNotifierProvider<
      QuranFocusRecitationSleepTimerController,
      QuranFocusRecitationSleepTimerState
    >((ref) {
      return QuranFocusRecitationSleepTimerController(ref);
    });
