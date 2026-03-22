import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/learn/hadith_reflection/domain/hadith_reflection_models.dart';

void main() {
  test('progress state serializes and restores selected choice data', () {
    final state = HadithReflectionProgressState(
      progressByPuzzleId: {
        'puzzle': const HadithReflectionPuzzleProgress(
          selectedChoiceId: 'choice_best',
          feedbackViewed: true,
          helpViewed: true,
          startedAtIso: '2026-03-21T10:00:00.000',
          completedAtIso: '2026-03-21T10:05:00.000',
          bestChoiceCompletedAtIso: '2026-03-21T10:05:00.000',
        ),
      },
      dailyProgressByDateKey: {
        '2026-03-21': const HadithReflectionDailyProgress(
          dateKey: '2026-03-21',
          puzzleId: 'puzzle',
          weekdayTheme: 'mixed',
          startedAtIso: '2026-03-21T10:00:00.000',
          completedAtIso: '2026-03-21T10:05:00.000',
        ),
      },
    );

    final restored = HadithReflectionProgressState.fromJson(state.toJson());
    final puzzle = restored.progressFor('puzzle');

    expect(puzzle.selectedChoiceId, 'choice_best');
    expect(puzzle.feedbackViewed, isTrue);
    expect(puzzle.helpViewed, isTrue);
    expect(restored.dailyProgressFor('2026-03-21')?.isCompleted, isTrue);
  });

  test('daily streak summary counts consecutive completions', () {
    final state = HadithReflectionProgressState(
      progressByPuzzleId: const {},
      dailyProgressByDateKey: {
        '2026-03-19': const HadithReflectionDailyProgress(
          dateKey: '2026-03-19',
          puzzleId: 'a',
          completedAtIso: '2026-03-19T10:00:00.000',
        ),
        '2026-03-20': const HadithReflectionDailyProgress(
          dateKey: '2026-03-20',
          puzzleId: 'b',
          completedAtIso: '2026-03-20T10:00:00.000',
        ),
        '2026-03-21': const HadithReflectionDailyProgress(
          dateKey: '2026-03-21',
          puzzleId: 'c',
          completedAtIso: '2026-03-21T10:00:00.000',
        ),
      },
    );

    final summary = state.dailyStreakSummary(DateTime(2026, 3, 21));
    expect(summary.currentStreak, 3);
    expect(summary.longestStreak, 3);
  });
}
