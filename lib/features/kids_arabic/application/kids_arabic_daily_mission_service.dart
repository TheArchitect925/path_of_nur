import '../../../shared/persistence/local_store.dart';
import '../domain/kids_arabic_models.dart';
import 'kids_arabic_progression.dart';

const int kidsArabicDailyBonusXp = 2;
const int kidsArabicDailyBonusDrops = 1;
const int kidsArabicDailyGraceRechargeEveryActiveDays = 7;
const int kidsArabicDailyMaxGraceDays = 1;

class KidsArabicDailyMissionService {
  const KidsArabicDailyMissionService();

  KidsArabicDailyMission missionForDay({
    required DateTime now,
    required KidsArabicProgressState progressState,
  }) {
    final dayKey = LocalStore.todayKey(now);
    final existing = progressState.dailyMission;
    if (existing != null && existing.generatedForDate == dayKey) {
      return existing;
    }

    final completed = progressState.completedLetterIds;
    final unlocked = unlockedKidsArabicLetterIds(completed);

    for (final id in kidsArabicStarterReleaseOrderIds) {
      if (!unlocked.contains(id) || completed.contains(id)) continue;
      return KidsArabicDailyMission(
        id: '$dayKey:${KidsArabicDailyMissionType.newLetter.name}:$id',
        type: KidsArabicDailyMissionType.newLetter,
        targetLetterId: id,
        targetCount: 1,
        generatedForDate: dayKey,
        isCompleted: false,
      );
    }

    for (final letter in kidsArabicProgressionLetters) {
      if (!completed.contains(letter.id)) continue;
      if (!progressState.reviewNeededLetterIds.contains(letter.id)) continue;
      return KidsArabicDailyMission(
        id: '$dayKey:${KidsArabicDailyMissionType.review.name}:${letter.id}',
        type: KidsArabicDailyMissionType.review,
        targetLetterId: letter.id,
        targetCount: 1,
        generatedForDate: dayKey,
        isCompleted: false,
      );
    }

    final fallbackLetterId =
        _recentLearnedLetterId(progressState) ??
        kidsArabicStarterReleaseOrderIds.first;
    return KidsArabicDailyMission(
      id: '$dayKey:${KidsArabicDailyMissionType.tracePractice.name}:$fallbackLetterId',
      type: KidsArabicDailyMissionType.tracePractice,
      targetLetterId: fallbackLetterId,
      targetCount: 1,
      generatedForDate: dayKey,
      isCompleted: false,
    );
  }

  KidsArabicDailyProgress syncProgressForMissionDay({
    required KidsArabicDailyProgress current,
    required KidsArabicDailyMission mission,
  }) {
    final completedToday =
        current.todayMissionId == mission.id &&
        current.todayMissionCompleted &&
        current.completedOnDay(mission.generatedForDate);
    return current.copyWith(
      todayMissionId: mission.id,
      todayMissionCompleted: completedToday,
      weeklyCompletions: _countWeeklyCompletions(
        dayKey: mission.generatedForDate,
        completionDayKeys: current.completionDayKeys,
      ),
    );
  }

  KidsArabicDailyProgressUpdate completeMission({
    required KidsArabicDailyProgress current,
    required KidsArabicDailyMission mission,
    required DateTime now,
  }) {
    final dayKey = LocalStore.todayKey(now);
    if (mission.generatedForDate != dayKey) {
      return KidsArabicDailyProgressUpdate(
        progress: syncProgressForMissionDay(current: current, mission: mission),
        alreadyCompleted: false,
        graceUsed: false,
      );
    }
    if (current.todayMissionId == mission.id &&
        current.todayMissionCompleted &&
        current.completedOnDay(dayKey)) {
      return KidsArabicDailyProgressUpdate(
        progress: current,
        alreadyCompleted: true,
        graceUsed: false,
      );
    }

    final completionKeys = <String>{
      ...current.completionDayKeys,
      dayKey,
    }.toList(growable: false)..sort();
    final totalActiveDays = current.completionDayKeys.contains(dayKey)
        ? current.totalActiveDays
        : current.totalActiveDays + 1;
    final difference = _dayDifference(current.lastCompletedAt, dayKey);

    var nextGrace = current.graceDaysAvailable;
    var graceUsed = false;
    int nextStreak;
    if (difference == null) {
      nextStreak = 1;
    } else if (difference <= 0) {
      nextStreak = current.currentStreak == 0 ? 1 : current.currentStreak;
    } else if (difference == 1) {
      nextStreak = current.currentStreak + 1;
    } else if (difference == 2 && nextGrace > 0) {
      nextStreak = current.currentStreak + 1;
      nextGrace -= 1;
      graceUsed = true;
    } else {
      nextStreak = 1;
    }

    if (!graceUsed &&
        nextGrace < kidsArabicDailyMaxGraceDays &&
        totalActiveDays % kidsArabicDailyGraceRechargeEveryActiveDays == 0) {
      nextGrace = kidsArabicDailyMaxGraceDays;
    }

    final weekly = _countWeeklyCompletions(
      dayKey: dayKey,
      completionDayKeys: completionKeys,
    );
    return KidsArabicDailyProgressUpdate(
      progress: current.copyWith(
        lastCompletedAt: now.toIso8601String(),
        currentStreak: nextStreak,
        bestStreak: nextStreak > current.bestStreak
            ? nextStreak
            : current.bestStreak,
        totalActiveDays: totalActiveDays,
        weeklyCompletions: weekly,
        graceDaysAvailable: nextGrace,
        todayMissionId: mission.id,
        todayMissionCompleted: true,
        completionDayKeys: completionKeys,
      ),
      alreadyCompleted: false,
      graceUsed: graceUsed,
    );
  }

  String? _recentLearnedLetterId(KidsArabicProgressState progressState) {
    final lastLessonId = progressState.lastLessonLetterId;
    if (lastLessonId != null &&
        progressState.completedLetterIds.contains(lastLessonId)) {
      return lastLessonId;
    }

    KidsArabicLetterProgress? newest;
    for (final item in progressState.progressByLetterId.values) {
      if (item.lessonsCompleted <= 0) continue;
      if (newest == null) {
        newest = item;
        continue;
      }
      final currentDay = item.lastCompletedDayKey ?? '';
      final bestDay = newest.lastCompletedDayKey ?? '';
      if (currentDay.compareTo(bestDay) > 0) {
        newest = item;
      }
    }
    return newest?.letterId;
  }

  int _countWeeklyCompletions({
    required String dayKey,
    required List<String> completionDayKeys,
  }) {
    final anchor = DateTime.tryParse('${dayKey}T00:00:00');
    if (anchor == null) return 0;
    final uniqueKeys = completionDayKeys.toSet();
    return uniqueKeys.where((value) {
      final date = DateTime.tryParse('${value}T00:00:00');
      if (date == null) return false;
      final difference = anchor.difference(date).inDays;
      return difference >= 0 && difference < 7;
    }).length;
  }

  int? _dayDifference(String? lastCompletedAt, String currentDayKey) {
    if (lastCompletedAt == null || lastCompletedAt.isEmpty) return null;
    final last = DateTime.tryParse(lastCompletedAt);
    final current = DateTime.tryParse('${currentDayKey}T00:00:00');
    if (last == null || current == null) return null;
    final lastDay = DateTime(last.year, last.month, last.day);
    return current.difference(lastDay).inDays;
  }
}

class KidsArabicDailyProgressUpdate {
  const KidsArabicDailyProgressUpdate({
    required this.progress,
    required this.alreadyCompleted,
    required this.graceUsed,
  });

  final KidsArabicDailyProgress progress;
  final bool alreadyCompleted;
  final bool graceUsed;
}
