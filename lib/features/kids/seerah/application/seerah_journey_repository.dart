import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/seerah_journey_seed.dart';
import '../domain/seerah_journey_models.dart';

final kidsSeerahJourneyRepositoryProvider =
    Provider<KidsSeerahJourneyRepository>(
      (ref) => const KidsSeerahJourneyRepository(),
    );

final kidsSeerahJourneysProvider = Provider<List<KidsSeerahJourney>>((ref) {
  return ref.watch(kidsSeerahJourneyRepositoryProvider).journeys;
});

final featuredKidsSeerahJourneyProvider = Provider<KidsSeerahJourney?>((ref) {
  return ref.watch(kidsSeerahJourneyRepositoryProvider).featuredJourney();
});

final kidsSeerahJourneyByIdProvider =
    Provider.family<KidsSeerahJourney?, String>((ref, journeyId) {
      return ref
          .watch(kidsSeerahJourneyRepositoryProvider)
          .journeyById(journeyId);
    });

final kidsSeerahCompanionStoriesProvider =
    Provider<List<KidsSeerahCompanionStoryLink>>((ref) {
      return ref.watch(kidsSeerahJourneyRepositoryProvider).companionStories;
    });

class KidsSeerahJourneyRepository {
  const KidsSeerahJourneyRepository();

  List<KidsSeerahJourney> get journeys => const [kKidsSeerahJourney];

  List<KidsSeerahJourneyStage> stagesForJourney(String journeyId) {
    return kKidsSeerahJourneyStages
        .where((stage) => stage.journeyId == journeyId)
        .toList(growable: false)
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
  }

  List<KidsSeerahJourneyNode> nodesForStage(String stageId) {
    return kKidsSeerahJourneyNodes
        .where((node) => node.stageId == stageId)
        .toList(growable: false)
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
  }

  KidsSeerahJourney? journeyById(String journeyId) {
    for (final journey in journeys) {
      if (journey.journeyId == journeyId) {
        return journey;
      }
    }
    return null;
  }

  KidsSeerahJourneyStage? stageById(String stageId) {
    for (final stage in kKidsSeerahJourneyStages) {
      if (stage.stageId == stageId) {
        return stage;
      }
    }
    return null;
  }

  KidsSeerahJourneyNode? nodeById(String nodeId) {
    for (final node in kKidsSeerahJourneyNodes) {
      if (node.nodeId == nodeId) {
        return node;
      }
    }
    return null;
  }

  KidsSeerahJourneyNode? nextNodeInJourney({
    required String journeyId,
    required String currentNodeId,
  }) {
    final orderedNodes = [
      for (final stage in stagesForJourney(journeyId))
        ...nodesForStage(stage.stageId),
    ];
    for (var index = 0; index < orderedNodes.length; index += 1) {
      if (orderedNodes[index].nodeId == currentNodeId) {
        if (index + 1 < orderedNodes.length) {
          return orderedNodes[index + 1];
        }
        return null;
      }
    }
    return null;
  }

  List<KidsSeerahCompanionStoryLink> get companionStories =>
      kKidsSeerahCompanionLinks;

  KidsSeerahCompanionStoryLink? companionById(String companionId) {
    for (final item in companionStories) {
      if (item.companionId == companionId) {
        return item;
      }
    }
    return null;
  }

  KidsSeerahJourney? featuredJourney() {
    for (final journey in journeys) {
      if (journey.isFeatured) {
        return journey;
      }
    }
    return journeys.isEmpty ? null : journeys.first;
  }
}
