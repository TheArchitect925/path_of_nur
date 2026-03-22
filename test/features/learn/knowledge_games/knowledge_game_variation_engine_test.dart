import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/learn/knowledge_games/adaptive/domain/user_learning_profile_models.dart';
import 'package:path_of_nur/features/learn/knowledge_games/application/knowledge_game_variation_engine.dart';
import 'package:path_of_nur/features/learn/knowledge_games/daily/domain/daily_knowledge_challenge_models.dart';
import 'package:path_of_nur/features/learn/knowledge_games/domain/knowledge_game_variations.dart';

void main() {
  group('KnowledgeGameVariationEngine', () {
    const engine = KnowledgeGameVariationEngine();

    test('daily variation resolution is deterministic for the same inputs', () {
      final profile = UserLearningProfile.initial().copyWith(
        difficultyComfort: const <String, double>{'crossword': 0.72},
        challengeGameType: 'crossword',
      );

      final first = engine.resolveDailyConfig(
        gameType: DailyKnowledgeGameType.crossword,
        dateKey: '2026-03-21',
        profile: profile,
      );
      final second = engine.resolveDailyConfig(
        gameType: DailyKnowledgeGameType.crossword,
        dateKey: '2026-03-21',
        profile: profile,
      );

      expect(first.toJson(), second.toJson());
    });

    test('support profile avoids harsher variations', () {
      final profile = UserLearningProfile.initial().copyWith(
        difficultyComfort: const <String, double>{'ayah_completion': 0.30},
        supportGameType: 'ayah_completion',
      );

      final config = engine.resolveDailyConfig(
        gameType: DailyKnowledgeGameType.ayahCompletion,
        dateKey: '2026-03-21',
        profile: profile,
      );

      expect(config.hasVariation(GameVariationType.audio), isTrue);
      expect(config.hasVariation(GameVariationType.challenge), isFalse);
    });

    test('timed and challenge bonuses are awarded conservatively', () {
      const config = KnowledgeGameConfig(
        variations: <GameVariationType>[
          GameVariationType.timed,
          GameVariationType.challenge,
        ],
        variationSettings: <String, Object?>{
          'durationSeconds': 120,
          'hintDisabled': true,
        },
      );

      final bonus = engine.completionBonusXp(
        config: config,
        startedAt: DateTime(2026, 3, 21, 10, 0, 0),
        completedAt: DateTime(2026, 3, 21, 10, 1, 30),
        perfect: true,
        usedAnyHint: false,
      );

      expect(bonus, 2);
    });
  });
}
