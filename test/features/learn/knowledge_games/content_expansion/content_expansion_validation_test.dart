import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/learn/knowledge_games/content_expansion/application/content_expansion_validation.dart';
import 'package:path_of_nur/features/learn/knowledge_games/content_expansion/domain/content_expansion_models.dart';
import 'package:path_of_nur/features/learn/knowledge_games/domain/knowledge_game_variations.dart';

void main() {
  group('ContentExpansionValidator', () {
    final validator = ContentExpansionValidator();

    test('flags invalid crossword draft data', () {
      const draft = InternalBuilderDraft(
        type: ContentItemType.crossword,
        id: '',
        category: '',
        difficulty: 0,
        tags: <String>[],
        isDailyEligible: false,
        audience: ContentAudience.mixed,
        supportedVariations: <GameVariationType>[GameVariationType.standard],
        payload: <String, Object?>{
          'gridSize': 2,
          'layoutKey': '',
          'placements': <Map<String, Object?>>[],
          'levelBandMin': 10,
          'levelBandMax': 1,
          'clueType': '',
          'dailyThemes': <String>[],
        },
      );

      final report = validator.validateDraft(draft);

      expect(report.hasErrors, isTrue);
      expect(report.issues.any((issue) => issue.scope == 'metadata'), isTrue);
    });

    test('accepts a valid variation profile draft', () {
      const draft = InternalBuilderDraft(
        type: ContentItemType.variationProfile,
        id: 'variation_profile_test',
        category: 'config',
        difficulty: 1,
        tags: <String>[],
        isDailyEligible: false,
        audience: ContentAudience.mixed,
        supportedVariations: <GameVariationType>[GameVariationType.timed],
        payload: <String, Object?>{
          'gameType': 'crossword',
          'defaultSettingsByVariation': <String, Map<String, Object?>>{
            'timed': <String, Object?>{'durationSeconds': 120},
          },
        },
      );

      final report = validator.validateDraft(draft);

      expect(report.hasErrors, isFalse);
    });
  });
}
