import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/learn/word_search/application/word_search_game_adapter.dart';
import 'package:path_of_nur/features/learn/word_search/domain/word_search_models.dart';

void main() {
  test(
    'adapter maps puzzle and progress into shared knowledge game models',
    () {
      const adapter = WordSearchGameAdapter();
      const puzzle = WordSearchPuzzle(
        id: 'ws_test',
        mode: WordSearchMode.adult,
        category: 'quran',
        difficulty: 30,
        gridSize: 7,
        entryIds: ['adult_huda'],
        targetWords: ['HUDA'],
        letterGrid: [
          ['H', 'U', 'D', 'A', 'A', 'A', 'A'],
          ['A', 'A', 'A', 'A', 'A', 'A', 'A'],
          ['A', 'A', 'A', 'A', 'A', 'A', 'A'],
          ['A', 'A', 'A', 'A', 'A', 'A', 'A'],
          ['A', 'A', 'A', 'A', 'A', 'A', 'A'],
          ['A', 'A', 'A', 'A', 'A', 'A', 'A'],
          ['A', 'A', 'A', 'A', 'A', 'A', 'A'],
        ],
        placements: [
          WordSearchPlacement(
            entryId: 'adult_huda',
            word: 'HUDA',
            startRow: 0,
            startCol: 0,
            endRow: 0,
            endCol: 3,
            direction: WordSearchDirection.right,
          ),
        ],
        tags: ['quran'],
        levelBandMin: 1,
        levelBandMax: 20,
        isDailyEligible: true,
        dailyThemes: ['quran'],
        packIds: ['pack'],
      );
      const progress = WordSearchPuzzleProgress(
        foundWordIds: {'adult_huda'},
        startedAtIso: '2026-03-21T10:00:00.000',
        completedAtIso: '2026-03-21T10:05:00.000',
        perfectCompletedAtIso: '2026-03-21T10:05:00.000',
      );

      final game = adapter.toGame(puzzle);
      final session = adapter.createSession(game: puzzle, progress: progress);
      final result = adapter.evaluate(
        game: puzzle,
        progress: progress,
        xpEarned: 2,
        dropsEarned: 1,
      );

      expect(game.type, 'word_search');
      expect(session.isCompleted, isTrue);
      expect(result.perfect, isTrue);
      expect(result.xpEarned, 2);
    },
  );
}
