import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/tvos/application/tvos_release_policy.dart';
import 'package:path_of_nur/features/tvos/data/tvos_foundation_registry.dart';
import 'package:path_of_nur/features/tvos/domain/tvos_foundation_models.dart';

void main() {
  test(
    'master tvOS phase definitions preserve the canonical display order',
    () {
      expect(tvosMasterPhaseDefinitions, hasLength(27));

      final displayOrders = tvosMasterPhaseDefinitions
          .map((phase) => phase.displayOrder)
          .toList(growable: false);

      expect(
        displayOrders,
        orderedEquals(List<int>.generate(27, (i) => i + 1)),
      );
    },
  );

  test(
    'currently mirrored tvOS surfaces are Home, Profiles, Quran, Favorites, Settings, Arabic, Learn, Games, Prayer, Dhikr, and Kids',
    () {
      final mirrored = TVOSReleasePolicy.currentlyMirroredSurfaces;
      final mirroredIds = mirrored.map((entry) => entry.id).toSet();

      expect(mirroredIds, <TVOSSurfaceId>{
        TVOSSurfaceId.home,
        TVOSSurfaceId.profiles,
        TVOSSurfaceId.quran,
        TVOSSurfaceId.favorites,
        TVOSSurfaceId.settings,
        TVOSSurfaceId.arabic,
        TVOSSurfaceId.learn,
        TVOSSurfaceId.games,
        TVOSSurfaceId.prayer,
        TVOSSurfaceId.dhikr,
        TVOSSurfaceId.kids,
      });
      expect(
        mirrored.every(
          (entry) =>
              entry.classification == TVOSParityClassification.adaptation,
        ),
        isTrue,
      );
    },
  );

  test(
    'tvOS parity review helper is true only for currently mirrored routes',
    () {
      expect(TVOSReleasePolicy.routeRequiresTVOSParityReview('/home'), isTrue);
      expect(
        TVOSReleasePolicy.routeRequiresTVOSParityReview(
          '/accounts-sync/profiles',
        ),
        isTrue,
      );
      expect(TVOSReleasePolicy.routeRequiresTVOSParityReview('/quran'), isTrue);
      expect(
        TVOSReleasePolicy.routeRequiresTVOSParityReview('/quran/bookmarks'),
        isTrue,
      );
      expect(
        TVOSReleasePolicy.routeRequiresTVOSParityReview('/settings'),
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
    },
  );

  test('foundation phases are restricted to architecture-first setup work', () {
    expect(
      isTVOSArchitectureFoundationPhase(TVOSPhaseId.phase1AuditArchitecture),
      isTrue,
    );
    expect(
      isTVOSArchitectureFoundationPhase(
        TVOSPhaseId.phase22ContentRegistryOnboarding,
      ),
      isTrue,
    );
    expect(
      isTVOSArchitectureFoundationPhase(TVOSPhaseId.phase5HomeContinueJourney),
      isFalse,
    );
    expect(
      isTVOSArchitectureFoundationPhase(
        TVOSPhaseId.phase27LaunchPolishReadiness,
      ),
      isFalse,
    );
  });
}
