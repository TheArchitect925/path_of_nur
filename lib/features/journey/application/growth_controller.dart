import 'dart:math' as math;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/persistence/local_store.dart';
import 'growth_models.dart';

const _growthStateStorageKey = 'growth.state.v2';
const _growthLegacyStateStorageKey = 'growth.state.v1';

class GrowthController extends StateNotifier<GrowthState> {
  GrowthController(this._store) : super(GrowthState.initial()) {
    _load();
  }

  final LocalStore _store;

  void _load() {
    final current = _store.getJsonMap(_growthStateStorageKey);
    final legacy = current == null
        ? _store.getJsonMap(_growthLegacyStateStorageKey)
        : null;
    state = GrowthState.fromJson(current ?? legacy);
    refreshDailySchedules();
  }

  void _persist() {
    _store.setJsonMap(_growthStateStorageKey, state.toJson());
  }

  void refreshDailySchedules([DateTime? now]) {
    final dayKey = LocalStore.todayKey(now);
    if (state.lastScheduleRefreshDayKey == dayKey) return;
    state = state.copyWith(lastScheduleRefreshDayKey: dayKey);
    _persist();
  }

  void setHabitStatus({
    required DateTime date,
    required String habitId,
    required GrowthHabitStatus? status,
    bool entrusted = false,
  }) {
    final dayKey = LocalStore.todayKey(date);
    final logsByDay = <String, Map<String, GrowthHabitLog>>{};
    for (final entry in state.habitLogsByDay.entries) {
      logsByDay[entry.key] = Map<String, GrowthHabitLog>.from(entry.value);
    }

    final dayLogs = Map<String, GrowthHabitLog>.from(logsByDay[dayKey] ?? const {});
    if (status == null) {
      dayLogs.remove(habitId);
    } else {
      final progress = switch (status) {
        GrowthHabitStatus.completed => 1.0,
        GrowthHabitStatus.partial => 0.5,
        GrowthHabitStatus.snoozed => 0.0,
        GrowthHabitStatus.deferred => 0.0,
        GrowthHabitStatus.skipped => 0.0,
      };
      dayLogs[habitId] = GrowthHabitLog(
        status: status,
        progress: progress,
        entrusted: entrusted,
        updatedAt: DateTime.now(),
      );
    }

    if (dayLogs.isEmpty) {
      logsByDay.remove(dayKey);
    } else {
      logsByDay[dayKey] = dayLogs;
    }

    // Keep legacy snapshot map in sync.
    final statusByDay = <String, Map<String, GrowthHabitStatus>>{};
    for (final entry in state.statusByDay.entries) {
      statusByDay[entry.key] = Map<String, GrowthHabitStatus>.from(entry.value);
    }
    final statusDay = Map<String, GrowthHabitStatus>.from(statusByDay[dayKey] ?? const {});
    if (status == null) {
      statusDay.remove(habitId);
    } else {
      statusDay[habitId] = status;
    }
    if (statusDay.isEmpty) {
      statusByDay.remove(dayKey);
    } else {
      statusByDay[dayKey] = statusDay;
    }

    state = state.copyWith(statusByDay: statusByDay, habitLogsByDay: logsByDay);
    _persist();
  }

  void setHabitProgress({
    required DateTime date,
    required String habitId,
    required double progress,
    bool entrusted = false,
  }) {
    final normalized = progress.clamp(0.0, 1.0);
    if (normalized <= 0) {
      setHabitStatus(date: date, habitId: habitId, status: null);
      return;
    }
    final status = normalized >= 0.999
        ? GrowthHabitStatus.completed
        : GrowthHabitStatus.partial;
    final dayKey = LocalStore.todayKey(date);
    final logsByDay = <String, Map<String, GrowthHabitLog>>{};
    for (final entry in state.habitLogsByDay.entries) {
      logsByDay[entry.key] = Map<String, GrowthHabitLog>.from(entry.value);
    }
    final dayLogs = Map<String, GrowthHabitLog>.from(logsByDay[dayKey] ?? const {});
    dayLogs[habitId] = GrowthHabitLog(
      status: status,
      progress: normalized,
      entrusted: entrusted,
      updatedAt: DateTime.now(),
    );
    logsByDay[dayKey] = dayLogs;

    final statusByDay = <String, Map<String, GrowthHabitStatus>>{};
    for (final entry in state.statusByDay.entries) {
      statusByDay[entry.key] = Map<String, GrowthHabitStatus>.from(entry.value);
    }
    final statusDay = Map<String, GrowthHabitStatus>.from(statusByDay[dayKey] ?? const {});
    statusDay[habitId] = status;
    statusByDay[dayKey] = statusDay;

    state = state.copyWith(statusByDay: statusByDay, habitLogsByDay: logsByDay);
    _persist();
  }

  void toggleCompleted({required DateTime date, required String habitId}) {
    final dayKey = LocalStore.todayKey(date);
    final existing = state.habitLogsByDay[dayKey]?[habitId];
    if (existing?.status == GrowthHabitStatus.completed) {
      setHabitStatus(date: date, habitId: habitId, status: null);
      return;
    }
    setHabitStatus(
      date: date,
      habitId: habitId,
      status: GrowthHabitStatus.completed,
      entrusted: existing?.entrusted ?? false,
    );
  }

  void setPathStarted(String pathId, {required bool started}) {
    final startedPathIds = Set<String>.from(state.startedPathIds);
    final pausedPathIds = Set<String>.from(state.pausedPathIds);

    if (started) {
      startedPathIds.add(pathId);
      pausedPathIds.remove(pathId);
    } else {
      startedPathIds.remove(pathId);
      pausedPathIds.remove(pathId);
    }

    state = state.copyWith(
      startedPathIds: startedPathIds,
      pausedPathIds: pausedPathIds,
    );
    _persist();
  }

  void setPathPaused(String pathId, {required bool paused}) {
    final pausedPathIds = Set<String>.from(state.pausedPathIds);
    if (paused) {
      pausedPathIds.add(pathId);
    } else {
      pausedPathIds.remove(pathId);
    }
    state = state.copyWith(pausedPathIds: pausedPathIds);
    _persist();
  }

  void markPathCelebrated(String pathId) {
    final celebrated = Set<String>.from(state.celebratedPathIds);
    celebrated.add(pathId);
    state = state.copyWith(celebratedPathIds: celebrated);
    _persist();
  }

  void updateHabitOverride(
    String habitId, {
    bool? active,
    bool? muted,
    bool? hidden,
    bool? reminderEnabled,
    bool? entrustToAllah,
    bool? archived,
    bool? privateTracking,
    bool? showInToday,
    bool? paused,
    GrowthReminderMode? reminderMode,
    int? reminderTimeMinutes,
    GrowthReminderPrayerAnchor? reminderPrayerAnchor,
    int? reminderOffsetMinutes,
    GrowthReminderWindowType? reminderWindowType,
    List<int>? reminderDays,
    String? reminderMessageOverride,
    bool? quietDelivery,
    bool? allowSnooze,
    bool? remindersPaused,
  }) {
    final overrides = Map<String, GrowthHabitOverride>.from(state.habitOverrides);
    final existing =
        overrides[habitId] ??
        const GrowthHabitOverride(
          active: null,
          muted: null,
          hidden: null,
          reminderEnabled: null,
          entrustToAllah: null,
          archived: null,
          privateTracking: null,
          showInToday: null,
          paused: null,
          reminderMode: null,
          reminderTimeMinutes: null,
          reminderPrayerAnchor: null,
          reminderOffsetMinutes: null,
          reminderWindowType: null,
          reminderDays: null,
          reminderMessageOverride: null,
          quietDelivery: null,
          allowSnooze: null,
          remindersPaused: null,
        );
    overrides[habitId] = existing.copyWith(
      active: active,
      muted: muted,
      hidden: hidden,
      reminderEnabled: reminderEnabled,
      entrustToAllah: entrustToAllah,
      archived: archived,
      privateTracking: privateTracking,
      showInToday: showInToday,
      paused: paused,
      reminderMode: reminderMode,
      reminderTimeMinutes: reminderTimeMinutes,
      reminderPrayerAnchor: reminderPrayerAnchor,
      reminderOffsetMinutes: reminderOffsetMinutes,
      reminderWindowType: reminderWindowType,
      reminderDays: reminderDays,
      reminderMessageOverride: reminderMessageOverride,
      quietDelivery: quietDelivery,
      allowSnooze: allowSnooze,
      remindersPaused: remindersPaused,
    );

    state = state.copyWith(habitOverrides: overrides);
    _persist();
  }

  void addCustomHabit({
    required String title,
    required String subtitle,
    required String description,
    required GrowthHabitCategory category,
    String? customCategoryId,
    required GrowthHabitRecurrenceType recurrenceType,
    required int frequencyTarget,
    required List<int> weekdays,
    required int difficulty,
    required int lightReward,
    required bool reminderEnabled,
    required String reflectionPrompt,
    required bool entrustable,
    required bool privateTracking,
    required bool allowPartial,
    required int customIntervalDays,
    required bool showInToday,
    required bool active,
    String? linkedPathId,
    String? reminderConfig,
    GrowthReminderMode reminderMode = GrowthReminderMode.gentleSuggestion,
    int reminderTimeMinutes = 1200,
    GrowthReminderPrayerAnchor? reminderPrayerAnchor,
    int reminderOffsetMinutes = 0,
    GrowthReminderWindowType? reminderWindowType,
    List<int> reminderDays = const [],
    String? reminderMessageOverride,
    bool quietDelivery = false,
    bool allowSnooze = true,
    bool remindersPaused = false,
  }) {
    final nowMs = DateTime.now().millisecondsSinceEpoch;
    final id = 'custom_${DateTime.now().millisecondsSinceEpoch}';
    final sortBase = state.customHabits.isEmpty
        ? 2000
        : state.customHabits.map((e) => e.sortOrder).reduce(math.max) + 1;
    final next = GrowthHabit(
      id: id,
      title: title,
      subtitle: subtitle,
      description: description,
      category: category,
      pathIds: linkedPathId == null ? const [] : [linkedPathId],
      linkedPathId: linkedPathId,
      recurrenceType: recurrenceType,
      weekdays: weekdays,
      frequencyTarget: frequencyTarget,
      difficulty: difficulty,
      lightReward: lightReward,
      streakEligible: true,
      reminderEnabled: reminderEnabled,
      reflectionPrompt: reflectionPrompt.isEmpty ? null : reflectionPrompt,
      active: active,
      muted: false,
      hidden: false,
      entrustable: entrustable,
      entrustToAllah: false,
      sortOrder: sortBase,
      isCustom: true,
      stage: 1,
      allowPartial: allowPartial,
      targetUnits: allowPartial ? 100 : 1,
      privateTracking: privateTracking,
      customIntervalDays: customIntervalDays,
      showInToday: showInToday,
      reminderConfig: reminderConfig,
      reminderMode: reminderMode,
      reminderTimeMinutes: reminderTimeMinutes,
      reminderPrayerAnchor: reminderPrayerAnchor,
      reminderOffsetMinutes: reminderOffsetMinutes,
      reminderWindowType: reminderWindowType,
      reminderDays: reminderDays,
      reminderMessageOverride: reminderMessageOverride,
      quietDelivery: quietDelivery,
      allowSnooze: allowSnooze,
      remindersPaused: remindersPaused,
      customCategoryId: customCategoryId,
      createdAtEpochMs: nowMs,
      updatedAtEpochMs: nowMs,
    );

    state = state.copyWith(customHabits: [...state.customHabits, next]);
    _persist();
  }

  void updateCustomHabit({
    required String habitId,
    required String title,
    required String subtitle,
    required String description,
    required GrowthHabitCategory category,
    String? customCategoryId,
    required GrowthHabitRecurrenceType recurrenceType,
    required int frequencyTarget,
    required List<int> weekdays,
    required int difficulty,
    required int lightReward,
    required bool reminderEnabled,
    required String reflectionPrompt,
    required bool entrustable,
    required bool privateTracking,
    required bool allowPartial,
    required int customIntervalDays,
    required bool showInToday,
    required bool active,
    required bool paused,
    required bool archived,
    String? linkedPathId,
    String? reminderConfig,
    GrowthReminderMode reminderMode = GrowthReminderMode.gentleSuggestion,
    int reminderTimeMinutes = 1200,
    GrowthReminderPrayerAnchor? reminderPrayerAnchor,
    int reminderOffsetMinutes = 0,
    GrowthReminderWindowType? reminderWindowType,
    List<int> reminderDays = const [],
    String? reminderMessageOverride,
    bool quietDelivery = false,
    bool allowSnooze = true,
    bool remindersPaused = false,
  }) {
    final habits = [...state.customHabits];
    final index = habits.indexWhere((h) => h.id == habitId);
    if (index == -1) return;
    final current = habits[index];
    habits[index] = current.copyWith(
      title: title,
      subtitle: subtitle,
      description: description,
      category: category,
      entrustable: entrustable,
      pathIds: linkedPathId == null ? const [] : [linkedPathId],
      recurrenceType: recurrenceType,
      weekdays: weekdays,
      frequencyTarget: frequencyTarget,
      difficulty: difficulty,
      lightReward: lightReward,
      reminderEnabled: reminderEnabled,
      reflectionPrompt: reflectionPrompt.isEmpty ? null : reflectionPrompt,
      allowPartial: allowPartial,
      customIntervalDays: customIntervalDays,
      showInToday: showInToday,
      active: active,
      paused: paused,
      archived: archived,
      privateTracking: privateTracking,
      reminderConfig: reminderConfig,
      reminderMode: reminderMode,
      reminderTimeMinutes: reminderTimeMinutes,
      reminderPrayerAnchor: reminderPrayerAnchor,
      reminderOffsetMinutes: reminderOffsetMinutes,
      reminderWindowType: reminderWindowType,
      reminderDays: reminderDays,
      reminderMessageOverride: reminderMessageOverride,
      quietDelivery: quietDelivery,
      allowSnooze: allowSnooze,
      remindersPaused: remindersPaused,
      linkedPathId: linkedPathId,
      customCategoryId: customCategoryId,
      updatedAtEpochMs: DateTime.now().millisecondsSinceEpoch,
    );

    // Update explicit override for entrust/private for consistent behavior.
    updateHabitOverride(
      habitId,
      privateTracking: privateTracking,
      archived: archived,
      paused: paused,
      showInToday: showInToday,
      active: active,
    );
    state = state.copyWith(customHabits: habits);
    _persist();
  }

  void duplicateCustomHabit(String habitId) {
    final source = state.customHabits.where((h) => h.id == habitId).toList();
    if (source.isEmpty) return;
    final original = source.first;
    final sortBase = state.customHabits.isEmpty
        ? 2000
        : state.customHabits.map((e) => e.sortOrder).reduce(math.max) + 1;
    final nowMs = DateTime.now().millisecondsSinceEpoch;
    final duplicate = GrowthHabit(
      id: 'custom_$nowMs',
      title: '${original.title} (Copy)',
      subtitle: original.subtitle,
      description: original.description,
      category: original.category,
      pathIds: original.pathIds,
      recurrenceType: original.recurrenceType,
      weekdays: original.weekdays,
      frequencyTarget: original.frequencyTarget,
      difficulty: original.difficulty,
      lightReward: original.lightReward,
      streakEligible: original.streakEligible,
      reminderEnabled: original.reminderEnabled,
      reflectionPrompt: original.reflectionPrompt,
      active: original.active,
      muted: false,
      hidden: false,
      entrustable: original.entrustable,
      entrustToAllah: original.entrustToAllah,
      sortOrder: sortBase,
      isCustom: true,
      stage: original.stage,
      allowPartial: original.allowPartial,
      targetUnits: original.targetUnits,
      customIntervalDays: original.customIntervalDays,
      archived: false,
      privateTracking: original.privateTracking,
      recurrenceHint: original.recurrenceHint,
      showInToday: original.showInToday,
      paused: false,
      reminderConfig: original.reminderConfig,
      reminderMode: original.reminderMode,
      reminderTimeMinutes: original.reminderTimeMinutes,
      reminderPrayerAnchor: original.reminderPrayerAnchor,
      reminderOffsetMinutes: original.reminderOffsetMinutes,
      reminderWindowType: original.reminderWindowType,
      reminderDays: original.reminderDays,
      reminderMessageOverride: original.reminderMessageOverride,
      quietDelivery: original.quietDelivery,
      allowSnooze: original.allowSnooze,
      remindersPaused: false,
      linkedPathId: original.linkedPathId,
      customCategoryId: original.customCategoryId,
      createdAtEpochMs: nowMs,
      updatedAtEpochMs: nowMs,
    );
    state = state.copyWith(customHabits: [...state.customHabits, duplicate]);
    _persist();
  }

  void deleteCustomHabit(String habitId) {
    final nextHabits = state.customHabits.where((h) => h.id != habitId).toList();
    final overrides = Map<String, GrowthHabitOverride>.from(state.habitOverrides);
    overrides.remove(habitId);
    final logs = <String, Map<String, GrowthHabitLog>>{};
    for (final day in state.habitLogsByDay.entries) {
      final map = Map<String, GrowthHabitLog>.from(day.value);
      map.remove(habitId);
      if (map.isNotEmpty) {
        logs[day.key] = map;
      }
    }
    state = state.copyWith(
      customHabits: nextHabits,
      habitOverrides: overrides,
      habitLogsByDay: logs,
      focusHabitId: state.focusHabitId == habitId ? null : state.focusHabitId,
    );
    _persist();
  }

  void addCustomHabitCategory({
    required String title,
    required String description,
  }) {
    final nowMs = DateTime.now().millisecondsSinceEpoch;
    final sortBase = state.customHabitCategories.isEmpty
        ? 1
        : state.customHabitCategories.map((e) => e.sortOrder).reduce(math.max) +
            1;
    final next = GrowthCustomCategory(
      id: 'category_$nowMs',
      title: title,
      description: description,
      sortOrder: sortBase,
      createdAtEpochMs: nowMs,
      updatedAtEpochMs: nowMs,
    );
    state = state.copyWith(
      customHabitCategories: [...state.customHabitCategories, next],
    );
    _persist();
  }

  void updateCustomHabitCategory({
    required String categoryId,
    required String title,
    required String description,
  }) {
    final categories = [...state.customHabitCategories];
    final index = categories.indexWhere((item) => item.id == categoryId);
    if (index == -1) return;
    categories[index] = categories[index].copyWith(
      title: title,
      description: description,
      updatedAtEpochMs: DateTime.now().millisecondsSinceEpoch,
    );
    state = state.copyWith(customHabitCategories: categories);
    _persist();
  }

  void deleteCustomHabitCategory(String categoryId) {
    final categories = state.customHabitCategories
        .where((item) => item.id != categoryId)
        .toList(growable: false);
    final habits = state.customHabits
        .map(
          (habit) => habit.customCategoryId == categoryId
              ? habit.copyWith(customCategoryId: null)
              : habit,
        )
        .toList(growable: false);
    state = state.copyWith(
      customHabitCategories: categories,
      customHabits: habits,
    );
    _persist();
  }

  void setFocusHabit(String? habitId) {
    state = state.copyWith(focusHabitId: habitId);
    _persist();
  }

  void setPrivateMode(bool enabled) {
    state = state.copyWith(privateMode: enabled);
    _persist();
  }

  void setRamadanQuranPlanDays(int days) {
    final normalized = days <= 10
        ? 10
        : days <= 15
        ? 15
        : 30;
    state = state.copyWith(ramadanQuranPlanDays: normalized);
    _persist();
  }

  void setRamadanModeOverride(bool enabled) {
    state = state.copyWith(ramadanModeOverride: enabled);
    _persist();
  }

  void setRamadanQuranCompletedJuz(double juz) {
    state = state.copyWith(
      ramadanQuranCompletedJuz: juz.clamp(0, 30).toDouble(),
    );
    _persist();
  }

  void setFastTrackTypeForDay({
    required DateTime date,
    required GrowthFastTrackType type,
  }) {
    final key = LocalStore.todayKey(date);
    final next = Map<String, String>.from(state.fastTrackTypeByDay);
    next[key] = type.name;
    state = state.copyWith(fastTrackTypeByDay: next);
    _persist();
  }

  void registerUnlockedRewards(Set<String> rewardIds, {required String source}) {
    if (rewardIds.isEmpty) return;
    final unlocked = Set<String>.from(state.unlockedRewardIds);
    final events = [...state.rewardEvents];
    var changed = false;
    for (final id in rewardIds) {
      if (unlocked.add(id)) {
        events.insert(
          0,
          GrowthRewardEvent(
            rewardId: id,
            unlockedAt: DateTime.now(),
            source: source,
          ),
        );
        changed = true;
      }
    }
    if (!changed) return;
    state = state.copyWith(
      unlockedRewardIds: unlocked,
      rewardEvents: events.take(80).toList(),
    );
    _persist();
  }

  void updateGlobalReminderSettings({
    bool? remindersEnabled,
    bool? gentleMode,
    bool? pauseAllReminders,
    bool? quietDelivery,
    bool? respectDoNotDisturb,
    bool? ramadanCompatibilityMode,
  }) {
    final next = state.globalReminderSettings.copyWith(
      remindersEnabled: remindersEnabled,
      gentleMode: gentleMode,
      pauseAllReminders: pauseAllReminders,
      quietDelivery: quietDelivery,
      respectDoNotDisturb: respectDoNotDisturb,
      ramadanCompatibilityMode: ramadanCompatibilityMode,
    );
    state = state.copyWith(globalReminderSettings: next);
    _persist();
  }

  void markReminderSent(String habitId, DateTime when) {
    final customIndex = state.customHabits.indexWhere((h) => h.id == habitId);
    if (customIndex != -1) {
      final list = [...state.customHabits];
      list[customIndex] = list[customIndex].copyWith(
        lastReminderSentAtEpochMs: when.millisecondsSinceEpoch,
      );
      state = state.copyWith(customHabits: list);
      _persist();
      return;
    }
    updateHabitOverride(
      habitId,
      remindersPaused: false,
    );
  }

  void addReflection({
    required DateTime date,
    required String prompt,
    required String gratitude,
    required String tawbah,
    required String note,
    required bool entrustToAllah,
    GrowthMoodState? mood,
    String? linkedHabitId,
  }) {
    final entry = GrowthReflectionEntry(
      id: 'r_${DateTime.now().millisecondsSinceEpoch}',
      dayKey: LocalStore.todayKey(date),
      prompt: prompt,
      gratitude: gratitude,
      tawbah: tawbah,
      note: note,
      entrustToAllah: entrustToAllah,
      createdAt: DateTime.now(),
      mood: mood,
      linkedHabitId: linkedHabitId,
    );

    final reflections = [entry, ...state.reflections].take(300).toList();
    state = state.copyWith(reflections: reflections);
    _persist();
  }
}
