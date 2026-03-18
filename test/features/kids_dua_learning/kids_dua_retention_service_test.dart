import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/kids_dua_learning/application/kids_dua_retention_service.dart';
import 'package:path_of_nur/features/kids_dua_learning/domain/kids_dua_models.dart';

void main() {
  const service = KidsDuaRetentionService();

  test('streak increments on consecutive days and marks today complete', () {
    final first = service.registerDailyActivity(
      state: KidsDuaLearningState.initial(),
      now: DateTime(2026, 3, 18, 9),
      activityType: KidsDuaDailyActivityType.lessonCompleted,
    );
    final second = service.registerDailyActivity(
      state: first.state,
      now: DateTime(2026, 3, 19, 9),
      activityType: KidsDuaDailyActivityType.practiceCorrect,
    );

    expect(first.firstActivityToday, isTrue);
    expect(second.state.currentStreakDays, 2);
    expect(second.state.longestStreakDays, 2);
    expect(second.state.todayCompleted, isTrue);
  });

  test('light level mapping follows streak thresholds', () {
    KidsDuaLearningState stateWithStreak(int streak) =>
        KidsDuaLearningState.initial().copyWith(currentStreakDays: streak);

    expect(
      service.getCurrentLightLevel(stateWithStreak(0)),
      KidsDuaLightLevel.seed,
    );
    expect(
      service.getCurrentLightLevel(stateWithStreak(1)),
      KidsDuaLightLevel.glow,
    );
    expect(
      service.getCurrentLightLevel(stateWithStreak(3)),
      KidsDuaLightLevel.lantern,
    );
    expect(
      service.getCurrentLightLevel(stateWithStreak(7)),
      KidsDuaLightLevel.moon,
    );
    expect(
      service.getCurrentLightLevel(stateWithStreak(14)),
      KidsDuaLightLevel.star,
    );
    expect(
      service.getCurrentLightLevel(stateWithStreak(30)),
      KidsDuaLightLevel.radiant,
    );
  });

  test('reminder selection prefers gentle recovery after a missed day', () {
    final state = KidsDuaLearningState.initial().copyWith(
      currentStreakDays: 4,
      lastActiveDate: '2026-03-16',
      todayCompleted: false,
    );

    final context = service.reminderContextFor(
      now: DateTime(2026, 3, 18, 17),
      state: state,
    );

    expect(context, KidsDuaReminderContextType.gentleRecovery);
    expect(
      service.getSuggestedReminderForContext(context).id,
      'recovery-light',
    );
  });
}
