import '../domain/tvos_foundation_models.dart';
import '../domain/tvos_launch_readiness_models.dart';

const List<TVOSPhaseId> tvosLaunchReadinessPhases = <TVOSPhaseId>[
  TVOSPhaseId.phase17LocalizationReadabilityAccessibility,
  TVOSPhaseId.phase23UpdatePipelineGovernance,
  TVOSPhaseId.phase24AnalyticsCrashQuality,
  TVOSPhaseId.phase25TestFocusRegression,
  TVOSPhaseId.phase26PerformanceOptimization,
  TVOSPhaseId.phase27LaunchPolishReadiness,
];

const List<TVOSDistributionEvidenceRecord> tvosLaunchDistributionEvidence =
    <TVOSDistributionEvidenceRecord>[
      TVOSDistributionEvidenceRecord(
        id: TVOSDistributionEvidenceId.signedArchive,
        label: 'Signed tvOS archive proof',
        status: TVOSDistributionEvidenceStatus.missing,
        reference: 'Awaiting Organizer archive or exported archive evidence.',
        notes:
            'Record the signed Xcode Organizer archive result here once a real signed tvOS archive exists.',
      ),
      TVOSDistributionEvidenceRecord(
        id: TVOSDistributionEvidenceId.testflightUpload,
        label: 'TestFlight upload proof',
        status: TVOSDistributionEvidenceStatus.missing,
        reference: 'Awaiting App Store Connect or Organizer upload evidence.',
        notes:
            'Record the uploaded TestFlight build reference here once the signed tvOS archive is accepted by App Store Connect.',
      ),
    ];

const List<TVOSLaunchReadinessGate> tvosBaseLaunchReadinessGates =
    <TVOSLaunchReadinessGate>[
      TVOSLaunchReadinessGate(
        id: TVOSLaunchReadinessGateId.repoSideReleaseBuild,
        label: 'Repo-side Release build',
        isPassing: true,
        blocksTestflight: true,
        blocksPublicLaunch: true,
        notes:
            'Unsigned repo-side tvOS Release builds must stay green before test distribution or public promotion.',
      ),
      TVOSLaunchReadinessGate(
        id: TVOSLaunchReadinessGateId.launchPolishEmptyStates,
        label: 'Launch polish and empty-state coverage',
        isPassing: true,
        blocksTestflight: true,
        blocksPublicLaunch: true,
        notes:
            'Optional shelves and detail rails should fail calmly instead of collapsing into blank large-screen surfaces.',
      ),
      TVOSLaunchReadinessGate(
        id: TVOSLaunchReadinessGateId.localizationAccessibility,
        label: 'Localization and readability hardening',
        isPassing: true,
        blocksTestflight: true,
        blocksPublicLaunch: true,
        notes:
            'Current tvOS strings and large-screen accessibility/readability protections must remain in place.',
      ),
      TVOSLaunchReadinessGate(
        id: TVOSLaunchReadinessGateId.focusRegressionCoverage,
        label: 'Focus regression coverage',
        isPassing: true,
        blocksTestflight: true,
        blocksPublicLaunch: true,
        notes:
            'Enabled sidebar routes must remain covered by the shared focus regression matrix.',
      ),
      TVOSLaunchReadinessGate(
        id: TVOSLaunchReadinessGateId.releaseGovernanceAligned,
        label: 'Release governance aligned',
        isPassing: true,
        blocksTestflight: true,
        blocksPublicLaunch: true,
        notes:
            'The governed route set, checklist, and phase requirements must stay aligned with the current tvOS shell.',
      ),
      TVOSLaunchReadinessGate(
        id: TVOSLaunchReadinessGateId.signedArchiveDistribution,
        label: 'Signed archive and distribution proof',
        isPassing: false,
        blocksTestflight: false,
        blocksPublicLaunch: true,
        notes:
            'Public launch remains blocked until the shared launch-readiness contract records both signed-archive and TestFlight upload proof.',
      ),
      TVOSLaunchReadinessGate(
        id: TVOSLaunchReadinessGateId.realDeviceAppleTvQa,
        label: 'Real-device Apple TV QA',
        isPassing: false,
        blocksTestflight: false,
        blocksPublicLaunch: true,
        notes:
            'Public launch remains blocked until the active route set has real-device focus, playback, and readability QA evidence.',
      ),
    ];
