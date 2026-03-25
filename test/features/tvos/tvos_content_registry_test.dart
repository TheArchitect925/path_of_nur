import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/tvos/application/tvos_content_registry.dart';
import 'package:path_of_nur/features/tvos/data/tvos_content_registry.dart';
import 'package:path_of_nur/features/tvos/domain/tvos_content_registry_models.dart';
import 'package:path_of_nur/features/tvos/domain/tvos_foundation_models.dart';

void main() {
  test('home route registry preserves module order', () {
    final modules = tvosContentModulesForRoute('/home');
    expect(modules.map((module) => module.sectionKey), <String>[
      'home.prayerSummary',
      'home.continueReading',
      'home.dailyVerse',
    ]);
  });

  test('quran route registry preserves module order', () {
    final modules = tvosContentModulesForRoute('/quran');
    expect(modules.map((module) => module.sectionKey), <String>[
      'quran.continueReading',
      'quran.dailyVerse',
      'quran.playback',
      'quran.browse',
    ]);
  });

  test('favorites route registry preserves module order', () {
    final modules = tvosContentModulesForRoute('/quran/bookmarks');
    expect(modules.map((module) => module.sectionKey), <String>[
      'favorites.primaryPaths',
      'favorites.savedItems',
      'favorites.watchLater',
    ]);
  });

  test('settings route registry preserves module order', () {
    final modules = tvosContentModulesForRoute('/settings');
    expect(modules.map((module) => module.sectionKey), <String>[
      'settings.startup',
      'settings.listeningDefaults',
      'settings.tvPreferences',
    ]);
  });

  test('arabic route registry preserves module order', () {
    final modules = tvosContentModulesForRoute('/quran/arabic');
    expect(modules.map((module) => module.sectionKey), <String>[
      'arabic.primaryPaths',
      'arabic.letterGroups',
      'arabic.familyGuidance',
    ]);
  });

  test('games route registry preserves module order', () {
    final modules = tvosContentModulesForRoute('/learn/games');
    expect(modules.map((module) => module.sectionKey), <String>[
      'games.primaryPaths',
      'games.challenges',
      'games.familyGuidance',
    ]);
  });

  test('profiles route registry preserves module order', () {
    final modules = tvosContentModulesForRoute('/accounts-sync/profiles');
    expect(modules.map((module) => module.sectionKey), <String>[
      'profiles.primarySwitcher',
      'profiles.sessionContinuity',
      'profiles.householdGuidance',
    ]);
  });

  test('prayer route registry preserves module order', () {
    final modules = tvosContentModulesForRoute('/worship/prayer');
    expect(modules.map((module) => module.sectionKey), <String>[
      'prayer.currentNext',
      'prayer.schedule',
      'prayer.companion',
    ]);
  });

  test('dhikr route registry preserves module order', () {
    final modules = tvosContentModulesForRoute('/worship/dhikr');
    expect(modules.map((module) => module.sectionKey), <String>[
      'dhikr.modes',
      'dhikr.guidedFlow',
      'dhikr.companion',
    ]);
  });

  test('kids route registry preserves module order', () {
    final modules = tvosContentModulesForRoute('/learn/kids/fun-learning');
    expect(modules.map((module) => module.sectionKey), <String>[
      'kids.primaryPaths',
      'kids.featuredStories',
      'kids.familyGuidance',
    ]);
  });

  test('learn route registry preserves module order', () {
    final modules = tvosContentModulesForRoute('/learn');
    expect(modules.map((module) => module.sectionKey), <String>[
      'learn.primaryPaths',
      'learn.storiesReflection',
      'learn.prophetsStories',
      'learn.seerahReflection',
      'learn.dailyWisdom',
      'learn.knowledgeDomains',
      'learn.signsCreation',
      'learn.visualObservation',
    ]);
  });

  test(
    'onboarded modules include only enabled route sections for current stage',
    () {
      final homeModules = buildOnboardedTVOSContentModules(
        routePath: '/home',
        releaseStage: TVOSReleaseStage.testflight,
      );
      final quranModules = buildOnboardedTVOSContentModules(
        routePath: '/quran',
        releaseStage: TVOSReleaseStage.testflight,
      );
      final favoritesModules = buildOnboardedTVOSContentModules(
        routePath: '/quran/bookmarks',
        releaseStage: TVOSReleaseStage.testflight,
      );
      final settingsModules = buildOnboardedTVOSContentModules(
        routePath: '/settings',
        releaseStage: TVOSReleaseStage.testflight,
      );
      final arabicModules = buildOnboardedTVOSContentModules(
        routePath: '/quran/arabic',
        releaseStage: TVOSReleaseStage.testflight,
      );
      final gamesModules = buildOnboardedTVOSContentModules(
        routePath: '/learn/games',
        releaseStage: TVOSReleaseStage.testflight,
      );
      final profilesModules = buildOnboardedTVOSContentModules(
        routePath: '/accounts-sync/profiles',
        releaseStage: TVOSReleaseStage.testflight,
      );
      final prayerModules = buildOnboardedTVOSContentModules(
        routePath: '/worship/prayer',
        releaseStage: TVOSReleaseStage.testflight,
      );
      final dhikrModules = buildOnboardedTVOSContentModules(
        routePath: '/worship/dhikr',
        releaseStage: TVOSReleaseStage.testflight,
      );
      final kidsModules = buildOnboardedTVOSContentModules(
        routePath: '/learn/kids/fun-learning',
        releaseStage: TVOSReleaseStage.testflight,
      );
      final learnModules = buildOnboardedTVOSContentModules(
        routePath: '/learn',
        releaseStage: TVOSReleaseStage.testflight,
      );

      expect(homeModules, hasLength(3));
      expect(quranModules, hasLength(4));
      expect(favoritesModules, hasLength(3));
      expect(settingsModules, hasLength(3));
      expect(arabicModules, hasLength(3));
      expect(gamesModules, hasLength(3));
      expect(profilesModules, hasLength(3));
      expect(prayerModules, hasLength(3));
      expect(dhikrModules, hasLength(3));
      expect(kidsModules, hasLength(3));
      expect(learnModules, hasLength(8));
      expect(
        quranModules.where(
          (module) => module.kind == TVOSContentModuleKind.playback,
        ),
        hasLength(1),
      );
      expect(
        settingsModules.where(
          (module) =>
              module.minimumPhase == TVOSPhaseId.phase20SettingsPreferences,
        ),
        hasLength(3),
      );
      expect(
        favoritesModules.where(
          (module) =>
              module.minimumPhase == TVOSPhaseId.phase16FavoritesPlaylistsSaved,
        ),
        hasLength(3),
      );
      expect(
        profilesModules.where(
          (module) =>
              module.minimumPhase ==
              TVOSPhaseId.phase19ProfilesHouseholdContinuity,
        ),
        hasLength(3),
      );
      expect(
        gamesModules.where(
          (module) =>
              module.minimumPhase ==
              TVOSPhaseId.phase14GamesRemoteInteractivity,
        ),
        hasLength(3),
      );
      expect(
        arabicModules.where(
          (module) =>
              module.minimumPhase == TVOSPhaseId.phase13ArabicBeginnerLearning,
        ),
        hasLength(3),
      );
      expect(
        kidsModules.where(
          (module) =>
              module.minimumPhase ==
              TVOSPhaseId.phase12KidsModeFamilySafeLearning,
        ),
        hasLength(3),
      );
      expect(
        learnModules.where(
          (module) =>
              module.minimumPhase ==
              TVOSPhaseId.phase11StoriesProphetsReflection,
        ),
        hasLength(3),
      );
      expect(
        learnModules.where(
          (module) =>
              module.minimumPhase ==
              TVOSPhaseId.phase15SignsCreationVisualLearning,
        ),
        hasLength(2),
      );
    },
  );

  test('disabled routes do not onboard modules', () {
    final settingsModules = buildOnboardedTVOSContentModules(
      routePath: '/not-a-route',
      releaseStage: TVOSReleaseStage.testflight,
    );
    expect(settingsModules, isEmpty);
  });

  test('registry lookup by section key returns stable module', () {
    final module = tvosContentModuleBySectionKey('quran.playback');
    expect(module, isNotNull);
    expect(module?.id, TVOSContentModuleId.quranPlayback);
    expect(module?.requiresSharedParityPayload, isTrue);
  });

  test('quran playback module is staged with phase 6 route ownership', () {
    final module = tvosContentModuleBySectionKey('quran.playback');
    expect(module, isNotNull);
    expect(module?.minimumPhase, TVOSPhaseId.phase6QuranBrowseReading);
  });

  test('learn prophetic stories module is staged with phase 11 ownership', () {
    final module = tvosContentModuleBySectionKey('learn.prophetsStories');
    expect(module, isNotNull);
    expect(module?.minimumPhase, TVOSPhaseId.phase11StoriesProphetsReflection);
  });

  test('learn signs in creation module is staged with phase 15 ownership', () {
    final module = tvosContentModuleBySectionKey('learn.signsCreation');
    expect(module, isNotNull);
    expect(
      module?.minimumPhase,
      TVOSPhaseId.phase15SignsCreationVisualLearning,
    );
  });

  test('prayer current-next module is staged with phase 8 ownership', () {
    final module = tvosContentModuleBySectionKey('prayer.currentNext');
    expect(module, isNotNull);
    expect(module?.minimumPhase, TVOSPhaseId.phase8PrayerSection);
  });

  test('settings startup module is staged with phase 20 ownership', () {
    final module = tvosContentModuleBySectionKey('settings.startup');
    expect(module, isNotNull);
    expect(module?.minimumPhase, TVOSPhaseId.phase20SettingsPreferences);
  });

  test('dhikr modes module is staged with phase 9 ownership', () {
    final module = tvosContentModuleBySectionKey('dhikr.modes');
    expect(module, isNotNull);
    expect(module?.minimumPhase, TVOSPhaseId.phase9DhikrGuidedRemembrance);
  });

  test('kids primary paths module is staged with phase 12 ownership', () {
    final module = tvosContentModuleBySectionKey('kids.primaryPaths');
    expect(module, isNotNull);
    expect(module?.minimumPhase, TVOSPhaseId.phase12KidsModeFamilySafeLearning);
  });

  test('arabic primary paths module is staged with phase 13 ownership', () {
    final module = tvosContentModuleBySectionKey('arabic.primaryPaths');
    expect(module, isNotNull);
    expect(module?.minimumPhase, TVOSPhaseId.phase13ArabicBeginnerLearning);
  });

  test('games primary paths module is staged with phase 14 ownership', () {
    final module = tvosContentModuleBySectionKey('games.primaryPaths');
    expect(module, isNotNull);
    expect(module?.minimumPhase, TVOSPhaseId.phase14GamesRemoteInteractivity);
  });

  test('profiles primary switcher module is staged with phase 19 ownership', () {
    final module = tvosContentModuleBySectionKey('profiles.primarySwitcher');
    expect(module, isNotNull);
    expect(
      module?.minimumPhase,
      TVOSPhaseId.phase19ProfilesHouseholdContinuity,
    );
  });

  test('favorites primary paths module is staged with phase 16 ownership', () {
    final module = tvosContentModuleBySectionKey('favorites.primaryPaths');
    expect(module, isNotNull);
    expect(module?.minimumPhase, TVOSPhaseId.phase16FavoritesPlaylistsSaved);
  });
}
