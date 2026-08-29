import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_surfaces.dart';
import '../../../../l10n/app_localizations.dart';
import '../../application/growth_models.dart';

String growthCategoryLabel(GrowthHabitCategory category) {
  final l10n = _growthL10n();
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
  final l10n = _growthL10n();
  switch (habit.recurrenceType) {
    case GrowthHabitRecurrenceType.daily:
      return l10n.growthRecurrenceDaily;
    case GrowthHabitRecurrenceType.weekdaysOnly:
      return l10n.growthRecurrenceWeekdays;
    case GrowthHabitRecurrenceType.customWeekdays:
      if (habit.weekdays.isEmpty) return l10n.growthRecurrenceSelectedWeekdays;
      return l10n.growthRecurrenceWeekdaysValue(
        habit.weekdays.map(_weekdayShort).join(', '),
      );
    case GrowthHabitRecurrenceType.weeklyTarget:
      return l10n.growthRecurrenceTimesPerWeek('${habit.frequencyTarget}');
    case GrowthHabitRecurrenceType.occasional:
      return l10n.growthRecurrenceOccasional;
    case GrowthHabitRecurrenceType.customFrequency:
      return l10n.growthRecurrenceEveryDays('${habit.customIntervalDays}');
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

BoxDecoration growthNoorPillDecoration(
  BuildContext context, {
  Color? tintColor,
  bool includeShadow = false,
}) {
  final style = AppSurfaceTheme.resolve(
    context,
    variant: AppSurfaceVariant.pill,
    tintColor: tintColor,
  );
  return style.decoration(radius: 999, includeShadow: includeShadow);
}

BoxDecoration growthNoorPanelDecoration(
  BuildContext context, {
  double radius = 12,
  Color? tintColor,
  bool includeShadow = false,
}) {
  final style = AppSurfaceTheme.resolve(
    context,
    variant: AppSurfaceVariant.panel,
    tintColor: tintColor,
  );
  return style.decoration(radius: radius, includeShadow: includeShadow);
}

Color growthNoorSubtleTextColor(BuildContext context) {
  return context.palette.onSurfaceSubtle;
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
  final l10n = _growthL10n();
  switch (weekday) {
    case DateTime.monday:
      return l10n.growthWeekdayMon;
    case DateTime.tuesday:
      return l10n.growthWeekdayTue;
    case DateTime.wednesday:
      return l10n.growthWeekdayWed;
    case DateTime.thursday:
      return l10n.growthWeekdayThu;
    case DateTime.friday:
      return l10n.growthWeekdayFri;
    case DateTime.saturday:
      return l10n.growthWeekdaySat;
    case DateTime.sunday:
      return l10n.growthWeekdaySun;
    default:
      return '-';
  }
}
