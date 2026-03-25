import '../domain/tvos_foundation_models.dart';
import '../domain/tvos_quality_guardrail_models.dart';

const List<TVOSAnalyticsEventDefinition>
tvosAnalyticsEventDefinitions = <TVOSAnalyticsEventDefinition>[
  TVOSAnalyticsEventDefinition(
    name: 'tvos_app_bootstrap',
    surfaceId: TVOSSurfaceId.home,
    severity: TVOSAnalyticsSeverity.info,
    summary: 'Records Apple TV app bootstrap mode for local diagnostics.',
  ),
  TVOSAnalyticsEventDefinition(
    name: 'tvos_route_opened',
    surfaceId: TVOSSurfaceId.home,
    severity: TVOSAnalyticsSeverity.info,
    summary: 'Records route entry for sidebar-enabled tvOS surfaces.',
  ),
  TVOSAnalyticsEventDefinition(
    name: 'tvos_profile_switched',
    surfaceId: TVOSSurfaceId.profiles,
    severity: TVOSAnalyticsSeverity.info,
    summary: 'Records household profile switching for shared-device QA.',
  ),
  TVOSAnalyticsEventDefinition(
    name: 'tvos_settings_changed',
    surfaceId: TVOSSurfaceId.settings,
    severity: TVOSAnalyticsSeverity.warning,
    summary: 'Records startup and listening-default changes for tvOS-safe preferences.',
  ),
  TVOSAnalyticsEventDefinition(
    name: 'tvos_listening_mode_opened',
    surfaceId: TVOSSurfaceId.quran,
    severity: TVOSAnalyticsSeverity.info,
    summary: 'Records focused Qur’an listening-mode entry on tvOS.',
  ),
  TVOSAnalyticsEventDefinition(
    name: 'tvos_playback_error',
    surfaceId: TVOSSurfaceId.quran,
    severity: TVOSAnalyticsSeverity.critical,
    summary: 'Records playback failures for local crash-safety and QA review.',
  ),
];

const List<TVOSQualityGuardrailDefinition>
tvosQualityGuardrailDefinitions = <TVOSQualityGuardrailDefinition>[
  TVOSQualityGuardrailDefinition(
    surfaceId: TVOSSurfaceId.home,
    routePath: '/home',
    minimumPhase: TVOSPhaseId.phase24AnalyticsCrashQuality,
    requiresRouteTelemetry: true,
    requiresLocalCrashBuffer: true,
    requiresPlaybackErrorCapture: false,
    requiresFocusQaCoverage: true,
    summary: 'Home should emit route telemetry and retain focus QA coverage.',
  ),
  TVOSQualityGuardrailDefinition(
    surfaceId: TVOSSurfaceId.quran,
    routePath: '/quran',
    minimumPhase: TVOSPhaseId.phase24AnalyticsCrashQuality,
    requiresRouteTelemetry: true,
    requiresLocalCrashBuffer: true,
    requiresPlaybackErrorCapture: true,
    requiresFocusQaCoverage: true,
    summary: 'Qur’an requires route telemetry, playback-error capture, and focus QA coverage.',
  ),
  TVOSQualityGuardrailDefinition(
    surfaceId: TVOSSurfaceId.settings,
    routePath: '/settings',
    minimumPhase: TVOSPhaseId.phase24AnalyticsCrashQuality,
    requiresRouteTelemetry: true,
    requiresLocalCrashBuffer: true,
    requiresPlaybackErrorCapture: false,
    requiresFocusQaCoverage: true,
    summary: 'Settings should capture preference changes without pretending cloud diagnostics exist.',
  ),
  TVOSQualityGuardrailDefinition(
    surfaceId: TVOSSurfaceId.profiles,
    routePath: '/accounts-sync/profiles',
    minimumPhase: TVOSPhaseId.phase24AnalyticsCrashQuality,
    requiresRouteTelemetry: true,
    requiresLocalCrashBuffer: true,
    requiresPlaybackErrorCapture: false,
    requiresFocusQaCoverage: true,
    summary: 'Profiles should capture household switching and shared-device QA signals.',
  ),
];
