import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'package:path_of_nur/features/learn/companion_surfaces/application/companion_surfaces_ui_state.dart';
import 'package:path_of_nur/shared/persistence/local_store.dart';

import '../../../test_helpers/app_test_harness.dart';

void main() {
  test('controller restores persisted companion selections', () async {
    final container = await makeTestContainer(
      seed: <String, Object>{
        'learn.companion.seerah.lastFocus': 'hijrah',
        'learn.companion.character.selectedTrait': 'sabr',
        'learn.companion.dailyWisdom.saved': jsonEncode(<String>['mercy']),
        'learn.companion.dailyWisdom.recent': jsonEncode(<String>[
          'gratitude',
          'mercy',
        ]),
      },
    );

    addTearDown(container.dispose);

    final state = container.read(companionSurfacesUiControllerProvider);
    expect(state.lastSeerahFocus, 'hijrah');
    expect(state.selectedCharacterTraitId, 'sabr');
    expect(state.savedDailyWisdomEntryIds, contains('mercy'));
    expect(state.recentDailyWisdomEntryIds, <String>['gratitude', 'mercy']);
  });

  test(
    'controller persists save toggles and recent daily wisdom history',
    () async {
      final container = await makeTestContainer();
      addTearDown(container.dispose);

      final controller = container.read(
        companionSurfacesUiControllerProvider.notifier,
      );
      final store = container.read(localStoreProvider);

      controller.setSeerahFocus('madinah-society');
      controller.setCharacterTrait('kindness');
      controller.toggleSavedDailyWisdom('mercy');
      controller.recordDailyWisdomViewed('mercy');
      controller.recordDailyWisdomViewed('gratitude');
      controller.recordDailyWisdomViewed('mercy');

      final state = container.read(companionSurfacesUiControllerProvider);
      expect(state.lastSeerahFocus, 'madinah-society');
      expect(state.selectedCharacterTraitId, 'kindness');
      expect(state.savedDailyWisdomEntryIds, contains('mercy'));
      expect(state.recentDailyWisdomEntryIds, <String>['mercy', 'gratitude']);

      expect(
        store.getString('learn.companion.seerah.lastFocus'),
        'madinah-society',
      );
      expect(
        store.getString('learn.companion.character.selectedTrait'),
        'kindness',
      );
      expect(store.getJsonList('learn.companion.dailyWisdom.recent'), <dynamic>[
        'mercy',
        'gratitude',
      ]);
    },
  );
}
