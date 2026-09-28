import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/garden/application/garden_scene_composer.dart';
import 'package:path_of_nur/features/garden/data/garden_scene_catalog.dart';
import 'package:path_of_nur/features/garden/data/garden_stage_catalog.dart';
import 'package:path_of_nur/features/garden/domain/garden_models.dart';
import 'package:path_of_nur/features/garden/domain/garden_scene_models.dart';
import 'package:path_of_nur/features/journey/application/growth_garden.dart';
import 'package:path_of_nur/features/journey/xp/domain/journey_xp_models.dart';
import 'package:path_of_nur/features/progression/domain/learner_progression_models.dart';

void main() {
  const composer = GardenSceneComposer();

  group('GardenSceneComposer catalog sweep', () {
    test(
      'every rule crosses each variant threshold exactly at the boundary',
      () {
        for (final rule in gardenSceneElementRules) {
          for (var i = 0; i < rule.variantThresholds.length; i++) {
            final threshold = rule.variantThresholds[i];
            final justBelow =
                threshold -
                (rule.driver == GardenSceneDriver.dimensionScore ? 0.01 : 1);
            final below = composer.compose(
              garden: _state(ruleValue: justBelow, rule: rule),
              lastSeen: null,
            );
            final at = composer.compose(
              garden: _state(ruleValue: threshold, rule: rule),
              lastSeen: null,
            );
            expect(
              below.elementById(rule.id)!.variantLevel,
              i,
              reason: '${rule.id.name} just below threshold ${i + 1}',
            );
            expect(
              at.elementById(rule.id)!.variantLevel,
              i + 1,
              reason: '${rule.id.name} at threshold ${i + 1}',
            );
          }
        }
      },
    );

    test('spec carries every catalog element, hidden ones at variant 0', () {
      final spec = composer.compose(garden: _state(), lastSeen: null);
      expect(spec.elements.length, gardenSceneElementRules.length);
      expect(spec.elements.every((e) => e.variantLevel == 0), isTrue);
    });
  });

  group('water', () {
    test('stream tiers follow the drops ladder', () {
      expect(_specForDrops(composer, 0).water.streamTier, 1);
      expect(_specForDrops(composer, 24).water.streamTier, 1);
      expect(_specForDrops(composer, 25).water.streamTier, 2);
      expect(_specForDrops(composer, 100).water.streamTier, 3);
      expect(_specForDrops(composer, 350).water.streamTier, 4);
      expect(_specForDrops(composer, 750).water.streamTier, 5);
    });

    test('ocean horizon glimpses at 500 drops and opens fully at 1000', () {
      expect(_specForDrops(composer, 499).water.oceanHorizonVisible, isFalse);
      final glimpse = _specForDrops(composer, 500).water;
      expect(glimpse.oceanHorizonVisible, isTrue);
      expect(glimpse.oceanHorizonFull, isFalse);
      final full = _specForDrops(composer, 1000).water;
      expect(full.oceanHorizonFull, isTrue);
    });
  });

  group('determinism', () {
    test('identical states compose to identical revisions', () {
      final garden = _state(
        prayer: 0.62,
        learning: 0.4,
        remembrance: 0.3,
        consistency: 0.5,
        wisdom: 0.35,
        drops: 260,
        maturity: 47,
      );
      final a = composer.compose(garden: garden, lastSeen: null);
      final b = composer.compose(garden: garden, lastSeen: null);
      expect(a.revision, b.revision);
      expect(a.water.streamTier, b.water.streamTier);
      for (var i = 0; i < a.elements.length; i++) {
        expect(a.elements[i].variantLevel, b.elements[i].variantLevel);
      }
    });

    test('revision changes when a variant changes', () {
      final low = composer.compose(garden: _state(prayer: 0.2), lastSeen: null);
      final high = composer.compose(
        garden: _state(prayer: 0.3),
        lastSeen: null,
      );
      expect(low.revision, isNot(high.revision));
    });
  });

  group('first visit', () {
    test('null memento never celebrates, even in a full garden', () {
      final spec = composer.compose(
        garden: _state(
          prayer: 1,
          learning: 1,
          remembrance: 1,
          consistency: 1,
          wisdom: 1,
          drops: 1000,
          maturity: 100,
        ),
        lastSeen: null,
      );
      expect(spec.newlyAppeared, isEmpty);
      expect(spec.newlyGrown, isEmpty);
      expect(spec.treeStageAdvanced, isFalse);
      expect(spec.elements.every((e) => !e.isNewSinceLastVisit), isTrue);
      expect(spec.hasNewGrowth, isFalse);
    });
  });

  group('memento diffing', () {
    test(
      'appearance, growth, stream, ocean and stage advances are detected',
      () {
        final before = composer.compose(
          garden: _state(
            prayer: 0.3, // olive v1
            remembrance: 0.5, // rayhan v2
            drops: 120, // tier 3
            maturity: 26,
          ),
          lastSeen: null,
        );
        final memento = GardenSceneMemento.fromSpec(
          before,
          savedAtIso: '2026-08-29T10:00:00',
        );
        final after = composer.compose(
          garden: _state(
            prayer: 0.3,
            learning: 0.25, // fig appears
            remembrance: 0.75, // rayhan grows v2 -> v3
            drops: 520, // tier 4 + ocean glimpse
            maturity: 41, // smallRoots -> smallTree
          ),
          lastSeen: memento,
        );
        expect(after.newlyAppeared, contains(GardenSceneElementId.fig));
        expect(
          after.newlyAppeared,
          contains(GardenSceneElementId.oceanHorizon),
        );
        expect(after.newlyGrown, contains(GardenSceneElementId.rayhan));
        expect(after.newlyGrown, contains(GardenSceneElementId.stream));
        expect(after.treeStageAdvanced, isTrue);
        expect(
          after.elementById(GardenSceneElementId.fig)!.isNewSinceLastVisit,
          isTrue,
        );
        expect(
          after.elementById(GardenSceneElementId.olive)!.isNewSinceLastVisit,
          isFalse,
        );
        expect(
          after.newlyAppeared,
          isNot(contains(GardenSceneElementId.olive)),
        );
      },
    );

    test('an unchanged garden diffs to nothing against its own memento', () {
      final garden = _state(prayer: 0.6, drops: 200, maturity: 50);
      final spec = composer.compose(garden: garden, lastSeen: null);
      final memento = GardenSceneMemento.fromSpec(
        spec,
        savedAtIso: '2026-08-29T10:00:00',
      );
      final again = composer.compose(garden: garden, lastSeen: memento);
      expect(again.hasNewGrowth, isFalse);
    });

    test('memento survives a json round trip', () {
      final spec = composer.compose(
        garden: _state(prayer: 0.55, drops: 380, maturity: 44),
        lastSeen: null,
      );
      final memento = GardenSceneMemento.fromSpec(
        spec,
        savedAtIso: '2026-08-29T10:00:00',
      );
      final revived = GardenSceneMemento.fromJson(memento.toJson());
      expect(revived.elementVariantById, memento.elementVariantById);
      expect(revived.treeStageId, memento.treeStageId);
      expect(revived.streamTier, memento.streamTier);
      expect(revived.oceanHorizonVisible, memento.oceanHorizonVisible);
      final again = composer.compose(
        garden: _state(prayer: 0.55, drops: 380, maturity: 44),
        lastSeen: revived,
      );
      expect(again.hasNewGrowth, isFalse);
    });
  });

  group('early-user liveliness', () {
    test('a typical second-month learner already sees several elements', () {
      // Mirrors the existing garden_service_test fixture: level ~8, 120 drops.
      final spec = composer.compose(
        garden: _state(
          prayer: 0.4,
          learning: 0.3,
          remembrance: 0.3,
          consistency: 0.4,
          wisdom: 0.2,
          drops: 120,
          maturity: 26,
        ),
        lastSeen: null,
      );
      final visible = spec.elements
          .where((e) => e.variantLevel > 0)
          .map((e) => e.id);
      expect(
        visible.length,
        greaterThanOrEqualTo(4),
        reason: 'day-one-adjacent gardens must not feel barren',
      );
      expect(visible, contains(GardenSceneElementId.olive));
      expect(visible, contains(GardenSceneElementId.gourd));
      expect(spec.water.streamTier, 3);
    });
  });

  group('dimension score source', () {
    test('prefers the dimensions list over named fallback fields', () {
      final garden = _state(
        remembrance: 0,
        dimensions: const [
          GardenDimensionState(
            dimension: GardenGrowthDimension.remembranceLight,
            score: 0.6,
            emphasisPercent: 60,
            summaryValue: 12,
          ),
        ],
      );
      final spec = composer.compose(garden: garden, lastSeen: null);
      expect(spec.elementById(GardenSceneElementId.songbirds)!.variantLevel, 1);
      expect(spec.elementById(GardenSceneElementId.rayhan)!.variantLevel, 2);
    });
  });

  group('legacyGrowthStageForMaturity', () {
    test('maps canonical maturity onto the legacy five stages', () {
      expect(legacyGrowthStageForMaturity(0), GrowthGardenStage.seed);
      expect(legacyGrowthStageForMaturity(19), GrowthGardenStage.seed);
      expect(legacyGrowthStageForMaturity(20), GrowthGardenStage.sprout);
      expect(legacyGrowthStageForMaturity(39), GrowthGardenStage.sprout);
      expect(legacyGrowthStageForMaturity(40), GrowthGardenStage.rooted);
      expect(legacyGrowthStageForMaturity(63), GrowthGardenStage.rooted);
      expect(legacyGrowthStageForMaturity(64), GrowthGardenStage.flourishing);
      expect(legacyGrowthStageForMaturity(87), GrowthGardenStage.flourishing);
      expect(
        legacyGrowthStageForMaturity(88),
        GrowthGardenStage.lightUponLight,
      );
      expect(
        legacyGrowthStageForMaturity(100),
        GrowthGardenStage.lightUponLight,
      );
    });
  });
}

/// Builds a GardenState with one rule's driving value set, for threshold
/// sweeps that iterate the catalog generically.
GardenState _state({
  double prayer = 0,
  double learning = 0,
  double remembrance = 0,
  double consistency = 0,
  double wisdom = 0,
  int drops = 0,
  int maturity = 0,
  double? ruleValue,
  GardenSceneElementRule? rule,
  List<GardenDimensionState> dimensions = const [],
}) {
  if (rule != null && ruleValue != null) {
    switch (rule.driver) {
      case GardenSceneDriver.lifetimeDrops:
        drops = ruleValue.round();
      case GardenSceneDriver.maturityPercent:
        maturity = ruleValue.round();
      case GardenSceneDriver.dimensionScore:
        switch (rule.dimension!) {
          case GardenGrowthDimension.prayerFoundation:
            prayer = ruleValue;
          case GardenGrowthDimension.learningGrowth:
            learning = ruleValue;
          case GardenGrowthDimension.remembranceLight:
            remembrance = ruleValue;
          case GardenGrowthDimension.consistencyBloom:
            consistency = ruleValue;
          case GardenGrowthDimension.wisdomFruit:
            wisdom = ruleValue;
          case GardenGrowthDimension.mercyWater:
            drops = (ruleValue * gardenOceanFullDrops).round();
        }
    }
  }
  final stage = gardenVisualStages.lastWhere(
    (item) => maturity >= item.minMaturityPercent,
    orElse: () => gardenVisualStages.first,
  );
  return GardenState(
    learnerId: 'learner_1',
    isFallbackLearner: true,
    currentGardenLevel: 1,
    currentVisualStage: stage,
    nextVisualStage: null,
    totalXp: 0,
    totalOceanDrops: drops,
    prayerFoundationScore: prayer,
    learningGrowthScore: learning,
    remembranceLightScore: remembrance,
    consistencyScore: consistency,
    wisdomFruitScore: wisdom,
    lastUpdatedIso: null,
    lastVisualRefreshAtIso: null,
    unlockedVisualIds: const [],
    ambientState: GardenAmbientState.quietDawn,
    progressToNextStage: 0,
    maturityPercent: maturity,
    xpSummary: _xpSummary(),
    metrics: _metrics(),
    dimensions: dimensions,
    insights: const [],
    recentGrowth: const [],
    milestones: const [],
  );
}

GardenSceneSpec _specForDrops(GardenSceneComposer composer, int drops) {
  return composer.compose(garden: _state(drops: drops), lastSeen: null);
}

XpSummary _xpSummary() {
  return XpSummary(
    totalXp: 0,
    todayXp: 0,
    currentLevel: 1,
    currentLevelTitle: 'Niyyah',
    currentLevelStartXp: 0,
    nextLevel: 2,
    nextLevelTitle: 'Next',
    nextLevelTotalXp: 100,
    xpIntoLevel: 0,
    xpRequiredInLevel: 100,
    xpRemainingToNextLevel: 100,
    progressPercent: 0,
    updatedAt: DateTime(2026, 8, 29),
  );
}

LearnerProgressionMetrics _metrics() {
  return const LearnerProgressionMetrics(
    totalXp: 0,
    totalDrops: 0,
    kidsArabicLessonCompletions: 0,
    kidsArabicDailyMissionCompletions: 0,
    storyCompletions: 0,
    quizCompletions: 0,
    memoryCompletions: 0,
    duaLessonCompletions: 0,
    duaPracticeSessions: 0,
    duaMyDayCompletions: 0,
    bedtimeRoutineCompletions: 0,
    seerahNodeCompletions: 0,
    seerahStageCompletions: 0,
    seerahJourneyCompletions: 0,
    currentLearningStreakDays: 0,
    longestLearningStreakDays: 0,
    lastActivityAtIso: null,
    activeDayKeys: [],
  );
}
