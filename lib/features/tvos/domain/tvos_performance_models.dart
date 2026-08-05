import 'tvos_foundation_models.dart';

enum TVOSPerformancePriority { standard, elevated, critical }

class TVOSPerformanceSurfaceProfile {
  const TVOSPerformanceSurfaceProfile({
    required this.surfaceId,
    required this.routePath,
    required this.priority,
    required this.requiresLazyShelfRendering,
    required this.requiresLazyVerticalRendering,
    required this.requiresCachedSelectionPayloads,
    required this.requiresMediaFocusRecovery,
    required this.notes,
  });

  final TVOSSurfaceId surfaceId;
  final String routePath;
  final TVOSPerformancePriority priority;
  final bool requiresLazyShelfRendering;
  final bool requiresLazyVerticalRendering;
  final bool requiresCachedSelectionPayloads;
  final bool requiresMediaFocusRecovery;
  final String notes;
}
