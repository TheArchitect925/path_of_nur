import 'package:flutter_test/flutter_test.dart';

import 'package:path_of_nur/features/kids_arabic/application/kids_arabic_daily_mission_service.dart';
import 'package:path_of_nur/features/kids_arabic/domain/kids_arabic_models.dart';

void main() {
  const service = KidsArabicDailyMissionService();

  test('mission generation prefers next unfinished starter letter first', () {
    final mission = service.missionForDay(
      now: DateTime(2026, 3, 18),
      progressState: KidsArabicProgressState.initial(),
    );

    expect(mission.type, KidsArabicDailyMissionType.newLetter);
    expect(mission.targetLetterId, 'alif');
  });

  test(
    'mission generation prefers review-needed learned letter before trace practice',
    () {
      final state = KidsArabicProgressState.initial().copyWith(
        progressByLetterId: <String, KidsArabicLetterProgress>{
          'alif': const KidsArabicLetterProgress(
            letterId: 'alif',
            lessonsCompleted: 1,
            correctReviews: 0,
            incorrectReviews: 1,
            lastCompletedDayKey: '2026-03-17',
          ),
          'ba': const KidsArabicLetterProgress(
            letterId: 'ba',
            lessonsCompleted: 1,
            correctReviews: 1,
            incorrectReviews: 0,
            lastCompletedDayKey: '2026-03-17',
          ),
          'meem': const KidsArabicLetterProgress(
            letterId: 'meem',
            lessonsCompleted: 1,
            correctReviews: 1,
            incorrectReviews: 0,
            lastCompletedDayKey: '2026-03-17',
          ),
          'noon': const KidsArabicLetterProgress(
            letterId: 'noon',
            lessonsCompleted: 1,
            correctReviews: 1,
            incorrectReviews: 0,
            lastCompletedDayKey: '2026-03-17',
          ),
          'seen': const KidsArabicLetterProgress(
            letterId: 'seen',
            lessonsCompleted: 1,
            correctReviews: 1,
            incorrectReviews: 0,
            lastCompletedDayKey: '2026-03-17',
          ),
        },
        reviewNeededLetterIds: <String>{'alif'},
        lastLessonLetterId: 'seen',
        lastLessonDayKey: '2026-03-17',
      );

      final mission = service.missionForDay(
        now: DateTime(2026, 3, 18),
        progressState: state,
      );

      expect(mission.type, KidsArabicDailyMissionType.review);
      expect(mission.targetLetterId, 'alif');
    },
  );

  test(
    'mission remains stable within the same day and changes on a new day',
    () {
      final state = KidsArabicProgressState.initial();
      final first = service.missionForDay(
        now: DateTime(2026, 3, 18, 9),
        progressState: state,
      );
      final sameDay = service.missionForDay(
        now: DateTime(2026, 3, 18, 20),
        progressState: state.copyWith(dailyMission: first),
      );
      final nextDay = service.missionForDay(
        now: DateTime(2026, 3, 19, 9),
        progressState: state.copyWith(dailyMission: first),
      );

      expect(sameDay.id, first.id);
      expect(nextDay.generatedForDate, isNot(first.generatedForDate));
    },
  );

  test('grace logic preserves streak across a one-day gap once', () {
    final mission = KidsArabicDailyMission(
      id: '2026-03-18:tracePractice:alif',
      type: KidsArabicDailyMissionType.tracePractice,
      targetLetterId: 'alif',
      targetCount: 1,
      generatedForDate: '2026-03-18',
      isCompleted: false,
    );
    final update = service.completeMission(
      current: const KidsArabicDailyProgress(
        lastCompletedAt: '2026-03-16T10:00:00.000',
        currentStreak: 4,
        bestStreak: 4,
        totalActiveDays: 4,
        weeklyCompletions: 4,
        graceDaysAvailable: 1,
        todayMissionId: null,
        todayMissionCompleted: false,
        completionDayKeys: <String>[
          '2026-03-13',
          '2026-03-14',
          '2026-03-15',
          '2026-03-16',
        ],
      ),
      mission: mission,
      now: DateTime(2026, 3, 18, 9),
    );

    expect(update.alreadyCompleted, isFalse);
    expect(update.graceUsed, isTrue);
    expect(update.progress.currentStreak, 5);
    expect(update.progress.graceDaysAvailable, 0);
  });
}
