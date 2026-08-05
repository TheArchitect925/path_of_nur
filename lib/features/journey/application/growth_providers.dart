import 'dart:math' as math;

import 'package:flutter/widgets.dart' show Locale;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/localization/locale_provider.dart';
import '../../../l10n/app_localizations.dart';
import '../../profile/application/profile_settings_provider.dart';
import '../../../shared/persistence/local_store.dart';
import 'growth_controller.dart';
import 'growth_garden.dart';
import 'growth_models.dart';
import 'growth_seasonal.dart';
import 'growth_seed_content.dart';
import 'growth_seed_data.dart';

final growthControllerProvider =
    StateNotifierProvider<GrowthController, GrowthState>((ref) {
      return GrowthController(ref.watch(localStoreProvider));
    });

class GrowthHabitSectionData {
  const GrowthHabitSectionData({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.habits,
  });

  final String id;
  final String title;
  final String? subtitle;
  final List<GrowthHabit> habits;
}

final growthSelectedDateProvider = StateProvider<DateTime>(
  (ref) => DateTime.now(),
);

final growthSeededHabitsProvider = Provider<List<GrowthHabit>>((ref) {
  return seededGrowthHabits;
});

final growthSeasonalHabitsProvider = Provider<List<GrowthHabit>>((ref) {
  return seasonalGrowthHabits;
});

final growthPathsProvider = Provider<List<GrowthPath>>((ref) {
  return seededGrowthPaths;
});

final growthCategoryContentProvider = Provider<List<GrowthCategoryContent>>((
  ref,
) {
  final list = [...seededGrowthCategories];
  list.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
  return list;
});

final growthCategoryContentByTypeProvider =
    Provider<Map<GrowthHabitCategory, GrowthCategoryContent>>((ref) {
      final map = <GrowthHabitCategory, GrowthCategoryContent>{};
      for (final item in ref.watch(growthCategoryContentProvider)) {
        map[item.category] = item;
      }
      return map;
    });

final growthStageContentProvider = Provider<List<GrowthStageContent>>((ref) {
  final list = [...seededGrowthStages];
  list.sort((a, b) => a.stage.compareTo(b.stage));
  return list;
});

final growthStageContentByNumberProvider =
    Provider<Map<int, GrowthStageContent>>((ref) {
      final map = <int, GrowthStageContent>{};
      for (final item in ref.watch(growthStageContentProvider)) {
        map[item.stage] = item;
      }
      return map;
    });

final growthCustomHabitCategoriesProvider =
    Provider<List<GrowthCustomCategory>>((ref) {
      final categories = [
        ...ref.watch(growthControllerProvider).customHabitCategories,
      ];
      categories.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
      return categories;
    });

final growthCustomHabitCategoriesByIdProvider =
    Provider<Map<String, GrowthCustomCategory>>((ref) {
      final map = <String, GrowthCustomCategory>{};
      for (final category in ref.watch(growthCustomHabitCategoriesProvider)) {
        map[category.id] = category;
      }
      return map;
    });

final growthHabitContentByIdProvider =
    Provider<Map<String, GrowthHabitContent>>((ref) {
      final map = <String, GrowthHabitContent>{};
      for (final item in seededGrowthHabitContent) {
        map[item.habitId] = item;
      }
      return map;
    });

final growthPathContentByIdProvider = Provider<Map<String, GrowthPathContent>>((
  ref,
) {
  final map = <String, GrowthPathContent>{};
  for (final item in seededGrowthPathContent) {
    map[item.pathId] = item;
  }
  return map;
});

final growthReflectionPromptGroupsProvider = Provider<List<GrowthPromptGroup>>((
  ref,
) {
  return seededGrowthPromptGroups;
});

final growthEncouragementCopyProvider = Provider<GrowthEncouragementCopy>((
  ref,
) {
  final locale = ref.watch(appLocaleProvider);
  final l10n = lookupAppLocalizations(locale ?? const Locale('en'));
  return GrowthEncouragementCopy(
    completion: [
      l10n.growthEncouragementCompletion1,
      l10n.growthEncouragementCompletion2,
      l10n.growthEncouragementCompletion3,
    ],
    returning: [
      l10n.growthEncouragementReturning1,
      l10n.growthEncouragementReturning2,
      l10n.growthEncouragementReturning3,
    ],
    streak: [
      l10n.growthEncouragementStreak1,
      l10n.growthEncouragementStreak2,
      l10n.growthEncouragementStreak3,
    ],
    dayEnd: [
      l10n.growthEncouragementDayEnd1,
      l10n.growthEncouragementDayEnd2,
      l10n.growthEncouragementDayEnd3,
    ],
    pathProgress: [
      l10n.growthEncouragementPath1,
      l10n.growthEncouragementPath2,
      l10n.growthEncouragementPath3,
    ],
    gentleReminders: [
      l10n.growthEncouragementReminder1,
      l10n.growthEncouragementReminder2,
      l10n.growthEncouragementReminder3,
    ],
  );
});

final growthMilestoneContentProvider = Provider<List<GrowthMilestoneContent>>((
  ref,
) {
  final list = [...seededGrowthMilestones];
  list.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
  return list;
});

final growthUnlockablesCatalogProvider = Provider<List<GrowthUnlockable>>((
  ref,
) {
  return seededGrowthUnlockables;
});

final growthSeasonalContextProvider = Provider<GrowthSeasonalContext>((ref) {
  final date = ref.watch(growthSelectedDateProvider);
  final profile = ref.watch(profileSettingsProvider);
  final state = ref.watch(growthControllerProvider);
  return buildGrowthSeasonalContext(
    date,
    manualRamadanToggle:
        profile.ramadanModeEnabled || state.ramadanModeOverride,
  );
});

final growthActiveSeasonalJourneyCardsProvider =
    Provider<List<GrowthSeasonalJourneyCard>>((ref) {
      final context = ref.watch(growthSeasonalContextProvider);
      final result = <GrowthSeasonalJourneyCard>[];
      for (final card in seasonalJourneyCards) {
        if (card.id == 'seasonal-ramadan' && context.isRamadanMode) {
          result.add(card);
        } else if (card.id == 'seasonal-last10' && context.isLastTenNights) {
          result.add(card);
        } else if (card.id == 'seasonal-friday' && context.isFriday) {
          result.add(card);
        } else if (card.id == 'seasonal-dhul-hijjah' &&
            context.isDhulHijjahFirstTen) {
          result.add(card);
        }
      }
      return result;
    });

final growthAllHabitsProvider = Provider<List<GrowthHabit>>((ref) {
  final state = ref.watch(growthControllerProvider);
  final base = [
    ...ref.watch(growthSeededHabitsProvider),
    ...ref.watch(growthSeasonalHabitsProvider),
    ...state.customHabits,
  ];

  final withOverrides = base.map((habit) {
    final override = state.habitOverrides[habit.id];
    if (override == null) return habit;
    return habit.copyWith(
      active: override.active,
      muted: override.muted,
      hidden: override.hidden,
      reminderEnabled: override.reminderEnabled,
      entrustToAllah: override.entrustToAllah,
      archived: override.archived,
      privateTracking: override.privateTracking,
      showInToday: override.showInToday,
      paused: override.paused,
      reminderMode: override.reminderMode,
      reminderTimeMinutes: override.reminderTimeMinutes,
      reminderPrayerAnchor: override.reminderPrayerAnchor,
      reminderOffsetMinutes: override.reminderOffsetMinutes,
      reminderWindowType: override.reminderWindowType,
      reminderDays: override.reminderDays,
      reminderMessageOverride: override.reminderMessageOverride,
      quietDelivery: override.quietDelivery,
      allowSnooze: override.allowSnooze,
      remindersPaused: override.remindersPaused,
    );
  }).toList();

  withOverrides.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
  return withOverrides;
});

final growthHabitsByIdProvider = Provider<Map<String, GrowthHabit>>((ref) {
  final map = <String, GrowthHabit>{};
  for (final habit in ref.watch(growthAllHabitsProvider)) {
    map[habit.id] = habit;
  }
  return map;
});

final growthEnabledHabitsProvider = Provider<List<GrowthHabit>>((ref) {
  return ref
      .watch(growthAllHabitsProvider)
      .where((habit) => habit.active && !habit.hidden && !habit.archived)
      .toList(growable: false);
});

final growthLogsForSelectedDateProvider = Provider<Map<String, GrowthHabitLog>>(
  (ref) {
    final state = ref.watch(growthControllerProvider);
    final date = ref.watch(growthSelectedDateProvider);
    final dayKey = LocalStore.todayKey(date);
    return Map<String, GrowthHabitLog>.from(
      state.habitLogsByDay[dayKey] ?? const {},
    );
  },
);

final growthStatusesForSelectedDateProvider =
    Provider<Map<String, GrowthHabitStatus>>((ref) {
      final logs = ref.watch(growthLogsForSelectedDateProvider);
      final status = <String, GrowthHabitStatus>{};
      for (final entry in logs.entries) {
        status[entry.key] = entry.value.status;
      }
      return status;
    });

final growthDueHabitsForSelectedDateProvider = Provider<List<GrowthHabit>>((
  ref,
) {
  final habits = ref.watch(growthAllHabitsProvider);
  final state = ref.watch(growthControllerProvider);
  final date = ref.watch(growthSelectedDateProvider);

  return habits.where((habit) => isHabitDueOnDate(habit, date, state)).toList();
});

final growthDueHabitsByCategoryProvider =
    Provider<Map<GrowthHabitCategory, List<GrowthHabit>>>((ref) {
      final due = ref.watch(growthDueHabitsForSelectedDateProvider);
      final map = <GrowthHabitCategory, List<GrowthHabit>>{};
      for (final habit in due) {
        map.putIfAbsent(habit.category, () => []);
        map[habit.category]!.add(habit);
      }
      return map;
    });

final growthDueHabitSectionsProvider = Provider<List<GrowthHabitSectionData>>((
  ref,
) {
  final due = ref.watch(growthDueHabitsForSelectedDateProvider);
  final categoryMeta = ref.watch(growthCategoryContentByTypeProvider);
  final customCategories = ref.watch(growthCustomHabitCategoriesByIdProvider);
  final sections = <String, List<GrowthHabit>>{};
  for (final habit in due) {
    final key = habit.customCategoryId?.isNotEmpty == true
        ? 'custom:${habit.customCategoryId}'
        : 'system:${habit.category.name}';
    sections.putIfAbsent(key, () => <GrowthHabit>[]);
    sections[key]!.add(habit);
  }
  final result = <GrowthHabitSectionData>[];
  for (final entry in sections.entries) {
    entry.value.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    final first = entry.value.first;
    final customCategory = first.customCategoryId == null
        ? null
        : customCategories[first.customCategoryId!];
    result.add(
      GrowthHabitSectionData(
        id: entry.key,
        title:
            customCategory?.title ??
            categoryMeta[first.category]?.title ??
            first.category.name,
        subtitle:
            customCategory?.description ??
            categoryMeta[first.category]?.subtitle,
        habits: entry.value,
      ),
    );
  }
  result.sort((a, b) {
    final left = a.habits.first.sortOrder;
    final right = b.habits.first.sortOrder;
    return left.compareTo(right);
  });
  return result;
});

final growthSeasonalReflectionPromptsProvider = Provider<List<String>>((ref) {
  final context = ref.watch(growthSeasonalContextProvider);
  final prompts = <String>[];
  for (final season in context.activeSeasons) {
    prompts.addAll(seasonalReflectionPromptBank[season] ?? const []);
  }
  return prompts;
});

final growthFastTrackingProvider = Provider<GrowthFastTrackingData>((ref) {
  final context = ref.watch(growthSeasonalContextProvider);
  final state = ref.watch(growthControllerProvider);
  final date = ref.watch(growthSelectedDateProvider);
  final logs = ref.watch(growthLogsForSelectedDateProvider);
  final dayKey = LocalStore.todayKey(date);

  GrowthFastTrackType selected = context.recommendedFastType;
  final persisted = state.fastTrackTypeByDay[dayKey];
  if (persisted != null) {
    for (final item in GrowthFastTrackType.values) {
      if (item.name == persisted) {
        selected = item;
      }
    }
  }

  final habitId = context.isRamadanMode
      ? 's_ramadan_fast_today'
      : 's_fast_optional_today';

  final completed = logs[habitId]?.status == GrowthHabitStatus.completed;

  return GrowthFastTrackingData(
    recommendedType: context.recommendedFastType,
    availableTypes: context.availableFastTypes,
    selectedType: selected,
    habitIdForToday: habitId,
    completedToday: completed,
  );
});

final growthRamadanQuranTrackerProvider =
    Provider<GrowthQuranCompletionTracker>((ref) {
      final state = ref.watch(growthControllerProvider);
      final context = ref.watch(growthSeasonalContextProvider);
      final plan = state.ramadanQuranPlanDays.clamp(10, 30);
      final juz = state.ramadanQuranCompletedJuz.clamp(0, 30).toDouble();
      final remaining = (30 - juz).clamp(0, 30).toDouble();
      final completedPercent = ((juz / 30) * 100).round().clamp(0, 100);
      final day = context.hijriDate.day.clamp(1, plan);
      final daysRemaining = (plan - day + 1).clamp(1, plan);
      final neededPerDay = remaining <= 0 ? 0.0 : (remaining / daysRemaining);

      return GrowthQuranCompletionTracker(
        planDays: plan,
        currentJuzProgress: juz,
        remainingJuz: remaining,
        completedPercent: completedPercent,
        estimatedDaysRemaining: daysRemaining,
        estimatedDailyJuzNeeded: neededPerDay,
      );
    });

final growthRamadanDashboardProvider = Provider<GrowthRamadanDashboardData?>((
  ref,
) {
  final l10n = lookupAppLocalizations(
    ref.watch(appLocaleProvider) ?? const Locale('en'),
  );
  final context = ref.watch(growthSeasonalContextProvider);
  if (!context.isRamadanMode) return null;
  final logs = ref.watch(growthLogsForSelectedDateProvider);
  final completedFast =
      logs['s_ramadan_fast_today']?.status == GrowthHabitStatus.completed;
  final completedQuran =
      logs['s_ramadan_quran']?.status == GrowthHabitStatus.completed;
  final completedCharity =
      logs['s_ramadan_charity']?.status == GrowthHabitStatus.completed;
  final completedReflection =
      logs['s_ramadan_night_reflection']?.status == GrowthHabitStatus.completed;
  var score = 0;
  if (completedFast) score += 1;
  if (completedQuran) score += 1;
  if (completedCharity) score += 1;
  if (completedReflection) score += 1;
  final progress = score / 4;
  return GrowthRamadanDashboardData(
    fastCompleted: completedFast,
    quranHabitCompleted: completedQuran,
    charityCompleted: completedCharity,
    reflectionCompleted: completedReflection,
    dailyProgress: progress,
    progressLabel: l10n.growthRamadanProgressLabel((progress * 100).round()),
  );
});

final growthReflectionPromptSuggestionsProvider = Provider<List<String>>((ref) {
  final l10n = lookupAppLocalizations(
    ref.watch(appLocaleProvider) ?? const Locale('en'),
  );
  final due = ref.watch(growthDueHabitsForSelectedDateProvider);
  final logs = ref.watch(growthLogsForSelectedDateProvider);
  final grouped = ref.watch(growthReflectionPromptGroupsProvider);
  final date = ref.watch(growthSelectedDateProvider);

  final prompts = <String>[];
  final completed = due.where(
    (h) => logs[h.id]?.status == GrowthHabitStatus.completed,
  );
  final revisit = due.where((h) {
    final status = logs[h.id]?.status;
    return status == GrowthHabitStatus.skipped ||
        status == GrowthHabitStatus.deferred;
  });

  for (final habit in completed.take(2)) {
    prompts.add(l10n.growthReflectionPromptCompleted(habit.title));
  }
  for (final habit in revisit.take(2)) {
    prompts.add(l10n.growthReflectionPromptRevisit(habit.title));
  }
  final dayIndex =
      (date.day + date.month + date.year) %
      grouped.fold<int>(0, (sum, g) => sum + g.prompts.length).clamp(1, 9999);
  var cursor = 0;
  for (final group in grouped) {
    for (final prompt in group.prompts) {
      if (cursor ==
          dayIndex % grouped.fold<int>(0, (sum, g) => sum + g.prompts.length)) {
        prompts.add(prompt);
      }
      cursor += 1;
    }
  }
  if (prompts.isEmpty) {
    prompts.add(l10n.growthReflectionPromptSincereMoment);
  }
  prompts.addAll(ref.watch(growthSeasonalReflectionPromptsProvider).take(2));
  return prompts.toSet().take(4).toList();
});

final growthTodaySummaryProvider = Provider<GrowthTodaySummary>((ref) {
  final state = ref.watch(growthControllerProvider);
  final date = ref.watch(growthSelectedDateProvider);
  final due = ref.watch(growthDueHabitsForSelectedDateProvider);
  final byId = ref.watch(growthHabitsByIdProvider);
  final dayLogs = ref.watch(growthLogsForSelectedDateProvider);

  var completed = 0;
  var partial = 0;
  var skipped = 0;
  var deferred = 0;
  var snoozed = 0;
  var visibleLight = 0;
  var subtleLight = 0;

  for (final habit in due) {
    final log = dayLogs[habit.id];
    if (log == null) continue;

    if (log.status == GrowthHabitStatus.completed) {
      completed += 1;
    } else if (log.status == GrowthHabitStatus.partial) {
      partial += 1;
    } else if (log.status == GrowthHabitStatus.skipped) {
      skipped += 1;
    } else if (log.status == GrowthHabitStatus.deferred) {
      deferred += 1;
    } else if (log.status == GrowthHabitStatus.snoozed) {
      snoozed += 1;
    }

    final contribution = (habit.lightReward * log.progress).round();
    subtleLight += contribution;
    if (!_isEntrustedForStats(habit: habit, log: log, state: state)) {
      visibleLight += contribution;
    }
  }

  final progressCredit = due.fold<double>(0, (sum, habit) {
    final log = dayLogs[habit.id];
    if (log == null) return sum;
    return sum + _completionCredit(log);
  });

  final progress = due.isEmpty
      ? 0.0
      : (progressCredit / due.length).clamp(0.0, 1.0);
  final streak = _computeCurrentStreak(state, byId, date);
  final bestStreak = _computeBestStreak(state, byId, date);

  return GrowthTodaySummary(
    date: date,
    dueCount: due.length,
    completedCount: completed,
    partialCount: partial,
    skippedCount: skipped,
    deferredCount: deferred,
    snoozedCount: snoozed,
    completionProgress: progress,
    visibleLightEarnedToday: visibleLight,
    subtleLightEarnedToday: subtleLight,
    currentStreakDays: streak.currentStreak,
    bestStreakDays: bestStreak,
    protectedDaysUsedThisWeek: streak.protectedDaysUsed,
  );
});

final growthPathProgressProvider = Provider<List<GrowthPathProgress>>((ref) {
  final state = ref.watch(growthControllerProvider);
  final paths = ref.watch(growthPathsProvider);
  final allHabitsById = ref.watch(growthHabitsByIdProvider);
  final selectedDate = ref.watch(growthSelectedDateProvider);
  final l10n = lookupAppLocalizations(
    ref.watch(appLocaleProvider) ?? const Locale('en'),
  );

  final totalLightVisible = _computeTotalLight(
    state,
    allHabitsById,
    visibleOnly: true,
  );
  final completedEver = <String, double>{};
  for (final day in state.habitLogsByDay.values) {
    for (final entry in day.entries) {
      final score = completedEver[entry.key] ?? 0;
      completedEver[entry.key] = math.max(score, entry.value.progress);
    }
  }

  final list = <GrowthPathProgress>[];

  for (final path in paths) {
    final habits = path.habitIds
        .map((id) => allHabitsById[id])
        .whereType<GrowthHabit>()
        .where((habit) => !habit.archived)
        .toList();

    final progressRaw = habits.fold<double>(0, (sum, habit) {
      return sum + (completedEver[habit.id] ?? 0);
    });

    final progress = habits.isEmpty
        ? 0.0
        : (progressRaw / habits.length).clamp(0.0, 1.0);

    var unlocked = true;
    if (path.unlockLight > 0 && totalLightVisible < path.unlockLight) {
      unlocked = false;
    }
    if (path.unlockPathId != null) {
      final dependency = list
          .where((e) => e.path.id == path.unlockPathId)
          .toList();
      if (dependency.isNotEmpty && dependency.first.progress < 0.55) {
        unlocked = false;
      }
    }

    final started = state.startedPathIds.contains(path.id);
    final paused = state.pausedPathIds.contains(path.id);
    final completedPath = progress >= 0.999;

    String? recommendedNextHabitId;
    String recommendedNextStep = l10n.growthPathRecommendedNextStepDefault;

    if (habits.isNotEmpty) {
      final dueToday = habits.where(
        (habit) => isHabitDueOnDate(habit, selectedDate, state),
      );
      for (final habit in dueToday) {
        final log =
            state.habitLogsByDay[LocalStore.todayKey(selectedDate)]?[habit.id];
        if (log == null || log.progress < 1) {
          recommendedNextHabitId = habit.id;
          recommendedNextStep = l10n.growthPathRecommendedNextStepCompleteToday(
            habit.title,
          );
          break;
        }
      }
      if (recommendedNextHabitId == null) {
        final firstUnbuilt = habits
            .where((h) => (completedEver[h.id] ?? 0) < 1)
            .toList();
        if (firstUnbuilt.isNotEmpty) {
          recommendedNextHabitId = firstUnbuilt.first.id;
          recommendedNextStep = l10n.growthPathRecommendedNextStepFocus(
            firstUnbuilt.first.title,
          );
        }
      }
    }

    list.add(
      GrowthPathProgress(
        path: path,
        unlocked: unlocked,
        started: started,
        paused: paused,
        completedHabits: habits
            .where((h) => (completedEver[h.id] ?? 0) >= 1)
            .length,
        progress: progress,
        completed: completedPath,
        completionCelebrationPending:
            completedPath && !state.celebratedPathIds.contains(path.id),
        recommendedNextHabitId: recommendedNextHabitId,
        recommendedNextStep: recommendedNextStep,
      ),
    );
  }

  return list;
});

final growthJourneyStatsProvider = Provider<GrowthJourneyStats>((ref) {
  final state = ref.watch(growthControllerProvider);
  final habitsById = ref.watch(growthHabitsByIdProvider);
  final paths = ref.watch(growthPathProgressProvider);
  final now = ref.watch(growthSelectedDateProvider);
  final l10n = lookupAppLocalizations(
    ref.watch(appLocaleProvider) ?? const Locale('en'),
  );

  final visibleLight = _computeTotalLight(state, habitsById, visibleOnly: true);
  final subtleLight = _computeTotalLight(state, habitsById, visibleOnly: false);

  final totalCompleted = _computeTotalCompletedActions(state);
  final streak = _computeCurrentStreak(state, habitsById, now);
  final bestStreak = _computeBestStreak(state, habitsById, now);
  final weekly = _weeklyCompletionBars(state, habitsById, now);
  final calendar = _monthlyConsistencyCalendar(state, habitsById, now);
  final categoryProgress = _categoryProgress(state, habitsById, now);

  final level = _levelForLight(visibleLight);
  final levelStart = _lightForLevel(level);
  final nextLevel = _lightForLevel(level + 1);
  final levelProgress =
      ((visibleLight - levelStart) / math.max(1, nextLevel - levelStart))
          .clamp(0.0, 1.0)
          .toDouble();

  final weekSummary = _buildWeekSummary(state, habitsById, now, l10n);
  final monthSummary = _buildMonthSummary(state, habitsById, now, l10n);
  final encouragement = ref.watch(growthEncouragementCopyProvider);
  final milestoneCatalog = ref.watch(growthMilestoneContentProvider);

  final milestones = <GrowthMilestoneView>[];
  GrowthMilestoneContent byId(String id) => milestoneCatalog.firstWhere(
    (item) => item.id == id,
    orElse: () => milestoneCatalog.first,
  );
  if (totalCompleted >= 1) {
    milestones.add(GrowthMilestoneView(content: byId('first_light')));
  }
  if (bestStreak >= 7) {
    milestones.add(GrowthMilestoneView(content: byId('steady_footsteps')));
  }
  if (state.reflections.length >= 12) {
    milestones.add(GrowthMilestoneView(content: byId('heart_in_motion')));
  }
  if (bestStreak >= 14) {
    milestones.add(GrowthMilestoneView(content: byId('days_of_consistency')));
  }
  if (streak.protectedDaysUsed > 0 ||
      summaryReturningSignal(state, habitsById, now) >= 3) {
    milestones.add(GrowthMilestoneView(content: byId('quiet_resolve')));
  }
  if (state.reflections.length >= 8) {
    milestones.add(GrowthMilestoneView(content: byId('returning_often')));
  }
  if (categoryProgress.values.where((v) => v >= 0.70).length >= 3) {
    milestones.add(GrowthMilestoneView(content: byId('garden_beginnings')));
  }
  if (categoryProgress[GrowthHabitCategory.healthDiscipline] != null &&
      categoryProgress[GrowthHabitCategory.healthDiscipline]! >= 0.55) {
    milestones.add(GrowthMilestoneView(content: byId('gentle_discipline')));
  }
  if (paths.where((e) => e.completed).isNotEmpty) {
    milestones.add(GrowthMilestoneView(content: byId('path_strengthened')));
  }
  if (bestStreak >= 21 || totalCompleted >= 220) {
    milestones.add(GrowthMilestoneView(content: byId('light_upon_light')));
  }
  final milestoneTitles = milestones.map((e) => e.content.title).toList();

  return GrowthJourneyStats(
    level: level,
    visibleLight: visibleLight,
    subtleLight: subtleLight,
    nextLevelLightRemaining: math.max(0, nextLevel - visibleLight),
    levelProgress: levelProgress,
    totalCompletedActions: totalCompleted,
    currentStreakDays: streak.currentStreak,
    bestStreakDays: bestStreak,
    weeklyCompletionBars: weekly,
    monthlyConsistencyByDay: calendar,
    categoryProgress: categoryProgress,
    pathProgress: paths,
    milestones: milestoneTitles,
    milestoneDetails: milestones,
    weeklySummary: weekSummary,
    monthlySummary: monthSummary,
    protectedDaysUsedThisWeek: streak.protectedDaysUsed,
    encouragementLine:
        encouragement.pathProgress[(now.day + now.month) %
            encouragement.pathProgress.length],
  );
});

final growthGardenProgressProvider = Provider<GrowthGardenProgressView>((ref) {
  final state = ref.watch(growthControllerProvider);
  final stats = ref.watch(growthJourneyStatsProvider);
  final paths = ref.watch(growthPathProgressProvider);
  final seasonalCards = ref.watch(growthActiveSeasonalJourneyCardsProvider);

  final completionScore = (stats.totalCompletedActions / 220).clamp(0.0, 1.0);
  final streakScore = (stats.bestStreakDays / 28).clamp(0.0, 1.0);
  final reflectionScore = (state.reflections.length / 40).clamp(0.0, 1.0);
  final pathScore = paths.isEmpty
      ? 0.0
      : paths.fold<double>(0, (sum, p) => sum + p.progress) / paths.length;
  final categoryScore = stats.categoryProgress.isEmpty
      ? 0.0
      : stats.categoryProgress.values.fold<double>(0, (s, v) => s + v) /
            stats.categoryProgress.length;
  final seasonalScore = _seasonalCompletionScore(state, seasonalCards);

  final gardenScore =
      ((completionScore * 0.24) +
              (streakScore * 0.2) +
              (reflectionScore * 0.18) +
              (pathScore * 0.16) +
              (categoryScore * 0.14) +
              (seasonalScore * 0.08))
          .clamp(0.0, 1.0);

  final visual = gardenVisualForScore(
    gardenScore: gardenScore,
    privateMode: state.privateMode,
  );

  return GrowthGardenProgressView(
    score: gardenScore,
    visual: visual,
    currentStage: visual.stage,
    currentStageLabel: visual.stageLabel,
    stageSubtitle: visual.stageSubtitle,
    stageProgress: visual.progressToNext,
    nextStageLabel: visual.nextStageLabel,
    recentGrowthLine: visual.recentGrowthLine,
  );
});

final growthEligibleUnlockablesProvider = Provider<List<GrowthUnlockable>>((
  ref,
) {
  final state = ref.watch(growthControllerProvider);
  final garden = ref.watch(growthGardenProgressProvider);
  final stats = ref.watch(growthJourneyStatsProvider);
  final quranTracker = ref.watch(growthRamadanQuranTrackerProvider);
  final milestones = stats.milestoneDetails.map((e) => e.content.id).toSet();
  final seasonal = ref.watch(growthSeasonalContextProvider);
  final catalog = ref.watch(growthUnlockablesCatalogProvider);
  final fastCompletions = _fastCompletionCount(state);

  bool seasonMatch(String? tag) {
    if (tag == null) return true;
    switch (tag) {
      case 'ramadan':
        return seasonal.isRamadanMode;
      case 'last10':
        return seasonal.isLastTenNights;
      case 'friday':
        return seasonal.isFriday;
      case 'dhul_hijjah':
        return seasonal.isDhulHijjahFirstTen;
      default:
        return true;
    }
  }

  return catalog.where((unlock) {
    if (state.unlockedRewardIds.contains(unlock.id)) return false;
    if (stats.totalCompletedActions < unlock.requiredTotalCompletions) {
      return false;
    }
    if (stats.bestStreakDays < unlock.requiredStreakDays) return false;
    if (state.reflections.length < unlock.requiredReflections) return false;
    if (_gardenStageIndex(garden.currentStage) <
        _gardenStageIndex(unlock.requiredGardenStage)) {
      return false;
    }
    if (quranTracker.currentJuzProgress < unlock.requiredQuranJuz) {
      return false;
    }
    if (fastCompletions < unlock.requiredFastCompletions) {
      return false;
    }
    if (unlock.requiredMilestoneId != null &&
        !milestones.contains(unlock.requiredMilestoneId)) {
      return false;
    }
    if (!seasonMatch(unlock.requiredSeasonTag)) return false;
    return true;
  }).toList();
});

final growthUnlocksAutoSyncProvider = Provider<void>((ref) {
  ref.listen<List<GrowthUnlockable>>(growthEligibleUnlockablesProvider, (
    _,
    eligible,
  ) {
    Future<void>.microtask(() {
      final ids = eligible.map((e) => e.id).toSet();
      if (ids.isEmpty) return;
      ref
          .read(growthControllerProvider.notifier)
          .registerUnlockedRewards(ids, source: 'growth_progress');
    });
  }, fireImmediately: true);
});

final growthUnlockedRewardsProvider = Provider<List<GrowthUnlockable>>((ref) {
  final state = ref.watch(growthControllerProvider);
  final catalog = ref.watch(growthUnlockablesCatalogProvider);
  final map = {for (final reward in catalog) reward.id: reward};
  final list = <GrowthUnlockable>[];
  for (final id in state.unlockedRewardIds) {
    final reward = map[id];
    if (reward != null) list.add(reward);
  }
  list.sort((a, b) => a.title.compareTo(b.title));
  return list;
});

final growthRecentUnlocksProvider = Provider<List<GrowthRecentUnlockView>>((
  ref,
) {
  final state = ref.watch(growthControllerProvider);
  final catalog = ref.watch(growthUnlockablesCatalogProvider);
  final map = {for (final reward in catalog) reward.id: reward};
  final list = <GrowthRecentUnlockView>[];
  for (final event in state.rewardEvents) {
    final reward = map[event.rewardId];
    if (reward == null) continue;
    list.add(
      GrowthRecentUnlockView(
        reward: reward,
        unlockedAt: event.unlockedAt,
        source: event.source,
      ),
    );
  }
  list.sort((a, b) => b.unlockedAt.compareTo(a.unlockedAt));
  return list.take(6).toList();
});

final growthNextUnlockPreviewProvider = Provider<GrowthUnlockable?>((ref) {
  final state = ref.watch(growthControllerProvider);
  final stats = ref.watch(growthJourneyStatsProvider);
  final garden = ref.watch(growthGardenProgressProvider);
  final catalog = ref.watch(growthUnlockablesCatalogProvider);

  final locked = catalog
      .where((item) => !state.unlockedRewardIds.contains(item.id))
      .toList();
  if (locked.isEmpty) return null;
  locked.sort((a, b) {
    final aGap = (a.requiredTotalCompletions - stats.totalCompletedActions)
        .abs();
    final bGap = (b.requiredTotalCompletions - stats.totalCompletedActions)
        .abs();
    if (aGap != bGap) return aGap.compareTo(bGap);
    final aStageGap =
        _gardenStageIndex(a.requiredGardenStage) -
        _gardenStageIndex(garden.currentStage);
    final bStageGap =
        _gardenStageIndex(b.requiredGardenStage) -
        _gardenStageIndex(garden.currentStage);
    return aStageGap.compareTo(bStageGap);
  });
  return locked.first;
});

final growthReflectionsForSelectedDateProvider =
    Provider<List<GrowthReflectionEntry>>((ref) {
      final state = ref.watch(growthControllerProvider);
      final dayKey = LocalStore.todayKey(ref.watch(growthSelectedDateProvider));
      return state.reflections.where((e) => e.dayKey == dayKey).toList();
    });

final growthReflectionHistoryProvider = Provider<List<GrowthReflectionEntry>>((
  ref,
) {
  final list = [...ref.watch(growthControllerProvider).reflections];
  list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
  return list;
});

final growthGratitudeHistoryProvider = Provider<List<String>>((ref) {
  return ref
      .watch(growthReflectionHistoryProvider)
      .map((e) => e.gratitude.trim())
      .where((text) => text.isNotEmpty)
      .toList();
});

final growthEndOfDaySummaryProvider = Provider<GrowthEndOfDaySummary>((ref) {
  final summary = ref.watch(growthTodaySummaryProvider);
  final reflections = ref.watch(growthReflectionsForSelectedDateProvider);
  final encouragement = ref.watch(growthEncouragementCopyProvider);
  final tone = summary.completionProgress >= 0.75
      ? encouragement.dayEnd.first
      : summary.completionProgress >= 0.45
      ? encouragement.dayEnd[1]
      : encouragement.returning.first;

  return GrowthEndOfDaySummary(
    completionPercent: (summary.completionProgress * 100).round(),
    completed: summary.completedCount,
    partial: summary.partialCount,
    missed: summary.skippedCount + summary.deferredCount,
    hasReflection: reflections.isNotEmpty,
    tone: tone,
  );
});

final growthRecentActivityProvider = Provider<List<GrowthRecentActivity>>((
  ref,
) {
  final l10n = lookupAppLocalizations(
    ref.watch(appLocaleProvider) ?? const Locale('en'),
  );
  final state = ref.watch(growthControllerProvider);
  final byId = ref.watch(growthHabitsByIdProvider);

  final items = <GrowthRecentActivity>[];

  for (final dayEntry in state.habitLogsByDay.entries) {
    final parsedDay = DateTime.tryParse(dayEntry.key);
    if (parsedDay == null) continue;
    for (final logEntry in dayEntry.value.entries) {
      final habit = byId[logEntry.key];
      if (habit == null) continue;
      items.add(
        GrowthRecentActivity(
          at: parsedDay,
          title: habit.title,
          subtitle: _statusLabel(logEntry.value.status, l10n),
          isReflection: false,
          isEntrusted: _isEntrustedForStats(
            habit: habit,
            log: logEntry.value,
            state: state,
          ),
        ),
      );
    }
  }

  for (final reflection in state.reflections) {
    items.add(
      GrowthRecentActivity(
        at: reflection.createdAt,
        title: l10n.growthRecentActivityReflectionRecorded,
        subtitle: reflection.gratitude.isEmpty
            ? l10n.growthRecentActivityPrivateNote
            : reflection.gratitude,
        isReflection: true,
        isEntrusted: reflection.entrustToAllah,
      ),
    );
  }

  items.sort((a, b) => b.at.compareTo(a.at));
  return items.take(20).toList();
});

bool isHabitDueOnDate(GrowthHabit habit, DateTime date, GrowthState state) {
  if (!_isSeasonalHabitActiveOnDate(habit.id, date, state)) {
    return false;
  }
  if (!habit.active ||
      habit.paused ||
      !habit.showInToday ||
      habit.hidden ||
      habit.muted ||
      habit.archived) {
    return false;
  }

  switch (habit.recurrenceType) {
    case GrowthHabitRecurrenceType.daily:
      return true;
    case GrowthHabitRecurrenceType.weekdaysOnly:
      return date.weekday >= DateTime.monday && date.weekday <= DateTime.friday;
    case GrowthHabitRecurrenceType.customWeekdays:
      return habit.weekdays.contains(date.weekday);
    case GrowthHabitRecurrenceType.weeklyTarget:
      final completedInWeek = _countCompletionCreditInWeek(
        state,
        habit.id,
        date,
      );
      final dayInWeek = date.weekday.clamp(1, 7);
      final expectedByToday = ((habit.frequencyTarget * dayInWeek) / 7).ceil();
      return completedInWeek < expectedByToday;
    case GrowthHabitRecurrenceType.occasional:
      final lastCompletion = _lastCompletionDate(state, habit.id, date);
      if (lastCompletion == null) return true;
      final gap = date.difference(lastCompletion).inDays;
      return gap >= math.max(5, habit.customIntervalDays);
    case GrowthHabitRecurrenceType.customFrequency:
      final lastCompletion = _lastCompletionDate(state, habit.id, date);
      if (lastCompletion == null) return true;
      final gap = date.difference(lastCompletion).inDays;
      return gap >= math.max(1, habit.customIntervalDays);
  }
}

bool _isSeasonalHabitActiveOnDate(
  String habitId,
  DateTime date,
  GrowthState state,
) {
  final hijri = growthToHijriDate(date);
  final isFriday = date.weekday == DateTime.friday;
  final today = DateTime.now();
  final isToday =
      date.year == today.year &&
      date.month == today.month &&
      date.day == today.day;
  if (habitId.startsWith('s_ramadan_')) {
    return hijri.month == 9 || (state.ramadanModeOverride && isToday);
  }
  if (habitId.startsWith('s_last10_')) {
    if (state.ramadanModeOverride && isToday) return true;
    return hijri.month == 9 && hijri.day >= 21;
  }
  if (habitId.startsWith('s_friday_')) {
    return isFriday;
  }
  if (habitId.startsWith('s_dhul_')) {
    return hijri.month == 12 && hijri.day <= 10;
  }
  if (habitId == 's_fast_optional_today') {
    if (hijri.month == 9) return false;
    if (date.weekday == DateTime.monday || date.weekday == DateTime.thursday) {
      return true;
    }
    if (hijri.day >= 13 && hijri.day <= 15) return true;
    if (hijri.month == 12 && hijri.day == 9) return true;
    if (hijri.month == 1 && (hijri.day == 9 || hijri.day == 10)) return true;
    return false;
  }
  return true;
}

int summaryReturningSignal(
  GrowthState state,
  Map<String, GrowthHabit> habitsById,
  DateTime now,
) {
  var count = 0;
  for (var i = 0; i < 28; i++) {
    final day = DateTime(
      now.year,
      now.month,
      now.day,
    ).subtract(Duration(days: i));
    final ratio = _dayCompletionRatio(state, habitsById, day);
    if (ratio >= 0.35 && ratio < 0.60) {
      count += 1;
    }
  }
  return count;
}

DateTime? _lastCompletionDate(
  GrowthState state,
  String habitId,
  DateTime onOrBefore,
) {
  DateTime? latest;
  for (final dayEntry in state.habitLogsByDay.entries) {
    final date = DateTime.tryParse(dayEntry.key);
    if (date == null) continue;
    if (date.isAfter(
      DateTime(onOrBefore.year, onOrBefore.month, onOrBefore.day),
    )) {
      continue;
    }
    final log = dayEntry.value[habitId];
    if (log == null || log.progress <= 0) continue;
    if (latest == null || date.isAfter(latest)) {
      latest = date;
    }
  }
  return latest;
}

double _countCompletionCreditInWeek(
  GrowthState state,
  String habitId,
  DateTime date,
) {
  final weekStart = date.subtract(
    Duration(days: date.weekday - DateTime.monday),
  );
  var completed = 0.0;
  for (var i = 0; i < 7; i++) {
    final day = weekStart.add(Duration(days: i));
    final key = LocalStore.todayKey(day);
    final log = state.habitLogsByDay[key]?[habitId];
    if (log == null) continue;
    completed += _completionCredit(log);
  }
  return completed;
}

double _completionCredit(GrowthHabitLog log) {
  switch (log.status) {
    case GrowthHabitStatus.completed:
      return 1;
    case GrowthHabitStatus.partial:
      return (log.progress.clamp(0.0, 1.0) * 0.8).clamp(0.2, 0.8);
    case GrowthHabitStatus.snoozed:
      return 0;
    case GrowthHabitStatus.deferred:
      return 0;
    case GrowthHabitStatus.skipped:
      return 0;
  }
}

double _dayCompletionRatio(
  GrowthState state,
  Map<String, GrowthHabit> byId,
  DateTime date,
) {
  final due = byId.values
      .where((habit) => isHabitDueOnDate(habit, date, state))
      .toList();
  if (due.isEmpty) return 0.0;
  final logs = state.habitLogsByDay[LocalStore.todayKey(date)] ?? const {};
  var credit = 0.0;
  var denominator = 0.0;
  for (final habit in due) {
    final log = logs[habit.id];
    final weight = _habitWeightForStreak(habit);
    denominator += weight;
    if (log == null) continue;
    credit += _completionCredit(log) * weight;
  }
  if (denominator <= 0) return 0.0;
  return (credit / denominator).clamp(0.0, 1.0);
}

double _habitWeightForStreak(GrowthHabit habit) {
  switch (habit.recurrenceType) {
    case GrowthHabitRecurrenceType.occasional:
      return 0.4;
    case GrowthHabitRecurrenceType.customFrequency:
      return 0.7;
    case GrowthHabitRecurrenceType.weeklyTarget:
      return 0.85;
    case GrowthHabitRecurrenceType.daily:
    case GrowthHabitRecurrenceType.weekdaysOnly:
    case GrowthHabitRecurrenceType.customWeekdays:
      return 1.0;
  }
}

bool _dayHasReflection(GrowthState state, DateTime date) {
  final key = LocalStore.todayKey(date);
  return state.reflections.any((entry) => entry.dayKey == key);
}

_StreakResult _computeCurrentStreak(
  GrowthState state,
  Map<String, GrowthHabit> byId,
  DateTime now,
) {
  var streak = 0;
  var protectedUsed = 0;
  final pointerStart = DateTime(now.year, now.month, now.day);

  for (var i = 0; i < 365; i++) {
    final pointer = pointerStart.subtract(Duration(days: i));
    final ratio = _dayCompletionRatio(state, byId, pointer);
    if (ratio >= 0.60) {
      streak += 1;
      continue;
    }

    final withinWeeklyCompassion = protectedUsed < 1;
    if (withinWeeklyCompassion &&
        ratio >= 0.45 &&
        _dayHasReflection(state, pointer)) {
      streak += 1;
      protectedUsed += 1;
      continue;
    }

    break;
  }

  return _StreakResult(currentStreak: streak, protectedDaysUsed: protectedUsed);
}

int _computeBestStreak(
  GrowthState state,
  Map<String, GrowthHabit> byId,
  DateTime now,
) {
  var best = 0;
  var running = 0;
  for (var i = 240; i >= 0; i--) {
    final day = DateTime(
      now.year,
      now.month,
      now.day,
    ).subtract(Duration(days: i));
    final ratio = _dayCompletionRatio(state, byId, day);
    if (ratio >= 0.60) {
      running += 1;
      if (running > best) best = running;
    } else {
      running = 0;
    }
  }
  return best;
}

int _computeTotalCompletedActions(GrowthState state) {
  var total = 0;
  for (final day in state.habitLogsByDay.values) {
    for (final log in day.values) {
      if (log.status == GrowthHabitStatus.completed) total += 1;
    }
  }
  return total;
}

int _computeTotalLight(
  GrowthState state,
  Map<String, GrowthHabit> byId, {
  required bool visibleOnly,
}) {
  var total = 0;
  for (final day in state.habitLogsByDay.values) {
    for (final entry in day.entries) {
      final habit = byId[entry.key];
      if (habit == null) continue;
      final log = entry.value;
      if (log.progress <= 0) continue;
      if (visibleOnly &&
          _isEntrustedForStats(habit: habit, log: log, state: state)) {
        continue;
      }
      total += (habit.lightReward * log.progress).round();
    }
  }
  return total;
}

bool _isEntrustedForStats({
  required GrowthHabit habit,
  required GrowthHabitLog? log,
  required GrowthState state,
}) {
  if (state.privateMode) return true;
  if (habit.privateTracking) return true;
  if (habit.entrustToAllah) return true;
  return log?.entrusted == true;
}

List<double> _weeklyCompletionBars(
  GrowthState state,
  Map<String, GrowthHabit> byId,
  DateTime now,
) {
  final start = DateTime(
    now.year,
    now.month,
    now.day,
  ).subtract(Duration(days: now.weekday - DateTime.monday));
  return List<double>.generate(7, (index) {
    return _dayCompletionRatio(state, byId, start.add(Duration(days: index)));
  });
}

Map<int, double> _monthlyConsistencyCalendar(
  GrowthState state,
  Map<String, GrowthHabit> byId,
  DateTime now,
) {
  final lastDay = DateTime(now.year, now.month + 1, 0).day;
  final map = <int, double>{};
  for (var day = 1; day <= lastDay; day++) {
    final date = DateTime(now.year, now.month, day);
    map[day] = _dayCompletionRatio(state, byId, date);
  }
  return map;
}

Map<GrowthHabitCategory, double> _categoryProgress(
  GrowthState state,
  Map<String, GrowthHabit> byId,
  DateTime now,
) {
  final due = <GrowthHabitCategory, int>{};
  final completed = <GrowthHabitCategory, double>{};
  for (var i = 0; i < 30; i++) {
    final date = DateTime(
      now.year,
      now.month,
      now.day,
    ).subtract(Duration(days: i));
    final dayKey = LocalStore.todayKey(date);
    final dayLogs = state.habitLogsByDay[dayKey] ?? const {};
    for (final habit in byId.values) {
      if (!isHabitDueOnDate(habit, date, state)) continue;
      due[habit.category] = (due[habit.category] ?? 0) + 1;
      final log = dayLogs[habit.id];
      if (log != null) {
        completed[habit.category] =
            (completed[habit.category] ?? 0) + _completionCredit(log);
      }
    }
  }

  final result = <GrowthHabitCategory, double>{};
  for (final category in GrowthHabitCategory.values) {
    final d = due[category] ?? 0;
    if (d == 0) {
      result[category] = 0;
    } else {
      result[category] = ((completed[category] ?? 0) / d).clamp(0.0, 1.0);
    }
  }
  return result;
}

GrowthWeeklySummary _buildWeekSummary(
  GrowthState state,
  Map<String, GrowthHabit> byId,
  DateTime now,
  AppLocalizations l10n,
) {
  final bars = _weeklyCompletionBars(state, byId, now);
  final average = bars.isEmpty
      ? 0.0
      : bars.reduce((a, b) => a + b) / bars.length;
  final bestDay = bars.indexWhere((e) => e == bars.reduce(math.max));
  final consistency = average >= 0.75
      ? l10n.growthWeeklySummaryStrong
      : average >= 0.45
      ? l10n.growthWeeklySummaryBalanced
      : l10n.growthWeeklySummaryRestart;

  return GrowthWeeklySummary(
    averageCompletion: average,
    strongestDayIndex: bestDay,
    note: consistency,
  );
}

GrowthMonthlySummary _buildMonthSummary(
  GrowthState state,
  Map<String, GrowthHabit> byId,
  DateTime now,
  AppLocalizations l10n,
) {
  final map = _monthlyConsistencyCalendar(state, byId, now);
  final values = map.values.toList();
  final average = values.isEmpty
      ? 0.0
      : values.reduce((a, b) => a + b) / values.length;
  final strongDays = values.where((v) => v >= 0.65).length;

  return GrowthMonthlySummary(
    averageCompletion: average,
    strongDays: strongDays,
    note: strongDays >= 15
        ? l10n.growthMonthlySummaryStrong
        : l10n.growthMonthlySummaryGentle,
  );
}

int _lightForLevel(int level) {
  if (level <= 1) return 0;
  final base = level - 1;
  return 120 * base * base;
}

int _levelForLight(int light) {
  var level = 1;
  while (light >= _lightForLevel(level + 1)) {
    level += 1;
    if (level >= 300) break;
  }
  return level;
}

String _statusLabel(GrowthHabitStatus status, AppLocalizations l10n) {
  switch (status) {
    case GrowthHabitStatus.completed:
      return l10n.growthStatusCompleted;
    case GrowthHabitStatus.partial:
      return l10n.growthStatusPartial;
    case GrowthHabitStatus.skipped:
      return l10n.growthStatusSkipped;
    case GrowthHabitStatus.snoozed:
      return l10n.growthStatusSnoozed;
    case GrowthHabitStatus.deferred:
      return l10n.growthStatusDeferred;
  }
}

class GrowthTodaySummary {
  const GrowthTodaySummary({
    required this.date,
    required this.dueCount,
    required this.completedCount,
    required this.partialCount,
    required this.skippedCount,
    required this.deferredCount,
    required this.snoozedCount,
    required this.completionProgress,
    required this.visibleLightEarnedToday,
    required this.subtleLightEarnedToday,
    required this.currentStreakDays,
    required this.bestStreakDays,
    required this.protectedDaysUsedThisWeek,
  });

  final DateTime date;
  final int dueCount;
  final int completedCount;
  final int partialCount;
  final int skippedCount;
  final int deferredCount;
  final int snoozedCount;
  final double completionProgress;
  final int visibleLightEarnedToday;
  final int subtleLightEarnedToday;
  final int currentStreakDays;
  final int bestStreakDays;
  final int protectedDaysUsedThisWeek;
}

class GrowthPathProgress {
  const GrowthPathProgress({
    required this.path,
    required this.unlocked,
    required this.started,
    required this.paused,
    required this.completedHabits,
    required this.progress,
    required this.completed,
    required this.completionCelebrationPending,
    required this.recommendedNextHabitId,
    required this.recommendedNextStep,
  });

  final GrowthPath path;
  final bool unlocked;
  final bool started;
  final bool paused;
  final int completedHabits;
  final double progress;
  final bool completed;
  final bool completionCelebrationPending;
  final String? recommendedNextHabitId;
  final String recommendedNextStep;
}

class GrowthJourneyStats {
  const GrowthJourneyStats({
    required this.level,
    required this.visibleLight,
    required this.subtleLight,
    required this.nextLevelLightRemaining,
    required this.levelProgress,
    required this.totalCompletedActions,
    required this.currentStreakDays,
    required this.bestStreakDays,
    required this.weeklyCompletionBars,
    required this.monthlyConsistencyByDay,
    required this.categoryProgress,
    required this.pathProgress,
    required this.milestones,
    required this.milestoneDetails,
    required this.weeklySummary,
    required this.monthlySummary,
    required this.protectedDaysUsedThisWeek,
    required this.encouragementLine,
  });

  final int level;
  final int visibleLight;
  final int subtleLight;
  final int nextLevelLightRemaining;
  final double levelProgress;
  final int totalCompletedActions;
  final int currentStreakDays;
  final int bestStreakDays;
  final List<double> weeklyCompletionBars;
  final Map<int, double> monthlyConsistencyByDay;
  final Map<GrowthHabitCategory, double> categoryProgress;
  final List<GrowthPathProgress> pathProgress;
  final List<String> milestones;
  final List<GrowthMilestoneView> milestoneDetails;
  final GrowthWeeklySummary weeklySummary;
  final GrowthMonthlySummary monthlySummary;
  final int protectedDaysUsedThisWeek;
  final String encouragementLine;
}

class GrowthMilestoneView {
  const GrowthMilestoneView({required this.content});

  final GrowthMilestoneContent content;
}

class GrowthWeeklySummary {
  const GrowthWeeklySummary({
    required this.averageCompletion,
    required this.strongestDayIndex,
    required this.note,
  });

  final double averageCompletion;
  final int strongestDayIndex;
  final String note;
}

class GrowthMonthlySummary {
  const GrowthMonthlySummary({
    required this.averageCompletion,
    required this.strongDays,
    required this.note,
  });

  final double averageCompletion;
  final int strongDays;
  final String note;
}

class GrowthEndOfDaySummary {
  const GrowthEndOfDaySummary({
    required this.completionPercent,
    required this.completed,
    required this.partial,
    required this.missed,
    required this.hasReflection,
    required this.tone,
  });

  final int completionPercent;
  final int completed;
  final int partial;
  final int missed;
  final bool hasReflection;
  final String tone;
}

class GrowthRecentActivity {
  const GrowthRecentActivity({
    required this.at,
    required this.title,
    required this.subtitle,
    required this.isReflection,
    required this.isEntrusted,
  });

  final DateTime at;
  final String title;
  final String subtitle;
  final bool isReflection;
  final bool isEntrusted;
}

class GrowthGardenProgressView {
  const GrowthGardenProgressView({
    required this.score,
    required this.visual,
    required this.currentStage,
    required this.currentStageLabel,
    required this.stageSubtitle,
    required this.stageProgress,
    required this.nextStageLabel,
    required this.recentGrowthLine,
  });

  final double score;
  final GrowthGardenVisualState visual;
  final GrowthGardenStage currentStage;
  final String currentStageLabel;
  final String stageSubtitle;
  final double stageProgress;
  final String? nextStageLabel;
  final String recentGrowthLine;
}

class GrowthRecentUnlockView {
  const GrowthRecentUnlockView({
    required this.reward,
    required this.unlockedAt,
    required this.source,
  });

  final GrowthUnlockable reward;
  final DateTime unlockedAt;
  final String source;
}

class _StreakResult {
  const _StreakResult({
    required this.currentStreak,
    required this.protectedDaysUsed,
  });

  final int currentStreak;
  final int protectedDaysUsed;
}

int _gardenStageIndex(GrowthGardenStage stage) {
  switch (stage) {
    case GrowthGardenStage.seed:
      return 0;
    case GrowthGardenStage.sprout:
      return 1;
    case GrowthGardenStage.rooted:
      return 2;
    case GrowthGardenStage.flourishing:
      return 3;
    case GrowthGardenStage.lightUponLight:
      return 4;
  }
}

double _seasonalCompletionScore(
  GrowthState state,
  List<GrowthSeasonalJourneyCard> cards,
) {
  if (cards.isEmpty) return 0;
  var total = 0.0;
  var count = 0;
  for (final card in cards) {
    var completed = 0;
    for (final habitId in card.habitIds) {
      if (_hasEverCompletedHabit(state, habitId)) {
        completed += 1;
      }
    }
    final ratio = card.habitIds.isEmpty
        ? 0.0
        : completed / card.habitIds.length;
    total += ratio;
    count += 1;
  }
  return count == 0 ? 0 : total / count;
}

bool _hasEverCompletedHabit(GrowthState state, String habitId) {
  for (final day in state.habitLogsByDay.values) {
    final log = day[habitId];
    if (log != null && log.progress >= 0.999) {
      return true;
    }
  }
  return false;
}

int _fastCompletionCount(GrowthState state) {
  var count = 0;
  const tracked = {
    's_ramadan_fast_today',
    's_fast_optional_today',
    'h_sunnah_fasts',
  };
  for (final day in state.habitLogsByDay.values) {
    for (final entry in day.entries) {
      if (!tracked.contains(entry.key)) continue;
      if (entry.value.progress >= 0.999) {
        count += 1;
      }
    }
  }
  return count;
}
