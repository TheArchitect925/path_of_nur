import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/learn/crossword/application/crossword_game_adapter.dart';
import 'package:path_of_nur/features/learn/crossword/domain/crossword_models.dart';

void main() {
  group('CrosswordGameAdapter', () {
    const adapter = CrosswordGameAdapter();
    const puzzle = CrosswordPuzzle(
      id: 'p1',
      mode: CrosswordMode.adult,
      category: 'quran',
      difficulty: 32,
      gridSize: 5,
      clues: <CrosswordClue>[
        CrosswordClue(
          id: 'c1',
          entryId: 'e1',
          clue: 'A reflective Qur’an clue',
          answer: 'SABR',
          row: 0,
          col: 0,
          isAcross: true,
          category: 'quran',
          sourceType: 'quran',
          tags: <String>['quran', 'reflection'],
        ),
      ],
      solutionGrid: <List<String>>[
        <String>['S', 'A', 'B', 'R', ''],
        <String>['', '', '', '', ''],
        <String>['', '', '', '', ''],
        <String>['', '', '', '', ''],
        <String>['', '', '', '', ''],
      ],
      tags: <String>['quran', 'reflection'],
      levelBandMin: 25,
      levelBandMax: 50,
      clueType: CrosswordClueType.contextual,
      dailyThemes: <String>['quran'],
      isDailyEligible: true,
      layoutKey: 'classic',
    );

    test(
      'maps crossword puzzle and progress into shared game abstractions',
      () {
        const progress = CrosswordPuzzleProgress(
          puzzleId: 'p1',
          startedAtIso: '2026-03-21T10:00:00.000',
          completedAtIso: '2026-03-21T10:05:00.000',
          perfectCompletedAtIso: '2026-03-21T10:05:00.000',
          selectedCellKey: '0:0',
          selectedDirection: 'across',
          solvedClueIds: <String>{'c1'},
        );

        final game = adapter.toGame(puzzle);
        final session = adapter.createSession(game: puzzle, progress: progress);
        final result = adapter.evaluate(
          game: puzzle,
          progress: progress,
          xpEarned: 2,
          dropsEarned: 1,
        );

        expect(game.type, 'crossword');
        expect(game.category, 'quran');
        expect(session.gameId, 'p1');
        expect(session.isCompleted, isTrue);
        expect(session.state['selectedCellKey'], '0:0');
        expect(result.completed, isTrue);
        expect(result.perfect, isTrue);
        expect(result.xpEarned, 2);
        expect(result.dropsEarned, 1);
      },
    );
  });
}
