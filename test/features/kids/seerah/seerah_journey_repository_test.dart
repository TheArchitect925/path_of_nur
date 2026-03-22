import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_of_nur/features/kids/seerah/application/seerah_journey_repository.dart';
import 'package:path_of_nur/shared/persistence/local_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('Kids Seerah journey repository', () {
    test('featured journey and stages resolve cleanly', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{});
      final prefs = await SharedPreferences.getInstance();
      final container = ProviderContainer(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      );
      addTearDown(container.dispose);

      final featured = container.read(featuredKidsSeerahJourneyProvider);
      final repository = container.read(kidsSeerahJourneyRepositoryProvider);

      expect(featured, isNotNull);
      expect(featured!.totalStages, 4);
      expect(
        repository.stagesForJourney(featured.journeyId).map((stage) => stage.stageId),
        orderedEquals(<String>[
          'seerah_stage_childhood',
          'seerah_stage_revelation',
          'seerah_stage_hijrah',
          'seerah_stage_return',
        ]),
      );
    });
  });
}
