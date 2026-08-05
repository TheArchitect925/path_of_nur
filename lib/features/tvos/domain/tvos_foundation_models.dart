enum TVOSParityClassification { directReuse, adaptation, laterPhase, iosOnly }

enum TVOSReleaseStage { foundation, testflight, limitedRelease, publicLaunch }

enum TVOSFeatureAvailability { enabled, staged, hidden, iosOnly }

enum TVOSParityHealth {
  mirrored,
  adaptationRequired,
  pendingSharedParity,
  deferred,
  intentionallyUnavailable,
}

enum TVOSPhaseId {
  phase1AuditArchitecture,
  phase2DesignSystem,
  phase3ShellNavigation,
  phase4SharedDomainParity,
  phase21FeatureFlagsParity,
  phase22ContentRegistryOnboarding,
  phase5HomeContinueJourney,
  phase6QuranBrowseReading,
  phase7QuranAudioListening,
  phase10LearnHubLayout,
  phase11StoriesProphetsReflection,
  phase15SignsCreationVisualLearning,
  phase8PrayerSection,
  phase9DhikrGuidedRemembrance,
  phase12KidsModeFamilySafeLearning,
  phase13ArabicBeginnerLearning,
  phase14GamesRemoteInteractivity,
  phase16FavoritesPlaylistsSaved,
  phase17LocalizationReadabilityAccessibility,
  phase18OfflineCachingSyncAware,
  phase19ProfilesHouseholdContinuity,
  phase20SettingsPreferences,
  phase24AnalyticsCrashQuality,
  phase25TestFocusRegression,
  phase26PerformanceOptimization,
  phase23UpdatePipelineGovernance,
  phase27LaunchPolishReadiness,
}

enum TVOSSurfaceId {
  home,
  quran,
  learn,
  prayer,
  dhikr,
  kids,
  arabic,
  games,
  favorites,
  settings,
  profiles,
  offline,
}

class TVOSPhaseDefinition {
  const TVOSPhaseDefinition({
    required this.id,
    required this.displayOrder,
    required this.label,
    required this.summary,
  });

  final TVOSPhaseId id;
  final int displayOrder;
  final String label;
  final String summary;
}

class TVOSSurfaceParityEntry {
  const TVOSSurfaceParityEntry({
    required this.id,
    required this.label,
    required this.sourceRoute,
    required this.classification,
    required this.currentlyMirrored,
    required this.targetPhase,
    required this.iosOwner,
    required this.tvosRationale,
  });

  final TVOSSurfaceId id;
  final String label;
  final String sourceRoute;
  final TVOSParityClassification classification;
  final bool currentlyMirrored;
  final TVOSPhaseId targetPhase;
  final String iosOwner;
  final String tvosRationale;
}

class TVOSSurfaceFlag {
  const TVOSSurfaceFlag({
    required this.surfaceId,
    required this.routePath,
    required this.availability,
    required this.releaseStage,
    required this.parityHealth,
    required this.requiresSharedParityPayload,
    required this.allowInSidebar,
    required this.notes,
  });

  final TVOSSurfaceId surfaceId;
  final String routePath;
  final TVOSFeatureAvailability availability;
  final TVOSReleaseStage releaseStage;
  final TVOSParityHealth parityHealth;
  final bool requiresSharedParityPayload;
  final bool allowInSidebar;
  final String notes;
}

class TVOSSectionFlag {
  const TVOSSectionFlag({
    required this.sectionKey,
    required this.routePath,
    required this.availability,
    required this.releaseStage,
    required this.parityHealth,
    required this.requiresSharedParityPayload,
    required this.notes,
  });

  final String sectionKey;
  final String routePath;
  final TVOSFeatureAvailability availability;
  final TVOSReleaseStage releaseStage;
  final TVOSParityHealth parityHealth;
  final bool requiresSharedParityPayload;
  final String notes;
}
