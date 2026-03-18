import 'package:flutter_test/flutter_test.dart';

import 'package:path_of_nur/features/kids_dua_learning/application/kids_dua_my_day_practice_service.dart';
import 'package:path_of_nur/features/kids_dua_learning/data/kids_dua_seed_data.dart';
import 'package:path_of_nur/features/kids_dua_learning/domain/kids_dua_models.dart';

void main() {
  test('questionAfterLesson uses linked behavior scenario when available', () {
    final service = const KidsDuaMyDayPracticeService();
    final lesson = kidsDuaStarterLessons.firstWhere(
      (item) => item.id == 'before-sleep',
    );
    final question = service.questionAfterLesson(
      lesson: lesson,
      lessons: kidsDuaStarterLessons,
      state: const KidsDuaLearningState(
        progressByLessonId: <String, KidsDuaLessonProgress>{
          'before-sleep': KidsDuaLessonProgress(
            lessonId: 'before-sleep',
            openCount: 1,
            timesPracticed: 0,
            startedAtIso: '2026-03-18T20:00:00',
          ),
          'after-waking-up': KidsDuaLessonProgress(
            lessonId: 'after-waking-up',
            openCount: 1,
            timesPracticed: 0,
            startedAtIso: '2026-03-18T07:00:00',
          ),
        },
        recentLessonIds: <String>['before-sleep'],
        unlockedRewardIds: <String>{},
        stickerUnlockedAtById: <String, String>{},
        totalPracticeSessions: 0,
        totalFeatureXpAwarded: 0,
        totalFeatureDropsAwarded: 0,
      ),
    );

    expect(question, isNotNull);
    expect(question!.type, KidsDuaPracticeQuestionType.behavior);
    expect(question.relatedDuaId, 'before-sleep');
  });

  test(
    'recapQuestionsForDay returns 2-3 mixed questions from completed day',
    () {
      final service = const KidsDuaMyDayPracticeService();
      final questions = service.recapQuestionsForDay(
        completedDuaIds: const {
          'after-waking-up',
          'rabbi-zidnee-ilma',
          'before-eating',
        },
        lessons: kidsDuaStarterLessons,
        state: KidsDuaLearningState.initial().copyWith(
          progressByLessonId: {
            for (final lesson in kidsDuaStarterLessons.take(5))
              lesson.id: KidsDuaLessonProgress(
                lessonId: lesson.id,
                openCount: 1,
                timesPracticed: 0,
                startedAtIso: '2026-03-18T09:00:00',
              ),
          },
        ),
      );

      expect(questions.length, inInclusiveRange(2, 3));
      expect(
        questions.any(
          (item) => item.type == KidsDuaPracticeQuestionType.behavior,
        ),
        isTrue,
      );
    },
  );
}
