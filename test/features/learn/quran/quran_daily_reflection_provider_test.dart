import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/learn/quran/application/quran_daily_reflection_provider.dart';
import 'package:path_of_nur/features/journey/drops/application/journey_drops_providers.dart';
import 'package:path_of_nur/features/journey/xp/application/journey_xp_providers.dart';
import 'package:path_of_nur/shared/persistence/local_store.dart';

import '../../../test_helpers/app_test_harness.dart';

void main() {
  test('daily reflection starts with the onboarding-friendly ayah', () async {
    final container = await makeTestContainer();
    addTearDown(container.dispose);

    final summary = container.read(quranDailyReflectionSummaryProvider);

    expect(summary.assignment.entry.id, 'worship_salah_20_14');
    expect(summary.assignment.isFirstTimeStarter, isTrue);
    expect(summary.isCompletedToday, isFalse);
  });

  test(
    'completeToday records streak and awards quran xp and drops once',
    () async {
      final container = await makeTestContainer();
      addTearDown(container.dispose);

      final summary = container.read(quranDailyReflectionSummaryProvider);
      final now = DateTime(2026, 3, 22, 9);
      final sourceRef = 'quran_daily_reflection:${LocalStore.todayKey(now)}';

      final changed = container
          .read(quranDailyReflectionStateProvider.notifier)
          .completeToday(
            assignment: QuranDailyReflectionAssignment(
              dateKey: LocalStore.todayKey(now),
              entry: summary.assignment.entry,
              isFirstTimeStarter: summary.assignment.isFirstTimeStarter,
            ),
            now: now,
          );

      expect(changed, isTrue);

      final state = container.read(quranDailyReflectionStateProvider);
      expect(state.currentStreak, 1);
      expect(state.bestStreak, 1);
      expect(
        state.completedDateKeys.contains(LocalStore.todayKey(now)),
        isTrue,
      );
      expect(
        state.history.any((item) => item.dateKey == LocalStore.todayKey(now)),
        isTrue,
      );
      expect(container.read(journeyXpSummaryProvider).totalXp, greaterThan(0));
      expect(
        container
            .read(journeyDropHistoryProvider)
            .any((item) => item.sourceRef == sourceRef),
        isTrue,
      );

      final second = container
          .read(quranDailyReflectionStateProvider.notifier)
          .completeToday(
            assignment: QuranDailyReflectionAssignment(
              dateKey: LocalStore.todayKey(now),
              entry: summary.assignment.entry,
              isFirstTimeStarter: summary.assignment.isFirstTimeStarter,
            ),
            now: now,
          );
      expect(second, isFalse);
    },
  );
}
