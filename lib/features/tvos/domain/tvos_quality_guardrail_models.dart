import 'tvos_foundation_models.dart';

enum TVOSDiagnosticsMode {
  localBufferOnly,
  localBufferWithCompanionExport,
}

enum TVOSAnalyticsSeverity {
  info,
  warning,
  critical,
}

class TVOSAnalyticsEventDefinition {
  const TVOSAnalyticsEventDefinition({
    required this.name,
    required this.surfaceId,
    required this.severity,
    required this.summary,
  });

  final String name;
  final TVOSSurfaceId surfaceId;
  final TVOSAnalyticsSeverity severity;
  final String summary;
}

class TVOSQualityGuardrailDefinition {
  const TVOSQualityGuardrailDefinition({
    required this.surfaceId,
    required this.routePath,
    required this.minimumPhase,
    required this.requiresRouteTelemetry,
    required this.requiresLocalCrashBuffer,
    required this.requiresPlaybackErrorCapture,
    required this.requiresFocusQaCoverage,
    required this.summary,
  });

  final TVOSSurfaceId surfaceId;
  final String routePath;
  final TVOSPhaseId minimumPhase;
  final bool requiresRouteTelemetry;
  final bool requiresLocalCrashBuffer;
  final bool requiresPlaybackErrorCapture;
  final bool requiresFocusQaCoverage;
  final String summary;
}
