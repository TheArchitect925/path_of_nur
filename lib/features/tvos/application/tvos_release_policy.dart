import '../data/tvos_foundation_registry.dart';
import '../domain/tvos_foundation_models.dart';

final class TVOSReleasePolicy {
  const TVOSReleasePolicy._();

  static bool get isPublicLaunchReady => false;

  static TVOSReleaseStage get currentReleaseStage => TVOSReleaseStage.testflight;

  static List<TVOSSurfaceParityEntry> get currentlyMirroredSurfaces =>
      tvosSurfaceParityEntries
          .where((entry) => entry.currentlyMirrored)
          .toList(growable: false);

  static List<TVOSSurfaceParityEntry> get futureSurfaceBacklog =>
      tvosSurfaceParityEntries
          .where((entry) => !entry.currentlyMirrored)
          .toList(growable: false);

  static bool routeRequiresTVOSParityReview(String route) {
    return isCurrentlyMirroredTVOSSurface(route);
  }

  static TVOSSurfaceFlag? surfaceFlagForRoute(String route) {
    return tvosSurfaceFlagForRoute(route);
  }

  static bool isSurfaceEnabled(String route) {
    final flag = surfaceFlagForRoute(route);
    if (flag == null) return false;
    return flag.availability == TVOSFeatureAvailability.enabled;
  }

  static bool shouldShowInSidebar(String route) {
    final flag = surfaceFlagForRoute(route);
    if (flag == null) return false;
    return flag.allowInSidebar &&
        flag.availability == TVOSFeatureAvailability.enabled;
  }

  static bool routeRequiresSharedParityPayload(String route) {
    final flag = surfaceFlagForRoute(route);
    return flag?.requiresSharedParityPayload ?? false;
  }

  static List<TVOSSectionFlag> sectionFlagsForRoute(String route) {
    return tvosSectionFlagsForRoute(route);
  }

  static bool isSectionEnabled(String route, String sectionKey) {
    return sectionFlagsForRoute(route).any(
      (flag) =>
          flag.sectionKey == sectionKey &&
          flag.availability == TVOSFeatureAvailability.enabled,
    );
  }

  static bool routeIsReadyForStage(String route, TVOSReleaseStage stage) {
    final flag = surfaceFlagForRoute(route);
    if (flag == null) return false;
    return flag.releaseStage.index <= stage.index &&
        flag.availability != TVOSFeatureAvailability.iosOnly;
  }
}
