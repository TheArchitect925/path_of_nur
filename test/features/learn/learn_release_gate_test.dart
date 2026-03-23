import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/learn/journey/data/learning_journey_registry.dart';
import 'package:path_of_nur/features/learn/shared/application/learn_release_gate.dart';

void main() {
  test('learn release gate keeps tajweed live and legacy island hidden', () {
    final quranJourney = LearningJourneyRegistry.journeyById('journey-quran');
    final tajweedJourney = LearningJourneyRegistry.journeyById(
      'tajweed-basics',
    );
    final legacyIsland = LearningJourneyRegistry.islandById('legacy-learning');

    expect(quranJourney, isNotNull);
    expect(tajweedJourney, isNotNull);
    expect(legacyIsland, isNotNull);

    expect(isProductionSafeLearningJourney(quranJourney!), isTrue);
    expect(isProductionSafeLearningJourney(tajweedJourney!), isTrue);
    expect(isProductionSafeLearningJourneyId('tajweed-basics'), isTrue);
    expect(isProductionSafeLearningJourneyIsland(legacyIsland!), isFalse);
  });
}
