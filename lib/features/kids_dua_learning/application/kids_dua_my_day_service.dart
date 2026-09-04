import 'package:flutter/material.dart';

import '../domain/kids_dua_models.dart';

const kidsDuaMyDaySections = <KidsDuaDaySection>[
  KidsDuaDaySection(
    id: 'morning',
    titleKey: 'kidsDuaMyDayMorningTitle',
    icon: Icons.wb_sunny_rounded,
    duaIds: <String>['after-waking-up', 'rabbi-zidnee-ilma'],
    order: 1,
  ),
  KidsDuaDaySection(
    id: 'meals',
    titleKey: 'kidsDuaMyDayMealsTitle',
    icon: Icons.restaurant_rounded,
    duaIds: <String>['before-eating', 'after-eating'],
    order: 2,
  ),
  KidsDuaDaySection(
    id: 'going-out',
    titleKey: 'kidsDuaMyDayGoingOutTitle',
    icon: Icons.directions_walk_rounded,
    duaIds: <String>['leaving-home'],
    order: 3,
  ),
  KidsDuaDaySection(
    id: 'night',
    titleKey: 'kidsDuaMyDayNightTitle',
    icon: Icons.nightlight_round_rounded,
    duaIds: <String>['before-sleep', 'astaghfirullah'],
    order: 4,
  ),
];

class KidsDuaMyDayService {
  const KidsDuaMyDayService();

  List<KidsDuaDaySection> getSections() => kidsDuaMyDaySections;

  String todayKey(DateTime now) =>
      '${now.year.toString().padLeft(4, '0')}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

  DailyUsageState ensureToday({
    required DailyUsageState state,
    required DateTime now,
  }) {
    final key = todayKey(now);
    if (state.date == key) return state;
    return DailyUsageState.initial(key);
  }

  DailyUsageState completeDua({
    required DailyUsageState state,
    required String duaId,
  }) {
    final completedDuaIds = Set<String>.from(state.completedDuaIds)..add(duaId);
    final completedSectionIds = <String>{};
    for (final section in kidsDuaMyDaySections) {
      if (section.duaIds.every(completedDuaIds.contains)) {
        completedSectionIds.add(section.id);
      }
    }
    return state.copyWith(
      completedDuaIds: completedDuaIds,
      completedSectionIds: completedSectionIds,
      isDayComplete: completedSectionIds.length == kidsDuaMyDaySections.length,
    );
  }

  KidsDuaTimeBlock blockFor(DateTime now) {
    final hour = now.hour;
    if (hour >= 5 && hour < 10) return KidsDuaTimeBlock.earlyMorning;
    if (hour >= 10 && hour < 14) return KidsDuaTimeBlock.midday;
    if (hour >= 14 && hour < 18) return KidsDuaTimeBlock.afternoon;
    if (hour >= 18 && hour < 21) return KidsDuaTimeBlock.evening;
    return KidsDuaTimeBlock.night;
  }

  KidsDuaDaySection activeSectionForNow(DateTime now) {
    switch (blockFor(now)) {
      case KidsDuaTimeBlock.earlyMorning:
        return kidsDuaMyDaySections.first;
      case KidsDuaTimeBlock.midday:
        return kidsDuaMyDaySections[1];
      case KidsDuaTimeBlock.afternoon:
        return kidsDuaMyDaySections[2];
      case KidsDuaTimeBlock.evening:
      case KidsDuaTimeBlock.night:
        return kidsDuaMyDaySections[3];
    }
  }

  KidsDuaDaySection? nextIncompleteSection(DailyUsageState state) {
    for (final section in kidsDuaMyDaySections) {
      if (!state.completedSectionIds.contains(section.id)) return section;
    }
    return null;
  }

  KidsDuaLessonContent? firstLessonForSection({
    required KidsDuaDaySection section,
    required List<KidsDuaLessonContent> lessons,
    required DailyUsageState state,
  }) {
    for (final duaId in section.duaIds) {
      if (!state.completedDuaIds.contains(duaId)) {
        for (final lesson in lessons) {
          if (lesson.id == duaId) return lesson;
        }
      }
    }
    for (final duaId in section.duaIds) {
      for (final lesson in lessons) {
        if (lesson.id == duaId) return lesson;
      }
    }
    return null;
  }

  KidsDuaMyDayGuidance buildGuidance({
    required List<KidsDuaLessonContent> lessons,
    required KidsDuaLearningState progress,
    required DailyUsageState state,
    required DateTime now,
  }) {
    KidsDuaLessonContent? lessonById(String id) {
      for (final lesson in lessons) {
        if (lesson.id == id) return lesson;
      }
      return null;
    }

    KidsDuaDailyDuaState statusFor(String duaId) {
      if (!state.completedDuaIds.contains(duaId)) {
        final progressStatus = progress.progressByLessonId[duaId]?.status;
        if (progressStatus == null &&
            !progress.learnedLessonIds.contains(duaId)) {
          return KidsDuaDailyDuaState.notLearned;
        }
        if (progressStatus == KidsDuaLessonStatus.inProgress) {
          return KidsDuaDailyDuaState.inProgress;
        }
      }
      return KidsDuaDailyDuaState.learned;
    }

    final activeSection = activeSectionForNow(now);
    final orderedSections = <KidsDuaDaySection>[
      activeSection,
      ...kidsDuaMyDaySections.where(
        (section) => section.id != activeSection.id,
      ),
    ];

    KidsDuaLessonContent? rightNowLesson;
    KidsDuaDailyDuaState? rightNowState;
    for (final section in orderedSections) {
      final candidates =
          section.duaIds
              .map(lessonById)
              .whereType<KidsDuaLessonContent>()
              .toList(growable: false)
            ..sort((a, b) {
              int rank(String id) {
                if (!state.completedDuaIds.contains(id)) {
                  final progressStatus =
                      progress.progressByLessonId[id]?.status;
                  if (progressStatus == null &&
                      !progress.learnedLessonIds.contains(id)) {
                    return 0;
                  }
                  if (progressStatus == KidsDuaLessonStatus.inProgress) {
                    return 1;
                  }
                  if (progress.learnedLessonIds.contains(id)) {
                    return 2;
                  }
                }
                return 3;
              }

              final order = rank(a.id).compareTo(rank(b.id));
              if (order != 0) return order;
              return section.duaIds
                  .indexOf(a.id)
                  .compareTo(section.duaIds.indexOf(b.id));
            });
      if (candidates.isEmpty) continue;
      rightNowLesson = candidates.first;
      rightNowState = statusFor(candidates.first.id);
      break;
    }

    KidsDuaLessonContent? nextUpLesson;
    KidsDuaDaySection? nextUpSection;
    final journeyIds = kidsDuaMyDaySections
        .expand((section) => section.duaIds)
        .toList(growable: false);
    final currentIndex = rightNowLesson == null
        ? -1
        : journeyIds.indexOf(rightNowLesson.id);
    for (var i = currentIndex + 1; i < journeyIds.length; i += 1) {
      final candidate = lessonById(journeyIds[i]);
      if (candidate == null) continue;
      if (state.completedDuaIds.contains(candidate.id) &&
          progress.learnedLessonIds.contains(candidate.id)) {
        continue;
      }
      nextUpLesson = candidate;
      nextUpSection = kidsDuaMyDaySections.firstWhere(
        (section) => section.duaIds.contains(candidate.id),
      );
      break;
    }

    return KidsDuaMyDayGuidance(
      activeSection: activeSection,
      rightNowLesson: rightNowLesson,
      rightNowState: rightNowState,
      rightNowReasonKey: switch (activeSection.id) {
        'morning' => 'kidsDuaMyDayRightNowMorningReason',
        'meals' => 'kidsDuaMyDayRightNowMealsReason',
        'going-out' => 'kidsDuaMyDayRightNowGoingOutReason',
        _ => 'kidsDuaMyDayRightNowNightReason',
      },
      nextUpLesson: nextUpLesson,
      nextUpSection: nextUpSection,
    );
  }
}
