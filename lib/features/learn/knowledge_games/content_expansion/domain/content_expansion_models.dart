import '../../domain/knowledge_game_variations.dart';

enum ContentItemType {
  crossword,
  wordSearch,
  matching,
  ayahCompletion,
  hadithScenario,
  spiritualGrowth,
  pack,
  variationProfile,
}

enum ContentAudience { kids, adult, mixed }

enum SpiritualGrowthContentSubtype { intention, action, reflectionPrompt }

class ContentMetadata {
  const ContentMetadata({
    required this.id,
    required this.type,
    required this.category,
    required this.difficulty,
    required this.tags,
    required this.isDailyEligible,
    required this.supportedVariations,
    required this.audience,
    this.sourceType,
    this.sourceReference,
    this.packIds = const <String>[],
  });

  final String id;
  final ContentItemType type;
  final String category;
  final int difficulty;
  final List<String> tags;
  final bool isDailyEligible;
  final List<GameVariationType> supportedVariations;
  final ContentAudience audience;
  final String? sourceType;
  final String? sourceReference;
  final List<String> packIds;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'type': type.name,
    'category': category,
    'difficulty': difficulty,
    'tags': tags,
    'isDailyEligible': isDailyEligible,
    'supportedVariations': supportedVariations
        .map((item) => item.name)
        .toList(growable: false),
    'audience': audience.name,
    'sourceType': sourceType,
    'sourceReference': sourceReference,
    'packIds': packIds,
  };
}

class CrosswordContent {
  const CrosswordContent({
    required this.metadata,
    required this.gridSize,
    required this.layoutKey,
    required this.placements,
    required this.levelBandMin,
    required this.levelBandMax,
    required this.clueType,
    required this.dailyThemes,
  });

  final ContentMetadata metadata;
  final int gridSize;
  final String layoutKey;
  final List<Map<String, Object?>> placements;
  final int levelBandMin;
  final int levelBandMax;
  final String clueType;
  final List<String> dailyThemes;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'metadata': metadata.toJson(),
    'gridSize': gridSize,
    'layoutKey': layoutKey,
    'placements': placements,
    'levelBandMin': levelBandMin,
    'levelBandMax': levelBandMax,
    'clueType': clueType,
    'dailyThemes': dailyThemes,
  };
}

class WordSearchContent {
  const WordSearchContent({
    required this.metadata,
    required this.gridSize,
    required this.entryIds,
    required this.allowedDirections,
    required this.levelBandMin,
    required this.levelBandMax,
    required this.dailyThemes,
  });

  final ContentMetadata metadata;
  final int gridSize;
  final List<String> entryIds;
  final List<String> allowedDirections;
  final int levelBandMin;
  final int levelBandMax;
  final List<String> dailyThemes;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'metadata': metadata.toJson(),
    'gridSize': gridSize,
    'entryIds': entryIds,
    'allowedDirections': allowedDirections,
    'levelBandMin': levelBandMin,
    'levelBandMax': levelBandMax,
    'dailyThemes': dailyThemes,
  };
}

class MatchingContent {
  const MatchingContent({
    required this.metadata,
    required this.pairIds,
    required this.levelBandMin,
    required this.levelBandMax,
    required this.dailyThemes,
  });

  final ContentMetadata metadata;
  final List<String> pairIds;
  final int levelBandMin;
  final int levelBandMax;
  final List<String> dailyThemes;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'metadata': metadata.toJson(),
    'pairIds': pairIds,
    'levelBandMin': levelBandMin,
    'levelBandMax': levelBandMax,
    'dailyThemes': dailyThemes,
  };
}

class AyahCompletionContent {
  const AyahCompletionContent({
    required this.metadata,
    required this.surah,
    required this.ayah,
    required this.blankWordIndexes,
    required this.levelBandMin,
    required this.levelBandMax,
    required this.dailyThemes,
  });

  final ContentMetadata metadata;
  final int surah;
  final int ayah;
  final List<int> blankWordIndexes;
  final int levelBandMin;
  final int levelBandMax;
  final List<String> dailyThemes;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'metadata': metadata.toJson(),
    'surah': surah,
    'ayah': ayah,
    'blankWordIndexes': blankWordIndexes,
    'levelBandMin': levelBandMin,
    'levelBandMax': levelBandMax,
    'dailyThemes': dailyThemes,
  };
}

class HadithScenarioContent {
  const HadithScenarioContent({
    required this.metadata,
    required this.hadithId,
    required this.theme,
    required this.shortTeachingSummary,
    required this.reflectionPrompt,
    required this.scenarioTitle,
    required this.scenarioDescription,
    required this.choices,
    required this.levelBandMin,
    required this.levelBandMax,
    required this.dailyThemes,
    this.followUpReflection,
    this.helpText,
  });

  final ContentMetadata metadata;
  final String hadithId;
  final String theme;
  final String shortTeachingSummary;
  final String reflectionPrompt;
  final String scenarioTitle;
  final String scenarioDescription;
  final List<Map<String, Object?>> choices;
  final int levelBandMin;
  final int levelBandMax;
  final List<String> dailyThemes;
  final String? followUpReflection;
  final String? helpText;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'metadata': metadata.toJson(),
    'hadithId': hadithId,
    'theme': theme,
    'shortTeachingSummary': shortTeachingSummary,
    'reflectionPrompt': reflectionPrompt,
    'scenarioTitle': scenarioTitle,
    'scenarioDescription': scenarioDescription,
    'choices': choices,
    'levelBandMin': levelBandMin,
    'levelBandMax': levelBandMax,
    'dailyThemes': dailyThemes,
    'followUpReflection': followUpReflection,
    'helpText': helpText,
  };
}

class SpiritualGrowthContent {
  const SpiritualGrowthContent({
    required this.metadata,
    required this.subtype,
    required this.theme,
    required this.titleKey,
    required this.descriptionKey,
    this.actionType,
    this.xpValue,
    this.dropValue,
    this.isManual,
    this.responseOptions = const <Map<String, String>>[],
  });

  final ContentMetadata metadata;
  final SpiritualGrowthContentSubtype subtype;
  final String theme;
  final String titleKey;
  final String descriptionKey;
  final String? actionType;
  final int? xpValue;
  final int? dropValue;
  final bool? isManual;
  final List<Map<String, String>> responseOptions;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'metadata': metadata.toJson(),
    'subtype': subtype.name,
    'theme': theme,
    'titleKey': titleKey,
    'descriptionKey': descriptionKey,
    'actionType': actionType,
    'xpValue': xpValue,
    'dropValue': dropValue,
    'isManual': isManual,
    'responseOptions': responseOptions,
  };
}

class GamePackContent {
  const GamePackContent({
    required this.id,
    required this.type,
    required this.mode,
    required this.category,
    required this.titleKey,
    required this.descriptionKey,
    required this.contentIds,
    required this.tags,
    required this.minDifficulty,
    required this.maxDifficulty,
    required this.isDailyEligible,
    required this.isFeatured,
  });

  final String id;
  final ContentItemType type;
  final String mode;
  final String category;
  final String titleKey;
  final String descriptionKey;
  final List<String> contentIds;
  final List<String> tags;
  final int minDifficulty;
  final int maxDifficulty;
  final bool isDailyEligible;
  final bool isFeatured;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'type': type.name,
    'mode': mode,
    'category': category,
    'titleKey': titleKey,
    'descriptionKey': descriptionKey,
    'contentIds': contentIds,
    'tags': tags,
    'minDifficulty': minDifficulty,
    'maxDifficulty': maxDifficulty,
    'isDailyEligible': isDailyEligible,
    'isFeatured': isFeatured,
  };
}

class VariationProfileContent {
  const VariationProfileContent({
    required this.id,
    required this.gameType,
    required this.supportedVariations,
    required this.defaultSettingsByVariation,
  });

  final String id;
  final String gameType;
  final List<GameVariationType> supportedVariations;
  final Map<String, Map<String, Object?>> defaultSettingsByVariation;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'gameType': gameType,
    'supportedVariations': supportedVariations
        .map((item) => item.name)
        .toList(growable: false),
    'defaultSettingsByVariation': defaultSettingsByVariation,
  };
}

class ContentExpansionSnapshot {
  const ContentExpansionSnapshot({
    required this.crossword,
    required this.wordSearch,
    required this.matching,
    required this.ayahCompletion,
    required this.hadithScenario,
    required this.spiritualGrowth,
    required this.packs,
    required this.variationProfiles,
  });

  final List<CrosswordContent> crossword;
  final List<WordSearchContent> wordSearch;
  final List<MatchingContent> matching;
  final List<AyahCompletionContent> ayahCompletion;
  final List<HadithScenarioContent> hadithScenario;
  final List<SpiritualGrowthContent> spiritualGrowth;
  final List<GamePackContent> packs;
  final List<VariationProfileContent> variationProfiles;

  Iterable<String> allIds() sync* {
    for (final item in crossword) {
      yield item.metadata.id;
    }
    for (final item in wordSearch) {
      yield item.metadata.id;
    }
    for (final item in matching) {
      yield item.metadata.id;
    }
    for (final item in ayahCompletion) {
      yield item.metadata.id;
    }
    for (final item in hadithScenario) {
      yield item.metadata.id;
    }
    for (final item in spiritualGrowth) {
      yield item.metadata.id;
    }
    for (final item in packs) {
      yield item.id;
    }
    for (final item in variationProfiles) {
      yield item.id;
    }
  }
}

class InternalBuilderDraft {
  const InternalBuilderDraft({
    required this.type,
    required this.id,
    required this.category,
    required this.difficulty,
    required this.tags,
    required this.isDailyEligible,
    required this.supportedVariations,
    required this.audience,
    required this.payload,
    this.sourceType,
    this.sourceReference,
    this.packIds = const <String>[],
  });

  final ContentItemType type;
  final String id;
  final String category;
  final int difficulty;
  final List<String> tags;
  final bool isDailyEligible;
  final List<GameVariationType> supportedVariations;
  final ContentAudience audience;
  final String? sourceType;
  final String? sourceReference;
  final List<String> packIds;
  final Map<String, Object?> payload;

  ContentMetadata get metadata => ContentMetadata(
    id: id,
    type: type,
    category: category,
    difficulty: difficulty,
    tags: tags,
    isDailyEligible: isDailyEligible,
    supportedVariations: supportedVariations,
    audience: audience,
    sourceType: sourceType,
    sourceReference: sourceReference,
    packIds: packIds,
  );
}
