import '../domain/tvos_foundation_models.dart';
import '../domain/tvos_release_governance_models.dart';

const TVOSUpdateChannel tvosCurrentUpdateChannel = TVOSUpdateChannel.testflight;

const List<TVOSPhaseId> tvosGovernedReleasePhases = <TVOSPhaseId>[
  TVOSPhaseId.phase21FeatureFlagsParity,
  TVOSPhaseId.phase22ContentRegistryOnboarding,
  TVOSPhaseId.phase24AnalyticsCrashQuality,
  TVOSPhaseId.phase25TestFocusRegression,
  TVOSPhaseId.phase26PerformanceOptimization,
  TVOSPhaseId.phase23UpdatePipelineGovernance,
];

const List<TVOSReleaseGate> tvosReleaseGovernanceGates = <TVOSReleaseGate>[
  TVOSReleaseGate(
    id: TVOSReleaseGateId.unsignedReleaseBuild,
    label: 'Unsigned tvOS Release build',
    isPassing: true,
    blocksPromotion: true,
    notes:
        'Repo-side unsigned Release build must stay green before any governed update is promoted.',
  ),
  TVOSReleaseGate(
    id: TVOSReleaseGateId.focusRegressionHarness,
    label: 'Focus regression harness',
    isPassing: true,
    blocksPromotion: true,
    notes:
        'Enabled sidebar routes must remain covered by the shared focus regression matrix.',
  ),
  TVOSReleaseGate(
    id: TVOSReleaseGateId.diagnosticsGuardrails,
    label: 'Diagnostics and crash guardrails',
    isPassing: true,
    blocksPromotion: true,
    notes:
        'Local-first telemetry and playback failure capture must stay active for governed tvOS updates.',
  ),
  TVOSReleaseGate(
    id: TVOSReleaseGateId.performanceProfiles,
    label: 'Large-surface performance profile',
    isPassing: true,
    blocksPromotion: true,
    notes:
        'Home, Qur’an, and Learn must stay aligned with the shared large-surface performance contract.',
  ),
  TVOSReleaseGate(
    id: TVOSReleaseGateId.testflightChecklist,
    label: 'TestFlight checklist maintained',
    isPassing: true,
    blocksPromotion: true,
    notes:
        'The release checklist must reflect the real governed route scope instead of stale V1-only assumptions.',
  ),
  TVOSReleaseGate(
    id: TVOSReleaseGateId.companionManagedSyncPosture,
    label: 'Companion-managed sync posture',
    isPassing: true,
    blocksPromotion: true,
    notes:
        'tvOS must continue to avoid claiming production cloud management or full device-authoring sync.',
  ),
  TVOSReleaseGate(
    id: TVOSReleaseGateId.realDeviceQaRequired,
    label: 'Real-device Apple TV QA',
    isPassing: false,
    blocksPromotion: true,
    notes:
        'Public-store promotion stays blocked until the current governed route set has real-device QA evidence.',
  ),
];
