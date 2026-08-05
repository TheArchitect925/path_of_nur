import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/tvos_foundation_registry.dart';
import '../domain/tvos_foundation_models.dart';
import 'tvos_release_policy.dart';

final tvosReleaseStageProvider = Provider<TVOSReleaseStage>((ref) {
  return TVOSReleasePolicy.currentReleaseStage;
});

final tvosEnabledSurfaceFlagsProvider = Provider<List<TVOSSurfaceFlag>>((ref) {
  return tvosSurfaceFlags
      .where((flag) => flag.availability == TVOSFeatureAvailability.enabled)
      .toList(growable: false);
});

final tvosSidebarSurfaceFlagsProvider = Provider<List<TVOSSurfaceFlag>>((ref) {
  return tvosSurfaceFlags
      .where(
        (flag) =>
            flag.allowInSidebar &&
            flag.availability == TVOSFeatureAvailability.enabled,
      )
      .toList(growable: false);
});

final tvosPendingParitySurfacesProvider = Provider<List<TVOSSurfaceFlag>>((
  ref,
) {
  return tvosSurfaceFlags
      .where(
        (flag) =>
            flag.parityHealth == TVOSParityHealth.pendingSharedParity ||
            flag.parityHealth == TVOSParityHealth.adaptationRequired,
      )
      .toList(growable: false);
});

final tvosMirroredRoutePathsProvider = Provider<List<String>>((ref) {
  return TVOSReleasePolicy.currentlyMirroredSurfaces
      .map((entry) => entry.sourceRoute)
      .toList(growable: false);
});
