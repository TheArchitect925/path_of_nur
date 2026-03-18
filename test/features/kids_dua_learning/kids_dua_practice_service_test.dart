import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/kids_dua_learning/application/kids_dua_practice_service.dart';
import 'package:path_of_nur/features/kids_dua_learning/data/kids_dua_seed_data.dart';
import 'package:path_of_nur/features/kids_dua_learning/domain/kids_dua_models.dart';

void main() {
  const service = KidsDuaPracticeService();

  test('returns empty when fewer than two duas are unlocked', () {
    final state = KidsDuaLearningState(
      progressByLessonId: {
        'bismillah': const KidsDuaLessonProgress(
          lessonId: 'bismillah',
          openCount: 1,
          timesPracticed: 0,
          startedAtIso: '2026-03-18T10:00:00.000',
        ),
      },
      unlockedRewardIds: const {},
      stickerUnlockedAtById: const {},
      recentLessonIds: const ['bismillah'],
      totalFeatureXpAwarded: 0,
      totalFeatureDropsAwarded: 0,
      totalPracticeSessions: 0,
    );

    final questions = service.generateQuestions(
      lessons: kidsDuaStarterLessons,
      state: state,
      todaysDua: kidsDuaStarterLessons.first,
    );

    expect(questions, isEmpty);
  });

  test('builds all three question types when enough content is unlocked', () {
    final unlockedLessons = [
      kidsDuaStarterLessons.firstWhere((lesson) => lesson.id == 'bismillah'),
      kidsDuaStarterLessons.firstWhere(
        (lesson) => lesson.id == 'alhamdulillah-basic',
      ),
      kidsDuaStarterLessons.firstWhere((lesson) => lesson.id == 'before-sleep'),
      kidsDuaStarterLessons.firstWhere((lesson) => lesson.id == 'when-sad'),
      kidsDuaStarterLessons.firstWhere(
        (lesson) => lesson.id == 'saying-thanks',
      ),
    ];
    final state = KidsDuaLearningState(
      progressByLessonId: {
        for (final lesson in unlockedLessons)
          lesson.id: KidsDuaLessonProgress(
            lessonId: lesson.id,
            openCount: 1,
            timesPracticed: 0,
            startedAtIso: '2026-03-18T10:00:00.000',
          ),
      },
      unlockedRewardIds: const {},
      stickerUnlockedAtById: const {},
      recentLessonIds: unlockedLessons
          .map((lesson) => lesson.id)
          .toList(growable: false),
      totalFeatureXpAwarded: 0,
      totalFeatureDropsAwarded: 0,
      totalPracticeSessions: 0,
    );

    final questions = service.generateQuestions(
      lessons: kidsDuaStarterLessons,
      state: state,
      todaysDua: kidsDuaStarterLessons.first,
    );

    expect(questions, isNotEmpty);
    expect(
      questions.map((question) => question.type).toSet(),
      containsAll(<KidsDuaPracticeQuestionType>[
        KidsDuaPracticeQuestionType.matchSituation,
        KidsDuaPracticeQuestionType.meaning,
        KidsDuaPracticeQuestionType.behavior,
      ]),
    );
  });

  test('prioritizes today dua and recent unlocked content', () {
    final bismillah = kidsDuaStarterLessons.firstWhere(
      (lesson) => lesson.id == 'bismillah',
    );
    final state = KidsDuaLearningState(
      progressByLessonId: {
        'bismillah': const KidsDuaLessonProgress(
          lessonId: 'bismillah',
          openCount: 1,
          timesPracticed: 0,
          startedAtIso: '2026-03-18T10:00:00.000',
        ),
        'after-eating': const KidsDuaLessonProgress(
          lessonId: 'after-eating',
          openCount: 1,
          timesPracticed: 0,
          startedAtIso: '2026-03-18T10:00:00.000',
        ),
      },
      unlockedRewardIds: const {},
      stickerUnlockedAtById: const {},
      recentLessonIds: const ['after-eating'],
      totalFeatureXpAwarded: 0,
      totalFeatureDropsAwarded: 0,
      totalPracticeSessions: 0,
    );

    final questions = service.generateQuestions(
      lessons: kidsDuaStarterLessons,
      state: state,
      todaysDua: bismillah,
    );

    expect(questions, isNotEmpty);
    expect(questions.first.relatedDuaId, anyOf('bismillah', 'after-eating'));
    expect(
      questions.every(
        (question) => <String>{
          'bismillah',
          'after-eating',
        }.contains(question.relatedDuaId),
      ),
      isTrue,
    );
  });
}
