import 'package:flutter/foundation.dart';

const Object _growthUnset = Object();

enum GrowthHabitCategory {
  dailyWorship,
  sunnahPractices,
  character,
  knowledge,
  charityService,
  healthDiscipline,
  reflectionGratitude,
}

enum GrowthHabitRecurrenceType {
  daily,
  weekdaysOnly,
  weeklyTarget,
  customWeekdays,
  occasional,
  customFrequency,
}

enum GrowthHabitStatus { completed, partial, skipped, snoozed, deferred }

enum GrowthPathDifficulty { beginner, steady, deep }

enum GrowthMoodState { calm, grateful, hopeful, tired, heavy }

enum GrowthReminderMode {
  fixedTime,
  prayerLinked,
  timeWindow,
  gentleSuggestion,
}

enum GrowthReminderPrayerAnchor { fajr, dhuhr, asr, maghrib, isha }

enum GrowthReminderWindowType {
  earlyMorning,
  morning,
  midday,
  afternoon,
  evening,
  night,
  beforeSleep,
  fridayMorning,
  fridayAfternoon,
  weekend,
}

enum GrowthFastTrackType {
  ramadan,
  mondayThursday,
  whiteDays,
  arafah,
  ashura,
  custom,
}

@immutable
class GrowthHabit {
  const GrowthHabit({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.category,
    required this.pathIds,
    required this.recurrenceType,
    required this.weekdays,
    required this.frequencyTarget,
    required this.difficulty,
    required this.lightReward,
    required this.streakEligible,
    required this.reminderEnabled,
    required this.reflectionPrompt,
    required this.active,
    required this.muted,
    required this.hidden,
    required this.entrustable,
    required this.entrustToAllah,
    required this.sortOrder,
    required this.isCustom,
    required this.stage,
    this.allowPartial = false,
    this.targetUnits = 1,
    this.customIntervalDays = 1,
    this.archived = false,
    this.privateTracking = false,
    this.recurrenceHint,
    this.showInToday = true,
    this.paused = false,
    this.reminderConfig,
    this.linkedPathId,
    this.createdAtEpochMs = 0,
    this.updatedAtEpochMs = 0,
    this.reminderMode = GrowthReminderMode.gentleSuggestion,
    this.reminderTimeMinutes = 1200,
    this.reminderPrayerAnchor,
    this.reminderOffsetMinutes = 0,
    this.reminderWindowType,
    this.reminderDays = const [],
    this.reminderMessageOverride,
    this.quietDelivery = false,
    this.allowSnooze = true,
    this.remindersPaused = false,
    this.nextReminderAtEpochMs = 0,
    this.lastReminderSentAtEpochMs = 0,
    this.customCategoryId,
  });

  final String id;
  final String title;
  final String subtitle;
  final String description;
  final GrowthHabitCategory category;
  final List<String> pathIds;
  final GrowthHabitRecurrenceType recurrenceType;
  final List<int> weekdays;
  final int frequencyTarget;
  final int difficulty;
  final int lightReward;
  final bool streakEligible;
  final bool reminderEnabled;
  final String? reflectionPrompt;
  final bool active;
  final bool muted;
  final bool hidden;
  final bool entrustable;
  final bool entrustToAllah;
  final int sortOrder;
  final bool isCustom;
  final int stage;
  final bool allowPartial;
  final int targetUnits;
  final int customIntervalDays;
  final bool archived;
  final bool privateTracking;
  final String? recurrenceHint;
  final bool showInToday;
  final bool paused;
  final String? reminderConfig;
  final String? linkedPathId;
  final int createdAtEpochMs;
  final int updatedAtEpochMs;
  final GrowthReminderMode reminderMode;
  final int reminderTimeMinutes;
  final GrowthReminderPrayerAnchor? reminderPrayerAnchor;
  final int reminderOffsetMinutes;
  final GrowthReminderWindowType? reminderWindowType;
  final List<int> reminderDays;
  final String? reminderMessageOverride;
  final bool quietDelivery;
  final bool allowSnooze;
  final bool remindersPaused;
  final int nextReminderAtEpochMs;
  final int lastReminderSentAtEpochMs;
  final String? customCategoryId;

  GrowthHabit copyWith({
    String? title,
    GrowthHabitCategory? category,
    List<String>? pathIds,
    bool? active,
    bool? muted,
    bool? hidden,
    bool? reminderEnabled,
    bool? entrustable,
    bool? entrustToAllah,
    bool? archived,
    bool? privateTracking,
    bool? allowPartial,
    int? targetUnits,
    int? customIntervalDays,
    int? frequencyTarget,
    GrowthHabitRecurrenceType? recurrenceType,
    List<int>? weekdays,
    String? subtitle,
    String? description,
    String? reflectionPrompt,
    int? difficulty,
    int? lightReward,
    String? recurrenceHint,
    bool? showInToday,
    bool? paused,
    String? reminderConfig,
    String? linkedPathId,
    int? updatedAtEpochMs,
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
    int? nextReminderAtEpochMs,
    int? lastReminderSentAtEpochMs,
    Object? customCategoryId = _growthUnset,
  }) {
    return GrowthHabit(
      id: id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      description: description ?? this.description,
      category: category ?? this.category,
      pathIds: pathIds ?? this.pathIds,
      recurrenceType: recurrenceType ?? this.recurrenceType,
      weekdays: weekdays ?? this.weekdays,
      frequencyTarget: frequencyTarget ?? this.frequencyTarget,
      difficulty: difficulty ?? this.difficulty,
      lightReward: lightReward ?? this.lightReward,
      streakEligible: streakEligible,
      reminderEnabled: reminderEnabled ?? this.reminderEnabled,
      reflectionPrompt: reflectionPrompt ?? this.reflectionPrompt,
      active: active ?? this.active,
      muted: muted ?? this.muted,
      hidden: hidden ?? this.hidden,
      entrustable: entrustable ?? this.entrustable,
      entrustToAllah: entrustToAllah ?? this.entrustToAllah,
      sortOrder: sortOrder,
      isCustom: isCustom,
      stage: stage,
      allowPartial: allowPartial ?? this.allowPartial,
      targetUnits: targetUnits ?? this.targetUnits,
      customIntervalDays: customIntervalDays ?? this.customIntervalDays,
      archived: archived ?? this.archived,
      privateTracking: privateTracking ?? this.privateTracking,
      recurrenceHint: recurrenceHint ?? this.recurrenceHint,
      showInToday: showInToday ?? this.showInToday,
      paused: paused ?? this.paused,
      reminderConfig: reminderConfig ?? this.reminderConfig,
      linkedPathId: linkedPathId ?? this.linkedPathId,
      createdAtEpochMs: createdAtEpochMs,
      updatedAtEpochMs: updatedAtEpochMs ?? this.updatedAtEpochMs,
      reminderMode: reminderMode ?? this.reminderMode,
      reminderTimeMinutes: reminderTimeMinutes ?? this.reminderTimeMinutes,
      reminderPrayerAnchor: reminderPrayerAnchor ?? this.reminderPrayerAnchor,
      reminderOffsetMinutes:
          reminderOffsetMinutes ?? this.reminderOffsetMinutes,
      reminderWindowType: reminderWindowType ?? this.reminderWindowType,
      reminderDays: reminderDays ?? this.reminderDays,
      reminderMessageOverride:
          reminderMessageOverride ?? this.reminderMessageOverride,
      quietDelivery: quietDelivery ?? this.quietDelivery,
      allowSnooze: allowSnooze ?? this.allowSnooze,
      remindersPaused: remindersPaused ?? this.remindersPaused,
      nextReminderAtEpochMs:
          nextReminderAtEpochMs ?? this.nextReminderAtEpochMs,
      lastReminderSentAtEpochMs:
          lastReminderSentAtEpochMs ?? this.lastReminderSentAtEpochMs,
      customCategoryId: identical(customCategoryId, _growthUnset)
          ? this.customCategoryId
          : customCategoryId as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'description': description,
      'category': category.name,
      'pathIds': pathIds,
      'recurrenceType': recurrenceType.name,
      'weekdays': weekdays,
      'frequencyTarget': frequencyTarget,
      'difficulty': difficulty,
      'lightReward': lightReward,
      'streakEligible': streakEligible,
      'reminderEnabled': reminderEnabled,
      'reflectionPrompt': reflectionPrompt,
      'active': active,
      'muted': muted,
      'hidden': hidden,
      'entrustable': entrustable,
      'entrustToAllah': entrustToAllah,
      'sortOrder': sortOrder,
      'isCustom': isCustom,
      'stage': stage,
      'allowPartial': allowPartial,
      'targetUnits': targetUnits,
      'customIntervalDays': customIntervalDays,
      'archived': archived,
      'privateTracking': privateTracking,
      'recurrenceHint': recurrenceHint,
      'showInToday': showInToday,
      'paused': paused,
      'reminderConfig': reminderConfig,
      'linkedPathId': linkedPathId,
      'createdAtEpochMs': createdAtEpochMs,
      'updatedAtEpochMs': updatedAtEpochMs,
      'reminderMode': reminderMode.name,
      'reminderTimeMinutes': reminderTimeMinutes,
      'reminderPrayerAnchor': reminderPrayerAnchor?.name,
      'reminderOffsetMinutes': reminderOffsetMinutes,
      'reminderWindowType': reminderWindowType?.name,
      'reminderDays': reminderDays,
      'reminderMessageOverride': reminderMessageOverride,
      'quietDelivery': quietDelivery,
      'allowSnooze': allowSnooze,
      'remindersPaused': remindersPaused,
      'nextReminderAtEpochMs': nextReminderAtEpochMs,
      'lastReminderSentAtEpochMs': lastReminderSentAtEpochMs,
      'customCategoryId': customCategoryId,
    };
  }

  static GrowthHabit fromJson(Map<String, dynamic> json) {
    GrowthHabitCategory category = GrowthHabitCategory.dailyWorship;
    for (final item in GrowthHabitCategory.values) {
      if (item.name == json['category']) category = item;
    }

    GrowthHabitRecurrenceType recurrenceType = GrowthHabitRecurrenceType.daily;
    for (final item in GrowthHabitRecurrenceType.values) {
      if (item.name == json['recurrenceType']) recurrenceType = item;
    }
    GrowthReminderMode reminderMode = GrowthReminderMode.gentleSuggestion;
    for (final item in GrowthReminderMode.values) {
      if (item.name == json['reminderMode']) reminderMode = item;
    }
    GrowthReminderPrayerAnchor? reminderPrayerAnchor;
    for (final item in GrowthReminderPrayerAnchor.values) {
      if (item.name == json['reminderPrayerAnchor']) reminderPrayerAnchor = item;
    }
    GrowthReminderWindowType? reminderWindowType;
    for (final item in GrowthReminderWindowType.values) {
      if (item.name == json['reminderWindowType']) reminderWindowType = item;
    }

    return GrowthHabit(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      subtitle: json['subtitle']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      category: category,
      pathIds: (json['pathIds'] as List? ?? const [])
          .map((e) => e.toString())
          .toList(),
      recurrenceType: recurrenceType,
      weekdays: (json['weekdays'] as List? ?? const [])
          .map((e) => int.tryParse(e.toString()) ?? 1)
          .toList(),
      frequencyTarget: int.tryParse(json['frequencyTarget']?.toString() ?? '') ??
          7,
      difficulty: int.tryParse(json['difficulty']?.toString() ?? '') ?? 1,
      lightReward: int.tryParse(json['lightReward']?.toString() ?? '') ?? 8,
      streakEligible: json['streakEligible'] != false,
      reminderEnabled: json['reminderEnabled'] == true,
      reflectionPrompt: json['reflectionPrompt']?.toString(),
      active: json['active'] != false,
      muted: json['muted'] == true,
      hidden: json['hidden'] == true,
      entrustable: json['entrustable'] != false,
      entrustToAllah: json['entrustToAllah'] == true,
      sortOrder: int.tryParse(json['sortOrder']?.toString() ?? '') ?? 999,
      isCustom: json['isCustom'] == true,
      stage: int.tryParse(json['stage']?.toString() ?? '') ?? 1,
      allowPartial: json['allowPartial'] == true,
      targetUnits: int.tryParse(json['targetUnits']?.toString() ?? '') ?? 1,
      customIntervalDays:
          int.tryParse(json['customIntervalDays']?.toString() ?? '') ?? 1,
      archived: json['archived'] == true,
      privateTracking: json['privateTracking'] == true,
      recurrenceHint: json['recurrenceHint']?.toString(),
      showInToday: json['showInToday'] != false,
      paused: json['paused'] == true,
      reminderConfig: json['reminderConfig']?.toString(),
      linkedPathId: json['linkedPathId']?.toString(),
      createdAtEpochMs:
          int.tryParse(json['createdAtEpochMs']?.toString() ?? '') ?? 0,
      updatedAtEpochMs:
          int.tryParse(json['updatedAtEpochMs']?.toString() ?? '') ?? 0,
      reminderMode: reminderMode,
      reminderTimeMinutes:
          int.tryParse(json['reminderTimeMinutes']?.toString() ?? '') ?? 1200,
      reminderPrayerAnchor: reminderPrayerAnchor,
      reminderOffsetMinutes:
          int.tryParse(json['reminderOffsetMinutes']?.toString() ?? '') ?? 0,
      reminderWindowType: reminderWindowType,
      reminderDays: (json['reminderDays'] as List? ?? const [])
          .map((e) => int.tryParse(e.toString()) ?? 1)
          .toList(),
      reminderMessageOverride: json['reminderMessageOverride']?.toString(),
      quietDelivery: json['quietDelivery'] == true,
      allowSnooze: json['allowSnooze'] != false,
      remindersPaused: json['remindersPaused'] == true,
      nextReminderAtEpochMs:
          int.tryParse(json['nextReminderAtEpochMs']?.toString() ?? '') ?? 0,
      lastReminderSentAtEpochMs:
          int.tryParse(json['lastReminderSentAtEpochMs']?.toString() ?? '') ?? 0,
      customCategoryId: json['customCategoryId']?.toString(),
    );
  }
}

@immutable
class GrowthHabitLog {
  const GrowthHabitLog({
    required this.status,
    required this.progress,
    required this.updatedAt,
    required this.entrusted,
  });

  final GrowthHabitStatus status;
  final double progress;
  final DateTime updatedAt;
  final bool entrusted;

  GrowthHabitLog copyWith({
    GrowthHabitStatus? status,
    double? progress,
    DateTime? updatedAt,
    bool? entrusted,
  }) {
    return GrowthHabitLog(
      status: status ?? this.status,
      progress: progress ?? this.progress,
      updatedAt: updatedAt ?? this.updatedAt,
      entrusted: entrusted ?? this.entrusted,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status.name,
      'progress': progress,
      'updatedAt': updatedAt.toIso8601String(),
      'entrusted': entrusted,
    };
  }

  static GrowthHabitLog fromJson(Map<String, dynamic> json) {
    GrowthHabitStatus status = GrowthHabitStatus.completed;
    for (final item in GrowthHabitStatus.values) {
      if (item.name == json['status']) status = item;
    }
    return GrowthHabitLog(
      status: status,
      progress: (json['progress'] as num?)?.toDouble() ??
          (status == GrowthHabitStatus.completed ? 1.0 : 0.0),
      updatedAt: DateTime.tryParse(json['updatedAt']?.toString() ?? '') ??
          DateTime.now(),
      entrusted: json['entrusted'] == true,
    );
  }
}

@immutable
class GrowthCustomCategory {
  const GrowthCustomCategory({
    required this.id,
    required this.title,
    required this.description,
    required this.sortOrder,
    required this.createdAtEpochMs,
    required this.updatedAtEpochMs,
  });

  final String id;
  final String title;
  final String description;
  final int sortOrder;
  final int createdAtEpochMs;
  final int updatedAtEpochMs;

  GrowthCustomCategory copyWith({
    String? title,
    String? description,
    int? sortOrder,
    int? updatedAtEpochMs,
  }) {
    return GrowthCustomCategory(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAtEpochMs: createdAtEpochMs,
      updatedAtEpochMs: updatedAtEpochMs ?? this.updatedAtEpochMs,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'sortOrder': sortOrder,
      'createdAtEpochMs': createdAtEpochMs,
      'updatedAtEpochMs': updatedAtEpochMs,
    };
  }

  static GrowthCustomCategory fromJson(Map<String, dynamic> json) {
    return GrowthCustomCategory(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      sortOrder: int.tryParse(json['sortOrder']?.toString() ?? '') ?? 999,
      createdAtEpochMs:
          int.tryParse(json['createdAtEpochMs']?.toString() ?? '') ?? 0,
      updatedAtEpochMs:
          int.tryParse(json['updatedAtEpochMs']?.toString() ?? '') ?? 0,
    );
  }
}

@immutable
class GrowthPath {
  const GrowthPath({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.difficulty,
    required this.totalHabits,
    required this.estimatedCommitment,
    required this.icon,
    required this.habitIds,
    required this.unlockPathId,
    required this.unlockLight,
    required this.stage,
  });

  final String id;
  final String title;
  final String subtitle;
  final String description;
  final GrowthPathDifficulty difficulty;
  final int totalHabits;
  final String estimatedCommitment;
  final String icon;
  final List<String> habitIds;
  final String? unlockPathId;
  final int unlockLight;
  final int stage;
}

@immutable
class GrowthReflectionEntry {
  const GrowthReflectionEntry({
    required this.id,
    required this.dayKey,
    required this.prompt,
    required this.gratitude,
    required this.tawbah,
    required this.note,
    required this.entrustToAllah,
    required this.createdAt,
    required this.mood,
    required this.linkedHabitId,
  });

  final String id;
  final String dayKey;
  final String prompt;
  final String gratitude;
  final String tawbah;
  final String note;
  final bool entrustToAllah;
  final DateTime createdAt;
  final GrowthMoodState? mood;
  final String? linkedHabitId;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dayKey': dayKey,
      'prompt': prompt,
      'gratitude': gratitude,
      'tawbah': tawbah,
      'note': note,
      'entrustToAllah': entrustToAllah,
      'createdAt': createdAt.toIso8601String(),
      'mood': mood?.name,
      'linkedHabitId': linkedHabitId,
    };
  }

  static GrowthReflectionEntry fromJson(Map<String, dynamic> json) {
    GrowthMoodState? mood;
    final moodName = json['mood']?.toString();
    for (final item in GrowthMoodState.values) {
      if (item.name == moodName) {
        mood = item;
      }
    }

    return GrowthReflectionEntry(
      id: json['id']?.toString() ?? '',
      dayKey: json['dayKey']?.toString() ?? '',
      prompt: json['prompt']?.toString() ?? '',
      gratitude: json['gratitude']?.toString() ?? '',
      tawbah: json['tawbah']?.toString() ?? '',
      note: json['note']?.toString() ?? '',
      entrustToAllah: json['entrustToAllah'] == true,
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
          DateTime.now(),
      mood: mood,
      linkedHabitId: json['linkedHabitId']?.toString(),
    );
  }
}

@immutable
class GrowthRewardEvent {
  const GrowthRewardEvent({
    required this.rewardId,
    required this.unlockedAt,
    required this.source,
  });

  final String rewardId;
  final DateTime unlockedAt;
  final String source;

  Map<String, dynamic> toJson() {
    return {
      'rewardId': rewardId,
      'unlockedAt': unlockedAt.toIso8601String(),
      'source': source,
    };
  }

  static GrowthRewardEvent fromJson(Map<String, dynamic> json) {
    return GrowthRewardEvent(
      rewardId: json['rewardId']?.toString() ?? '',
      unlockedAt: DateTime.tryParse(json['unlockedAt']?.toString() ?? '') ??
          DateTime.now(),
      source: json['source']?.toString() ?? 'growth',
    );
  }
}

@immutable
class GrowthGlobalReminderSettings {
  const GrowthGlobalReminderSettings({
    required this.remindersEnabled,
    required this.gentleMode,
    required this.pauseAllReminders,
    required this.quietDelivery,
    required this.respectDoNotDisturb,
    required this.ramadanCompatibilityMode,
  });

  factory GrowthGlobalReminderSettings.defaults() {
    return const GrowthGlobalReminderSettings(
      remindersEnabled: false,
      gentleMode: true,
      pauseAllReminders: false,
      quietDelivery: false,
      respectDoNotDisturb: true,
      ramadanCompatibilityMode: false,
    );
  }

  final bool remindersEnabled;
  final bool gentleMode;
  final bool pauseAllReminders;
  final bool quietDelivery;
  final bool respectDoNotDisturb;
  final bool ramadanCompatibilityMode;

  GrowthGlobalReminderSettings copyWith({
    bool? remindersEnabled,
    bool? gentleMode,
    bool? pauseAllReminders,
    bool? quietDelivery,
    bool? respectDoNotDisturb,
    bool? ramadanCompatibilityMode,
  }) {
    return GrowthGlobalReminderSettings(
      remindersEnabled: remindersEnabled ?? this.remindersEnabled,
      gentleMode: gentleMode ?? this.gentleMode,
      pauseAllReminders: pauseAllReminders ?? this.pauseAllReminders,
      quietDelivery: quietDelivery ?? this.quietDelivery,
      respectDoNotDisturb: respectDoNotDisturb ?? this.respectDoNotDisturb,
      ramadanCompatibilityMode:
          ramadanCompatibilityMode ?? this.ramadanCompatibilityMode,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'remindersEnabled': remindersEnabled,
      'gentleMode': gentleMode,
      'pauseAllReminders': pauseAllReminders,
      'quietDelivery': quietDelivery,
      'respectDoNotDisturb': respectDoNotDisturb,
      'ramadanCompatibilityMode': ramadanCompatibilityMode,
    };
  }

  static GrowthGlobalReminderSettings fromJson(Map<String, dynamic>? json) {
    if (json == null) return GrowthGlobalReminderSettings.defaults();
    return GrowthGlobalReminderSettings(
      remindersEnabled: json['remindersEnabled'] == true,
      gentleMode: json['gentleMode'] != false,
      pauseAllReminders: json['pauseAllReminders'] == true,
      quietDelivery: json['quietDelivery'] == true,
      respectDoNotDisturb: json['respectDoNotDisturb'] != false,
      ramadanCompatibilityMode: json['ramadanCompatibilityMode'] == true,
    );
  }
}

@immutable
class GrowthState {
  const GrowthState({
    required this.isReady,
    required this.customHabits,
    required this.customHabitCategories,
    required this.habitOverrides,
    required this.statusByDay,
    required this.habitLogsByDay,
    required this.startedPathIds,
    required this.pausedPathIds,
    required this.celebratedPathIds,
    required this.reflections,
    required this.globalReminderSettings,
    required this.privateMode,
    required this.focusHabitId,
    required this.ramadanQuranPlanDays,
    required this.ramadanQuranCompletedJuz,
    required this.ramadanModeOverride,
    required this.fastTrackTypeByDay,
    required this.unlockedRewardIds,
    required this.rewardEvents,
    required this.lastScheduleRefreshDayKey,
  });

  factory GrowthState.initial() {
    return GrowthState(
      isReady: false,
      customHabits: [],
      customHabitCategories: [],
      habitOverrides: {},
      statusByDay: {},
      habitLogsByDay: {},
      startedPathIds: {},
      pausedPathIds: {},
      celebratedPathIds: {},
      reflections: [],
      globalReminderSettings: GrowthGlobalReminderSettings.defaults(),
      privateMode: false,
      focusHabitId: null,
      ramadanQuranPlanDays: 30,
      ramadanQuranCompletedJuz: 0,
      ramadanModeOverride: false,
      fastTrackTypeByDay: {},
      unlockedRewardIds: {},
      rewardEvents: [],
      lastScheduleRefreshDayKey: '',
    );
  }

  final bool isReady;
  final List<GrowthHabit> customHabits;
  final List<GrowthCustomCategory> customHabitCategories;
  final Map<String, GrowthHabitOverride> habitOverrides;
  final Map<String, Map<String, GrowthHabitStatus>> statusByDay;
  final Map<String, Map<String, GrowthHabitLog>> habitLogsByDay;
  final Set<String> startedPathIds;
  final Set<String> pausedPathIds;
  final Set<String> celebratedPathIds;
  final List<GrowthReflectionEntry> reflections;
  final GrowthGlobalReminderSettings globalReminderSettings;
  final bool privateMode;
  final String? focusHabitId;
  final int ramadanQuranPlanDays;
  final double ramadanQuranCompletedJuz;
  final bool ramadanModeOverride;
  final Map<String, String> fastTrackTypeByDay;
  final Set<String> unlockedRewardIds;
  final List<GrowthRewardEvent> rewardEvents;
  final String lastScheduleRefreshDayKey;

  GrowthState copyWith({
    bool? isReady,
    List<GrowthHabit>? customHabits,
    List<GrowthCustomCategory>? customHabitCategories,
    Map<String, GrowthHabitOverride>? habitOverrides,
    Map<String, Map<String, GrowthHabitStatus>>? statusByDay,
    Map<String, Map<String, GrowthHabitLog>>? habitLogsByDay,
    Set<String>? startedPathIds,
    Set<String>? pausedPathIds,
    Set<String>? celebratedPathIds,
    List<GrowthReflectionEntry>? reflections,
    GrowthGlobalReminderSettings? globalReminderSettings,
    bool? privateMode,
    String? focusHabitId,
    int? ramadanQuranPlanDays,
    double? ramadanQuranCompletedJuz,
    bool? ramadanModeOverride,
    Map<String, String>? fastTrackTypeByDay,
    Set<String>? unlockedRewardIds,
    List<GrowthRewardEvent>? rewardEvents,
    String? lastScheduleRefreshDayKey,
  }) {
    return GrowthState(
      isReady: isReady ?? this.isReady,
      customHabits: customHabits ?? this.customHabits,
      customHabitCategories:
          customHabitCategories ?? this.customHabitCategories,
      habitOverrides: habitOverrides ?? this.habitOverrides,
      statusByDay: statusByDay ?? this.statusByDay,
      habitLogsByDay: habitLogsByDay ?? this.habitLogsByDay,
      startedPathIds: startedPathIds ?? this.startedPathIds,
      pausedPathIds: pausedPathIds ?? this.pausedPathIds,
      celebratedPathIds: celebratedPathIds ?? this.celebratedPathIds,
      reflections: reflections ?? this.reflections,
      globalReminderSettings:
          globalReminderSettings ?? this.globalReminderSettings,
      privateMode: privateMode ?? this.privateMode,
      focusHabitId: focusHabitId ?? this.focusHabitId,
      ramadanQuranPlanDays: ramadanQuranPlanDays ?? this.ramadanQuranPlanDays,
      ramadanQuranCompletedJuz:
          ramadanQuranCompletedJuz ?? this.ramadanQuranCompletedJuz,
      ramadanModeOverride: ramadanModeOverride ?? this.ramadanModeOverride,
      fastTrackTypeByDay: fastTrackTypeByDay ?? this.fastTrackTypeByDay,
      unlockedRewardIds: unlockedRewardIds ?? this.unlockedRewardIds,
      rewardEvents: rewardEvents ?? this.rewardEvents,
      lastScheduleRefreshDayKey:
          lastScheduleRefreshDayKey ?? this.lastScheduleRefreshDayKey,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'customHabits': customHabits.map((e) => e.toJson()).toList(),
      'customHabitCategories': customHabitCategories
          .map((e) => e.toJson())
          .toList(),
      'habitOverrides': habitOverrides.map(
        (key, value) => MapEntry(key, value.toJson()),
      ),
      'statusByDay': statusByDay.map(
        (day, statusMap) => MapEntry(
          day,
          statusMap.map((id, status) => MapEntry(id, status.name)),
        ),
      ),
      'habitLogsByDay': habitLogsByDay.map(
        (day, logs) => MapEntry(
          day,
          logs.map((id, log) => MapEntry(id, log.toJson())),
        ),
      ),
      'startedPathIds': startedPathIds.toList(),
      'pausedPathIds': pausedPathIds.toList(),
      'celebratedPathIds': celebratedPathIds.toList(),
      'reflections': reflections.map((e) => e.toJson()).toList(),
      'globalReminderSettings': globalReminderSettings.toJson(),
      'privateMode': privateMode,
      'focusHabitId': focusHabitId,
      'ramadanQuranPlanDays': ramadanQuranPlanDays,
      'ramadanQuranCompletedJuz': ramadanQuranCompletedJuz,
      'ramadanModeOverride': ramadanModeOverride,
      'fastTrackTypeByDay': fastTrackTypeByDay,
      'unlockedRewardIds': unlockedRewardIds.toList(),
      'rewardEvents': rewardEvents.map((e) => e.toJson()).toList(),
      'lastScheduleRefreshDayKey': lastScheduleRefreshDayKey,
    };
  }

  static GrowthState fromJson(Map<String, dynamic>? json) {
    if (json == null) return GrowthState.initial().copyWith(isReady: true);

    final customHabitsRaw = (json['customHabits'] as List? ?? const [])
        .whereType<Map>()
        .map((e) => e.map((k, v) => MapEntry(k.toString(), v)))
        .toList();
    final customCategoriesRaw = (json['customHabitCategories'] as List? ?? const [])
        .whereType<Map>()
        .map((e) => e.map((k, v) => MapEntry(k.toString(), v)))
        .toList();

    final statusByDay = <String, Map<String, GrowthHabitStatus>>{};
    final habitLogsByDay = <String, Map<String, GrowthHabitLog>>{};
    final habitOverrides = <String, GrowthHabitOverride>{};
    final overrideRaw = json['habitOverrides'];
    if (overrideRaw is Map) {
      for (final entry in overrideRaw.entries) {
        if (entry.value is! Map) continue;
        final value = (entry.value as Map).map((k, v) => MapEntry(k.toString(), v));
        habitOverrides[entry.key.toString()] = GrowthHabitOverride.fromJson(value);
      }
    }
    final statusRaw = json['statusByDay'];
    if (statusRaw is Map) {
      for (final entry in statusRaw.entries) {
        if (entry.value is! Map) continue;
        final map = <String, GrowthHabitStatus>{};
        for (final statusEntry in (entry.value as Map).entries) {
          final statusName = statusEntry.value?.toString() ?? '';
          var status = GrowthHabitStatus.completed;
          for (final item in GrowthHabitStatus.values) {
            if (item.name == statusName) status = item;
          }
          map[statusEntry.key.toString()] = status;
        }
        statusByDay[entry.key.toString()] = map;
      }
    }

    final logsRaw = json['habitLogsByDay'];
    if (logsRaw is Map) {
      for (final entry in logsRaw.entries) {
        if (entry.value is! Map) continue;
        final map = <String, GrowthHabitLog>{};
        for (final logEntry in (entry.value as Map).entries) {
          if (logEntry.value is! Map) continue;
          final value = (logEntry.value as Map).map((k, v) => MapEntry(k.toString(), v));
          map[logEntry.key.toString()] = GrowthHabitLog.fromJson(value);
        }
        habitLogsByDay[entry.key.toString()] = map;
      }
    }

    // Backward compatibility migration from statusByDay.
    if (habitLogsByDay.isEmpty && statusByDay.isNotEmpty) {
      for (final day in statusByDay.entries) {
        final map = <String, GrowthHabitLog>{};
        for (final statusEntry in day.value.entries) {
          map[statusEntry.key] = GrowthHabitLog(
            status: statusEntry.value,
            progress: statusEntry.value == GrowthHabitStatus.completed ? 1 : 0,
            updatedAt: DateTime.now(),
            entrusted: false,
          );
        }
        habitLogsByDay[day.key] = map;
      }
    }

    final reflectionsRaw = (json['reflections'] as List? ?? const [])
        .whereType<Map>()
        .map((e) => e.map((k, v) => MapEntry(k.toString(), v)))
        .toList();

    return GrowthState(
      isReady: true,
      customHabits: customHabitsRaw.map(GrowthHabit.fromJson).toList(),
      customHabitCategories: customCategoriesRaw
          .map(GrowthCustomCategory.fromJson)
          .toList(),
      habitOverrides: habitOverrides,
      statusByDay: statusByDay,
      habitLogsByDay: habitLogsByDay,
      startedPathIds: (json['startedPathIds'] as List? ?? const [])
          .map((e) => e.toString())
          .toSet(),
      pausedPathIds: (json['pausedPathIds'] as List? ?? const [])
          .map((e) => e.toString())
          .toSet(),
      celebratedPathIds: (json['celebratedPathIds'] as List? ?? const [])
          .map((e) => e.toString())
          .toSet(),
      reflections: reflectionsRaw.map(GrowthReflectionEntry.fromJson).toList(),
      globalReminderSettings: GrowthGlobalReminderSettings.fromJson(
        (json['globalReminderSettings'] as Map?)?.map(
          (k, v) => MapEntry(k.toString(), v),
        ),
      ),
      privateMode: json['privateMode'] == true,
      focusHabitId: json['focusHabitId']?.toString(),
      ramadanQuranPlanDays:
          int.tryParse(json['ramadanQuranPlanDays']?.toString() ?? '') ?? 30,
      ramadanQuranCompletedJuz:
          double.tryParse(json['ramadanQuranCompletedJuz']?.toString() ?? '') ??
          0,
      ramadanModeOverride: json['ramadanModeOverride'] == true,
      fastTrackTypeByDay: ((json['fastTrackTypeByDay'] as Map?) ?? const {})
          .map((k, v) => MapEntry(k.toString(), v.toString())),
      unlockedRewardIds: (json['unlockedRewardIds'] as List? ?? const [])
          .map((e) => e.toString())
          .toSet(),
      rewardEvents: (json['rewardEvents'] as List? ?? const [])
          .whereType<Map>()
          .map((e) => e.map((k, v) => MapEntry(k.toString(), v)))
          .map(GrowthRewardEvent.fromJson)
          .toList(),
      lastScheduleRefreshDayKey:
          json['lastScheduleRefreshDayKey']?.toString() ?? '',
    );
  }
}

@immutable
class GrowthWidgetSnapshot {
  const GrowthWidgetSnapshot({
    required this.dayKey,
    required this.todayCompletedCount,
    required this.todayDueCount,
    required this.todayProgressPercent,
    required this.lightEarnedToday,
    required this.currentStreak,
    required this.nextDueHabitId,
    required this.nextDueHabitTitle,
    required this.selectedFocusHabitId,
    required this.selectedFocusHabitTitle,
    required this.selectedFocusHabitCompleted,
    required this.reflectionPromptPreview,
    required this.privateModeEnabled,
    required this.updatedAtIso,
  });

  final String dayKey;
  final int todayCompletedCount;
  final int todayDueCount;
  final int todayProgressPercent;
  final int lightEarnedToday;
  final int currentStreak;
  final String? nextDueHabitId;
  final String? nextDueHabitTitle;
  final String? selectedFocusHabitId;
  final String? selectedFocusHabitTitle;
  final bool selectedFocusHabitCompleted;
  final String reflectionPromptPreview;
  final bool privateModeEnabled;
  final String updatedAtIso;

  Map<String, dynamic> toJson() {
    return {
      'dayKey': dayKey,
      'todayCompletedCount': todayCompletedCount,
      'todayDueCount': todayDueCount,
      'todayProgressPercent': todayProgressPercent,
      'lightEarnedToday': lightEarnedToday,
      'currentStreak': currentStreak,
      'nextDueHabitId': nextDueHabitId,
      'nextDueHabitTitle': nextDueHabitTitle,
      'selectedFocusHabitId': selectedFocusHabitId,
      'selectedFocusHabitTitle': selectedFocusHabitTitle,
      'selectedFocusHabitCompleted': selectedFocusHabitCompleted,
      'reflectionPromptPreview': reflectionPromptPreview,
      'privateModeEnabled': privateModeEnabled,
      'updatedAtIso': updatedAtIso,
    };
  }

  static GrowthWidgetSnapshot fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      final now = DateTime.now();
      return GrowthWidgetSnapshot(
        dayKey: '${now.year.toString().padLeft(4, '0')}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}',
        todayCompletedCount: 0,
        todayDueCount: 0,
        todayProgressPercent: 0,
        lightEarnedToday: 0,
        currentStreak: 0,
        nextDueHabitId: null,
        nextDueHabitTitle: null,
        selectedFocusHabitId: null,
        selectedFocusHabitTitle: null,
        selectedFocusHabitCompleted: false,
        reflectionPromptPreview: 'Return gently when you are ready.',
        privateModeEnabled: false,
        updatedAtIso: now.toIso8601String(),
      );
    }
    return GrowthWidgetSnapshot(
      dayKey: json['dayKey']?.toString() ?? '',
      todayCompletedCount:
          int.tryParse(json['todayCompletedCount']?.toString() ?? '') ?? 0,
      todayDueCount: int.tryParse(json['todayDueCount']?.toString() ?? '') ?? 0,
      todayProgressPercent:
          int.tryParse(json['todayProgressPercent']?.toString() ?? '') ?? 0,
      lightEarnedToday:
          int.tryParse(json['lightEarnedToday']?.toString() ?? '') ?? 0,
      currentStreak: int.tryParse(json['currentStreak']?.toString() ?? '') ?? 0,
      nextDueHabitId: json['nextDueHabitId']?.toString(),
      nextDueHabitTitle: json['nextDueHabitTitle']?.toString(),
      selectedFocusHabitId: json['selectedFocusHabitId']?.toString(),
      selectedFocusHabitTitle: json['selectedFocusHabitTitle']?.toString(),
      selectedFocusHabitCompleted: json['selectedFocusHabitCompleted'] == true,
      reflectionPromptPreview:
          json['reflectionPromptPreview']?.toString() ??
          'Return gently when you are ready.',
      privateModeEnabled: json['privateModeEnabled'] == true,
      updatedAtIso: json['updatedAtIso']?.toString() ?? DateTime.now().toIso8601String(),
    );
  }
}

@immutable
class GrowthHabitOverride {
  const GrowthHabitOverride({
    required this.active,
    required this.muted,
    required this.hidden,
    required this.reminderEnabled,
    required this.entrustToAllah,
    required this.archived,
    required this.privateTracking,
    required this.showInToday,
    required this.paused,
    required this.reminderMode,
    required this.reminderTimeMinutes,
    required this.reminderPrayerAnchor,
    required this.reminderOffsetMinutes,
    required this.reminderWindowType,
    required this.reminderDays,
    required this.reminderMessageOverride,
    required this.quietDelivery,
    required this.allowSnooze,
    required this.remindersPaused,
  });

  final bool? active;
  final bool? muted;
  final bool? hidden;
  final bool? reminderEnabled;
  final bool? entrustToAllah;
  final bool? archived;
  final bool? privateTracking;
  final bool? showInToday;
  final bool? paused;
  final GrowthReminderMode? reminderMode;
  final int? reminderTimeMinutes;
  final GrowthReminderPrayerAnchor? reminderPrayerAnchor;
  final int? reminderOffsetMinutes;
  final GrowthReminderWindowType? reminderWindowType;
  final List<int>? reminderDays;
  final String? reminderMessageOverride;
  final bool? quietDelivery;
  final bool? allowSnooze;
  final bool? remindersPaused;

  GrowthHabitOverride copyWith({
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
    return GrowthHabitOverride(
      active: active ?? this.active,
      muted: muted ?? this.muted,
      hidden: hidden ?? this.hidden,
      reminderEnabled: reminderEnabled ?? this.reminderEnabled,
      entrustToAllah: entrustToAllah ?? this.entrustToAllah,
      archived: archived ?? this.archived,
      privateTracking: privateTracking ?? this.privateTracking,
      showInToday: showInToday ?? this.showInToday,
      paused: paused ?? this.paused,
      reminderMode: reminderMode ?? this.reminderMode,
      reminderTimeMinutes: reminderTimeMinutes ?? this.reminderTimeMinutes,
      reminderPrayerAnchor:
          reminderPrayerAnchor ?? this.reminderPrayerAnchor,
      reminderOffsetMinutes:
          reminderOffsetMinutes ?? this.reminderOffsetMinutes,
      reminderWindowType: reminderWindowType ?? this.reminderWindowType,
      reminderDays: reminderDays ?? this.reminderDays,
      reminderMessageOverride:
          reminderMessageOverride ?? this.reminderMessageOverride,
      quietDelivery: quietDelivery ?? this.quietDelivery,
      allowSnooze: allowSnooze ?? this.allowSnooze,
      remindersPaused: remindersPaused ?? this.remindersPaused,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'active': active,
      'muted': muted,
      'hidden': hidden,
      'reminderEnabled': reminderEnabled,
      'entrustToAllah': entrustToAllah,
      'archived': archived,
      'privateTracking': privateTracking,
      'showInToday': showInToday,
      'paused': paused,
      'reminderMode': reminderMode?.name,
      'reminderTimeMinutes': reminderTimeMinutes,
      'reminderPrayerAnchor': reminderPrayerAnchor?.name,
      'reminderOffsetMinutes': reminderOffsetMinutes,
      'reminderWindowType': reminderWindowType?.name,
      'reminderDays': reminderDays,
      'reminderMessageOverride': reminderMessageOverride,
      'quietDelivery': quietDelivery,
      'allowSnooze': allowSnooze,
      'remindersPaused': remindersPaused,
    };
  }

  static GrowthHabitOverride fromJson(Map<String, dynamic> json) {
    GrowthReminderMode? reminderMode;
    for (final item in GrowthReminderMode.values) {
      if (item.name == json['reminderMode']) reminderMode = item;
    }
    GrowthReminderPrayerAnchor? reminderPrayerAnchor;
    for (final item in GrowthReminderPrayerAnchor.values) {
      if (item.name == json['reminderPrayerAnchor']) reminderPrayerAnchor = item;
    }
    GrowthReminderWindowType? reminderWindowType;
    for (final item in GrowthReminderWindowType.values) {
      if (item.name == json['reminderWindowType']) reminderWindowType = item;
    }
    return GrowthHabitOverride(
      active: json['active'] as bool?,
      muted: json['muted'] as bool?,
      hidden: json['hidden'] as bool?,
      reminderEnabled: json['reminderEnabled'] as bool?,
      entrustToAllah: json['entrustToAllah'] as bool?,
      archived: json['archived'] as bool?,
      privateTracking: json['privateTracking'] as bool?,
      showInToday: json['showInToday'] as bool?,
      paused: json['paused'] as bool?,
      reminderMode: reminderMode,
      reminderTimeMinutes:
          int.tryParse(json['reminderTimeMinutes']?.toString() ?? ''),
      reminderPrayerAnchor: reminderPrayerAnchor,
      reminderOffsetMinutes:
          int.tryParse(json['reminderOffsetMinutes']?.toString() ?? ''),
      reminderWindowType: reminderWindowType,
      reminderDays: (json['reminderDays'] as List?)
          ?.map((e) => int.tryParse(e.toString()) ?? 1)
          .toList(),
      reminderMessageOverride: json['reminderMessageOverride']?.toString(),
      quietDelivery: json['quietDelivery'] as bool?,
      allowSnooze: json['allowSnooze'] as bool?,
      remindersPaused: json['remindersPaused'] as bool?,
    );
  }
}
