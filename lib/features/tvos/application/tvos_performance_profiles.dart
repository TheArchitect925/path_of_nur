import '../data/tvos_performance_profiles.dart';
import '../domain/tvos_foundation_models.dart';
import '../domain/tvos_performance_models.dart';

List<TVOSPerformanceSurfaceProfile> activeTVOSPerformanceProfiles() {
  return tvosPerformanceSurfaceProfiles.toList(growable: false);
}

List<TVOSPerformanceSurfaceProfile> highPriorityTVOSPerformanceProfiles() {
  return activeTVOSPerformanceProfiles()
      .where(
        (profile) =>
            profile.priority == TVOSPerformancePriority.critical ||
            profile.priority == TVOSPerformancePriority.elevated,
      )
      .toList(growable: false);
}

bool tvosQuranPerformanceProfileRequiresCaching() {
  final quranProfile = tvosPerformanceSurfaceProfiles.firstWhere(
    (profile) => profile.surfaceId == TVOSSurfaceId.quran,
  );
  return quranProfile.requiresCachedSelectionPayloads &&
      quranProfile.requiresLazyVerticalRendering &&
      quranProfile.requiresMediaFocusRecovery;
}

bool tvosLargeSurfaceProfilesPreferLazyRendering() {
  return highPriorityTVOSPerformanceProfiles().every(
    (profile) =>
        profile.requiresLazyShelfRendering ||
        profile.requiresLazyVerticalRendering,
  );
}
