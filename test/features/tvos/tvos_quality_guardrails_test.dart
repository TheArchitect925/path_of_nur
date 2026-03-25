import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/tvos/application/tvos_quality_guardrails.dart';
import 'package:path_of_nur/features/tvos/data/tvos_quality_guardrails.dart';
import 'package:path_of_nur/features/tvos/domain/tvos_foundation_models.dart';
import 'package:path_of_nur/features/tvos/domain/tvos_quality_guardrail_models.dart';

void main() {
  test('quality guardrails stay local-first for current tvOS diagnostics', () {
    expect(tvosUsesLocalOnlyDiagnostics(), isTrue);
  });

  test('active quality guardrails include quran, settings, and profiles', () {
    final guardrails = activeTVOSQualityGuardrails();
    final ids = guardrails.map((guardrail) => guardrail.surfaceId).toSet();

    expect(ids, contains(TVOSSurfaceId.quran));
    expect(ids, contains(TVOSSurfaceId.settings));
    expect(ids, contains(TVOSSurfaceId.profiles));
  });

  test('quran guardrail requires playback error capture and focus QA', () {
    final quranGuardrail = tvosQualityGuardrailDefinitions.firstWhere(
      (guardrail) => guardrail.routePath == '/quran',
    );

    expect(quranGuardrail.requiresPlaybackErrorCapture, isTrue);
    expect(quranGuardrail.requiresFocusQaCoverage, isTrue);
    expect(
      quranGuardrail.minimumPhase,
      TVOSPhaseId.phase24AnalyticsCrashQuality,
    );
  });

  test('settings analytics include mutable preference changes', () {
    final settingsEvents = tvosAnalyticsEventDefinitions
        .where((event) => event.surfaceId == TVOSSurfaceId.settings)
        .toList(growable: false);

    expect(settingsEvents, isNotEmpty);
    expect(
      settingsEvents.map((event) => event.name),
      contains('tvos_settings_changed'),
    );
    expect(
      settingsEvents.firstWhere((event) => event.name == 'tvos_settings_changed').severity,
      TVOSAnalyticsSeverity.warning,
    );
  });
}
