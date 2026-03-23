import '../../journey/domain/learning_journey_models.dart';

const Set<String> _containedJourneyIds = <String>{};

const Set<String> _hiddenIslandIds = <String>{'legacy-learning'};

bool isProductionSafeLearningJourney(LearningJourney journey) {
  return !_containedJourneyIds.contains(journey.id);
}

bool isProductionSafeLearningJourneyId(String journeyId) {
  return !_containedJourneyIds.contains(journeyId);
}

bool isProductionSafeLearningJourneyIsland(LearningJourneyIsland island) {
  return !_hiddenIslandIds.contains(island.id);
}
