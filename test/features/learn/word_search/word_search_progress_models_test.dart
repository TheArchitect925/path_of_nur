import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/learn/word_search/domain/word_search_models.dart';

void main() {
  test('progress state serializes and restores found words', () {
    final state = WordSearchProgressState(
      progressByPuzzleId: {
        'puzzle': const WordSearchPuzzleProgress(
          foundWordIds: {'adult_ihsan', 'adult_ikhlas'},
          highlightedWordIds: {'adult_ihsan'},
          revealedFirstLetterWordIds: {'adult_ikhlas'},
          recentSelectionCellKeys: ['0:0', '0:1'],
          selectedStartCellKey: '0:0',
          selectedEndCellKey: '0:1',
          startedAtIso: '2026-03-21T10:00:00.000',
        ),
      },
      dailyProgressByDateKey: {
        '2026-03-21': const WordSearchDailyProgress(
          dateKey: '2026-03-21',
          puzzleId: 'puzzle',
          weekdayTheme: 'mixed',
          startedAtIso: '2026-03-21T10:00:00.000',
          completedAtIso: '2026-03-21T10:05:00.000',
        ),
      },
    );

    final restored = WordSearchProgressState.fromJson(state.toJson());
    final puzzle = restored.progressFor('puzzle');

    expect(
      puzzle.foundWordIds,
      containsAll(<String>['adult_ihsan', 'adult_ikhlas']),
    );
    expect(puzzle.highlightedWordIds, contains('adult_ihsan'));
    expect(puzzle.revealedFirstLetterWordIds, contains('adult_ikhlas'));
    expect(restored.dailyProgressFor('2026-03-21')?.isCompleted, isTrue);
  });

  test('daily streak summary counts consecutive completions', () {
    final state = WordSearchProgressState(
      progressByPuzzleId: const {},
      dailyProgressByDateKey: {
        '2026-03-19': const WordSearchDailyProgress(
          dateKey: '2026-03-19',
          puzzleId: 'a',
          completedAtIso: '2026-03-19T10:00:00.000',
        ),
        '2026-03-20': const WordSearchDailyProgress(
          dateKey: '2026-03-20',
          puzzleId: 'b',
          completedAtIso: '2026-03-20T10:00:00.000',
        ),
        '2026-03-21': const WordSearchDailyProgress(
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
