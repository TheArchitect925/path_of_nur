import 'growth_models.dart';

class GrowthHijriDate {
  const GrowthHijriDate({
    required this.year,
    required this.month,
    required this.day,
  });

  final int year;
  final int month;
  final int day;

  String get monthName => _hijriMonthNames[month - 1];
}

enum GrowthSeasonKind { ramadan, lastTenNights, friday, dhulHijjah }

class GrowthSeasonalContext {
  const GrowthSeasonalContext({
    required this.gregorianDate,
    required this.hijriDate,
    required this.isRamadanDetected,
    required this.isRamadanMode,
    required this.isLastTenNights,
    required this.isFriday,
    required this.isDhulHijjahFirstTen,
    required this.activeSeasons,
    required this.recommendedFastType,
    required this.availableFastTypes,
  });

  final DateTime gregorianDate;
  final GrowthHijriDate hijriDate;
  final bool isRamadanDetected;
  final bool isRamadanMode;
  final bool isLastTenNights;
  final bool isFriday;
  final bool isDhulHijjahFirstTen;
  final List<GrowthSeasonKind> activeSeasons;
  final GrowthFastTrackType recommendedFastType;
  final List<GrowthFastTrackType> availableFastTypes;
}

class GrowthRamadanDashboardData {
  const GrowthRamadanDashboardData({
    required this.fastCompleted,
    required this.quranHabitCompleted,
    required this.charityCompleted,
    required this.reflectionCompleted,
    required this.dailyProgress,
    required this.progressLabel,
  });

  final bool fastCompleted;
  final bool quranHabitCompleted;
  final bool charityCompleted;
  final bool reflectionCompleted;
  final double dailyProgress;
  final String progressLabel;
}

class GrowthQuranCompletionTracker {
  const GrowthQuranCompletionTracker({
    required this.planDays,
    required this.currentJuzProgress,
    required this.remainingJuz,
    required this.completedPercent,
    required this.estimatedDaysRemaining,
    required this.estimatedDailyJuzNeeded,
  });

  final int planDays;
  final double currentJuzProgress;
  final double remainingJuz;
  final int completedPercent;
  final int estimatedDaysRemaining;
  final double estimatedDailyJuzNeeded;
}

class GrowthFastTrackingData {
  const GrowthFastTrackingData({
    required this.recommendedType,
    required this.availableTypes,
    required this.selectedType,
    required this.habitIdForToday,
    required this.completedToday,
  });

  final GrowthFastTrackType recommendedType;
  final List<GrowthFastTrackType> availableTypes;
  final GrowthFastTrackType selectedType;
  final String? habitIdForToday;
  final bool completedToday;
}

class GrowthSeasonalJourneyCard {
  const GrowthSeasonalJourneyCard({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.habitIds,
  });

  final String id;
  final String title;
  final String subtitle;
  final String icon;
  final List<String> habitIds;
}

GrowthHijriDate growthToHijriDate(DateTime date) {
  final y = date.year;
  final m = date.month;
  final d = date.day;
  final a = ((14 - m) / 12).floor();
  final y2 = y + 4800 - a;
  final m2 = m + 12 * a - 3;
  final jd =
      d +
      ((153 * m2 + 2) / 5).floor() +
      365 * y2 +
      (y2 / 4).floor() -
      (y2 / 100).floor() +
      (y2 / 400).floor() -
      32045;

  var l = jd - 1948440 + 10632;
  final n = ((l - 1) / 10631).floor();
  l = l - 10631 * n + 354;
  final j =
      (((10985 - l) / 5316).floor()) * (((50 * l) / 17719).floor()) +
      ((l / 5670).floor()) * (((43 * l) / 15238).floor());
  l =
      l -
      (((30 - j) / 15).floor()) * (((17719 * j) / 50).floor()) -
      ((j / 16).floor()) * (((15238 * j) / 43).floor()) +
      29;
  final month = (24 * l / 709).floor();
  final day = l - (709 * month / 24).floor();
  final year = 30 * n + j - 30;
  return GrowthHijriDate(year: year, month: month, day: day);
}

GrowthSeasonalContext buildGrowthSeasonalContext(
  DateTime date, {
  required bool manualRamadanToggle,
}) {
  final normalized = DateTime(date.year, date.month, date.day);
  final hijri = growthToHijriDate(normalized);

  final isRamadanDetected = hijri.month == 9;
  final isRamadanMode = isRamadanDetected || manualRamadanToggle;
  final isLastTenNights = isRamadanMode && hijri.month == 9 && hijri.day >= 21;
  final isFriday = normalized.weekday == DateTime.friday;
  final isDhulHijjahFirstTen = hijri.month == 12 && hijri.day <= 10;

  final active = <GrowthSeasonKind>[];
  if (isRamadanMode) active.add(GrowthSeasonKind.ramadan);
  if (isLastTenNights) active.add(GrowthSeasonKind.lastTenNights);
  if (isFriday) active.add(GrowthSeasonKind.friday);
  if (isDhulHijjahFirstTen) active.add(GrowthSeasonKind.dhulHijjah);

  final available = <GrowthFastTrackType>[GrowthFastTrackType.custom];
  GrowthFastTrackType recommended = GrowthFastTrackType.custom;

  if (isRamadanMode) {
    available.insert(0, GrowthFastTrackType.ramadan);
    recommended = GrowthFastTrackType.ramadan;
  }
  if (hijri.month == 12 && hijri.day == 9) {
    if (!available.contains(GrowthFastTrackType.arafah)) {
      available.insert(0, GrowthFastTrackType.arafah);
    }
    recommended = GrowthFastTrackType.arafah;
  }
  if (hijri.month == 1 && (hijri.day == 9 || hijri.day == 10)) {
    if (!available.contains(GrowthFastTrackType.ashura)) {
      available.insert(0, GrowthFastTrackType.ashura);
    }
    if (recommended == GrowthFastTrackType.custom) {
      recommended = GrowthFastTrackType.ashura;
    }
  }
  if (hijri.day >= 13 && hijri.day <= 15) {
    if (!available.contains(GrowthFastTrackType.whiteDays)) {
      available.insert(0, GrowthFastTrackType.whiteDays);
    }
    if (recommended == GrowthFastTrackType.custom) {
      recommended = GrowthFastTrackType.whiteDays;
    }
  }
  if (normalized.weekday == DateTime.monday ||
      normalized.weekday == DateTime.thursday) {
    if (!available.contains(GrowthFastTrackType.mondayThursday)) {
      available.insert(0, GrowthFastTrackType.mondayThursday);
    }
    if (recommended == GrowthFastTrackType.custom) {
      recommended = GrowthFastTrackType.mondayThursday;
    }
  }

  return GrowthSeasonalContext(
    gregorianDate: normalized,
    hijriDate: hijri,
    isRamadanDetected: isRamadanDetected,
    isRamadanMode: isRamadanMode,
    isLastTenNights: isLastTenNights,
    isFriday: isFriday,
    isDhulHijjahFirstTen: isDhulHijjahFirstTen,
    activeSeasons: active,
    recommendedFastType: recommended,
    availableFastTypes: available,
  );
}

const _hijriMonthNames = <String>[
  'Muharram',
  'Safar',
  'Rabi al-Awwal',
  'Rabi al-Thani',
  'Jumada al-Awwal',
  'Jumada al-Thani',
  'Rajab',
  'Sha\'ban',
  'Ramadan',
  'Shawwal',
  'Dhu al-Qi\'dah',
  'Dhu al-Hijjah',
];

const seasonalReflectionPromptBank = <GrowthSeasonKind, List<String>>{
  GrowthSeasonKind.ramadan: [
    'What act today brought your heart closest to Allah in Ramadan?',
    'Where did you feel restraint and sincerity while fasting today?',
    'What small act can you protect tonight in Ramadan?',
  ],
  GrowthSeasonKind.lastTenNights: [
    'What can you offer tonight with full sincerity, even if small?',
    'How will you make space for du’a and quiet worship tonight?',
    'What does returning in these nights look like for you?',
  ],
  GrowthSeasonKind.friday: [
    'What Sunnah of Friday can you hold with presence today?',
    'How can your salawat soften your Friday?',
    'What du’a will you carry before Maghrib?',
  ],
  GrowthSeasonKind.dhulHijjah: [
    'What act can you increase in these blessed days?',
    'How can dhikr shape your day with steadiness?',
    'What sincere intention can you renew before tomorrow?',
  ],
};

const seasonalEncouragementCopy = <GrowthSeasonKind, List<String>>{
  GrowthSeasonKind.ramadan: [
    'Ramadan is a month of return. Keep walking gently.',
    'Small acts in Ramadan carry weight when done sincerely.',
  ],
  GrowthSeasonKind.lastTenNights: [
    'These nights are precious. Begin again tonight with hope.',
    'Quiet worship in these nights can transform a heart.',
  ],
  GrowthSeasonKind.friday: [
    'Friday is a weekly renewal. Keep your heart attentive.',
    'A calm Friday routine strengthens the path over time.',
  ],
  GrowthSeasonKind.dhulHijjah: [
    'These ten days are an opening. Take one sincere step today.',
    'Consistency in blessed days brings light upon light.',
  ],
};

List<GrowthHabit> seasonalGrowthHabits = const [
  GrowthHabit(
    id: 's_ramadan_fast_today',
    title: 'Fast Today',
    subtitle: 'Hold the Ramadan fast with sincerity.',
    description: 'Track today’s Ramadan fast gently in your Growth path.',
    category: GrowthHabitCategory.dailyWorship,
    pathIds: ['seasonal-ramadan'],
    recurrenceType: GrowthHabitRecurrenceType.daily,
    weekdays: [1, 2, 3, 4, 5, 6, 7],
    frequencyTarget: 7,
    difficulty: 2,
    lightReward: 22,
    streakEligible: true,
    reminderEnabled: true,
    reminderMode: GrowthReminderMode.timeWindow,
    reminderWindowType: GrowthReminderWindowType.earlyMorning,
    reflectionPrompt: 'How did fasting shape your focus today?',
    active: true,
    muted: false,
    hidden: false,
    entrustable: true,
    entrustToAllah: false,
    sortOrder: 5000,
    isCustom: false,
    stage: 1,
  ),
  GrowthHabit(
    id: 's_ramadan_quran',
    title: 'Ramadan Qur’an Reading',
    subtitle: 'Read with a completion intention.',
    description: 'Maintain daily Qur’an reading through Ramadan.',
    category: GrowthHabitCategory.knowledge,
    pathIds: ['seasonal-ramadan'],
    recurrenceType: GrowthHabitRecurrenceType.daily,
    weekdays: [1, 2, 3, 4, 5, 6, 7],
    frequencyTarget: 7,
    difficulty: 2,
    lightReward: 18,
    streakEligible: true,
    reminderEnabled: true,
    reminderMode: GrowthReminderMode.timeWindow,
    reminderWindowType: GrowthReminderWindowType.evening,
    reflectionPrompt: 'What ayah stayed with you in Ramadan today?',
    active: true,
    muted: false,
    hidden: false,
    entrustable: true,
    entrustToAllah: false,
    sortOrder: 5001,
    isCustom: false,
    stage: 1,
    allowPartial: true,
  ),
  GrowthHabit(
    id: 's_ramadan_taraweeh',
    title: 'Taraweeh Salah',
    subtitle: 'Stand in night salah during Ramadan.',
    description: 'Track taraweeh consistently and gently.',
    category: GrowthHabitCategory.sunnahPractices,
    pathIds: ['seasonal-ramadan'],
    recurrenceType: GrowthHabitRecurrenceType.daily,
    weekdays: [1, 2, 3, 4, 5, 6, 7],
    frequencyTarget: 7,
    difficulty: 2,
    lightReward: 16,
    streakEligible: true,
    reminderEnabled: false,
    reflectionPrompt: null,
    active: true,
    muted: false,
    hidden: false,
    entrustable: true,
    entrustToAllah: false,
    sortOrder: 5002,
    isCustom: false,
    stage: 1,
  ),
  GrowthHabit(
    id: 's_ramadan_charity',
    title: 'Ramadan Charity',
    subtitle: 'Give regularly in the month of mercy.',
    description: 'Record one act of giving, even if small.',
    category: GrowthHabitCategory.charityService,
    pathIds: ['seasonal-ramadan'],
    recurrenceType: GrowthHabitRecurrenceType.weeklyTarget,
    weekdays: [1, 2, 3, 4, 5, 6, 7],
    frequencyTarget: 3,
    difficulty: 2,
    lightReward: 18,
    streakEligible: true,
    reminderEnabled: true,
    reminderMode: GrowthReminderMode.timeWindow,
    reminderWindowType: GrowthReminderWindowType.fridayAfternoon,
    reflectionPrompt: 'How did giving affect your heart today?',
    active: true,
    muted: false,
    hidden: false,
    entrustable: true,
    entrustToAllah: false,
    sortOrder: 5003,
    isCustom: false,
    stage: 1,
  ),
  GrowthHabit(
    id: 's_ramadan_dua',
    title: 'Extra Du’a',
    subtitle: 'Increase sincere du’a in Ramadan.',
    description: 'Keep one focused du’a session each day.',
    category: GrowthHabitCategory.dailyWorship,
    pathIds: ['seasonal-ramadan'],
    recurrenceType: GrowthHabitRecurrenceType.daily,
    weekdays: [1, 2, 3, 4, 5, 6, 7],
    frequencyTarget: 7,
    difficulty: 1,
    lightReward: 12,
    streakEligible: true,
    reminderEnabled: true,
    reminderMode: GrowthReminderMode.timeWindow,
    reminderWindowType: GrowthReminderWindowType.beforeSleep,
    reflectionPrompt: 'What did you ask Allah for with sincerity today?',
    active: true,
    muted: false,
    hidden: false,
    entrustable: true,
    entrustToAllah: false,
    sortOrder: 5004,
    isCustom: false,
    stage: 1,
  ),
  GrowthHabit(
    id: 's_ramadan_guard_speech',
    title: 'Avoid Harmful Speech',
    subtitle: 'Protect the fast through character.',
    description: 'Guard words and reactions with care.',
    category: GrowthHabitCategory.character,
    pathIds: ['seasonal-ramadan'],
    recurrenceType: GrowthHabitRecurrenceType.daily,
    weekdays: [1, 2, 3, 4, 5, 6, 7],
    frequencyTarget: 7,
    difficulty: 2,
    lightReward: 12,
    streakEligible: true,
    reminderEnabled: false,
    reflectionPrompt: null,
    active: true,
    muted: false,
    hidden: false,
    entrustable: true,
    entrustToAllah: false,
    sortOrder: 5005,
    isCustom: false,
    stage: 1,
  ),
  GrowthHabit(
    id: 's_ramadan_night_reflection',
    title: 'Night Reflection',
    subtitle: 'End the day with muhasabah.',
    description: 'Review your day and return in tawbah.',
    category: GrowthHabitCategory.reflectionGratitude,
    pathIds: ['seasonal-ramadan'],
    recurrenceType: GrowthHabitRecurrenceType.daily,
    weekdays: [1, 2, 3, 4, 5, 6, 7],
    frequencyTarget: 7,
    difficulty: 1,
    lightReward: 10,
    streakEligible: true,
    reminderEnabled: true,
    reminderMode: GrowthReminderMode.timeWindow,
    reminderWindowType: GrowthReminderWindowType.beforeSleep,
    reflectionPrompt: 'What can you improve tomorrow in Ramadan?',
    active: true,
    muted: false,
    hidden: false,
    entrustable: true,
    entrustToAllah: false,
    sortOrder: 5006,
    isCustom: false,
    stage: 1,
  ),
  GrowthHabit(
    id: 's_last10_tahajjud',
    title: 'Tahajjud in Last Ten',
    subtitle: 'Wake gently for night worship.',
    description: 'Track tahajjud in the final nights of Ramadan.',
    category: GrowthHabitCategory.sunnahPractices,
    pathIds: ['seasonal-last10'],
    recurrenceType: GrowthHabitRecurrenceType.occasional,
    weekdays: [1, 2, 3, 4, 5, 6, 7],
    frequencyTarget: 4,
    difficulty: 3,
    lightReward: 20,
    streakEligible: true,
    reminderEnabled: true,
    reminderMode: GrowthReminderMode.timeWindow,
    reminderWindowType: GrowthReminderWindowType.night,
    reflectionPrompt: 'How did tonight’s qiyam affect your heart?',
    active: true,
    muted: false,
    hidden: false,
    entrustable: true,
    entrustToAllah: false,
    sortOrder: 5010,
    isCustom: false,
    stage: 2,
  ),
  GrowthHabit(
    id: 's_last10_quran',
    title: 'Extended Qur’an Reading',
    subtitle: 'Increase your daily Qur’an portion.',
    description: 'Take a longer Qur’an session in the last ten nights.',
    category: GrowthHabitCategory.knowledge,
    pathIds: ['seasonal-last10'],
    recurrenceType: GrowthHabitRecurrenceType.daily,
    weekdays: [1, 2, 3, 4, 5, 6, 7],
    frequencyTarget: 7,
    difficulty: 3,
    lightReward: 18,
    streakEligible: true,
    reminderEnabled: false,
    reflectionPrompt: null,
    active: true,
    muted: false,
    hidden: false,
    entrustable: true,
    entrustToAllah: false,
    sortOrder: 5011,
    isCustom: false,
    stage: 2,
    allowPartial: true,
  ),
  GrowthHabit(
    id: 's_last10_dua',
    title: 'Long Du’a Session',
    subtitle: 'Give time to sincere supplication.',
    description: 'Set aside a focused period for du’a each night.',
    category: GrowthHabitCategory.dailyWorship,
    pathIds: ['seasonal-last10'],
    recurrenceType: GrowthHabitRecurrenceType.daily,
    weekdays: [1, 2, 3, 4, 5, 6, 7],
    frequencyTarget: 7,
    difficulty: 2,
    lightReward: 14,
    streakEligible: true,
    reminderEnabled: true,
    reminderMode: GrowthReminderMode.timeWindow,
    reminderWindowType: GrowthReminderWindowType.night,
    reflectionPrompt: 'What did you place before Allah tonight?',
    active: true,
    muted: false,
    hidden: false,
    entrustable: true,
    entrustToAllah: false,
    sortOrder: 5012,
    isCustom: false,
    stage: 2,
  ),
  GrowthHabit(
    id: 's_last10_charity',
    title: 'Charity in Last Ten',
    subtitle: 'Increase hidden giving in blessed nights.',
    description: 'Offer one act of charity in these nights.',
    category: GrowthHabitCategory.charityService,
    pathIds: ['seasonal-last10'],
    recurrenceType: GrowthHabitRecurrenceType.weeklyTarget,
    weekdays: [1, 2, 3, 4, 5, 6, 7],
    frequencyTarget: 4,
    difficulty: 2,
    lightReward: 16,
    streakEligible: true,
    reminderEnabled: false,
    reflectionPrompt: null,
    active: true,
    muted: false,
    hidden: false,
    entrustable: true,
    entrustToAllah: false,
    sortOrder: 5013,
    isCustom: false,
    stage: 2,
  ),
  GrowthHabit(
    id: 's_last10_reflection',
    title: 'Nightly Reflection',
    subtitle: 'Protect intention in the final nights.',
    description: 'Reflect briefly each night with sincerity.',
    category: GrowthHabitCategory.reflectionGratitude,
    pathIds: ['seasonal-last10'],
    recurrenceType: GrowthHabitRecurrenceType.daily,
    weekdays: [1, 2, 3, 4, 5, 6, 7],
    frequencyTarget: 7,
    difficulty: 2,
    lightReward: 12,
    streakEligible: true,
    reminderEnabled: false,
    reflectionPrompt: 'What intention do you renew tonight?',
    active: true,
    muted: false,
    hidden: false,
    entrustable: true,
    entrustToAllah: false,
    sortOrder: 5014,
    isCustom: false,
    stage: 2,
  ),
  GrowthHabit(
    id: 's_friday_salawat',
    title: 'Send Salawat on Friday',
    subtitle: 'Increase salawat through the day.',
    description: 'Keep frequent salawat with presence today.',
    category: GrowthHabitCategory.sunnahPractices,
    pathIds: ['seasonal-friday'],
    recurrenceType: GrowthHabitRecurrenceType.daily,
    weekdays: [DateTime.friday],
    frequencyTarget: 1,
    difficulty: 1,
    lightReward: 10,
    streakEligible: true,
    reminderEnabled: true,
    reminderMode: GrowthReminderMode.timeWindow,
    reminderWindowType: GrowthReminderWindowType.fridayMorning,
    reflectionPrompt: null,
    active: true,
    muted: false,
    hidden: false,
    entrustable: true,
    entrustToAllah: false,
    sortOrder: 5020,
    isCustom: false,
    stage: 1,
  ),
  GrowthHabit(
    id: 's_friday_kahf',
    title: 'Read Surah Al-Kahf',
    subtitle: 'Weekly Friday Qur’an rhythm.',
    description: 'Read or listen to Surah Al-Kahf today.',
    category: GrowthHabitCategory.knowledge,
    pathIds: ['seasonal-friday'],
    recurrenceType: GrowthHabitRecurrenceType.daily,
    weekdays: [DateTime.friday],
    frequencyTarget: 1,
    difficulty: 2,
    lightReward: 14,
    streakEligible: true,
    reminderEnabled: true,
    reminderMode: GrowthReminderMode.timeWindow,
    reminderWindowType: GrowthReminderWindowType.fridayMorning,
    reflectionPrompt: 'What verse of Al-Kahf stayed with you today?',
    active: true,
    muted: false,
    hidden: false,
    entrustable: true,
    entrustToAllah: false,
    sortOrder: 5021,
    isCustom: false,
    stage: 1,
  ),
  GrowthHabit(
    id: 's_friday_jumuah',
    title: 'Attend Jumuʿah Salah',
    subtitle: 'Protect the weekly congregational salah.',
    description: 'Attend Jumuʿah with presence and preparedness.',
    category: GrowthHabitCategory.dailyWorship,
    pathIds: ['seasonal-friday'],
    recurrenceType: GrowthHabitRecurrenceType.daily,
    weekdays: [DateTime.friday],
    frequencyTarget: 1,
    difficulty: 2,
    lightReward: 16,
    streakEligible: true,
    reminderEnabled: false,
    reflectionPrompt: null,
    active: true,
    muted: false,
    hidden: false,
    entrustable: true,
    entrustToAllah: false,
    sortOrder: 5022,
    isCustom: false,
    stage: 1,
  ),
  GrowthHabit(
    id: 's_friday_charity',
    title: 'Friday Charity',
    subtitle: 'Give weekly with sincerity.',
    description: 'Offer a Friday act of charity, even small.',
    category: GrowthHabitCategory.charityService,
    pathIds: ['seasonal-friday'],
    recurrenceType: GrowthHabitRecurrenceType.daily,
    weekdays: [DateTime.friday],
    frequencyTarget: 1,
    difficulty: 1,
    lightReward: 12,
    streakEligible: true,
    reminderEnabled: false,
    reflectionPrompt: null,
    active: true,
    muted: false,
    hidden: false,
    entrustable: true,
    entrustToAllah: false,
    sortOrder: 5023,
    isCustom: false,
    stage: 1,
  ),
  GrowthHabit(
    id: 's_friday_dua_maghrib',
    title: 'Du’a Before Maghrib',
    subtitle: 'Guard this Friday supplication moment.',
    description: 'Take a focused du’a moment before Maghrib.',
    category: GrowthHabitCategory.dailyWorship,
    pathIds: ['seasonal-friday'],
    recurrenceType: GrowthHabitRecurrenceType.daily,
    weekdays: [DateTime.friday],
    frequencyTarget: 1,
    difficulty: 1,
    lightReward: 12,
    streakEligible: true,
    reminderEnabled: true,
    reminderMode: GrowthReminderMode.timeWindow,
    reminderWindowType: GrowthReminderWindowType.fridayAfternoon,
    reflectionPrompt: 'What did you ask before Maghrib today?',
    active: true,
    muted: false,
    hidden: false,
    entrustable: true,
    entrustToAllah: false,
    sortOrder: 5024,
    isCustom: false,
    stage: 1,
  ),
  GrowthHabit(
    id: 's_dhul_fast',
    title: 'Recommended Fast',
    subtitle: 'Fast where possible in the ten days.',
    description: 'Track fasting in the first ten days of Dhul-Hijjah.',
    category: GrowthHabitCategory.dailyWorship,
    pathIds: ['seasonal-dhul-hijjah'],
    recurrenceType: GrowthHabitRecurrenceType.weeklyTarget,
    weekdays: [1, 2, 3, 4, 5, 6, 7],
    frequencyTarget: 6,
    difficulty: 2,
    lightReward: 18,
    streakEligible: true,
    reminderEnabled: true,
    reminderMode: GrowthReminderMode.timeWindow,
    reminderWindowType: GrowthReminderWindowType.earlyMorning,
    reflectionPrompt: null,
    active: true,
    muted: false,
    hidden: false,
    entrustable: true,
    entrustToAllah: false,
    sortOrder: 5030,
    isCustom: false,
    stage: 2,
  ),
  GrowthHabit(
    id: 's_dhul_dhikr',
    title: 'Increase Dhikr',
    subtitle: 'Fill these days with remembrance.',
    description: 'Keep steady takbir, tahmid, and tahlil in these days.',
    category: GrowthHabitCategory.sunnahPractices,
    pathIds: ['seasonal-dhul-hijjah'],
    recurrenceType: GrowthHabitRecurrenceType.daily,
    weekdays: [1, 2, 3, 4, 5, 6, 7],
    frequencyTarget: 7,
    difficulty: 1,
    lightReward: 12,
    streakEligible: true,
    reminderEnabled: true,
    reminderMode: GrowthReminderMode.timeWindow,
    reminderWindowType: GrowthReminderWindowType.morning,
    reflectionPrompt: null,
    active: true,
    muted: false,
    hidden: false,
    entrustable: true,
    entrustToAllah: false,
    sortOrder: 5031,
    isCustom: false,
    stage: 2,
  ),
  GrowthHabit(
    id: 's_dhul_charity',
    title: 'Charity in Blessed Days',
    subtitle: 'Give during these ten days.',
    description: 'Offer charity with intention during these days.',
    category: GrowthHabitCategory.charityService,
    pathIds: ['seasonal-dhul-hijjah'],
    recurrenceType: GrowthHabitRecurrenceType.weeklyTarget,
    weekdays: [1, 2, 3, 4, 5, 6, 7],
    frequencyTarget: 3,
    difficulty: 2,
    lightReward: 14,
    streakEligible: true,
    reminderEnabled: false,
    reflectionPrompt: null,
    active: true,
    muted: false,
    hidden: false,
    entrustable: true,
    entrustToAllah: false,
    sortOrder: 5032,
    isCustom: false,
    stage: 2,
  ),
  GrowthHabit(
    id: 's_dhul_extra_prayer',
    title: 'Extra Salah',
    subtitle: 'Add voluntary salah in the ten days.',
    description: 'Protect one extra salah each day.',
    category: GrowthHabitCategory.sunnahPractices,
    pathIds: ['seasonal-dhul-hijjah'],
    recurrenceType: GrowthHabitRecurrenceType.daily,
    weekdays: [1, 2, 3, 4, 5, 6, 7],
    frequencyTarget: 7,
    difficulty: 2,
    lightReward: 14,
    streakEligible: true,
    reminderEnabled: false,
    reflectionPrompt: null,
    active: true,
    muted: false,
    hidden: false,
    entrustable: true,
    entrustToAllah: false,
    sortOrder: 5033,
    isCustom: false,
    stage: 2,
  ),
  GrowthHabit(
    id: 's_dhul_quran_reflection',
    title: 'Qur’an Reflection',
    subtitle: 'Reflect on one verse daily.',
    description: 'Take one verse and reflect in these blessed days.',
    category: GrowthHabitCategory.knowledge,
    pathIds: ['seasonal-dhul-hijjah'],
    recurrenceType: GrowthHabitRecurrenceType.daily,
    weekdays: [1, 2, 3, 4, 5, 6, 7],
    frequencyTarget: 7,
    difficulty: 1,
    lightReward: 10,
    streakEligible: true,
    reminderEnabled: true,
    reminderMode: GrowthReminderMode.timeWindow,
    reminderWindowType: GrowthReminderWindowType.evening,
    reflectionPrompt: 'What verse guided you today?',
    active: true,
    muted: false,
    hidden: false,
    entrustable: true,
    entrustToAllah: false,
    sortOrder: 5034,
    isCustom: false,
    stage: 2,
  ),
  GrowthHabit(
    id: 's_fast_optional_today',
    title: 'Optional Fast Today',
    subtitle: 'Track recommended voluntary fasting days.',
    description:
        'Use this for Monday/Thursday, white days, Arafah, Ashura, or custom fasts.',
    category: GrowthHabitCategory.healthDiscipline,
    pathIds: ['seasonal-fasting'],
    recurrenceType: GrowthHabitRecurrenceType.daily,
    weekdays: [1, 2, 3, 4, 5, 6, 7],
    frequencyTarget: 7,
    difficulty: 2,
    lightReward: 16,
    streakEligible: true,
    reminderEnabled: false,
    reflectionPrompt: 'How did fasting shape your day?',
    active: true,
    muted: false,
    hidden: false,
    entrustable: true,
    entrustToAllah: false,
    sortOrder: 5040,
    isCustom: false,
    stage: 1,
  ),
];

const seasonalJourneyCards = <GrowthSeasonalJourneyCard>[
  GrowthSeasonalJourneyCard(
    id: 'seasonal-ramadan',
    title: 'Ramadan Journey',
    subtitle: 'Fast, Qur’an, du’a, charity, and nightly reflection.',
    icon: '🌙',
    habitIds: [
      's_ramadan_fast_today',
      's_ramadan_quran',
      's_ramadan_taraweeh',
      's_ramadan_charity',
      's_ramadan_dua',
      's_ramadan_guard_speech',
      's_ramadan_night_reflection',
    ],
  ),
  GrowthSeasonalJourneyCard(
    id: 'seasonal-last10',
    title: 'Last 10 Nights',
    subtitle: 'Tahajjud, extended Qur’an, long du’a, charity, reflection.',
    icon: '✨',
    habitIds: [
      's_last10_tahajjud',
      's_last10_quran',
      's_last10_dua',
      's_last10_charity',
      's_last10_reflection',
    ],
  ),
  GrowthSeasonalJourneyCard(
    id: 'seasonal-friday',
    title: 'Friday Sunnah Routine',
    subtitle: 'Salawat, Al-Kahf, Jumuʿah, charity, and du’a before Maghrib.',
    icon: '🕌',
    habitIds: [
      's_friday_salawat',
      's_friday_kahf',
      's_friday_jumuah',
      's_friday_charity',
      's_friday_dua_maghrib',
    ],
  ),
  GrowthSeasonalJourneyCard(
    id: 'seasonal-dhul-hijjah',
    title: 'Dhul-Hijjah Journey',
    subtitle: 'The first ten days with fasting, dhikr, prayer, and reflection.',
    icon: '🕋',
    habitIds: [
      's_dhul_fast',
      's_dhul_dhikr',
      's_dhul_charity',
      's_dhul_extra_prayer',
      's_dhul_quran_reflection',
    ],
  ),
];
