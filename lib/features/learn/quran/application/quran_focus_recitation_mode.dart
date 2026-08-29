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
    this.stopAtIso,
  });

  final QuranFocusRecitationSleepTimerMode mode;
  final int? durationSeconds;
  final int? remainingSeconds;
  final String? startedAtIso;

  /// Set when the timer was chosen as a clock time ("stop at 22:30") rather
  /// than a duration, so the surface can show the hour it will stop.
  final String? stopAtIso;

  DateTime? get stopAt =>
      stopAtIso == null ? null : DateTime.tryParse(stopAtIso!);

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
    String? stopAtIso,
    bool clearStopAtIso = false,
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
      stopAtIso: clearStopAtIso ? null : (stopAtIso ?? this.stopAtIso),
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
    if (!mounted || state.repeatCurrentAyah == value) {
      return;
    }
    state = state.copyWith(repeatCurrentAyah: value);
    await _ref
        .read(quranPlayerControllerProvider)
        .setRepeatCurrentAyahEnabled(value);
  }

  Future<void> clearForExit() async {
    if (!mounted) {
      return;
    }
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

  void setDuration(Duration duration, {DateTime? stopAt}) {
    final safeSeconds = duration.inSeconds.clamp(1, 24 * 60 * 60);
    _timer?.cancel();
    state = QuranFocusRecitationSleepTimerState(
      mode: QuranFocusRecitationSleepTimerMode.duration,
      durationSeconds: safeSeconds,
      remainingSeconds: safeSeconds,
      startedAtIso: DateTime.now().toIso8601String(),
      stopAtIso: stopAt?.toIso8601String(),
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

  /// Stops playback at a wall-clock time. A time already past today is read
  /// as tomorrow, so picking 06:00 at night behaves the way it reads.
  void setStopAt(DateTime target, {DateTime? now}) {
    final from = now ?? DateTime.now();
    var stopAt = DateTime(
      from.year,
      from.month,
      from.day,
      target.hour,
      target.minute,
    );
    if (!stopAt.isAfter(from)) {
      stopAt = stopAt.add(const Duration(days: 1));
    }
    setDuration(stopAt.difference(from), stopAt: stopAt);
  }

  void clear() {
    _timer?.cancel();
    _timer = null;
    if (!mounted) {
      return;
    }
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
