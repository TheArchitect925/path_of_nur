import 'tvos_foundation_models.dart';

enum TVOSContentModuleId {
  homePrayerSummary,
  homeContinueJourney,
  homeDailyVerse,
  quranContinueReading,
  quranDailyVerse,
  quranBrowse,
  quranPlayback,
  favoritesPrimaryPaths,
  favoritesSavedItems,
  favoritesWatchLater,
  settingsStartup,
  settingsListeningDefaults,
  settingsTVPreferences,
  prayerCurrentNext,
  prayerSchedule,
  prayerCompanion,
  dhikrModes,
  dhikrGuidedFlow,
  dhikrCompanion,
  kidsPrimaryPaths,
  kidsFeaturedStories,
  kidsFamilyGuidance,
  arabicPrimaryPaths,
  arabicLetterGroups,
  arabicFamilyGuidance,
  gamesPrimaryPaths,
  gamesChallenges,
  gamesFamilyGuidance,
  profilesPrimarySwitcher,
  profilesSessionContinuity,
  profilesHouseholdGuidance,
  learnPrimaryPaths,
  learnStoriesReflection,
  learnProphetsStories,
  learnSeerahReflection,
  learnDailyWisdom,
  learnSignsCreation,
  learnVisualObservation,
  learnKnowledgeDomains,
}

enum TVOSContentModuleKind {
  summary,
  continueJourney,
  featuredReflection,
  browse,
  playback,
  hub,
}

class TVOSContentModuleDefinition {
  const TVOSContentModuleDefinition({
    required this.id,
    required this.sectionKey,
    required this.routePath,
    required this.order,
    required this.kind,
    required this.surfaceId,
    required this.minimumPhase,
    required this.requiredReleaseStage,
    required this.requiresSharedParityPayload,
    required this.dependsOnSectionKeys,
    required this.summary,
  });

  final TVOSContentModuleId id;
  final String sectionKey;
  final String routePath;
  final int order;
  final TVOSContentModuleKind kind;
  final TVOSSurfaceId surfaceId;
  final TVOSPhaseId minimumPhase;
  final TVOSReleaseStage requiredReleaseStage;
  final bool requiresSharedParityPayload;
  final List<String> dependsOnSectionKeys;
  final String summary;
}

class TVOSRouteContentBundle {
  const TVOSRouteContentBundle({
    required this.routePath,
    required this.surfaceId,
    required this.modules,
  });

  final String routePath;
  final TVOSSurfaceId surfaceId;
  final List<TVOSContentModuleDefinition> modules;
}
