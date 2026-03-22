import '../../application/knowledge_game_variation_engine.dart';
import '../../domain/knowledge_game_variations.dart';
import '../domain/content_expansion_models.dart';

enum ContentValidationSeverity { warning, error }

class ContentValidationIssue {
  const ContentValidationIssue({
    required this.severity,
    required this.scope,
    required this.message,
  });

  final ContentValidationSeverity severity;
  final String scope;
  final String message;
}

class ContentValidationReport {
  const ContentValidationReport(this.issues);

  final List<ContentValidationIssue> issues;

  bool get hasErrors =>
      issues.any((item) => item.severity == ContentValidationSeverity.error);
}

class ContentExpansionValidator {
  ContentExpansionValidator({KnowledgeGameVariationEngine? variationEngine})
    : _variationEngine =
          variationEngine ?? const KnowledgeGameVariationEngine();

  final KnowledgeGameVariationEngine _variationEngine;

  ContentValidationReport validateSnapshot(ContentExpansionSnapshot snapshot) {
    final issues = <ContentValidationIssue>[];
    final seenIds = <String>{};
    for (final id in snapshot.allIds()) {
      if (!seenIds.add(id)) {
        issues.add(
          ContentValidationIssue(
            severity: ContentValidationSeverity.error,
            scope: 'snapshot',
            message: 'Duplicate content id "$id".',
          ),
        );
      }
    }
    for (final item in snapshot.crossword) {
      issues.addAll(validateCrossword(item));
    }
    for (final item in snapshot.wordSearch) {
      issues.addAll(validateWordSearch(item));
    }
    for (final item in snapshot.matching) {
      issues.addAll(validateMatching(item));
    }
    for (final item in snapshot.ayahCompletion) {
      issues.addAll(validateAyahCompletion(item));
    }
    for (final item in snapshot.hadithScenario) {
      issues.addAll(validateHadithScenario(item));
    }
    for (final item in snapshot.spiritualGrowth) {
      issues.addAll(validateSpiritualGrowth(item));
    }
    for (final item in snapshot.packs) {
      issues.addAll(validatePack(item, snapshot));
    }
    for (final item in snapshot.variationProfiles) {
      issues.addAll(validateVariationProfile(item));
    }
    return ContentValidationReport(issues);
  }

  ContentValidationReport validateDraft(InternalBuilderDraft draft) {
    final issues = <ContentValidationIssue>[
      ..._validateMetadata(draft.metadata),
    ];
    switch (draft.type) {
      case ContentItemType.crossword:
        issues.addAll(
          validateCrossword(
            CrosswordContent(
              metadata: draft.metadata,
              gridSize: (draft.payload['gridSize'] as num?)?.toInt() ?? 0,
              layoutKey: draft.payload['layoutKey']?.toString() ?? '',
              placements:
                  (draft.payload['placements'] as List<dynamic>? ?? const [])
                      .map((item) => Map<String, Object?>.from(item as Map))
                      .toList(growable: false),
              levelBandMin:
                  (draft.payload['levelBandMin'] as num?)?.toInt() ?? 0,
              levelBandMax:
                  (draft.payload['levelBandMax'] as num?)?.toInt() ?? 0,
              clueType: draft.payload['clueType']?.toString() ?? '',
              dailyThemes:
                  (draft.payload['dailyThemes'] as List<dynamic>? ?? const [])
                      .map((item) => item.toString())
                      .toList(growable: false),
            ),
          ),
        );
      case ContentItemType.wordSearch:
        issues.addAll(
          validateWordSearch(
            WordSearchContent(
              metadata: draft.metadata,
              gridSize: (draft.payload['gridSize'] as num?)?.toInt() ?? 0,
              entryIds:
                  (draft.payload['entryIds'] as List<dynamic>? ?? const [])
                      .map((item) => item.toString())
                      .toList(growable: false),
              allowedDirections:
                  (draft.payload['allowedDirections'] as List<dynamic>? ??
                          const [])
                      .map((item) => item.toString())
                      .toList(growable: false),
              levelBandMin:
                  (draft.payload['levelBandMin'] as num?)?.toInt() ?? 0,
              levelBandMax:
                  (draft.payload['levelBandMax'] as num?)?.toInt() ?? 0,
              dailyThemes:
                  (draft.payload['dailyThemes'] as List<dynamic>? ?? const [])
                      .map((item) => item.toString())
                      .toList(growable: false),
            ),
          ),
        );
      case ContentItemType.matching:
        issues.addAll(
          validateMatching(
            MatchingContent(
              metadata: draft.metadata,
              pairIds: (draft.payload['pairIds'] as List<dynamic>? ?? const [])
                  .map((item) => item.toString())
                  .toList(growable: false),
              levelBandMin:
                  (draft.payload['levelBandMin'] as num?)?.toInt() ?? 0,
              levelBandMax:
                  (draft.payload['levelBandMax'] as num?)?.toInt() ?? 0,
              dailyThemes:
                  (draft.payload['dailyThemes'] as List<dynamic>? ?? const [])
                      .map((item) => item.toString())
                      .toList(growable: false),
            ),
          ),
        );
      case ContentItemType.ayahCompletion:
        issues.addAll(
          validateAyahCompletion(
            AyahCompletionContent(
              metadata: draft.metadata,
              surah: (draft.payload['surah'] as num?)?.toInt() ?? 0,
              ayah: (draft.payload['ayah'] as num?)?.toInt() ?? 0,
              blankWordIndexes:
                  (draft.payload['blankWordIndexes'] as List<dynamic>? ??
                          const [])
                      .map((item) => (item as num).toInt())
                      .toList(growable: false),
              levelBandMin:
                  (draft.payload['levelBandMin'] as num?)?.toInt() ?? 0,
              levelBandMax:
                  (draft.payload['levelBandMax'] as num?)?.toInt() ?? 0,
              dailyThemes:
                  (draft.payload['dailyThemes'] as List<dynamic>? ?? const [])
                      .map((item) => item.toString())
                      .toList(growable: false),
            ),
          ),
        );
      case ContentItemType.hadithScenario:
        issues.addAll(
          validateHadithScenario(
            HadithScenarioContent(
              metadata: draft.metadata,
              hadithId: draft.payload['hadithId']?.toString() ?? '',
              theme: draft.payload['theme']?.toString() ?? '',
              shortTeachingSummary:
                  draft.payload['shortTeachingSummary']?.toString() ?? '',
              reflectionPrompt:
                  draft.payload['reflectionPrompt']?.toString() ?? '',
              scenarioTitle: draft.payload['scenarioTitle']?.toString() ?? '',
              scenarioDescription:
                  draft.payload['scenarioDescription']?.toString() ?? '',
              choices: (draft.payload['choices'] as List<dynamic>? ?? const [])
                  .map((item) => Map<String, Object?>.from(item as Map))
                  .toList(growable: false),
              levelBandMin:
                  (draft.payload['levelBandMin'] as num?)?.toInt() ?? 0,
              levelBandMax:
                  (draft.payload['levelBandMax'] as num?)?.toInt() ?? 0,
              dailyThemes:
                  (draft.payload['dailyThemes'] as List<dynamic>? ?? const [])
                      .map((item) => item.toString())
                      .toList(growable: false),
              followUpReflection: draft.payload['followUpReflection']
                  ?.toString(),
              helpText: draft.payload['helpText']?.toString(),
            ),
          ),
        );
      case ContentItemType.spiritualGrowth:
        issues.addAll(
          validateSpiritualGrowth(
            SpiritualGrowthContent(
              metadata: draft.metadata,
              subtype: SpiritualGrowthContentSubtype.values.firstWhere(
                (item) => item.name == draft.payload['subtype']?.toString(),
                orElse: () => SpiritualGrowthContentSubtype.intention,
              ),
              theme: draft.payload['theme']?.toString() ?? '',
              titleKey: draft.payload['titleKey']?.toString() ?? '',
              descriptionKey: draft.payload['descriptionKey']?.toString() ?? '',
              actionType: draft.payload['actionType']?.toString(),
              xpValue: (draft.payload['xpValue'] as num?)?.toInt(),
              dropValue: (draft.payload['dropValue'] as num?)?.toInt(),
              isManual: draft.payload['isManual'] as bool?,
              responseOptions:
                  (draft.payload['responseOptions'] as List<dynamic>? ??
                          const [])
                      .map((item) => Map<String, String>.from(item as Map))
                      .toList(growable: false),
            ),
          ),
        );
      case ContentItemType.pack:
        issues.addAll(
          validatePack(
            GamePackContent(
              id: draft.id,
              type: ContentItemType.values.firstWhere(
                (item) => item.name == draft.payload['contentType']?.toString(),
                orElse: () => ContentItemType.crossword,
              ),
              mode: draft.payload['mode']?.toString() ?? '',
              category: draft.category,
              titleKey: draft.payload['titleKey']?.toString() ?? '',
              descriptionKey: draft.payload['descriptionKey']?.toString() ?? '',
              contentIds:
                  (draft.payload['contentIds'] as List<dynamic>? ?? const [])
                      .map((item) => item.toString())
                      .toList(growable: false),
              tags: draft.tags,
              minDifficulty:
                  (draft.payload['minDifficulty'] as num?)?.toInt() ?? 0,
              maxDifficulty:
                  (draft.payload['maxDifficulty'] as num?)?.toInt() ?? 0,
              isDailyEligible: draft.isDailyEligible,
              isFeatured: draft.payload['isFeatured'] == true,
            ),
            const ContentExpansionSnapshot(
              crossword: <CrosswordContent>[],
              wordSearch: <WordSearchContent>[],
              matching: <MatchingContent>[],
              ayahCompletion: <AyahCompletionContent>[],
              hadithScenario: <HadithScenarioContent>[],
              spiritualGrowth: <SpiritualGrowthContent>[],
              packs: <GamePackContent>[],
              variationProfiles: <VariationProfileContent>[],
            ),
          ),
        );
      case ContentItemType.variationProfile:
        issues.addAll(
          validateVariationProfile(
            VariationProfileContent(
              id: draft.id,
              gameType: draft.payload['gameType']?.toString() ?? '',
              supportedVariations: draft.supportedVariations,
              defaultSettingsByVariation:
                  (draft.payload['defaultSettingsByVariation'] as Map?)?.map(
                    (key, value) => MapEntry(
                      key.toString(),
                      Map<String, Object?>.from(value as Map),
                    ),
                  ) ??
                  const <String, Map<String, Object?>>{},
            ),
          ),
        );
    }
    return ContentValidationReport(issues);
  }

  List<ContentValidationIssue> validateCrossword(CrosswordContent item) {
    final issues = <ContentValidationIssue>[
      ..._validateMetadata(item.metadata),
    ];
    if (item.gridSize < 3) {
      issues.add(_error(item.metadata.id, 'Crossword gridSize must be >= 3.'));
    }
    if (item.placements.isEmpty) {
      issues.add(
        _error(item.metadata.id, 'Crossword must include placements.'),
      );
    }
    if (item.layoutKey.trim().isEmpty) {
      issues.add(_error(item.metadata.id, 'Crossword layoutKey is required.'));
    }
    if (item.levelBandMin > item.levelBandMax) {
      issues.add(_error(item.metadata.id, 'Crossword level band is invalid.'));
    }
    return issues;
  }

  List<ContentValidationIssue> validateWordSearch(WordSearchContent item) {
    final issues = <ContentValidationIssue>[
      ..._validateMetadata(item.metadata),
    ];
    if (item.gridSize < 3) {
      issues.add(
        _error(item.metadata.id, 'Word Search gridSize must be >= 3.'),
      );
    }
    if (item.entryIds.isEmpty) {
      issues.add(
        _error(item.metadata.id, 'Word Search must include entryIds.'),
      );
    }
    if (item.allowedDirections.isEmpty) {
      issues.add(
        _error(item.metadata.id, 'Word Search must include allowedDirections.'),
      );
    }
    return issues;
  }

  List<ContentValidationIssue> validateMatching(MatchingContent item) {
    final issues = <ContentValidationIssue>[
      ..._validateMetadata(item.metadata),
    ];
    if (item.pairIds.length < 2) {
      issues.add(
        _error(item.metadata.id, 'Matching must include at least 2 pairs.'),
      );
    }
    if (item.levelBandMin > item.levelBandMax) {
      issues.add(_error(item.metadata.id, 'Matching level band is invalid.'));
    }
    return issues;
  }

  List<ContentValidationIssue> validateAyahCompletion(
    AyahCompletionContent item,
  ) {
    final issues = <ContentValidationIssue>[
      ..._validateMetadata(item.metadata),
    ];
    if (item.surah <= 0 || item.ayah <= 0) {
      issues.add(
        _error(item.metadata.id, 'Ayah Completion requires valid surah/ayah.'),
      );
    }
    if (item.blankWordIndexes.isEmpty) {
      issues.add(
        _error(item.metadata.id, 'Ayah Completion requires blankWordIndexes.'),
      );
    }
    return issues;
  }

  List<ContentValidationIssue> validateHadithScenario(
    HadithScenarioContent item,
  ) {
    final issues = <ContentValidationIssue>[
      ..._validateMetadata(item.metadata),
    ];
    if (item.hadithId.trim().isEmpty) {
      issues.add(
        _error(item.metadata.id, 'Hadith scenario requires hadithId.'),
      );
    }
    if (item.theme.trim().isEmpty) {
      issues.add(_error(item.metadata.id, 'Hadith scenario requires theme.'));
    }
    if (item.scenarioTitle.trim().isEmpty ||
        item.scenarioDescription.trim().isEmpty ||
        item.reflectionPrompt.trim().isEmpty) {
      issues.add(
        _error(
          item.metadata.id,
          'Hadith scenario teaching copy is incomplete.',
        ),
      );
    }
    if (item.choices.length < 2) {
      issues.add(
        _error(
          item.metadata.id,
          'Hadith scenario requires at least 2 choices.',
        ),
      );
    }
    return issues;
  }

  List<ContentValidationIssue> validateSpiritualGrowth(
    SpiritualGrowthContent item,
  ) {
    final issues = <ContentValidationIssue>[
      ..._validateMetadata(item.metadata),
    ];
    if (item.theme.trim().isEmpty) {
      issues.add(
        _error(item.metadata.id, 'Spiritual growth item requires theme.'),
      );
    }
    if (item.titleKey.trim().isEmpty || item.descriptionKey.trim().isEmpty) {
      issues.add(
        _error(
          item.metadata.id,
          'Spiritual growth localization keys are required.',
        ),
      );
    }
    if (item.subtype == SpiritualGrowthContentSubtype.reflectionPrompt &&
        item.responseOptions.isEmpty) {
      issues.add(
        _error(
          item.metadata.id,
          'Reflection prompt requires response options.',
        ),
      );
    }
    return issues;
  }

  List<ContentValidationIssue> validatePack(
    GamePackContent item,
    ContentExpansionSnapshot snapshot,
  ) {
    final issues = <ContentValidationIssue>[];
    if (item.titleKey.trim().isEmpty || item.descriptionKey.trim().isEmpty) {
      issues.add(_error(item.id, 'Pack localization keys are required.'));
    }
    if (item.contentIds.isEmpty) {
      issues.add(_warning(item.id, 'Pack has no content ids assigned.'));
    }
    if (item.minDifficulty > item.maxDifficulty) {
      issues.add(_error(item.id, 'Pack difficulty range is invalid.'));
    }
    if (snapshot.allIds().isNotEmpty) {
      final knownIds = snapshot.allIds().toSet();
      for (final contentId in item.contentIds) {
        if (!knownIds.contains(contentId)) {
          issues.add(
            _warning(item.id, 'Pack references unknown content "$contentId".'),
          );
        }
      }
    }
    return issues;
  }

  List<ContentValidationIssue> validateVariationProfile(
    VariationProfileContent item,
  ) {
    final issues = <ContentValidationIssue>[];
    if (item.gameType.trim().isEmpty) {
      issues.add(_error(item.id, 'Variation profile requires gameType.'));
    }
    if (item.supportedVariations.isEmpty) {
      issues.add(
        _warning(item.id, 'Variation profile has no supported variations.'),
      );
    }
    for (final entry in item.defaultSettingsByVariation.entries) {
      final config = KnowledgeGameConfig(
        variations: <GameVariationType>[
          GameVariationType.values.firstWhere(
            (variation) => variation.name == entry.key,
            orElse: () => GameVariationType.standard,
          ),
        ],
        variationSettings: entry.value,
      );
      for (final issue in _variationEngine.validateConfig(config)) {
        issues.add(
          ContentValidationIssue(
            severity: ContentValidationSeverity.error,
            scope: item.id,
            message: issue.message,
          ),
        );
      }
    }
    return issues;
  }

  List<ContentValidationIssue> _validateMetadata(ContentMetadata metadata) {
    final issues = <ContentValidationIssue>[];
    if (metadata.id.trim().isEmpty) {
      issues.add(_error('metadata', 'Content id is required.'));
    }
    if (metadata.category.trim().isEmpty) {
      issues.add(_error(metadata.id, 'Content category is required.'));
    }
    if (metadata.difficulty < 1 || metadata.difficulty > 100) {
      issues.add(
        _error(metadata.id, 'Content difficulty must stay within 1..100.'),
      );
    }
    if (metadata.supportedVariations.contains(GameVariationType.standard) &&
        metadata.supportedVariations.length > 1) {
      issues.add(
        _error(
          metadata.id,
          'Standard cannot be combined with other supported variations.',
        ),
      );
    }
    if (metadata.supportedVariations.toSet().length !=
        metadata.supportedVariations.length) {
      issues.add(
        _error(
          metadata.id,
          'Supported variations must not contain duplicates.',
        ),
      );
    }
    return issues;
  }

  ContentValidationIssue _warning(String scope, String message) {
    return ContentValidationIssue(
      severity: ContentValidationSeverity.warning,
      scope: scope,
      message: message,
    );
  }

  ContentValidationIssue _error(String scope, String message) {
    return ContentValidationIssue(
      severity: ContentValidationSeverity.error,
      scope: scope,
      message: message,
    );
  }
}
