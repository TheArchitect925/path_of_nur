import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/tvos/application/tvos_release_policy.dart';
import 'package:path_of_nur/features/tvos/data/tvos_foundation_registry.dart';
import 'package:path_of_nur/features/tvos/domain/tvos_foundation_models.dart';

void main() {
  test('current tvOS release stage is testflight', () {
    expect(TVOSReleasePolicy.currentReleaseStage, TVOSReleaseStage.testflight);
  });

  test(
    'Home, Profiles, Quran, Favorites, Settings, Arabic, Learn, Games, Prayer, Dhikr, and Kids are enabled sidebar surfaces',
    () {
      final sidebarFlags = tvosSurfaceFlags
          .where(
            (flag) =>
                flag.allowInSidebar &&
                flag.availability == TVOSFeatureAvailability.enabled,
          )
          .toList(growable: false);

      expect(sidebarFlags.map((flag) => flag.routePath), <String>[
        '/home',
        '/quran',
        '/learn',
        '/learn/games',
        '/worship/prayer',
        '/worship/dhikr',
        '/learn/kids/fun-learning',
        '/quran/arabic',
        '/quran/bookmarks',
        '/settings',
        '/accounts-sync/profiles',
      ]);
      expect(TVOSReleasePolicy.shouldShowInSidebar('/home'), isTrue);
      expect(
        TVOSReleasePolicy.shouldShowInSidebar('/accounts-sync/profiles'),
        isTrue,
      );
      expect(TVOSReleasePolicy.shouldShowInSidebar('/quran/bookmarks'), isTrue);
      expect(TVOSReleasePolicy.shouldShowInSidebar('/settings'), isTrue);
      expect(TVOSReleasePolicy.shouldShowInSidebar('/quran/arabic'), isTrue);
      expect(TVOSReleasePolicy.shouldShowInSidebar('/learn'), isTrue);
      expect(TVOSReleasePolicy.shouldShowInSidebar('/learn/games'), isTrue);
      expect(TVOSReleasePolicy.shouldShowInSidebar('/worship/prayer'), isTrue);
      expect(TVOSReleasePolicy.shouldShowInSidebar('/worship/dhikr'), isTrue);
      expect(
        TVOSReleasePolicy.shouldShowInSidebar('/learn/kids/fun-learning'),
        isTrue,
      );
    },
  );

  test('mirrored routes require shared parity payloads and parity review', () {
    expect(TVOSReleasePolicy.routeRequiresSharedParityPayload('/home'), isTrue);
    expect(
      TVOSReleasePolicy.routeRequiresSharedParityPayload(
        '/accounts-sync/profiles',
      ),
      isFalse,
    );
    expect(
      TVOSReleasePolicy.routeRequiresSharedParityPayload('/quran'),
      isTrue,
    );
    expect(
      TVOSReleasePolicy.routeRequiresTVOSParityReview(
        '/accounts-sync/profiles',
      ),
      isTrue,
    );
    expect(
      TVOSReleasePolicy.routeRequiresSharedParityPayload('/quran/bookmarks'),
      isTrue,
    );
    expect(TVOSReleasePolicy.routeRequiresTVOSParityReview('/home'), isTrue);
    expect(
      TVOSReleasePolicy.routeRequiresTVOSParityReview('/quran/bookmarks'),
      isTrue,
    );
    expect(
      TVOSReleasePolicy.routeRequiresTVOSParityReview('/quran/arabic'),
      isTrue,
    );
    expect(TVOSReleasePolicy.routeRequiresTVOSParityReview('/learn'), isTrue);
    expect(
      TVOSReleasePolicy.routeRequiresTVOSParityReview('/learn/games'),
      isTrue,
    );
    expect(
      TVOSReleasePolicy.routeRequiresTVOSParityReview('/worship/prayer'),
      isTrue,
    );
    expect(
      TVOSReleasePolicy.routeRequiresTVOSParityReview('/worship/dhikr'),
      isTrue,
    );
    expect(
      TVOSReleasePolicy.routeRequiresTVOSParityReview(
        '/learn/kids/fun-learning',
      ),
      isTrue,
    );
  });

  test(
    'later-phase and ios-only surfaces outside active routes stay disabled',
    () {
      expect(TVOSReleasePolicy.isSurfaceEnabled('/learn'), isTrue);
      expect(
        TVOSReleasePolicy.isSurfaceEnabled('/accounts-sync/profiles'),
        isTrue,
      );
      expect(TVOSReleasePolicy.isSurfaceEnabled('/quran/bookmarks'), isTrue);
      expect(TVOSReleasePolicy.isSurfaceEnabled('/settings'), isTrue);
      expect(TVOSReleasePolicy.isSurfaceEnabled('/learn/games'), isTrue);
      expect(TVOSReleasePolicy.isSurfaceEnabled('/quran/arabic'), isTrue);
      expect(TVOSReleasePolicy.isSurfaceEnabled('/worship/prayer'), isTrue);
      expect(TVOSReleasePolicy.isSurfaceEnabled('/worship/dhikr'), isTrue);
      expect(
        TVOSReleasePolicy.isSurfaceEnabled('/learn/kids/fun-learning'),
        isTrue,
      );
      expect(
        tvosSurfaceFlagForRoute('/settings')?.availability,
        TVOSFeatureAvailability.enabled,
      );
    },
  );

  test('mirrored section flags are enabled for home and quran routes', () {
    final homeSections = TVOSReleasePolicy.sectionFlagsForRoute('/home');
    final quranSections = TVOSReleasePolicy.sectionFlagsForRoute('/quran');

    expect(homeSections, isNotEmpty);
    expect(quranSections, isNotEmpty);
    expect(
      TVOSReleasePolicy.isSectionEnabled('/home', 'home.prayerSummary'),
      isTrue,
    );
    expect(
      TVOSReleasePolicy.isSectionEnabled('/quran', 'quran.playback'),
      isTrue,
    );
    expect(
      TVOSReleasePolicy.isSectionEnabled(
        '/quran/bookmarks',
        'favorites.primaryPaths',
      ),
      isTrue,
    );
    expect(
      TVOSReleasePolicy.isSectionEnabled(
        '/quran/bookmarks',
        'favorites.savedItems',
      ),
      isTrue,
    );
    expect(
      TVOSReleasePolicy.isSectionEnabled(
        '/quran/bookmarks',
        'favorites.watchLater',
      ),
      isTrue,
    );
    expect(
      TVOSReleasePolicy.isSectionEnabled('/settings', 'settings.startup'),
      isTrue,
    );
    expect(
      TVOSReleasePolicy.isSectionEnabled(
        '/settings',
        'settings.listeningDefaults',
      ),
      isTrue,
    );
    expect(
      TVOSReleasePolicy.isSectionEnabled('/settings', 'settings.tvPreferences'),
      isTrue,
    );
    expect(
      TVOSReleasePolicy.isSectionEnabled(
        '/accounts-sync/profiles',
        'profiles.primarySwitcher',
      ),
      isTrue,
    );
    expect(
      TVOSReleasePolicy.isSectionEnabled(
        '/accounts-sync/profiles',
        'profiles.sessionContinuity',
      ),
      isTrue,
    );
    expect(
      TVOSReleasePolicy.isSectionEnabled(
        '/accounts-sync/profiles',
        'profiles.householdGuidance',
      ),
      isTrue,
    );
    expect(
      TVOSReleasePolicy.isSectionEnabled(
        '/quran/arabic',
        'arabic.primaryPaths',
      ),
      isTrue,
    );
    expect(
      TVOSReleasePolicy.isSectionEnabled(
        '/quran/arabic',
        'arabic.letterGroups',
      ),
      isTrue,
    );
    expect(
      TVOSReleasePolicy.isSectionEnabled(
        '/quran/arabic',
        'arabic.familyGuidance',
      ),
      isTrue,
    );
    expect(
      TVOSReleasePolicy.isSectionEnabled('/learn/games', 'games.primaryPaths'),
      isTrue,
    );
    expect(
      TVOSReleasePolicy.isSectionEnabled('/learn/games', 'games.challenges'),
      isTrue,
    );
    expect(
      TVOSReleasePolicy.isSectionEnabled(
        '/learn/games',
        'games.familyGuidance',
      ),
      isTrue,
    );
    expect(
      TVOSReleasePolicy.isSectionEnabled('/learn', 'learn.primaryPaths'),
      isTrue,
    );
    expect(
      TVOSReleasePolicy.isSectionEnabled('/learn', 'learn.prophetsStories'),
      isTrue,
    );
    expect(
      TVOSReleasePolicy.isSectionEnabled('/learn', 'learn.signsCreation'),
      isTrue,
    );
    expect(
      TVOSReleasePolicy.isSectionEnabled(
        '/worship/prayer',
        'prayer.currentNext',
      ),
      isTrue,
    );
    expect(
      TVOSReleasePolicy.isSectionEnabled('/worship/dhikr', 'dhikr.modes'),
      isTrue,
    );
    expect(
      TVOSReleasePolicy.isSectionEnabled(
        '/learn/kids/fun-learning',
        'kids.primaryPaths',
      ),
      isTrue,
    );
    expect(
      TVOSReleasePolicy.isSectionEnabled(
        '/learn/kids/fun-learning',
        'kids.featuredStories',
      ),
      isTrue,
    );
    expect(
      TVOSReleasePolicy.isSectionEnabled(
        '/learn/kids/fun-learning',
        'kids.familyGuidance',
      ),
      isTrue,
    );
  });
}
