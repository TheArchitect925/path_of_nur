import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
  if (level >= 3) return 'Deep';
  if (level == 2) return 'Steady';
  return 'Foundation';
}

String growthDateLabel(DateTime date) => DateFormat('EEE, MMM d').format(date);

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
  switch (status) {
    case GrowthHabitStatus.completed:
      return 'Completed';
    case GrowthHabitStatus.partial:
      return 'In progress';
    case GrowthHabitStatus.skipped:
      return 'Paused for today';
    case GrowthHabitStatus.snoozed:
      return 'Return later';
    case GrowthHabitStatus.deferred:
      return 'Carry forward';
    case null:
      return 'Due';
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
  switch (mood) {
    case GrowthMoodState.calm:
      return 'Calm';
    case GrowthMoodState.grateful:
      return 'Grateful';
    case GrowthMoodState.hopeful:
      return 'Hopeful';
    case GrowthMoodState.tired:
      return 'Tired';
    case GrowthMoodState.heavy:
      return 'Heavy';
  }
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
