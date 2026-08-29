import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/learn/journey/data/learning_journey_registry.dart';
import 'package:path_of_nur/features/learn/shared/application/learn_release_gate.dart';
import 'package:path_of_nur/features/learn/shared/learn_art_assets.dart';

/// Journeys inherit their island's scene as a card thumbnail, so art coverage
/// has to hold for every island a user can actually reach — otherwise the
/// learn surfaces mix illustrated and icon-only cards.
void main() {
  test('every visible island has a scene, and the file is on disk', () {
    final visible = LearningJourneyRegistry.islands
        .where(isProductionSafeLearningJourneyIsland)
        .toList(growable: false);
    expect(visible, isNotEmpty);

    for (final island in visible) {
      final asset = journeyIslandArtAsset(island.id);
      expect(
        asset,
        isNotNull,
        reason: 'island ${island.id} has no scene, so its journeys fall back '
            'to an icon while other islands show art',
      );
      expect(
        File(asset!).existsSync(),
        isTrue,
        reason: '$asset is referenced but missing on disk',
      );
    }
  });

  test('every published journey resolves to its island scene', () {
    for (final journey in LearningJourneyRegistry.journeys) {
      if (!journey.isPublished) continue;
      if (!isProductionSafeLearningJourney(journey)) continue;
      expect(
        journeyIslandArtAsset(journey.islandId),
        isNotNull,
        reason: 'journey ${journey.id} sits on island ${journey.islandId}, '
            'which has no scene',
      );
    }
  });

  test('island scenes are distinct and stay inside the size budget', () {
    final assets = LearningJourneyRegistry.islands
        .where(isProductionSafeLearningJourneyIsland)
        .map((island) => journeyIslandArtAsset(island.id))
        .whereType<String>()
        .toList(growable: false);
    expect(
      assets.toSet().length,
      assets.length,
      reason: 'two islands share a scene; each should read distinctly',
    );
    for (final asset in assets) {
      final bytes = File(asset).lengthSync();
      expect(
        bytes,
        lessThanOrEqualTo(120 * 1024),
        reason: '$asset is ${(bytes / 1024).round()} KB, over the art budget',
      );
    }
  });
}
