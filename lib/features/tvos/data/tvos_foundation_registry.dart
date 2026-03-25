import '../domain/tvos_foundation_models.dart';
import 'tvos_content_parity_manifest.dart';

const List<TVOSPhaseDefinition> tvosMasterPhaseDefinitions =
    <TVOSPhaseDefinition>[
      TVOSPhaseDefinition(
        id: TVOSPhaseId.phase1AuditArchitecture,
        displayOrder: 1,
        label: 'Phase 1',
        summary: 'tvOS product audit and architecture foundation',
      ),
      TVOSPhaseDefinition(
        id: TVOSPhaseId.phase2DesignSystem,
        displayOrder: 2,
        label: 'Phase 2',
        summary: 'shared design system and Path of Nur tvOS look and feel',
      ),
      TVOSPhaseDefinition(
        id: TVOSPhaseId.phase3ShellNavigation,
        displayOrder: 3,
        label: 'Phase 3',
        summary: 'app shell, navigation, focus engine, and route structure',
      ),
      TVOSPhaseDefinition(
        id: TVOSPhaseId.phase4SharedDomainParity,
        displayOrder: 4,
        label: 'Phase 4',
        summary: 'shared domain and content parity layer',
      ),
      TVOSPhaseDefinition(
        id: TVOSPhaseId.phase21FeatureFlagsParity,
        displayOrder: 5,
        label: 'Phase 21',
        summary: 'shared feature flag and parity system for future releases',
      ),
      TVOSPhaseDefinition(
        id: TVOSPhaseId.phase22ContentRegistryOnboarding,
        displayOrder: 6,
        label: 'Phase 22',
        summary: 'shared content registry and modular section onboarding',
      ),
      TVOSPhaseDefinition(
        id: TVOSPhaseId.phase5HomeContinueJourney,
        displayOrder: 7,
        label: 'Phase 5',
        summary: 'tvOS home screen and continue your journey',
      ),
      TVOSPhaseDefinition(
        id: TVOSPhaseId.phase6QuranBrowseReading,
        displayOrder: 8,
        label: 'Phase 6',
        summary: 'Qur’an browse and reading experience for tvOS',
      ),
      TVOSPhaseDefinition(
        id: TVOSPhaseId.phase7QuranAudioListening,
        displayOrder: 9,
        label: 'Phase 7',
        summary: 'Qur’an audio playback and full-screen listening mode',
      ),
      TVOSPhaseDefinition(
        id: TVOSPhaseId.phase10LearnHubLayout,
        displayOrder: 10,
        label: 'Phase 10',
        summary: 'learn hub master layout',
      ),
      TVOSPhaseDefinition(
        id: TVOSPhaseId.phase11StoriesProphetsReflection,
        displayOrder: 11,
        label: 'Phase 11',
        summary: 'stories, prophets, and reflection content',
      ),
      TVOSPhaseDefinition(
        id: TVOSPhaseId.phase15SignsCreationVisualLearning,
        displayOrder: 12,
        label: 'Phase 15',
        summary: 'signs, creation, and visual learning experiences',
      ),
      TVOSPhaseDefinition(
        id: TVOSPhaseId.phase8PrayerSection,
        displayOrder: 13,
        label: 'Phase 8',
        summary: 'prayer section for tvOS',
      ),
      TVOSPhaseDefinition(
        id: TVOSPhaseId.phase9DhikrGuidedRemembrance,
        displayOrder: 14,
        label: 'Phase 9',
        summary: 'dhikr and guided remembrance mode',
      ),
      TVOSPhaseDefinition(
        id: TVOSPhaseId.phase12KidsModeFamilySafeLearning,
        displayOrder: 15,
        label: 'Phase 12',
        summary: 'kids mode and family-safe TV learning',
      ),
      TVOSPhaseDefinition(
        id: TVOSPhaseId.phase13ArabicBeginnerLearning,
        displayOrder: 16,
        label: 'Phase 13',
        summary: 'Arabic letters and beginner learning on TV',
      ),
      TVOSPhaseDefinition(
        id: TVOSPhaseId.phase14GamesRemoteInteractivity,
        displayOrder: 17,
        label: 'Phase 14',
        summary: 'quizzes, games, and remote-friendly interactivity',
      ),
      TVOSPhaseDefinition(
        id: TVOSPhaseId.phase16FavoritesPlaylistsSaved,
        displayOrder: 18,
        label: 'Phase 16',
        summary: 'favorites, playlists, saved items, and watch-later flow',
      ),
      TVOSPhaseDefinition(
        id: TVOSPhaseId.phase17LocalizationReadabilityAccessibility,
        displayOrder: 19,
        label: 'Phase 17',
        summary: 'localization, readability, and accessibility for television',
      ),
      TVOSPhaseDefinition(
        id: TVOSPhaseId.phase18OfflineCachingSyncAware,
        displayOrder: 20,
        label: 'Phase 18',
        summary: 'offline content, caching, and sync-aware behavior',
      ),
      TVOSPhaseDefinition(
        id: TVOSPhaseId.phase19ProfilesHouseholdContinuity,
        displayOrder: 21,
        label: 'Phase 19',
        summary: 'profiles, household usage, and session continuity',
      ),
      TVOSPhaseDefinition(
        id: TVOSPhaseId.phase20SettingsPreferences,
        displayOrder: 22,
        label: 'Phase 20',
        summary: 'settings and tvOS-specific preferences',
      ),
      TVOSPhaseDefinition(
        id: TVOSPhaseId.phase24AnalyticsCrashQuality,
        displayOrder: 23,
        label: 'Phase 24',
        summary: 'analytics, crash safety, and quality guardrails',
      ),
      TVOSPhaseDefinition(
        id: TVOSPhaseId.phase25TestFocusRegression,
        displayOrder: 24,
        label: 'Phase 25',
        summary: 'test suite, focus navigation QA, and regression harness',
      ),
      TVOSPhaseDefinition(
        id: TVOSPhaseId.phase26PerformanceOptimization,
        displayOrder: 25,
        label: 'Phase 26',
        summary: 'performance optimization for large-screen media surfaces',
      ),
      TVOSPhaseDefinition(
        id: TVOSPhaseId.phase23UpdatePipelineGovernance,
        displayOrder: 26,
        label: 'Phase 23',
        summary: 'tvOS update pipeline and release governance',
      ),
      TVOSPhaseDefinition(
        id: TVOSPhaseId.phase27LaunchPolishReadiness,
        displayOrder: 27,
        label: 'Phase 27',
        summary:
            'launch polish, empty states, and production release readiness',
      ),
    ];

const List<TVOSSurfaceParityEntry>
tvosSurfaceParityEntries = <TVOSSurfaceParityEntry>[
  TVOSSurfaceParityEntry(
    id: TVOSSurfaceId.home,
    label: 'Home',
    sourceRoute: '/home',
    classification: TVOSParityClassification.adaptation,
    currentlyMirrored: true,
    targetPhase: TVOSPhaseId.phase5HomeContinueJourney,
    iosOwner: 'HomePage',
    tvosRationale:
        'Mirror the prayer-first dashboard direction, but present it as large remote-friendly shelves and summary cards.',
  ),
  TVOSSurfaceParityEntry(
    id: TVOSSurfaceId.quran,
    label: 'Quran',
    sourceRoute: '/quran',
    classification: TVOSParityClassification.adaptation,
    currentlyMirrored: true,
    targetPhase: TVOSPhaseId.phase6QuranBrowseReading,
    iosOwner: 'QuranAppHubPage and Quran reader surfaces',
    tvosRationale:
        'Mirror browse, continue, and listening direction while redesigning reading and playback around focus navigation.',
  ),
  TVOSSurfaceParityEntry(
    id: TVOSSurfaceId.learn,
    label: 'Learn',
    sourceRoute: '/learn',
    classification: TVOSParityClassification.adaptation,
    currentlyMirrored: true,
    targetPhase: TVOSPhaseId.phase10LearnHubLayout,
    iosOwner: 'LearningSectionLandingPage',
    tvosRationale:
        'Mirror the journey-first Learn direction as a browse-first curated hub rather than a dense mobile-style dashboard.',
  ),
  TVOSSurfaceParityEntry(
    id: TVOSSurfaceId.prayer,
    label: 'Prayer',
    sourceRoute: '/worship/prayer',
    classification: TVOSParityClassification.adaptation,
    currentlyMirrored: true,
    targetPhase: TVOSPhaseId.phase8PrayerSection,
    iosOwner: 'Worship prayer surfaces',
    tvosRationale:
        'Useful in the family room, but should follow shared prayer summaries and remote-friendly glance-first layouts.',
  ),
  TVOSSurfaceParityEntry(
    id: TVOSSurfaceId.dhikr,
    label: 'Dhikr',
    sourceRoute: '/worship/dhikr',
    classification: TVOSParityClassification.adaptation,
    currentlyMirrored: true,
    targetPhase: TVOSPhaseId.phase9DhikrGuidedRemembrance,
    iosOwner: 'Worship dhikr surfaces',
    tvosRationale:
        'Adapt for audio-led guided remembrance rather than touch-count interaction.',
  ),
  TVOSSurfaceParityEntry(
    id: TVOSSurfaceId.kids,
    label: 'Kids',
    sourceRoute: '/learn/kids/fun-learning',
    classification: TVOSParityClassification.adaptation,
    currentlyMirrored: true,
    targetPhase: TVOSPhaseId.phase12KidsModeFamilySafeLearning,
    iosOwner: 'Kids learning wrappers and story systems',
    tvosRationale:
        'Strong family-room fit when curated for mixed ages, lighter navigation, and safe shared-use learning.',
  ),
  TVOSSurfaceParityEntry(
    id: TVOSSurfaceId.arabic,
    label: 'Arabic',
    sourceRoute: '/quran/arabic',
    classification: TVOSParityClassification.adaptation,
    currentlyMirrored: true,
    targetPhase: TVOSPhaseId.phase13ArabicBeginnerLearning,
    iosOwner: 'Shared Arabic learning systems',
    tvosRationale:
        'Should emphasize listen, see, and choose interactions instead of typing or dense touch progression.',
  ),
  TVOSSurfaceParityEntry(
    id: TVOSSurfaceId.games,
    label: 'Games',
    sourceRoute: '/learn/games',
    classification: TVOSParityClassification.adaptation,
    currentlyMirrored: true,
    targetPhase: TVOSPhaseId.phase14GamesRemoteInteractivity,
    iosOwner: 'Learn games and quizzes surfaces',
    tvosRationale:
        'Only bring game types that feel natural on a remote and can be completed with low-friction focus controls.',
  ),
  TVOSSurfaceParityEntry(
    id: TVOSSurfaceId.favorites,
    label: 'Favorites',
    sourceRoute: '/quran/bookmarks',
    classification: TVOSParityClassification.adaptation,
    currentlyMirrored: true,
    targetPhase: TVOSPhaseId.phase16FavoritesPlaylistsSaved,
    iosOwner: 'Quran bookmarks, notes, and reflection saves',
    tvosRationale:
        'Read-only or queue-first saved state is a good fit; creation/editing should stay light.',
  ),
  TVOSSurfaceParityEntry(
    id: TVOSSurfaceId.settings,
    label: 'Settings',
    sourceRoute: '/settings',
    classification: TVOSParityClassification.adaptation,
    currentlyMirrored: true,
    targetPhase: TVOSPhaseId.phase20SettingsPreferences,
    iosOwner: 'SettingsPage',
    tvosRationale:
        'Only tvOS-specific preferences belong on TV; dense app settings should remain on iPhone/iPad.',
  ),
  TVOSSurfaceParityEntry(
    id: TVOSSurfaceId.profiles,
    label: 'Profiles',
    sourceRoute: '/accounts-sync/profiles',
    classification: TVOSParityClassification.adaptation,
    currentlyMirrored: true,
    targetPhase: TVOSPhaseId.phase19ProfilesHouseholdContinuity,
    iosOwner: 'Accounts, Profiles and Sync surfaces',
    tvosRationale:
        'Bring only household switching and continuity to TV, while full account, backup, and permission management stays on companion devices.',
  ),
  TVOSSurfaceParityEntry(
    id: TVOSSurfaceId.offline,
    label: 'Offline',
    sourceRoute: '/quran',
    classification: TVOSParityClassification.laterPhase,
    currentlyMirrored: false,
    targetPhase: TVOSPhaseId.phase18OfflineCachingSyncAware,
    iosOwner: 'Media and shared persistence systems',
    tvosRationale:
        'Offline behavior should be added after the shared content and playback contracts are stable.',
  ),
];

const List<TVOSSurfaceFlag> tvosSurfaceFlags = <TVOSSurfaceFlag>[
  TVOSSurfaceFlag(
    surfaceId: TVOSSurfaceId.home,
    routePath: '/home',
    availability: TVOSFeatureAvailability.enabled,
    releaseStage: TVOSReleaseStage.testflight,
    parityHealth: TVOSParityHealth.mirrored,
    requiresSharedParityPayload: true,
    allowInSidebar: true,
    notes:
        'Home is an active mirrored tvOS route and must remain in parity review.',
  ),
  TVOSSurfaceFlag(
    surfaceId: TVOSSurfaceId.quran,
    routePath: '/quran',
    availability: TVOSFeatureAvailability.enabled,
    releaseStage: TVOSReleaseStage.testflight,
    parityHealth: TVOSParityHealth.mirrored,
    requiresSharedParityPayload: true,
    allowInSidebar: true,
    notes:
        'Quran is an active mirrored tvOS route and should consume shared parity payloads before deeper expansion.',
  ),
  TVOSSurfaceFlag(
    surfaceId: TVOSSurfaceId.learn,
    routePath: '/learn',
    availability: TVOSFeatureAvailability.enabled,
    releaseStage: TVOSReleaseStage.testflight,
    parityHealth: TVOSParityHealth.adaptationRequired,
    requiresSharedParityPayload: false,
    allowInSidebar: true,
    notes:
        'Learn is now an active tvOS route with a curated master layout and should stay aligned with journey-first mobile Learn ownership.',
  ),
  TVOSSurfaceFlag(
    surfaceId: TVOSSurfaceId.games,
    routePath: '/learn/games',
    availability: TVOSFeatureAvailability.enabled,
    releaseStage: TVOSReleaseStage.testflight,
    parityHealth: TVOSParityHealth.adaptationRequired,
    requiresSharedParityPayload: false,
    allowInSidebar: true,
    notes:
        'Games is now an active tvOS route and should stay limited to remote-friendly quizzes and recognition-led challenge formats.',
  ),
  TVOSSurfaceFlag(
    surfaceId: TVOSSurfaceId.prayer,
    routePath: '/worship/prayer',
    availability: TVOSFeatureAvailability.enabled,
    releaseStage: TVOSReleaseStage.testflight,
    parityHealth: TVOSParityHealth.adaptationRequired,
    requiresSharedParityPayload: false,
    allowInSidebar: true,
    notes:
        'Prayer is now an active tvOS route with a calm glance-first layout and should stay aligned with mobile prayer ownership.',
  ),
  TVOSSurfaceFlag(
    surfaceId: TVOSSurfaceId.dhikr,
    routePath: '/worship/dhikr',
    availability: TVOSFeatureAvailability.enabled,
    releaseStage: TVOSReleaseStage.testflight,
    parityHealth: TVOSParityHealth.adaptationRequired,
    requiresSharedParityPayload: false,
    allowInSidebar: true,
    notes:
        'Dhikr is now an active tvOS route with guided-remembrance adaptation and should avoid touch-style counter porting.',
  ),
  TVOSSurfaceFlag(
    surfaceId: TVOSSurfaceId.kids,
    routePath: '/learn/kids/fun-learning',
    availability: TVOSFeatureAvailability.enabled,
    releaseStage: TVOSReleaseStage.testflight,
    parityHealth: TVOSParityHealth.adaptationRequired,
    requiresSharedParityPayload: false,
    allowInSidebar: true,
    notes:
        'Kids is now an active tvOS route with curated family-safe learning and should stay aligned with the broader kids product direction.',
  ),
  TVOSSurfaceFlag(
    surfaceId: TVOSSurfaceId.arabic,
    routePath: '/quran/arabic',
    availability: TVOSFeatureAvailability.enabled,
    releaseStage: TVOSReleaseStage.testflight,
    parityHealth: TVOSParityHealth.adaptationRequired,
    requiresSharedParityPayload: false,
    allowInSidebar: true,
    notes:
        'Arabic is now an active tvOS route under Qur’an ownership and should stay aligned with the broader shared Arabic learning direction.',
  ),
  TVOSSurfaceFlag(
    surfaceId: TVOSSurfaceId.favorites,
    routePath: '/quran/bookmarks',
    availability: TVOSFeatureAvailability.enabled,
    releaseStage: TVOSReleaseStage.testflight,
    parityHealth: TVOSParityHealth.adaptationRequired,
    requiresSharedParityPayload: true,
    allowInSidebar: true,
    notes:
        'Favorites is now an active tvOS route and should stay read-first, queue-first, and aligned with mobile bookmarks/saved-state ownership.',
  ),
  TVOSSurfaceFlag(
    surfaceId: TVOSSurfaceId.settings,
    routePath: '/settings',
    availability: TVOSFeatureAvailability.enabled,
    releaseStage: TVOSReleaseStage.testflight,
    parityHealth: TVOSParityHealth.adaptationRequired,
    requiresSharedParityPayload: false,
    allowInSidebar: true,
    notes:
        'Settings is now an active tvOS route for startup and listening defaults, while denser management stays on companion devices.',
  ),
  TVOSSurfaceFlag(
    surfaceId: TVOSSurfaceId.profiles,
    routePath: '/accounts-sync/profiles',
    availability: TVOSFeatureAvailability.enabled,
    releaseStage: TVOSReleaseStage.testflight,
    parityHealth: TVOSParityHealth.adaptationRequired,
    requiresSharedParityPayload: false,
    allowInSidebar: true,
    notes:
        'Profiles is now an active tvOS route for household switching and session continuity, while deeper account management stays on companion devices.',
  ),
  TVOSSurfaceFlag(
    surfaceId: TVOSSurfaceId.offline,
    routePath: '/quran',
    availability: TVOSFeatureAvailability.staged,
    releaseStage: TVOSReleaseStage.foundation,
    parityHealth: TVOSParityHealth.pendingSharedParity,
    requiresSharedParityPayload: true,
    allowInSidebar: false,
    notes: 'Offline behavior should wait for shared media/cache parity work.',
  ),
];

final List<TVOSSectionFlag> tvosSectionFlags = <TVOSSectionFlag>[
  ...tvosMirroredSectionManifests.map((manifest) {
    final availability =
        manifest.routePath == '/home' || manifest.routePath == '/quran'
        ? TVOSFeatureAvailability.enabled
        : TVOSFeatureAvailability.staged;
    return TVOSSectionFlag(
      sectionKey: manifest.contentKey,
      routePath: manifest.routePath,
      availability: availability,
      releaseStage: TVOSReleaseStage.testflight,
      parityHealth: availability == TVOSFeatureAvailability.enabled
          ? TVOSParityHealth.mirrored
          : TVOSParityHealth.pendingSharedParity,
      requiresSharedParityPayload: true,
      notes: manifest.phaseSummary,
    );
  }),
  const TVOSSectionFlag(
    sectionKey: 'favorites.primaryPaths',
    routePath: '/quran/bookmarks',
    availability: TVOSFeatureAvailability.enabled,
    releaseStage: TVOSReleaseStage.testflight,
    parityHealth: TVOSParityHealth.adaptationRequired,
    requiresSharedParityPayload: true,
    notes: 'Primary saved-lane selector for the tvOS Favorites route.',
  ),
  const TVOSSectionFlag(
    sectionKey: 'favorites.savedItems',
    routePath: '/quran/bookmarks',
    availability: TVOSFeatureAvailability.enabled,
    releaseStage: TVOSReleaseStage.testflight,
    parityHealth: TVOSParityHealth.adaptationRequired,
    requiresSharedParityPayload: true,
    notes: 'Saved-item resume shelf for the tvOS Favorites route.',
  ),
  const TVOSSectionFlag(
    sectionKey: 'favorites.watchLater',
    routePath: '/quran/bookmarks',
    availability: TVOSFeatureAvailability.enabled,
    releaseStage: TVOSReleaseStage.testflight,
    parityHealth: TVOSParityHealth.adaptationRequired,
    requiresSharedParityPayload: true,
    notes:
        'Watch-later and playlist continuity stage for the tvOS Favorites route.',
  ),
  const TVOSSectionFlag(
    sectionKey: 'games.primaryPaths',
    routePath: '/learn/games',
    availability: TVOSFeatureAvailability.enabled,
    releaseStage: TVOSReleaseStage.testflight,
    parityHealth: TVOSParityHealth.adaptationRequired,
    requiresSharedParityPayload: false,
    notes: 'Primary game-path selector for the tvOS Games route.',
  ),
  const TVOSSectionFlag(
    sectionKey: 'games.challenges',
    routePath: '/learn/games',
    availability: TVOSFeatureAvailability.enabled,
    releaseStage: TVOSReleaseStage.testflight,
    parityHealth: TVOSParityHealth.adaptationRequired,
    requiresSharedParityPayload: false,
    notes: 'Interactive challenge stage for the tvOS Games route.',
  ),
  const TVOSSectionFlag(
    sectionKey: 'games.familyGuidance',
    routePath: '/learn/games',
    availability: TVOSFeatureAvailability.enabled,
    releaseStage: TVOSReleaseStage.testflight,
    parityHealth: TVOSParityHealth.adaptationRequired,
    requiresSharedParityPayload: false,
    notes: 'Family-room guidance shelf for the tvOS Games route.',
  ),
  const TVOSSectionFlag(
    sectionKey: 'settings.startup',
    routePath: '/settings',
    availability: TVOSFeatureAvailability.enabled,
    releaseStage: TVOSReleaseStage.testflight,
    parityHealth: TVOSParityHealth.adaptationRequired,
    requiresSharedParityPayload: false,
    notes: 'Startup-behavior selector for the tvOS Settings route.',
  ),
  const TVOSSectionFlag(
    sectionKey: 'settings.listeningDefaults',
    routePath: '/settings',
    availability: TVOSFeatureAvailability.enabled,
    releaseStage: TVOSReleaseStage.testflight,
    parityHealth: TVOSParityHealth.adaptationRequired,
    requiresSharedParityPayload: false,
    notes: 'Default reciter and listening-helper preferences for tvOS.',
  ),
  const TVOSSectionFlag(
    sectionKey: 'settings.tvPreferences',
    routePath: '/settings',
    availability: TVOSFeatureAvailability.enabled,
    releaseStage: TVOSReleaseStage.testflight,
    parityHealth: TVOSParityHealth.adaptationRequired,
    requiresSharedParityPayload: false,
    notes: 'tvOS-specific preference guidance and companion-device boundary module.',
  ),
  const TVOSSectionFlag(
    sectionKey: 'profiles.primarySwitcher',
    routePath: '/accounts-sync/profiles',
    availability: TVOSFeatureAvailability.enabled,
    releaseStage: TVOSReleaseStage.testflight,
    parityHealth: TVOSParityHealth.adaptationRequired,
    requiresSharedParityPayload: false,
    notes: 'Household profile switcher stage for the tvOS Profiles route.',
  ),
  const TVOSSectionFlag(
    sectionKey: 'profiles.sessionContinuity',
    routePath: '/accounts-sync/profiles',
    availability: TVOSFeatureAvailability.enabled,
    releaseStage: TVOSReleaseStage.testflight,
    parityHealth: TVOSParityHealth.adaptationRequired,
    requiresSharedParityPayload: false,
    notes: 'Per-profile resume and continuity stage for the tvOS Profiles route.',
  ),
  const TVOSSectionFlag(
    sectionKey: 'profiles.householdGuidance',
    routePath: '/accounts-sync/profiles',
    availability: TVOSFeatureAvailability.enabled,
    releaseStage: TVOSReleaseStage.testflight,
    parityHealth: TVOSParityHealth.adaptationRequired,
    requiresSharedParityPayload: false,
    notes:
        'Shared-device and companion-handoff guidance for the tvOS Profiles route.',
  ),
  const TVOSSectionFlag(
    sectionKey: 'prayer.currentNext',
    routePath: '/worship/prayer',
    availability: TVOSFeatureAvailability.enabled,
    releaseStage: TVOSReleaseStage.testflight,
    parityHealth: TVOSParityHealth.adaptationRequired,
    requiresSharedParityPayload: false,
    notes: 'Current-and-next salah summary module for the tvOS Prayer route.',
  ),
  const TVOSSectionFlag(
    sectionKey: 'prayer.schedule',
    routePath: '/worship/prayer',
    availability: TVOSFeatureAvailability.enabled,
    releaseStage: TVOSReleaseStage.testflight,
    parityHealth: TVOSParityHealth.adaptationRequired,
    requiresSharedParityPayload: false,
    notes: 'Full-day schedule module for the tvOS Prayer route.',
  ),
  const TVOSSectionFlag(
    sectionKey: 'prayer.companion',
    routePath: '/worship/prayer',
    availability: TVOSFeatureAvailability.enabled,
    releaseStage: TVOSReleaseStage.testflight,
    parityHealth: TVOSParityHealth.adaptationRequired,
    requiresSharedParityPayload: false,
    notes:
        'Presence and preparation companion module for the tvOS Prayer route.',
  ),
  const TVOSSectionFlag(
    sectionKey: 'dhikr.modes',
    routePath: '/worship/dhikr',
    availability: TVOSFeatureAvailability.enabled,
    releaseStage: TVOSReleaseStage.testflight,
    parityHealth: TVOSParityHealth.adaptationRequired,
    requiresSharedParityPayload: false,
    notes: 'Guided remembrance mode selector for the tvOS Dhikr route.',
  ),
  const TVOSSectionFlag(
    sectionKey: 'dhikr.guidedFlow',
    routePath: '/worship/dhikr',
    availability: TVOSFeatureAvailability.enabled,
    releaseStage: TVOSReleaseStage.testflight,
    parityHealth: TVOSParityHealth.adaptationRequired,
    requiresSharedParityPayload: false,
    notes:
        'Phrase-by-phrase guided remembrance stage for the tvOS Dhikr route.',
  ),
  const TVOSSectionFlag(
    sectionKey: 'dhikr.companion',
    routePath: '/worship/dhikr',
    availability: TVOSFeatureAvailability.enabled,
    releaseStage: TVOSReleaseStage.testflight,
    parityHealth: TVOSParityHealth.adaptationRequired,
    requiresSharedParityPayload: false,
    notes: 'Companion guidance shelf for the tvOS Dhikr route.',
  ),
  const TVOSSectionFlag(
    sectionKey: 'arabic.primaryPaths',
    routePath: '/quran/arabic',
    availability: TVOSFeatureAvailability.enabled,
    releaseStage: TVOSReleaseStage.testflight,
    parityHealth: TVOSParityHealth.adaptationRequired,
    requiresSharedParityPayload: false,
    notes: 'Primary path selector for the tvOS Arabic route.',
  ),
  const TVOSSectionFlag(
    sectionKey: 'arabic.letterGroups',
    routePath: '/quran/arabic',
    availability: TVOSFeatureAvailability.enabled,
    releaseStage: TVOSReleaseStage.testflight,
    parityHealth: TVOSParityHealth.adaptationRequired,
    requiresSharedParityPayload: false,
    notes: 'Letter-group browse stage for the tvOS Arabic route.',
  ),
  const TVOSSectionFlag(
    sectionKey: 'arabic.familyGuidance',
    routePath: '/quran/arabic',
    availability: TVOSFeatureAvailability.enabled,
    releaseStage: TVOSReleaseStage.testflight,
    parityHealth: TVOSParityHealth.adaptationRequired,
    requiresSharedParityPayload: false,
    notes: 'Family and learner guidance stage for the tvOS Arabic route.',
  ),
  const TVOSSectionFlag(
    sectionKey: 'kids.primaryPaths',
    routePath: '/learn/kids/fun-learning',
    availability: TVOSFeatureAvailability.enabled,
    releaseStage: TVOSReleaseStage.testflight,
    parityHealth: TVOSParityHealth.adaptationRequired,
    requiresSharedParityPayload: false,
    notes: 'Primary family-safe path selector for the tvOS Kids route.',
  ),
  const TVOSSectionFlag(
    sectionKey: 'kids.featuredStories',
    routePath: '/learn/kids/fun-learning',
    availability: TVOSFeatureAvailability.enabled,
    releaseStage: TVOSReleaseStage.testflight,
    parityHealth: TVOSParityHealth.adaptationRequired,
    requiresSharedParityPayload: false,
    notes: 'Featured story shelf for the tvOS Kids route.',
  ),
  const TVOSSectionFlag(
    sectionKey: 'kids.familyGuidance',
    routePath: '/learn/kids/fun-learning',
    availability: TVOSFeatureAvailability.enabled,
    releaseStage: TVOSReleaseStage.testflight,
    parityHealth: TVOSParityHealth.adaptationRequired,
    requiresSharedParityPayload: false,
    notes: 'Family-safe guidance shelf for the tvOS Kids route.',
  ),
  const TVOSSectionFlag(
    sectionKey: 'learn.primaryPaths',
    routePath: '/learn',
    availability: TVOSFeatureAvailability.enabled,
    releaseStage: TVOSReleaseStage.testflight,
    parityHealth: TVOSParityHealth.adaptationRequired,
    requiresSharedParityPayload: false,
    notes: 'Primary path selection module for the tvOS Learn hub.',
  ),
  const TVOSSectionFlag(
    sectionKey: 'learn.storiesReflection',
    routePath: '/learn',
    availability: TVOSFeatureAvailability.enabled,
    releaseStage: TVOSReleaseStage.testflight,
    parityHealth: TVOSParityHealth.adaptationRequired,
    requiresSharedParityPayload: false,
    notes: 'Stories and reflection shelf cluster for the tvOS Learn hub.',
  ),
  const TVOSSectionFlag(
    sectionKey: 'learn.prophetsStories',
    routePath: '/learn',
    availability: TVOSFeatureAvailability.enabled,
    releaseStage: TVOSReleaseStage.testflight,
    parityHealth: TVOSParityHealth.adaptationRequired,
    requiresSharedParityPayload: false,
    notes: 'Prophetic stories stage for the tvOS Learn route.',
  ),
  const TVOSSectionFlag(
    sectionKey: 'learn.seerahReflection',
    routePath: '/learn',
    availability: TVOSFeatureAvailability.enabled,
    releaseStage: TVOSReleaseStage.testflight,
    parityHealth: TVOSParityHealth.adaptationRequired,
    requiresSharedParityPayload: false,
    notes: 'Seerah-focused reflection stage for the tvOS Learn route.',
  ),
  const TVOSSectionFlag(
    sectionKey: 'learn.dailyWisdom',
    routePath: '/learn',
    availability: TVOSFeatureAvailability.enabled,
    releaseStage: TVOSReleaseStage.testflight,
    parityHealth: TVOSParityHealth.adaptationRequired,
    requiresSharedParityPayload: false,
    notes: 'Short daily wisdom and reflection stage for the tvOS Learn route.',
  ),
  const TVOSSectionFlag(
    sectionKey: 'learn.knowledgeDomains',
    routePath: '/learn',
    availability: TVOSFeatureAvailability.enabled,
    releaseStage: TVOSReleaseStage.testflight,
    parityHealth: TVOSParityHealth.adaptationRequired,
    requiresSharedParityPayload: false,
    notes: 'Knowledge-domain shelf cluster for the tvOS Learn hub.',
  ),
  const TVOSSectionFlag(
    sectionKey: 'learn.signsCreation',
    routePath: '/learn',
    availability: TVOSFeatureAvailability.enabled,
    releaseStage: TVOSReleaseStage.testflight,
    parityHealth: TVOSParityHealth.adaptationRequired,
    requiresSharedParityPayload: false,
    notes: 'Signs-in-creation visual learning stage for the tvOS Learn route.',
  ),
  const TVOSSectionFlag(
    sectionKey: 'learn.visualObservation',
    routePath: '/learn',
    availability: TVOSFeatureAvailability.enabled,
    releaseStage: TVOSReleaseStage.testflight,
    parityHealth: TVOSParityHealth.adaptationRequired,
    requiresSharedParityPayload: false,
    notes:
        'Observation-first visual reflection stage for the tvOS Learn route.',
  ),
];

bool isCurrentlyMirroredTVOSSurface(String route) {
  return tvosSurfaceParityEntries.any(
    (entry) => entry.currentlyMirrored && route == entry.sourceRoute,
  );
}

TVOSSurfaceFlag? tvosSurfaceFlagForRoute(String route) {
  for (final flag in tvosSurfaceFlags) {
    if (flag.routePath == route) {
      return flag;
    }
  }
  return null;
}

List<TVOSSectionFlag> tvosSectionFlagsForRoute(String route) {
  return tvosSectionFlags
      .where((flag) => flag.routePath == route)
      .toList(growable: false);
}

bool isTVOSArchitectureFoundationPhase(TVOSPhaseId phaseId) {
  switch (phaseId) {
    case TVOSPhaseId.phase1AuditArchitecture:
    case TVOSPhaseId.phase2DesignSystem:
    case TVOSPhaseId.phase3ShellNavigation:
    case TVOSPhaseId.phase4SharedDomainParity:
    case TVOSPhaseId.phase21FeatureFlagsParity:
    case TVOSPhaseId.phase22ContentRegistryOnboarding:
      return true;
    default:
      return false;
  }
}
