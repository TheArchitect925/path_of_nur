import 'garden_models.dart';

/// Every element that can appear in the living garden vista.
enum GardenSceneElementId {
  centralTree,
  stream,
  oceanHorizon,
  olive,
  datePalm,
  fig,
  pomegranate,
  grapeVine,
  gourd,
  loteTree,
  rayhan,
  bee,
  ant,
  hoopoe,
  songbirds,
  fish,
}

enum GardenSceneElementKind { tree, plant, animal, water }

/// What number feeds an element's growth.
enum GardenSceneDriver { dimensionScore, maturityPercent, lifetimeDrops }

class GardenSceneElementSpec {
  const GardenSceneElementSpec({
    required this.id,
    required this.kind,
    required this.dimension,
    required this.variantLevel,
    required this.isNewSinceLastVisit,
  });

  final GardenSceneElementId id;
  final GardenSceneElementKind kind;
  final GardenGrowthDimension? dimension;

  /// 0 = not visible; 1..3 = visible growth variants.
  final int variantLevel;
  final bool isNewSinceLastVisit;
}

class GardenSceneWaterSpec {
  const GardenSceneWaterSpec({
    required this.streamTier,
    required this.oceanHorizonVisible,
    required this.oceanHorizonFull,
  });

  /// 1..5 discrete art tiers; keyed to the garden's 1-1000 drops ladder,
  /// deliberately NOT the ocean feature's personal ladder.
  final int streamTier;
  final bool oceanHorizonVisible;
  final bool oceanHorizonFull;
}

class GardenSceneSpec {
  const GardenSceneSpec({
    required this.learnerId,
    required this.treeStage,
    required this.treeProgress,
    required this.maturityPercent,
    required this.ambient,
    required this.elements,
    required this.water,
    required this.newlyAppeared,
    required this.newlyGrown,
    required this.treeStageAdvanced,
    required this.revision,
  });

  final String learnerId;
  final GardenVisualStageId treeStage;
  final double treeProgress;
  final int maturityPercent;
  final GardenAmbientState ambient;
  final List<GardenSceneElementSpec> elements;
  final GardenSceneWaterSpec water;

  /// Elements that went from hidden (variant 0) to visible since the last
  /// acknowledged visit. Empty on a first visit (no celebration then).
  final List<GardenSceneElementId> newlyAppeared;

  /// Visible elements whose variant increased since the last acknowledged
  /// visit (already-visible growth, quieter than a first appearance).
  final List<GardenSceneElementId> newlyGrown;
  final bool treeStageAdvanced;

  /// Stable signature of the visible composition; equal revisions render
  /// identical scenes, so consumers can gate rebuilds on it.
  final String revision;

  bool get hasNewGrowth =>
      treeStageAdvanced || newlyAppeared.isNotEmpty || newlyGrown.isNotEmpty;

  GardenSceneElementSpec? elementById(GardenSceneElementId id) {
    for (final element in elements) {
      if (element.id == id) {
        return element;
      }
    }
    return null;
  }
}

/// Snapshot of the last composition the user acknowledged, persisted per
/// learner so the composer can diff "what appeared since last visit".
class GardenSceneMemento {
  const GardenSceneMemento({
    required this.elementVariantById,
    required this.treeStageId,
    required this.streamTier,
    required this.oceanHorizonVisible,
    required this.savedAtIso,
  });

  factory GardenSceneMemento.fromSpec(
    GardenSceneSpec spec, {
    required String savedAtIso,
  }) {
    return GardenSceneMemento(
      elementVariantById: <String, int>{
        for (final element in spec.elements)
          if (element.variantLevel > 0) element.id.name: element.variantLevel,
      },
      treeStageId: spec.treeStage.name,
      streamTier: spec.water.streamTier,
      oceanHorizonVisible: spec.water.oceanHorizonVisible,
      savedAtIso: savedAtIso,
    );
  }

  factory GardenSceneMemento.fromJson(Map<String, Object?> json) {
    final rawVariants = json['elementVariantById'];
    return GardenSceneMemento(
      elementVariantById: <String, int>{
        if (rawVariants is Map)
          for (final entry in rawVariants.entries)
            if (entry.value is num)
              entry.key.toString(): (entry.value as num).toInt(),
      },
      treeStageId: json['treeStageId'] as String? ?? '',
      streamTier: (json['streamTier'] as num?)?.toInt() ?? 0,
      oceanHorizonVisible: json['oceanHorizonVisible'] as bool? ?? false,
      savedAtIso: json['savedAtIso'] as String? ?? '',
    );
  }

  final Map<String, int> elementVariantById;
  final String treeStageId;
  final int streamTier;
  final bool oceanHorizonVisible;
  final String savedAtIso;

  int variantFor(GardenSceneElementId id) => elementVariantById[id.name] ?? 0;

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'elementVariantById': elementVariantById,
      'treeStageId': treeStageId,
      'streamTier': streamTier,
      'oceanHorizonVisible': oceanHorizonVisible,
      'savedAtIso': savedAtIso,
    };
  }
}
