import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/learn/knowledge_games/content_expansion/application/content_expansion_repository.dart';
import 'package:path_of_nur/features/learn/knowledge_games/content_expansion/domain/content_expansion_models.dart';
import 'package:path_of_nur/features/learn/knowledge_games/domain/knowledge_game_variations.dart';

void main() {
  group('ContentExpansionRepository', () {
    final repository = ContentExpansionRepository();

    test('builds a non-empty normalized snapshot', () {
      final snapshot = repository.buildSnapshot();

      expect(snapshot.crossword, isNotEmpty);
      expect(snapshot.wordSearch, isNotEmpty);
      expect(snapshot.matching, isNotEmpty);
      expect(snapshot.ayahCompletion, isNotEmpty);
      expect(snapshot.hadithScenario, isNotEmpty);
      expect(snapshot.spiritualGrowth, isNotEmpty);
      expect(snapshot.packs, isNotEmpty);
      expect(snapshot.variationProfiles, isNotEmpty);
      expect(snapshot.allIds().toSet().length, snapshot.allIds().length);
    });

    test('validates the normalized snapshot without blocking errors', () {
      final report = repository.validateSnapshot();

      expect(report.hasErrors, isFalse);
    });

    test('exports a valid draft as normalized json', () {
      const draft = InternalBuilderDraft(
        type: ContentItemType.matching,
        id: 'draft_matching_sample',
        category: 'character',
        difficulty: 10,
        tags: <String>['kindness'],
        isDailyEligible: true,
        audience: ContentAudience.mixed,
        supportedVariations: <GameVariationType>[GameVariationType.standard],
        packIds: <String>['sample_pack'],
        payload: <String, Object?>{
          'pairIds': <String>['pair_one', 'pair_two'],
          'levelBandMin': 1,
          'levelBandMax': 10,
          'dailyThemes': <String>['mixed'],
        },
      );

      final json = repository.exportDraftAsJson(draft);

      expect(json, contains('"metadata"'));
      expect(json, contains('"payload"'));
      expect(json, contains('"draft_matching_sample"'));
    });
  });
}
