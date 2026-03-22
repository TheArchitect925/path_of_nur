import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../adaptive/domain/user_learning_profile_models.dart';
import '../daily/domain/daily_knowledge_challenge_models.dart';
import '../domain/knowledge_game_variations.dart';

class KnowledgeGameVariationIssue {
  const KnowledgeGameVariationIssue({
    required this.code,
    required this.message,
  });

  final String code;
  final String message;
}

class KnowledgeGameVariationEngine {
  const KnowledgeGameVariationEngine();

  KnowledgeGameConfig resolveDailyConfig({
    required DailyKnowledgeGameType gameType,
    required String dateKey,
    required UserLearningProfile profile,
  }) {
    final seed = _seedFor(dateKey, gameType.name);
    final comfort = profile.comfortScore(_gameTypeKey(gameType));
    final prefersSupport =
        profile.supportGameType == _gameTypeKey(gameType) || comfort < 0.45;
    final prefersChallenge =
        profile.challengeGameType == _gameTypeKey(gameType) || comfort > 0.62;

    return switch (gameType) {
      DailyKnowledgeGameType.crossword => _resolveCrosswordConfig(
        seed: seed,
        prefersSupport: prefersSupport,
        prefersChallenge: prefersChallenge,
      ),
      DailyKnowledgeGameType.wordSearch => _resolveWordSearchConfig(
        seed: seed,
        prefersSupport: prefersSupport,
        prefersChallenge: prefersChallenge,
      ),
      DailyKnowledgeGameType.matching => _resolveMatchingConfig(
        seed: seed,
        prefersSupport: prefersSupport,
        prefersChallenge: prefersChallenge,
      ),
      DailyKnowledgeGameType.ayahCompletion => _resolveAyahConfig(
        seed: seed,
        prefersSupport: prefersSupport,
        prefersChallenge: prefersChallenge,
      ),
      DailyKnowledgeGameType.hadithReflection => _resolveHadithConfig(
        seed: seed,
        prefersSupport: prefersSupport,
        prefersChallenge: prefersChallenge,
      ),
    };
  }

  int completionBonusXp({
    required KnowledgeGameConfig config,
    required DateTime startedAt,
    required DateTime completedAt,
    required bool perfect,
    bool usedAnyHint = false,
  }) {
    if (config.isStandard) return 0;
    var bonus = 0;
    if (config.hasVariation(GameVariationType.timed)) {
      final durationSeconds = config.intSetting(
        'durationSeconds',
        fallback: 180,
      );
      final elapsedSeconds = completedAt.difference(startedAt).inSeconds;
      if (elapsedSeconds <= durationSeconds) {
        bonus += 1;
      }
    }
    if (config.hasVariation(GameVariationType.challenge) &&
        perfect &&
        !usedAnyHint) {
      bonus += 1;
    }
    return bonus;
  }

  List<KnowledgeGameVariationIssue> validateConfig(KnowledgeGameConfig config) {
    final issues = <KnowledgeGameVariationIssue>[];
    if (config.hasVariation(GameVariationType.standard) &&
        config.variations.length > 1) {
      issues.add(
        const KnowledgeGameVariationIssue(
          code: 'mixed_standard',
          message: 'Standard cannot be combined with other variations.',
        ),
      );
    }
    if (config.hasVariation(GameVariationType.timed) &&
        config.intSetting('durationSeconds') <= 0) {
      issues.add(
        const KnowledgeGameVariationIssue(
          code: 'timed_duration',
          message: 'Timed variation requires a positive duration.',
        ),
      );
    }
    if (config.hasVariation(GameVariationType.challenge) &&
        config.intSetting('maxMistakes') < 0) {
      issues.add(
        const KnowledgeGameVariationIssue(
          code: 'challenge_max_mistakes',
          message: 'Challenge max mistakes must be non-negative.',
        ),
      );
    }
    if (config.hasVariation(GameVariationType.fog) &&
        config.intSetting('visibilityRadius') <= 0) {
      issues.add(
        const KnowledgeGameVariationIssue(
          code: 'fog_visibility_radius',
          message: 'Fog mode requires a positive visibility radius.',
        ),
      );
    }
    return issues;
  }

  KnowledgeGameConfig _resolveCrosswordConfig({
    required int seed,
    required bool prefersSupport,
    required bool prefersChallenge,
  }) {
    if (prefersSupport) return const KnowledgeGameConfig.standard();
    switch (seed % 4) {
      case 0:
        return const KnowledgeGameConfig(
          variations: <GameVariationType>[GameVariationType.timed],
          variationSettings: <String, Object?>{'durationSeconds': 240},
        );
      case 1:
        return const KnowledgeGameConfig(
          variations: <GameVariationType>[GameVariationType.sequential],
        );
      case 2:
        if (prefersChallenge) {
          return const KnowledgeGameConfig(
            variations: <GameVariationType>[GameVariationType.noClue],
          );
        }
        return const KnowledgeGameConfig.standard();
      default:
        return const KnowledgeGameConfig.standard();
    }
  }

  KnowledgeGameConfig _resolveWordSearchConfig({
    required int seed,
    required bool prefersSupport,
    required bool prefersChallenge,
  }) {
    if (prefersSupport) {
      return const KnowledgeGameConfig(
        variations: <GameVariationType>[GameVariationType.memory],
        variationSettings: <String, Object?>{'revealDuration': 6},
      );
    }
    switch (seed % 4) {
      case 0:
        return const KnowledgeGameConfig(
          variations: <GameVariationType>[GameVariationType.sequential],
        );
      case 1:
        return const KnowledgeGameConfig(
          variations: <GameVariationType>[GameVariationType.memory],
          variationSettings: <String, Object?>{'revealDuration': 5},
        );
      case 2:
        if (prefersChallenge) {
          return const KnowledgeGameConfig(
            variations: <GameVariationType>[GameVariationType.fog],
            variationSettings: <String, Object?>{'visibilityRadius': 1},
          );
        }
        return const KnowledgeGameConfig.standard();
      default:
        return const KnowledgeGameConfig.standard();
    }
  }

  KnowledgeGameConfig _resolveMatchingConfig({
    required int seed,
    required bool prefersSupport,
    required bool prefersChallenge,
  }) {
    if (prefersSupport) {
      return const KnowledgeGameConfig(
        variations: <GameVariationType>[GameVariationType.memory],
        variationSettings: <String, Object?>{'revealDuration': 5},
      );
    }
    switch (seed % 4) {
      case 0:
        return const KnowledgeGameConfig(
          variations: <GameVariationType>[GameVariationType.reverse],
        );
      case 1:
        return const KnowledgeGameConfig(
          variations: <GameVariationType>[GameVariationType.timed],
          variationSettings: <String, Object?>{'durationSeconds': 150},
        );
      case 2:
        return prefersChallenge
            ? const KnowledgeGameConfig(
                variations: <GameVariationType>[GameVariationType.memory],
                variationSettings: <String, Object?>{'revealDuration': 4},
              )
            : const KnowledgeGameConfig.standard();
      default:
        return const KnowledgeGameConfig.standard();
    }
  }

  KnowledgeGameConfig _resolveAyahConfig({
    required int seed,
    required bool prefersSupport,
    required bool prefersChallenge,
  }) {
    if (prefersSupport) {
      return const KnowledgeGameConfig(
        variations: <GameVariationType>[GameVariationType.audio],
      );
    }
    switch (seed % 4) {
      case 0:
        return const KnowledgeGameConfig(
          variations: <GameVariationType>[GameVariationType.sequential],
        );
      case 1:
        return const KnowledgeGameConfig(
          variations: <GameVariationType>[GameVariationType.audio],
        );
      case 2:
        if (prefersChallenge) {
          return const KnowledgeGameConfig(
            variations: <GameVariationType>[GameVariationType.challenge],
            variationSettings: <String, Object?>{
              'hintDisabled': true,
              'maxMistakes': 1,
            },
          );
        }
        return const KnowledgeGameConfig.standard();
      default:
        return const KnowledgeGameConfig.standard();
    }
  }

  KnowledgeGameConfig _resolveHadithConfig({
    required int seed,
    required bool prefersSupport,
    required bool prefersChallenge,
  }) {
    if (prefersSupport) {
      return const KnowledgeGameConfig(
        variations: <GameVariationType>[GameVariationType.reflection],
      );
    }
    switch (seed % 3) {
      case 0:
        return const KnowledgeGameConfig(
          variations: <GameVariationType>[GameVariationType.reflection],
        );
      case 1:
        return prefersChallenge
            ? const KnowledgeGameConfig(
                variations: <GameVariationType>[GameVariationType.challenge],
                variationSettings: <String, Object?>{
                  'hintDisabled': true,
                  'maxMistakes': 0,
                },
              )
            : const KnowledgeGameConfig.standard();
      default:
        return const KnowledgeGameConfig.standard();
    }
  }

  int _seedFor(String dateKey, String gameType) {
    final input = '$dateKey:$gameType';
    var hash = 17;
    for (final codeUnit in input.codeUnits) {
      hash = 37 * hash + codeUnit;
    }
    return hash.abs();
  }

  String _gameTypeKey(DailyKnowledgeGameType gameType) {
    return switch (gameType) {
      DailyKnowledgeGameType.crossword => 'crossword',
      DailyKnowledgeGameType.wordSearch => 'word_search',
      DailyKnowledgeGameType.matching => 'matching',
      DailyKnowledgeGameType.ayahCompletion => 'ayah_completion',
      DailyKnowledgeGameType.hadithReflection => 'hadith_reflection',
    };
  }
}

final knowledgeGameVariationEngineProvider =
    Provider<KnowledgeGameVariationEngine>(
      (_) => const KnowledgeGameVariationEngine(),
    );
