import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/learn/ayah_completion/domain/ayah_completion_models.dart';
import 'package:path_of_nur/features/learn/crossword/domain/crossword_models.dart';
import 'package:path_of_nur/features/learn/hadith_reflection/domain/hadith_reflection_models.dart';
import 'package:path_of_nur/features/learn/knowledge_games/daily/application/daily_knowledge_challenge_hub_provider.dart';
import 'package:path_of_nur/features/learn/knowledge_games/daily/domain/daily_knowledge_challenge_models.dart';
import 'package:path_of_nur/features/learn/matching/domain/matching_models.dart';
import 'package:path_of_nur/features/learn/word_search/domain/word_search_models.dart';

void main() {
  group('DailyKnowledgeChallengeHubRepository', () {
    const repository = DailyKnowledgeChallengeHubRepository();

    test('builds a stable five-game bundle', () {
      final bundle = repository.buildBundle(
        dateKey: '2026-03-21',
        crossword: const KnowledgeGameRef(
          gameType: DailyKnowledgeGameType.crossword,
          puzzleId: 'cw',
          routeName: 'learnCrosswordDaily',
          category: 'quran',
          difficulty: 28,
        ),
        wordSearch: const KnowledgeGameRef(
          gameType: DailyKnowledgeGameType.wordSearch,
          puzzleId: 'ws',
          routeName: 'learnWordSearchDaily',
          category: 'hadith',
          difficulty: 32,
        ),
        matching: const KnowledgeGameRef(
          gameType: DailyKnowledgeGameType.matching,
          puzzleId: 'mt',
          routeName: 'learnMatchingDaily',
          category: 'prophets',
          difficulty: 30,
        ),
        ayahCompletion: const KnowledgeGameRef(
          gameType: DailyKnowledgeGameType.ayahCompletion,
          puzzleId: 'ac',
          routeName: 'learnAyahCompletionDaily',
          category: 'patience',
          difficulty: 34,
        ),
        hadithReflection: const KnowledgeGameRef(
          gameType: DailyKnowledgeGameType.hadithReflection,
          puzzleId: 'hr',
          routeName: 'learnHadithReflectionDaily',
          category: 'kindness',
          difficulty: 28,
        ),
        completedGameTypes: const {
          DailyKnowledgeGameType.crossword,
          DailyKnowledgeGameType.wordSearch,
        },
      );

      expect(bundle.dateKey, '2026-03-21');
      expect(bundle.games.length, 5);
      expect(bundle.completedCount, 2);
      expect(bundle.isCompleted, isFalse);
    });

    test('derives completed game types from per-game daily progress', () {
      final completed = repository.completedGameTypesForDate(
        dateKey: '2026-03-21',
        crossword: CrosswordProgressState(
          progressByPuzzleId: const {},
          dailyProgressByDateKey: {
            '2026-03-21': const CrosswordDailyProgress(
              dateKey: '2026-03-21',
              puzzleId: 'cw',
              completedAtIso: '2026-03-21T10:00:00.000',
            ),
          },
        ),
        wordSearch: WordSearchProgressState(
          progressByPuzzleId: const {},
          dailyProgressByDateKey: const {},
        ),
        matching: MatchingProgressState(
          progressByPuzzleId: const {},
          dailyProgressByDateKey: {
            '2026-03-21': const MatchingDailyProgress(
              dateKey: '2026-03-21',
              puzzleId: 'mt',
              completedAtIso: '2026-03-21T10:00:00.000',
            ),
          },
        ),
        ayahCompletion: AyahCompletionProgressState(
          progressByPuzzleId: const {},
          dailyProgressByDateKey: {
            '2026-03-21': const AyahCompletionDailyProgress(
              dateKey: '2026-03-21',
              puzzleId: 'ac',
              completedAtIso: '2026-03-21T10:00:00.000',
            ),
          },
        ),
        hadithReflection: HadithReflectionProgressState(
          progressByPuzzleId: const {},
          dailyProgressByDateKey: const {},
        ),
      );

      expect(
        completed,
        containsAll(<DailyKnowledgeGameType>[
          DailyKnowledgeGameType.crossword,
          DailyKnowledgeGameType.matching,
          DailyKnowledgeGameType.ayahCompletion,
        ]),
      );
      expect(completed, isNot(contains(DailyKnowledgeGameType.wordSearch)));
    });
  });
}
