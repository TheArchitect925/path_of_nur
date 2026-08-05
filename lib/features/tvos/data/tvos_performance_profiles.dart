import '../domain/tvos_foundation_models.dart';
import '../domain/tvos_performance_models.dart';

const List<TVOSPerformanceSurfaceProfile>
tvosPerformanceSurfaceProfiles = <TVOSPerformanceSurfaceProfile>[
  TVOSPerformanceSurfaceProfile(
    surfaceId: TVOSSurfaceId.home,
    routePath: '/home',
    priority: TVOSPerformancePriority.elevated,
    requiresLazyShelfRendering: true,
    requiresLazyVerticalRendering: false,
    requiresCachedSelectionPayloads: false,
    requiresMediaFocusRecovery: false,
    notes:
        'Home uses multiple large shelves and should keep family-room resume surfaces light.',
  ),
  TVOSPerformanceSurfaceProfile(
    surfaceId: TVOSSurfaceId.quran,
    routePath: '/quran',
    priority: TVOSPerformancePriority.critical,
    requiresLazyShelfRendering: true,
    requiresLazyVerticalRendering: true,
    requiresCachedSelectionPayloads: true,
    requiresMediaFocusRecovery: true,
    notes:
        'Qur\'an combines browse, reader, and media playback and is the highest-cost large-screen route.',
  ),
  TVOSPerformanceSurfaceProfile(
    surfaceId: TVOSSurfaceId.learn,
    routePath: '/learn',
    priority: TVOSPerformancePriority.elevated,
    requiresLazyShelfRendering: true,
    requiresLazyVerticalRendering: true,
    requiresCachedSelectionPayloads: false,
    requiresMediaFocusRecovery: false,
    notes:
        'Learn has the broadest shelf count and should avoid eager off-screen card creation.',
  ),
  TVOSPerformanceSurfaceProfile(
    surfaceId: TVOSSurfaceId.settings,
    routePath: '/settings',
    priority: TVOSPerformancePriority.standard,
    requiresLazyShelfRendering: false,
    requiresLazyVerticalRendering: false,
    requiresCachedSelectionPayloads: false,
    requiresMediaFocusRecovery: false,
    notes:
        'Settings is lighter, but it should stay compatible with diagnostics and preference persistence.',
  ),
];
