import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_of_nur/features/kids/seerah/application/seerah_journey_progress_service.dart';
import 'package:path_of_nur/features/kids/seerah/application/seerah_journey_repository.dart';
import 'package:path_of_nur/shared/persistence/local_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('Kids Seerah journey progress', () {
    test('manual reflection node completion stays learner scoped', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{});
      final prefs = await SharedPreferences.getInstance();
      final container = ProviderContainer(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      );
      addTearDown(container.dispose);

      final repository = container.read(kidsSeerahJourneyRepositoryProvider);
      final controller = container.read(kidsSeerahJourneyProgressProvider.notifier);
      final node = repository.nodeById('seerah_node_reflection_character');

      expect(node, isNotNull);
      controller.updateActiveLearner('child_a');
      controller.completeManualNode(
        journeyId: 'journey_seerah_muhammad_kids_v1',
        node: node!,
      );

      var summary = controller.buildSummary('journey_seerah_muhammad_kids_v1');
      expect(
        summary!.stages
            .firstWhere((stage) => stage.stage.stageId == 'seerah_stage_childhood')
            .nodes
            .firstWhere((item) => item.node.nodeId == node.nodeId)
            .isCompleted,
        isTrue,
      );

      controller.updateActiveLearner('child_b');
      summary = controller.buildSummary('journey_seerah_muhammad_kids_v1');
      expect(
        summary!.stages
            .firstWhere((stage) => stage.stage.stageId == 'seerah_stage_childhood')
            .nodes
            .firstWhere((item) => item.node.nodeId == node.nodeId)
            .isCompleted,
        isFalse,
      );
    });

    test('manual completion rewards only once for the same node', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{});
      final prefs = await SharedPreferences.getInstance();
      final container = ProviderContainer(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      );
      addTearDown(container.dispose);

      final repository = container.read(kidsSeerahJourneyRepositoryProvider);
      final controller = container.read(kidsSeerahJourneyProgressProvider.notifier);
      final node = repository.nodeById('seerah_node_reflection_mercy');

      final first = controller.completeManualNode(
        journeyId: 'journey_seerah_muhammad_kids_v1',
        node: node!,
      );
      final second = controller.completeManualNode(
        journeyId: 'journey_seerah_muhammad_kids_v1',
        node: node,
      );

      expect(first.nodeCompleted, isTrue);
      expect(first.xpAwarded, greaterThan(0));
      expect(second.nodeCompleted, isFalse);
      expect(second.xpAwarded, 0);
    });
  });
}
