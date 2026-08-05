import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/learn/quran/application/quran_providers.dart';
import 'package:path_of_nur/shared/persistence/local_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('Quran reading stats', () {
    test('records reading duration and session totals', () async {
      SharedPreferences.setMockInitialValues(const {});
      final prefs = await SharedPreferences.getInstance();
      final container = ProviderContainer(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      );
      addTearDown(container.dispose);

      container
          .read(quranReadingStatsProvider.notifier)
          .logReadingSession(
            duration: const Duration(minutes: 12),
            completedAt: DateTime(2026, 3, 20, 10, 30),
          );

      final stats = container.read(quranReadingStatsProvider);
      expect(stats.totalReadingSeconds, 12 * 60);
      expect(stats.totalSessions, 1);
      expect(stats.secondsForDay('2026-03-20'), 12 * 60);
    });

    test('computes streak from tracked reading days', () async {
      SharedPreferences.setMockInitialValues(const {});
      final prefs = await SharedPreferences.getInstance();
      final container = ProviderContainer(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      );
      addTearDown(container.dispose);

      final notifier = container.read(quranReadingStatsProvider.notifier);
      final now = DateTime.now();
      notifier.logReadingSession(
        duration: const Duration(minutes: 8),
        completedAt: now,
      );
      notifier.logReadingSession(
        duration: const Duration(minutes: 7),
        completedAt: now.subtract(const Duration(days: 1)),
      );
      notifier.logReadingSession(
        duration: const Duration(minutes: 6),
        completedAt: now.subtract(const Duration(days: 2)),
      );

      expect(container.read(quranReadingStreakProvider), 3);
    });

    test('records listening duration separately from reading stats', () async {
      SharedPreferences.setMockInitialValues(const {});
      final prefs = await SharedPreferences.getInstance();
      final container = ProviderContainer(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      );
      addTearDown(container.dispose);

      container
          .read(quranListeningStatsProvider.notifier)
          .logListeningSession(
            duration: const Duration(minutes: 9),
            completedAt: DateTime(2026, 3, 20, 11, 45),
          );

      final listening = container.read(quranListeningStatsProvider);
      final reading = container.read(quranReadingStatsProvider);
      expect(listening.totalListeningSeconds, 9 * 60);
      expect(listening.totalSessions, 1);
      expect(listening.secondsForDay('2026-03-20'), 9 * 60);
      expect(reading.totalReadingSeconds, 0);
    });
  });
}
