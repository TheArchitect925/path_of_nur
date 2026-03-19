import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../l10n/app_localizations.dart';
import '../../application/growth_models.dart';

String growthCategoryLabel(GrowthHabitCategory category) {
  switch (category) {
    case GrowthHabitCategory.dailyWorship:
      return 'Daily Worship';
    case GrowthHabitCategory.sunnahPractices:
      return 'Sunnah Practices';
    case GrowthHabitCategory.character:
      return 'Character';
    case GrowthHabitCategory.knowledge:
      return 'Knowledge';
    case GrowthHabitCategory.charityService:
      return 'Charity & Service';
    case GrowthHabitCategory.healthDiscipline:
      return 'Health & Discipline';
    case GrowthHabitCategory.reflectionGratitude:
      return 'Reflection & Gratitude';
  }
}

String growthDifficultyLabel(int level) {
  final l10n = _growthL10n();
  if (level >= 3) return l10n.growthDifficultyDeep;
  if (level == 2) return l10n.growthDifficultySteady;
  return l10n.growthDifficultyFoundation;
}

String growthDateLabel(DateTime date) => DateFormat('EEE, MMM d').format(date);

String growthDateLabelForLocale(DateTime date, String locale) =>
    DateFormat.MMMEd(locale).format(date);

String growthCategoryLocalizedLabel(
  GrowthHabitCategory category,
  AppLocalizations l10n,
) {
  switch (category) {
    case GrowthHabitCategory.dailyWorship:
      return l10n.growthCategoryDailyWorship;
    case GrowthHabitCategory.sunnahPractices:
      return l10n.growthCategorySunnahPractices;
    case GrowthHabitCategory.character:
      return l10n.growthCategoryCharacter;
    case GrowthHabitCategory.knowledge:
      return l10n.growthCategoryKnowledge;
    case GrowthHabitCategory.charityService:
      return l10n.growthCategoryCharityService;
    case GrowthHabitCategory.healthDiscipline:
      return l10n.growthCategoryHealthDiscipline;
    case GrowthHabitCategory.reflectionGratitude:
      return l10n.growthCategoryReflectionGratitude;
  }
}

IconData growthPathIcon(String icon) {
  switch (icon) {
    case 'spark':
      return Icons.auto_awesome_rounded;
    case 'sun':
      return Icons.wb_sunny_rounded;
    case 'heart':
      return Icons.favorite_outline_rounded;
    case 'mountain':
      return Icons.landscape_rounded;
    case 'book':
      return Icons.menu_book_rounded;
    case 'leaf':
      return Icons.spa_rounded;
    case 'crescent':
      return Icons.nightlight_round;
    case 'family':
      return Icons.family_restroom_rounded;
    default:
      return Icons.auto_awesome_rounded;
  }
}

String growthStatusLabel(GrowthHabitStatus? status) {
  final l10n = _growthL10n();
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
    case null:
      return l10n.growthStatusDue;
  }
}

String growthRecurrenceLabel(GrowthHabit habit) {
  switch (habit.recurrenceType) {
    case GrowthHabitRecurrenceType.daily:
      return 'Daily';
    case GrowthHabitRecurrenceType.weekdaysOnly:
      return 'Weekdays';
    case GrowthHabitRecurrenceType.customWeekdays:
      if (habit.weekdays.isEmpty) return 'Selected weekdays';
      return 'Weekdays: ${habit.weekdays.map(_weekdayShort).join(', ')}';
    case GrowthHabitRecurrenceType.weeklyTarget:
      return '${habit.frequencyTarget} times/week';
    case GrowthHabitRecurrenceType.occasional:
      return 'Occasional';
    case GrowthHabitRecurrenceType.customFrequency:
      return 'Every ${habit.customIntervalDays} day(s)';
  }
}

String growthMoodLabel(GrowthMoodState mood) {
  final l10n = _growthL10n();
  switch (mood) {
    case GrowthMoodState.calm:
      return l10n.growthMoodCalm;
    case GrowthMoodState.grateful:
      return l10n.growthMoodGrateful;
    case GrowthMoodState.hopeful:
      return l10n.growthMoodHopeful;
    case GrowthMoodState.tired:
      return l10n.growthMoodTired;
    case GrowthMoodState.heavy:
      return l10n.growthMoodHeavy;
  }
}

String growthMoodLocalizedLabel(GrowthMoodState mood, AppLocalizations l10n) {
  switch (mood) {
    case GrowthMoodState.calm:
      return l10n.growthMoodCalm;
    case GrowthMoodState.grateful:
      return l10n.growthMoodGrateful;
    case GrowthMoodState.hopeful:
      return l10n.growthMoodHopeful;
    case GrowthMoodState.tired:
      return l10n.growthMoodTired;
    case GrowthMoodState.heavy:
      return l10n.growthMoodHeavy;
  }
}

String growthStatusLocalizedLabel(
  GrowthHabitStatus? status,
  AppLocalizations l10n,
) {
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
    case null:
      return l10n.growthStatusDue;
  }
}

AppLocalizations _growthL10n() {
  final locale = Intl.getCurrentLocale().replaceAll('-', '_').split('_');
  return lookupAppLocalizations(
    Locale.fromSubtags(
      languageCode: locale.isNotEmpty && locale.first.isNotEmpty
          ? locale.first
          : 'en',
      countryCode: locale.length > 1 ? locale.last : null,
    ),
  );
}

String _weekdayShort(int weekday) {
  switch (weekday) {
    case DateTime.monday:
      return 'Mon';
    case DateTime.tuesday:
      return 'Tue';
    case DateTime.wednesday:
      return 'Wed';
    case DateTime.thursday:
      return 'Thu';
    case DateTime.friday:
      return 'Fri';
    case DateTime.saturday:
      return 'Sat';
    case DateTime.sunday:
      return 'Sun';
    default:
      return '-';
  }
}
