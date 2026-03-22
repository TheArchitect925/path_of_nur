enum GameVariationType {
  standard,
  timed,
  memory,
  sequential,
  reflection,
  audio,
  challenge,
  fog,
  noClue,
  reverse,
}

class KnowledgeGameConfig {
  const KnowledgeGameConfig({
    this.variations = const <GameVariationType>[GameVariationType.standard],
    this.variationSettings = const <String, Object?>{},
  });

  const KnowledgeGameConfig.standard()
    : variations = const <GameVariationType>[GameVariationType.standard],
      variationSettings = const <String, Object?>{};

  final List<GameVariationType> variations;
  final Map<String, Object?> variationSettings;

  bool get isStandard =>
      variations.isEmpty ||
      (variations.length == 1 &&
          variations.first == GameVariationType.standard);

  bool hasVariation(GameVariationType type) => variations.contains(type);

  int intSetting(String key, {int fallback = 0}) {
    final value = variationSettings[key];
    return (value as num?)?.toInt() ?? fallback;
  }

  bool boolSetting(String key, {bool fallback = false}) {
    final value = variationSettings[key];
    return value is bool ? value : fallback;
  }

  String? stringSetting(String key) => variationSettings[key]?.toString();

  KnowledgeGameConfig copyWith({
    List<GameVariationType>? variations,
    Map<String, Object?>? variationSettings,
  }) {
    return KnowledgeGameConfig(
      variations: variations ?? this.variations,
      variationSettings: variationSettings ?? this.variationSettings,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'variations': variations.map((item) => item.name).toList(growable: false),
    'variationSettings': variationSettings,
  };

  factory KnowledgeGameConfig.fromJson(Map<String, dynamic>? json) {
    final source = json ?? const <String, dynamic>{};
    final rawVariations =
        source['variations'] as List<dynamic>? ?? const <dynamic>[];
    final variations = rawVariations
        .map(
          (item) => GameVariationType.values.firstWhere(
            (value) => value.name == item?.toString(),
            orElse: () => GameVariationType.standard,
          ),
        )
        .toList(growable: false);
    final rawSettings =
        source['variationSettings'] as Map<String, dynamic>? ??
        const <String, dynamic>{};
    return KnowledgeGameConfig(
      variations: variations.isEmpty
          ? const <GameVariationType>[GameVariationType.standard]
          : variations,
      variationSettings: Map<String, Object?>.from(rawSettings),
    );
  }
}

class GameVariationContext {
  const GameVariationContext({
    required this.gameType,
    required this.config,
    required this.state,
  });

  final String gameType;
  final KnowledgeGameConfig config;
  final Map<String, Object?> state;
}

abstract class GameVariationHandler {
  const GameVariationHandler();

  GameVariationType get type;

  void onGameStart(GameVariationContext context) {}

  void onUserInteraction(GameVariationContext context) {}

  void onEvaluate(GameVariationContext context) {}

  void onComplete(GameVariationContext context) {}
}
