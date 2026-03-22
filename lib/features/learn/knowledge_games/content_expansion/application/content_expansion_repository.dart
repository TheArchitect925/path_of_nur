import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../journey/spiritual_growth/data/spiritual_growth_seed_data.dart';
import '../../../../journey/spiritual_growth/domain/spiritual_growth_models.dart';
import '../../../ayah_completion/data/ayah_completion_seed_data.dart';
import '../../../ayah_completion/domain/ayah_completion_models.dart';
import '../../../crossword/data/crossword_seed_data.dart';
import '../../../crossword/domain/crossword_models.dart';
import '../../../hadith_reflection/data/hadith_reflection_seed_data.dart';
import '../../../hadith_reflection/domain/hadith_reflection_models.dart';
import '../../../matching/data/matching_seed_data.dart';
import '../../../matching/domain/matching_models.dart';
import '../../../word_search/data/word_search_seed_data.dart';
import '../../../word_search/domain/word_search_models.dart';
import '../../domain/knowledge_game_variations.dart';
import '../domain/content_expansion_models.dart';
import 'content_expansion_validation.dart';

class ContentExpansionRepository {
  ContentExpansionRepository({ContentExpansionValidator? validator})
    : _validator = validator ?? ContentExpansionValidator();

  final ContentExpansionValidator _validator;

  ContentExpansionSnapshot buildSnapshot() {
    return ContentExpansionSnapshot(
      crossword: _crosswordContent(),
      wordSearch: _wordSearchContent(),
      matching: _matchingContent(),
      ayahCompletion: _ayahContent(),
      hadithScenario: _hadithContent(),
      spiritualGrowth: _spiritualGrowthContent(),
      packs: _packContent(),
      variationProfiles: _variationProfiles(),
    );
  }

  ContentValidationReport validateSnapshot() {
    return _validator.validateSnapshot(buildSnapshot());
  }

  ContentValidationReport validateDraft(InternalBuilderDraft draft) {
    return _validator.validateDraft(draft);
  }

  String exportDraftAsJson(InternalBuilderDraft draft) {
    final encoder = const JsonEncoder.withIndent('  ');
    return encoder.convert(<String, dynamic>{
      'metadata': draft.metadata.toJson(),
      'payload': draft.payload,
    });
  }

  Map<String, Object?> templatePayloadFor(ContentItemType type) {
    return switch (type) {
      ContentItemType.crossword => <String, Object?>{
        'gridSize': 5,
        'layoutKey': 'classic',
        'placements': <Map<String, Object?>>[
          <String, Object?>{
            'entryId': 'entry_id',
            'row': 0,
            'col': 0,
            'isAcross': true,
          },
        ],
        'levelBandMin': 1,
        'levelBandMax': 10,
        'clueType': 'direct',
        'dailyThemes': <String>['mixed'],
      },
      ContentItemType.wordSearch => <String, Object?>{
        'gridSize': 6,
        'entryIds': <String>['entry_one', 'entry_two'],
        'allowedDirections': <String>['right', 'down'],
        'levelBandMin': 1,
        'levelBandMax': 10,
        'dailyThemes': <String>['mixed'],
      },
      ContentItemType.matching => <String, Object?>{
        'pairIds': <String>['pair_one', 'pair_two'],
        'levelBandMin': 1,
        'levelBandMax': 10,
        'dailyThemes': <String>['mixed'],
      },
      ContentItemType.ayahCompletion => <String, Object?>{
        'surah': 1,
        'ayah': 2,
        'blankWordIndexes': <int>[1],
        'levelBandMin': 1,
        'levelBandMax': 10,
        'dailyThemes': <String>['memorization'],
      },
      ContentItemType.hadithScenario => <String, Object?>{
        'hadithId': 'hadith_id',
        'theme': 'kindness',
        'shortTeachingSummary': 'A short summary.',
        'reflectionPrompt': 'A reflective question.',
        'scenarioTitle': 'Scenario title',
        'scenarioDescription': 'Scenario description',
        'choices': <Map<String, Object?>>[
          <String, Object?>{
            'id': 'best_choice',
            'label': 'Best choice',
            'feedbackText': 'Feedback',
            'isBestChoice': true,
          },
          <String, Object?>{
            'id': 'acceptable_choice',
            'label': 'Acceptable choice',
            'feedbackText': 'Feedback',
            'isAcceptableChoice': true,
          },
        ],
        'levelBandMin': 1,
        'levelBandMax': 10,
        'dailyThemes': <String>['mixed'],
      },
      ContentItemType.spiritualGrowth => <String, Object?>{
        'subtype': 'intention',
        'theme': 'gratitude',
        'titleKey': 'localizationKeyTitle',
        'descriptionKey': 'localizationKeySubtitle',
        'actionType': 'learning',
        'xpValue': 0,
        'dropValue': 0,
        'isManual': false,
        'responseOptions': <Map<String, String>>[
          <String, String>{'id': 'option_one', 'labelKey': 'optionKeyOne'},
        ],
      },
      ContentItemType.pack => <String, Object?>{
        'contentType': 'crossword',
        'mode': 'adult',
        'titleKey': 'packTitleKey',
        'descriptionKey': 'packDescriptionKey',
        'contentIds': <String>['content_id'],
        'minDifficulty': 1,
        'maxDifficulty': 25,
        'isFeatured': true,
      },
      ContentItemType.variationProfile => <String, Object?>{
        'gameType': 'crossword',
        'defaultSettingsByVariation': <String, Map<String, Object?>>{
          'timed': <String, Object?>{'durationSeconds': 180},
        },
      },
    };
  }

  List<CrosswordContent> _crosswordContent() {
    final seeds = <CrosswordPuzzleSeed>[
      ...kidsCrosswordPuzzleSeeds,
      ...adultCrosswordPuzzleSeeds,
    ];
    return seeds
        .map(
          (seed) => CrosswordContent(
            metadata: ContentMetadata(
              id: seed.id,
              type: ContentItemType.crossword,
              category: seed.category,
              difficulty: seed.difficulty,
              tags: seed.tags,
              isDailyEligible: seed.isDailyEligible,
              supportedVariations: const <GameVariationType>[
                GameVariationType.timed,
                GameVariationType.noClue,
                GameVariationType.sequential,
              ],
              audience: seed.mode == CrosswordMode.kids
                  ? ContentAudience.kids
                  : ContentAudience.adult,
            ),
            gridSize: seed.gridSize,
            layoutKey: seed.layoutKey,
            placements: seed.placements
                .map(
                  (placement) => <String, Object?>{
                    'entryId': placement.entryId,
                    'row': placement.row,
                    'col': placement.col,
                    'isAcross': placement.isAcross,
                  },
                )
                .toList(growable: false),
            levelBandMin: seed.levelBandMin,
            levelBandMax: seed.levelBandMax,
            clueType: seed.clueType.name,
            dailyThemes: seed.dailyThemes,
          ),
        )
        .toList(growable: false);
  }

  List<WordSearchContent> _wordSearchContent() {
    return wordSearchPuzzleSeeds
        .map(
          (seed) => WordSearchContent(
            metadata: ContentMetadata(
              id: seed.id,
              type: ContentItemType.wordSearch,
              category: seed.category,
              difficulty: seed.difficulty,
              tags: seed.tags,
              isDailyEligible: seed.isDailyEligible,
              supportedVariations: const <GameVariationType>[
                GameVariationType.memory,
                GameVariationType.fog,
                GameVariationType.sequential,
              ],
              audience: seed.mode == WordSearchMode.kids
                  ? ContentAudience.kids
                  : ContentAudience.adult,
            ),
            gridSize: seed.gridSize,
            entryIds: seed.entryIds,
            allowedDirections: seed.allowedDirections
                .map((item) => item.name)
                .toList(growable: false),
            levelBandMin: seed.levelBandMin,
            levelBandMax: seed.levelBandMax,
            dailyThemes: seed.dailyThemes,
          ),
        )
        .toList(growable: false);
  }

  List<MatchingContent> _matchingContent() {
    return matchingPuzzleSeeds
        .map(
          (seed) => MatchingContent(
            metadata: ContentMetadata(
              id: seed.id,
              type: ContentItemType.matching,
              category: seed.category,
              difficulty: seed.difficulty,
              tags: seed.tags,
              isDailyEligible: seed.isDailyEligible,
              supportedVariations: const <GameVariationType>[
                GameVariationType.reverse,
                GameVariationType.memory,
                GameVariationType.timed,
              ],
              audience: seed.mode == MatchingMode.kids
                  ? ContentAudience.kids
                  : ContentAudience.adult,
            ),
            pairIds: seed.pairIds,
            levelBandMin: seed.levelBandMin,
            levelBandMax: seed.levelBandMax,
            dailyThemes: seed.dailyThemes,
          ),
        )
        .toList(growable: false);
  }

  List<AyahCompletionContent> _ayahContent() {
    return ayahCompletionPuzzleSeeds
        .map(
          (seed) => AyahCompletionContent(
            metadata: ContentMetadata(
              id: seed.id,
              type: ContentItemType.ayahCompletion,
              category: seed.category,
              difficulty: seed.difficulty,
              tags: seed.tags,
              isDailyEligible: seed.isDailyEligible,
              supportedVariations: const <GameVariationType>[
                GameVariationType.audio,
                GameVariationType.challenge,
                GameVariationType.sequential,
              ],
              audience: seed.mode == AyahCompletionMode.kids
                  ? ContentAudience.kids
                  : ContentAudience.adult,
              sourceType: 'quran',
              sourceReference: '${seed.ref.surah}:${seed.ref.ayah}',
            ),
            surah: seed.ref.surah,
            ayah: seed.ref.ayah,
            blankWordIndexes: seed.blankWordIndexes,
            levelBandMin: seed.levelBandMin,
            levelBandMax: seed.levelBandMax,
            dailyThemes: seed.dailyThemes,
          ),
        )
        .toList(growable: false);
  }

  List<HadithScenarioContent> _hadithContent() {
    return hadithReflectionScenarioSeeds
        .map(
          (seed) => HadithScenarioContent(
            metadata: ContentMetadata(
              id: seed.id,
              type: ContentItemType.hadithScenario,
              category: seed.category,
              difficulty: seed.difficulty,
              tags: seed.tags,
              isDailyEligible: seed.isDailyEligible,
              supportedVariations: const <GameVariationType>[
                GameVariationType.reflection,
                GameVariationType.challenge,
              ],
              audience: seed.mode == HadithReflectionMode.kids
                  ? ContentAudience.kids
                  : ContentAudience.adult,
              sourceType: 'hadith',
              sourceReference: seed.hadithId,
            ),
            hadithId: seed.hadithId,
            theme: seed.theme,
            shortTeachingSummary: seed.shortTeachingSummary,
            reflectionPrompt: seed.reflectionPrompt,
            scenarioTitle: seed.scenarioTitle,
            scenarioDescription: seed.scenarioDescription,
            choices: seed.choices
                .map(
                  (choice) => <String, Object?>{
                    'id': choice.id,
                    'label': choice.label,
                    'feedbackText': choice.feedbackText,
                    'rationale': choice.rationale,
                    'isBestChoice': choice.isBestChoice,
                    'isAcceptableChoice': choice.isAcceptableChoice,
                  },
                )
                .toList(growable: false),
            levelBandMin: seed.levelBandMin,
            levelBandMax: seed.levelBandMax,
            dailyThemes: seed.dailyThemes,
            followUpReflection: seed.followUpReflection,
            helpText: seed.helpText,
          ),
        )
        .toList(growable: false);
  }

  List<SpiritualGrowthContent> _spiritualGrowthContent() {
    return <SpiritualGrowthContent>[
      ...spiritualGrowthIntentions.map(_mapIntention),
      ...spiritualGrowthActions.map(_mapAction),
      ...spiritualGrowthReflectionPrompts.map(_mapPrompt),
    ];
  }

  SpiritualGrowthContent _mapIntention(DailyIntention item) {
    return SpiritualGrowthContent(
      metadata: ContentMetadata(
        id: item.id,
        type: ContentItemType.spiritualGrowth,
        category: item.theme,
        difficulty: item.difficulty,
        tags: item.tags,
        isDailyEligible: item.isDailyEligible,
        supportedVariations: const <GameVariationType>[
          GameVariationType.standard,
        ],
        audience: _growthAudience(item.audience),
      ),
      subtype: SpiritualGrowthContentSubtype.intention,
      theme: item.theme,
      titleKey: item.titleKey,
      descriptionKey: item.descriptionKey,
    );
  }

  SpiritualGrowthContent _mapAction(GrowthAction item) {
    return SpiritualGrowthContent(
      metadata: ContentMetadata(
        id: item.id,
        type: ContentItemType.spiritualGrowth,
        category: item.theme,
        difficulty: 1,
        tags: <String>[item.type, item.theme],
        isDailyEligible: false,
        supportedVariations: const <GameVariationType>[
          GameVariationType.standard,
        ],
        audience: ContentAudience.mixed,
      ),
      subtype: SpiritualGrowthContentSubtype.action,
      theme: item.theme,
      titleKey: item.titleKey,
      descriptionKey: item.descriptionKey,
      actionType: item.type,
      xpValue: item.xpValue,
      dropValue: item.dropValue,
      isManual: item.isManual,
    );
  }

  SpiritualGrowthContent _mapPrompt(SpiritualReflectionPrompt item) {
    return SpiritualGrowthContent(
      metadata: ContentMetadata(
        id: item.id,
        type: ContentItemType.spiritualGrowth,
        category: item.theme,
        difficulty: 1,
        tags: item.tags,
        isDailyEligible: true,
        supportedVariations: const <GameVariationType>[
          GameVariationType.reflection,
        ],
        audience: _growthAudience(item.audience),
      ),
      subtype: SpiritualGrowthContentSubtype.reflectionPrompt,
      theme: item.theme,
      titleKey: item.titleKey,
      descriptionKey: item.descriptionKey,
      responseOptions: item.responseOptions
          .map(
            (option) => <String, String>{
              'id': option.id,
              'labelKey': option.labelKey,
            },
          )
          .toList(growable: false),
    );
  }

  List<GamePackContent> _packContent() {
    return <GamePackContent>[
      ...wordSearchPuzzlePacks.map(
        (item) => GamePackContent(
          id: item.id,
          type: ContentItemType.wordSearch,
          mode: item.mode,
          category: item.category,
          titleKey: item.titleKey,
          descriptionKey: item.descriptionKey,
          contentIds: item.puzzleIds,
          tags: item.tags,
          minDifficulty: item.minDifficulty,
          maxDifficulty: item.maxDifficulty,
          isDailyEligible: item.isDailyEligible,
          isFeatured: item.isFeatured,
        ),
      ),
      ...matchingPuzzlePacks.map(
        (item) => GamePackContent(
          id: item.id,
          type: ContentItemType.matching,
          mode: item.mode,
          category: item.category,
          titleKey: item.titleKey,
          descriptionKey: item.descriptionKey,
          contentIds: item.puzzleIds,
          tags: item.tags,
          minDifficulty: item.minDifficulty,
          maxDifficulty: item.maxDifficulty,
          isDailyEligible: item.isDailyEligible,
          isFeatured: item.isFeatured,
        ),
      ),
      ...ayahCompletionPuzzlePacks.map(
        (item) => GamePackContent(
          id: item.id,
          type: ContentItemType.ayahCompletion,
          mode: item.mode,
          category: item.category,
          titleKey: item.titleKey,
          descriptionKey: item.descriptionKey,
          contentIds: item.puzzleIds,
          tags: item.tags,
          minDifficulty: item.minDifficulty,
          maxDifficulty: item.maxDifficulty,
          isDailyEligible: item.isDailyEligible,
          isFeatured: item.isFeatured,
        ),
      ),
      ...hadithReflectionPuzzlePacks.map(
        (item) => GamePackContent(
          id: item.id,
          type: ContentItemType.hadithScenario,
          mode: item.mode,
          category: item.category,
          titleKey: item.titleKey,
          descriptionKey: item.descriptionKey,
          contentIds: item.puzzleIds,
          tags: item.tags,
          minDifficulty: item.minDifficulty,
          maxDifficulty: item.maxDifficulty,
          isDailyEligible: item.isDailyEligible,
          isFeatured: item.isFeatured,
        ),
      ),
    ];
  }

  List<VariationProfileContent> _variationProfiles() {
    return const <VariationProfileContent>[
      VariationProfileContent(
        id: 'variation_profile_crossword',
        gameType: 'crossword',
        supportedVariations: <GameVariationType>[
          GameVariationType.timed,
          GameVariationType.noClue,
          GameVariationType.sequential,
        ],
        defaultSettingsByVariation: <String, Map<String, Object?>>{
          'timed': <String, Object?>{'durationSeconds': 240},
          'sequential': <String, Object?>{},
          'noClue': <String, Object?>{},
        },
      ),
      VariationProfileContent(
        id: 'variation_profile_word_search',
        gameType: 'word_search',
        supportedVariations: <GameVariationType>[
          GameVariationType.memory,
          GameVariationType.fog,
          GameVariationType.sequential,
        ],
        defaultSettingsByVariation: <String, Map<String, Object?>>{
          'memory': <String, Object?>{'revealDuration': 5},
          'fog': <String, Object?>{'visibilityRadius': 1},
          'sequential': <String, Object?>{},
        },
      ),
      VariationProfileContent(
        id: 'variation_profile_matching',
        gameType: 'matching',
        supportedVariations: <GameVariationType>[
          GameVariationType.reverse,
          GameVariationType.memory,
          GameVariationType.timed,
        ],
        defaultSettingsByVariation: <String, Map<String, Object?>>{
          'reverse': <String, Object?>{},
          'memory': <String, Object?>{'revealDuration': 5},
          'timed': <String, Object?>{'durationSeconds': 150},
        },
      ),
      VariationProfileContent(
        id: 'variation_profile_ayah_completion',
        gameType: 'ayah_completion',
        supportedVariations: <GameVariationType>[
          GameVariationType.audio,
          GameVariationType.challenge,
          GameVariationType.sequential,
        ],
        defaultSettingsByVariation: <String, Map<String, Object?>>{
          'audio': <String, Object?>{},
          'challenge': <String, Object?>{
            'hintDisabled': true,
            'maxMistakes': 1,
          },
          'sequential': <String, Object?>{},
        },
      ),
      VariationProfileContent(
        id: 'variation_profile_hadith_reflection',
        gameType: 'hadith_reflection',
        supportedVariations: <GameVariationType>[
          GameVariationType.reflection,
          GameVariationType.challenge,
        ],
        defaultSettingsByVariation: <String, Map<String, Object?>>{
          'reflection': <String, Object?>{},
          'challenge': <String, Object?>{
            'hintDisabled': true,
            'maxMistakes': 0,
          },
        },
      ),
    ];
  }

  ContentAudience _growthAudience(String audience) {
    return switch (audience) {
      'kids' => ContentAudience.kids,
      'adult' => ContentAudience.adult,
      _ => ContentAudience.mixed,
    };
  }
}

final contentExpansionRepositoryProvider = Provider<ContentExpansionRepository>(
  (_) => ContentExpansionRepository(),
);
