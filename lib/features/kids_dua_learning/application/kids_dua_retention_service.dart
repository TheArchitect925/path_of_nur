import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/kids_dua_models.dart';

final kidsDuaRetentionServiceProvider = Provider<KidsDuaRetentionService>(
  (ref) => const KidsDuaRetentionService(),
);

class KidsDuaRetentionUpdate {
  const KidsDuaRetentionUpdate({
    required this.state,
    required this.firstActivityToday,
    required this.usedGraceToday,
  });

  final KidsDuaLearningState state;
  final bool firstActivityToday;
  final bool usedGraceToday;
}

class KidsDuaRetentionService {
  const KidsDuaRetentionService();

  String dayKey(DateTime now) =>
      '${now.year.toString().padLeft(4, '0')}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

  KidsDuaLearningState syncForToday({
    required KidsDuaLearningState state,
    required DateTime now,
  }) {
    final today = dayKey(now);
    if (state.lastActiveDate == today || !state.todayCompleted) {
      return state;
    }
    return state.copyWith(todayCompleted: false);
  }

  KidsDuaRetentionUpdate registerDailyActivity({
    required KidsDuaLearningState state,
    required DateTime now,
    required KidsDuaDailyActivityType activityType,
  }) {
    final normalized = syncForToday(state: state, now: now);
    final today = dayKey(now);
    if (normalized.lastActiveDate == today && normalized.todayCompleted) {
      return KidsDuaRetentionUpdate(
        state: normalized,
        firstActivityToday: false,
        usedGraceToday: false,
      );
    }

    final yesterday = dayKey(now.subtract(const Duration(days: 1)));
    final twoDaysAgo = dayKey(now.subtract(const Duration(days: 2)));
    final canUseGrace =
        normalized.lastActiveDate == twoDaysAgo &&
        normalized.lastGraceUsedDate != today &&
        normalized.lastGraceUsedDate != yesterday &&
        normalized.lastGraceUsedDate != twoDaysAgo;

    final nextStreak = switch (normalized.lastActiveDate) {
      null => 1,
      final last when last == yesterday => normalized.currentStreakDays + 1,
      final last when last == twoDaysAgo && canUseGrace =>
        normalized.currentStreakDays + 1,
      final last when last == today => normalized.currentStreakDays,
      _ => 1,
    };

    final nextState = normalized.copyWith(
      currentStreakDays: nextStreak,
      longestStreakDays: nextStreak > normalized.longestStreakDays
          ? nextStreak
          : normalized.longestStreakDays,
      lastActiveDate: today,
      todayCompleted: true,
      lastGraceUsedDate: canUseGrace ? today : normalized.lastGraceUsedDate,
    );

    return KidsDuaRetentionUpdate(
      state: nextState,
      firstActivityToday: true,
      usedGraceToday: canUseGrace,
    );
  }

  KidsDuaLightLevel getCurrentLightLevel(KidsDuaLearningState state) {
    final streak = state.currentStreakDays;
    if (streak >= 30) return KidsDuaLightLevel.radiant;
    if (streak >= 14) return KidsDuaLightLevel.star;
    if (streak >= 7) return KidsDuaLightLevel.moon;
    if (streak >= 3) return KidsDuaLightLevel.lantern;
    if (streak >= 1) return KidsDuaLightLevel.glow;
    return KidsDuaLightLevel.seed;
  }

  String lightLabelKey(KidsDuaLightLevel level) => switch (level) {
    KidsDuaLightLevel.seed => 'kidsDuaLightSeedLabel',
    KidsDuaLightLevel.glow => 'kidsDuaLightGlowLabel',
    KidsDuaLightLevel.lantern => 'kidsDuaLightLanternLabel',
    KidsDuaLightLevel.moon => 'kidsDuaLightMoonLabel',
    KidsDuaLightLevel.star => 'kidsDuaLightStarLabel',
    KidsDuaLightLevel.radiant => 'kidsDuaLightRadiantLabel',
  };

  String lightDescriptionKey({
    required KidsDuaLearningState state,
    required KidsDuaLightLevel level,
  }) {
    if (state.todayCompleted) return 'kidsDuaLightCompleteTodayMessage';
    if (state.currentStreakDays == 0) return 'kidsDuaLightStartMessage';
    if (state.lastActiveDate != null) return 'kidsDuaLightRecoveryMessage';
    return switch (level) {
      KidsDuaLightLevel.seed => 'kidsDuaLightStartMessage',
      KidsDuaLightLevel.glow => 'kidsDuaLightBuildMessage',
      KidsDuaLightLevel.lantern => 'kidsDuaLightBuildMessage',
      KidsDuaLightLevel.moon => 'kidsDuaLightSteadyMessage',
      KidsDuaLightLevel.star => 'kidsDuaLightSteadyMessage',
      KidsDuaLightLevel.radiant => 'kidsDuaLightRadiantMessage',
    };
  }

  List<KidsDuaReminderPrompt> getReminderCopySet() =>
      const <KidsDuaReminderPrompt>[
        KidsDuaReminderPrompt(
          id: 'morning-light',
          contextType: KidsDuaReminderContextType.morning,
          titleKey: 'kidsDuaReminderMorningTitle',
          bodyKey: 'kidsDuaReminderMorningBody',
          suggestedHour: 8,
          categoryBias: 'daily_basics',
          enabledByDefault: true,
        ),
        KidsDuaReminderPrompt(
          id: 'midday-light',
          contextType: KidsDuaReminderContextType.midday,
          titleKey: 'kidsDuaReminderMiddayTitle',
          bodyKey: 'kidsDuaReminderMiddayBody',
          suggestedHour: 12,
          categoryBias: 'food_drink',
          enabledByDefault: true,
        ),
        KidsDuaReminderPrompt(
          id: 'evening-light',
          contextType: KidsDuaReminderContextType.evening,
          titleKey: 'kidsDuaReminderEveningTitle',
          bodyKey: 'kidsDuaReminderEveningBody',
          suggestedHour: 18,
          categoryBias: 'learning_family',
          enabledByDefault: true,
        ),
        KidsDuaReminderPrompt(
          id: 'bedtime-light',
          contextType: KidsDuaReminderContextType.bedtime,
          titleKey: 'kidsDuaReminderBedtimeTitle',
          bodyKey: 'kidsDuaReminderBedtimeBody',
          suggestedHour: 21,
          categoryBias: 'sleep',
          enabledByDefault: true,
        ),
        KidsDuaReminderPrompt(
          id: 'recovery-light',
          contextType: KidsDuaReminderContextType.gentleRecovery,
          titleKey: 'kidsDuaReminderRecoveryTitle',
          bodyKey: 'kidsDuaReminderRecoveryBody',
          suggestedHour: 17,
          categoryBias: null,
          enabledByDefault: true,
        ),
      ];

  KidsDuaReminderPrompt getSuggestedReminderForContext(
    KidsDuaReminderContextType contextType,
  ) {
    return getReminderCopySet().firstWhere(
      (item) => item.contextType == contextType,
    );
  }

  KidsDuaReminderContextType reminderContextFor({
    required DateTime now,
    required KidsDuaLearningState state,
  }) {
    if (!state.todayCompleted && state.currentStreakDays > 0) {
      final today = dayKey(now);
      if (state.lastActiveDate != null && state.lastActiveDate != today) {
        return KidsDuaReminderContextType.gentleRecovery;
      }
    }
    final hour = now.hour;
    if (hour >= 5 && hour < 10) return KidsDuaReminderContextType.morning;
    if (hour >= 10 && hour < 15) return KidsDuaReminderContextType.midday;
    if (hour >= 15 && hour < 21) return KidsDuaReminderContextType.evening;
    return KidsDuaReminderContextType.bedtime;
  }
}
