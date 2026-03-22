import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/learn/ayah_completion/domain/ayah_completion_models.dart';

void main() {
  test('progress state serializes and restores blank progress', () {
    final state = AyahCompletionProgressState(
      progressByPuzzleId: {
        'puzzle': const AyahCompletionPuzzleProgress(
          filledWordsByBlankIndex: {'0': 'الصَّمَدُ'},
          revealedBlankIndexes: {'0'},
          selectedBlankIndex: 0,
          startedAtIso: '2026-03-21T10:00:00.000',
        ),
      },
      dailyProgressByDateKey: {
        '2026-03-21': const AyahCompletionDailyProgress(
          dateKey: '2026-03-21',
          puzzleId: 'puzzle',
          weekdayTheme: 'memorization',
          startedAtIso: '2026-03-21T10:00:00.000',
          completedAtIso: '2026-03-21T10:05:00.000',
        ),
      },
    );

    final restored = AyahCompletionProgressState.fromJson(state.toJson());
    final puzzle = restored.progressFor('puzzle');

    expect(puzzle.filledWordsByBlankIndex['0'], 'الصَّمَدُ');
    expect(puzzle.revealedBlankIndexes, contains('0'));
    expect(restored.dailyProgressFor('2026-03-21')?.isCompleted, isTrue);
  });

  test('daily streak summary counts consecutive completions', () {
    final state = AyahCompletionProgressState(
      progressByPuzzleId: const {},
      dailyProgressByDateKey: {
        '2026-03-19': const AyahCompletionDailyProgress(
          dateKey: '2026-03-19',
          puzzleId: 'a',
          completedAtIso: '2026-03-19T10:00:00.000',
        ),
        '2026-03-20': const AyahCompletionDailyProgress(
          dateKey: '2026-03-20',
          puzzleId: 'b',
          completedAtIso: '2026-03-20T10:00:00.000',
        ),
        '2026-03-21': const AyahCompletionDailyProgress(
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
