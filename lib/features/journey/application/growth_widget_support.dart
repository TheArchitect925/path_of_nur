import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/persistence/local_store.dart';
import 'growth_extension_points.dart';
import 'growth_models.dart';
import 'growth_providers.dart';

@immutable
class GrowthTodayProgressWidgetData {
  const GrowthTodayProgressWidgetData({
    required this.completedCount,
    required this.dueCount,
    required this.progressPercent,
    required this.lightEarnedToday,
    required this.deepLinkPath,
    required this.title,
  });

  final int completedCount;
  final int dueCount;
  final int progressPercent;
  final int lightEarnedToday;
  final String deepLinkPath;
  final String title;
}

@immutable
class GrowthFocusHabitWidgetData {
  const GrowthFocusHabitWidgetData({
    required this.habitId,
    required this.title,
    required this.isCompleted,
    required this.supportingCopy,
    required this.deepLinkPath,
  });

  final String? habitId;
  final String title;
  final bool isCompleted;
  final String supportingCopy;
  final String deepLinkPath;
}

@immutable
class GrowthReflectionWidgetData {
  const GrowthReflectionWidgetData({
    required this.prompt,
    required this.deepLinkPath,
  });

  final String prompt;
  final String deepLinkPath;
}

@immutable
class GrowthJourneyWidgetData {
  const GrowthJourneyWidgetData({
    required this.currentStreak,
    required this.visibleLight,
    required this.level,
    required this.deepLinkPath,
    required this.title,
  });

  final int currentStreak;
  final int visibleLight;
  final int level;
  final String deepLinkPath;
  final String title;
}

final growthWidgetSnapshotProvider = Provider<GrowthWidgetSnapshot>((ref) {
  final state = ref.watch(growthControllerProvider);
  final summary = ref.watch(growthTodaySummaryProvider);
  final due = ref.watch(growthDueHabitsForSelectedDateProvider);
  final logs = ref.watch(growthLogsForSelectedDateProvider);
  final prompts = ref.watch(growthReflectionPromptSuggestionsProvider);

  GrowthHabit? focusHabit;
  if (state.focusHabitId != null) {
    focusHabit = due.where((habit) => habit.id == state.focusHabitId).firstOrNull;
    focusHabit ??=
        ref.watch(growthHabitsByIdProvider)[state.focusHabitId!];
  }
  focusHabit ??= due.firstOrNull;

  GrowthHabit? nextDue;
  for (final habit in due) {
    final status = logs[habit.id]?.status;
    if (status != GrowthHabitStatus.completed) {
      nextDue = habit;
      break;
    }
  }

  return GrowthWidgetSnapshot(
    dayKey: LocalStore.todayKey(summary.date),
    todayCompletedCount: summary.completedCount,
    todayDueCount: summary.dueCount,
    todayProgressPercent: (summary.completionProgress * 100).round(),
    lightEarnedToday: summary.visibleLightEarnedToday,
    currentStreak: summary.currentStreakDays,
    nextDueHabitId: nextDue?.id,
    nextDueHabitTitle: nextDue?.title,
    selectedFocusHabitId: focusHabit?.id,
    selectedFocusHabitTitle: focusHabit?.title,
    selectedFocusHabitCompleted:
        focusHabit != null &&
        logs[focusHabit.id]?.status == GrowthHabitStatus.completed,
    reflectionPromptPreview: prompts.firstOrNull ?? 'Return gently when you are ready.',
    privateModeEnabled: state.privateMode,
    updatedAtIso: DateTime.now().toIso8601String(),
  );
});

final growthTodayProgressWidgetDataProvider = Provider<GrowthTodayProgressWidgetData>((
  ref,
) {
  final snapshot = ref.watch(growthWidgetSnapshotProvider);
  return GrowthTodayProgressWidgetData(
    completedCount: snapshot.todayCompletedCount,
    dueCount: snapshot.todayDueCount,
    progressPercent: snapshot.todayProgressPercent,
    lightEarnedToday: snapshot.lightEarnedToday,
    deepLinkPath: '/journey/growth/today',
    title: snapshot.privateModeEnabled ? 'Today\'s Path' : 'Today Progress',
  );
});

final growthFocusHabitWidgetDataProvider = Provider<GrowthFocusHabitWidgetData>((ref) {
  final snapshot = ref.watch(growthWidgetSnapshotProvider);
  return GrowthFocusHabitWidgetData(
    habitId: snapshot.selectedFocusHabitId,
    title: snapshot.selectedFocusHabitTitle ?? 'Choose a focus habit',
    isCompleted: snapshot.selectedFocusHabitCompleted,
    supportingCopy: snapshot.selectedFocusHabitCompleted
        ? 'Quiet progress for today.'
        : 'Return gently to this habit.',
    deepLinkPath: snapshot.selectedFocusHabitId == null
        ? '/journey/growth/today'
        : '/journey/habit/${snapshot.selectedFocusHabitId}',
  );
});

final growthReflectionWidgetDataProvider = Provider<GrowthReflectionWidgetData>((ref) {
  final snapshot = ref.watch(growthWidgetSnapshotProvider);
  return GrowthReflectionWidgetData(
    prompt: snapshot.reflectionPromptPreview,
    deepLinkPath: '/journey/growth/reflection',
  );
});

final growthJourneyWidgetDataProvider = Provider<GrowthJourneyWidgetData>((ref) {
  final snapshot = ref.watch(growthWidgetSnapshotProvider);
  final journey = ref.watch(growthJourneyStatsProvider);
  return GrowthJourneyWidgetData(
    currentStreak: snapshot.currentStreak,
    visibleLight: journey.visibleLight,
    level: journey.level,
    deepLinkPath: '/journey/growth/journey',
    title: snapshot.privateModeEnabled ? 'Quiet Progress' : 'Journey',
  );
});

final growthWidgetBootstrapProvider = Provider<void>((ref) {
  final store = ref.read(localStoreProvider);
  final adapter = ref.read(growthWidgetSyncAdapterProvider);

  ref.listen<GrowthWidgetSnapshot>(growthWidgetSnapshotProvider, (_, snapshot) {
    Future<void>.microtask(() async {
      await store.setJsonMap('growth.widget.snapshot.v1', snapshot.toJson());
      await store.setJsonMap('growth.widget.deeplinks.v1', {
        'today': '/journey/growth/today',
        'focusHabit': snapshot.selectedFocusHabitId == null
            ? '/journey/growth/today'
            : '/journey/habit/${snapshot.selectedFocusHabitId}',
        'reflection': '/journey/growth/reflection',
        'journey': '/journey/growth/journey',
      });
      await adapter.syncWidgetState(ref.read(growthControllerProvider));
    });
  }, fireImmediately: true);
});
