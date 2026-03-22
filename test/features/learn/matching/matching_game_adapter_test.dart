import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/learn/matching/application/matching_game_adapter.dart';
import 'package:path_of_nur/features/learn/matching/domain/matching_models.dart';

void main() {
  test('adapter maps matching puzzle into shared knowledge game models', () {
    const adapter = MatchingGameAdapter();
    const puzzle = MatchingPuzzle(
      id: 'matching_test',
      mode: MatchingMode.adult,
      category: 'quran',
      difficulty: 30,
      pairs: [
        MatchingPair(
          id: 'pair_1',
          leftItem: 'Taqwa',
          rightItem: 'God-consciousness',
          category: 'quran',
          difficulty: 30,
          tags: ['quran'],
          sourceType: 'quran',
          sourceReference: 'core:taqwa',
        ),
      ],
      tags: ['quran'],
      levelBandMin: 1,
      levelBandMax: 20,
      isDailyEligible: true,
      dailyThemes: ['quran'],
      packIds: ['pack'],
    );
    const progress = MatchingPuzzleProgress(
      matchedPairIds: {'pair_1'},
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

    expect(game.type, 'matching');
    expect(session.isCompleted, isTrue);
    expect(result.perfect, isTrue);
    expect(result.xpEarned, 2);
  });
}
