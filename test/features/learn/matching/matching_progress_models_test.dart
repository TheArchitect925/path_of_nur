import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/learn/matching/domain/matching_models.dart';

void main() {
  test('progress state serializes and restores matched pairs', () {
    final state = MatchingProgressState(
      progressByPuzzleId: {
        'puzzle': const MatchingPuzzleProgress(
          matchedPairIds: {'adult_ihsan_excellence', 'adult_ikhlas_sincerity'},
          hiddenRightItemIds: {'adult_niyyah_intention'},
          revealedPairIds: {'adult_ihsan_excellence'},
          selectedLeftPairId: 'adult_ikhlas_sincerity',
          selectedRightPairId: 'adult_ikhlas_sincerity',
          startedAtIso: '2026-03-21T10:00:00.000',
        ),
      },
      dailyProgressByDateKey: {
        '2026-03-21': const MatchingDailyProgress(
          dateKey: '2026-03-21',
          puzzleId: 'puzzle',
          weekdayTheme: 'mixed',
          startedAtIso: '2026-03-21T10:00:00.000',
          completedAtIso: '2026-03-21T10:05:00.000',
        ),
      },
    );

    final restored = MatchingProgressState.fromJson(state.toJson());
    final puzzle = restored.progressFor('puzzle');

    expect(
      puzzle.matchedPairIds,
      containsAll(<String>['adult_ihsan_excellence', 'adult_ikhlas_sincerity']),
    );
    expect(puzzle.hiddenRightItemIds, contains('adult_niyyah_intention'));
    expect(puzzle.revealedPairIds, contains('adult_ihsan_excellence'));
    expect(restored.dailyProgressFor('2026-03-21')?.isCompleted, isTrue);
  });

  test('daily streak summary counts consecutive completions', () {
    final state = MatchingProgressState(
      progressByPuzzleId: const {},
      dailyProgressByDateKey: {
        '2026-03-19': const MatchingDailyProgress(
          dateKey: '2026-03-19',
          puzzleId: 'a',
          completedAtIso: '2026-03-19T10:00:00.000',
        ),
        '2026-03-20': const MatchingDailyProgress(
          dateKey: '2026-03-20',
          puzzleId: 'b',
          completedAtIso: '2026-03-20T10:00:00.000',
        ),
        '2026-03-21': const MatchingDailyProgress(
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
