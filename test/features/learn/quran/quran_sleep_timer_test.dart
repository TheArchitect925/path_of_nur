import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/learn/quran/application/quran_focus_recitation_mode.dart';

/// The sleep timer grew a clock-time mode ("stop at 22:30") alongside the
/// duration presets, and a running timer must release the wake lock so the
/// screen can turn off while someone listens themselves to sleep.
void main() {
  group('QuranFocusRecitationSleepTimerState', () {
    test('a plain duration timer carries no stop-at time', () {
      const state = QuranFocusRecitationSleepTimerState(
        mode: QuranFocusRecitationSleepTimerMode.duration,
        durationSeconds: 1800,
        remainingSeconds: 1800,
      );
      expect(state.isActive, isTrue);
      expect(state.stopAt, isNull);
      expect(state.remainingDuration, const Duration(minutes: 30));
    });

    test('stopAt parses back to a time the surface can show', () {
      final state = QuranFocusRecitationSleepTimerState(
        mode: QuranFocusRecitationSleepTimerMode.duration,
        durationSeconds: 600,
        remainingSeconds: 600,
        stopAtIso: DateTime(2026, 8, 29, 22, 30).toIso8601String(),
      );
      expect(state.stopAt, DateTime(2026, 8, 29, 22, 30));
    });

    test('an off timer reports no remaining time', () {
      const state = QuranFocusRecitationSleepTimerState();
      expect(state.isActive, isFalse);
      expect(state.remainingDuration, Duration.zero);
    });
  });
  group('setStopAt', () {
    QuranFocusRecitationSleepTimerController controllerFor(
      ProviderContainer container,
    ) => container.read(quranFocusRecitationSleepTimerProvider.notifier);

    test('a later time today counts down to that hour', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final controller = controllerFor(container);

      controller.setStopAt(
        DateTime(2026, 1, 1, 22, 30),
        now: DateTime(2026, 8, 29, 21, 0),
      );

      final state = container.read(quranFocusRecitationSleepTimerProvider);
      expect(state.isActive, isTrue);
      expect(state.durationSeconds, const Duration(minutes: 90).inSeconds);
      expect(state.stopAt, DateTime(2026, 8, 29, 22, 30));
      controller.clear();
    });

    test('a time already past today rolls over to tomorrow', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final controller = controllerFor(container);

      // 06:00 chosen at 23:00 means tomorrow morning, not seventeen hours ago.
      controller.setStopAt(
        DateTime(2026, 1, 1, 6, 0),
        now: DateTime(2026, 8, 29, 23, 0),
      );

      final state = container.read(quranFocusRecitationSleepTimerProvider);
      expect(state.stopAt, DateTime(2026, 8, 30, 6, 0));
      expect(state.durationSeconds, const Duration(hours: 7).inSeconds);
      controller.clear();
    });

    test('clearing removes the stop-at time with the countdown', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final controller = controllerFor(container);

      controller.setStopAt(
        DateTime(2026, 1, 1, 23, 0),
        now: DateTime(2026, 8, 29, 22, 0),
      );
      controller.clear();

      final state = container.read(quranFocusRecitationSleepTimerProvider);
      expect(state.isActive, isFalse);
      expect(state.stopAt, isNull);
    });
  });
}
