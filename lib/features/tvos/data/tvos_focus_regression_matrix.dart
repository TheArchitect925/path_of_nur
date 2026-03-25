import '../domain/tvos_focus_regression_models.dart';
import '../domain/tvos_foundation_models.dart';

const List<TVOSFocusQaScenario> tvosFocusQaScenarios = <
    TVOSFocusQaScenario>[
  TVOSFocusQaScenario(
    surfaceId: TVOSSurfaceId.home,
    routePath: '/home',
    defaultSectionId: 'home.continueJourney',
    orderedSectionIds: <String>[
      'home.continueJourney',
      'home.verse',
    ],
    requiresLeftEdgeNavigationEscape: true,
    requiresContentFocusRestore: true,
    requiresNavigationRestore: true,
    requiresModalReturnCoverage: false,
    risk: TVOSFocusRegressionRisk.medium,
    notes:
        'Home must restore the continue-journey lane cleanly after sidebar return and inter-route navigation.',
  ),
  TVOSFocusQaScenario(
    surfaceId: TVOSSurfaceId.profiles,
    routePath: '/accounts-sync/profiles',
    defaultSectionId: 'profiles.primary',
    orderedSectionIds: <String>[
      'profiles.primary',
      'profiles.continuity',
      'profiles.support',
    ],
    requiresLeftEdgeNavigationEscape: true,
    requiresContentFocusRestore: true,
    requiresNavigationRestore: true,
    requiresModalReturnCoverage: false,
    risk: TVOSFocusRegressionRisk.medium,
    notes:
        'Profiles must keep household switching and per-profile continuity stable when returning from the sidebar.',
  ),
  TVOSFocusQaScenario(
    surfaceId: TVOSSurfaceId.quran,
    routePath: '/quran',
    defaultSectionId: 'quran.browse',
    orderedSectionIds: <String>[
      'quran.browse',
      'quran.reader',
      'quran.playback',
    ],
    requiresLeftEdgeNavigationEscape: true,
    requiresContentFocusRestore: true,
    requiresNavigationRestore: true,
    requiresModalReturnCoverage: true,
    risk: TVOSFocusRegressionRisk.high,
    notes:
        'Qur\'an needs the strongest regression coverage because browse, reader, playback, and listening-mode return all share focus state.',
  ),
  TVOSFocusQaScenario(
    surfaceId: TVOSSurfaceId.favorites,
    routePath: '/quran/bookmarks',
    defaultSectionId: 'favorites.primary',
    orderedSectionIds: <String>[
      'favorites.primary',
      'favorites.saved',
      'favorites.support',
    ],
    requiresLeftEdgeNavigationEscape: true,
    requiresContentFocusRestore: true,
    requiresNavigationRestore: true,
    requiresModalReturnCoverage: false,
    risk: TVOSFocusRegressionRisk.medium,
    notes:
        'Saved needs stable lane order and sidebar return so resume-first continuity does not drift.',
  ),
  TVOSFocusQaScenario(
    surfaceId: TVOSSurfaceId.settings,
    routePath: '/settings',
    defaultSectionId: 'settings.startup',
    orderedSectionIds: <String>[
      'settings.startup',
      'settings.listening',
      'settings.support',
    ],
    requiresLeftEdgeNavigationEscape: true,
    requiresContentFocusRestore: true,
    requiresNavigationRestore: true,
    requiresModalReturnCoverage: false,
    risk: TVOSFocusRegressionRisk.medium,
    notes:
        'Settings must preserve startup and listening preference sections, plus the diagnostics summary lane.',
  ),
  TVOSFocusQaScenario(
    surfaceId: TVOSSurfaceId.arabic,
    routePath: '/quran/arabic',
    defaultSectionId: 'arabic.primary',
    orderedSectionIds: <String>[
      'arabic.primary',
      'arabic.letters',
      'arabic.support',
    ],
    requiresLeftEdgeNavigationEscape: true,
    requiresContentFocusRestore: true,
    requiresNavigationRestore: true,
    requiresModalReturnCoverage: false,
    risk: TVOSFocusRegressionRisk.medium,
    notes:
        'Arabic must keep grouped beginner learning shelves predictable under remote navigation.',
  ),
  TVOSFocusQaScenario(
    surfaceId: TVOSSurfaceId.learn,
    routePath: '/learn',
    defaultSectionId: 'learn.primary',
    orderedSectionIds: <String>[
      'learn.primary',
      'learn.shelf',
      'learn.story',
      'learn.visual',
    ],
    requiresLeftEdgeNavigationEscape: true,
    requiresContentFocusRestore: true,
    requiresNavigationRestore: true,
    requiresModalReturnCoverage: false,
    risk: TVOSFocusRegressionRisk.medium,
    notes:
        'Learn needs stable hero-to-shelf progression across the expanded stories and visual-learning stages.',
  ),
  TVOSFocusQaScenario(
    surfaceId: TVOSSurfaceId.games,
    routePath: '/learn/games',
    defaultSectionId: 'games.primary',
    orderedSectionIds: <String>[
      'games.primary',
      'games.challenge',
      'games.support',
    ],
    requiresLeftEdgeNavigationEscape: true,
    requiresContentFocusRestore: true,
    requiresNavigationRestore: true,
    requiresModalReturnCoverage: false,
    risk: TVOSFocusRegressionRisk.medium,
    notes:
        'Games needs stable answer-flow and support-lane focus after challenge interaction.',
  ),
  TVOSFocusQaScenario(
    surfaceId: TVOSSurfaceId.prayer,
    routePath: '/worship/prayer',
    defaultSectionId: 'prayer.currentNext',
    orderedSectionIds: <String>[
      'prayer.currentNext',
      'prayer.schedule',
      'prayer.companion',
    ],
    requiresLeftEdgeNavigationEscape: true,
    requiresContentFocusRestore: true,
    requiresNavigationRestore: true,
    requiresModalReturnCoverage: false,
    risk: TVOSFocusRegressionRisk.medium,
    notes:
        'Prayer must preserve glance-first order from current and next prayer into the full-day schedule.',
  ),
  TVOSFocusQaScenario(
    surfaceId: TVOSSurfaceId.dhikr,
    routePath: '/worship/dhikr',
    defaultSectionId: 'dhikr.modes',
    orderedSectionIds: <String>[
      'dhikr.modes',
      'dhikr.guidedFlow',
      'dhikr.companion',
    ],
    requiresLeftEdgeNavigationEscape: true,
    requiresContentFocusRestore: true,
    requiresNavigationRestore: true,
    requiresModalReturnCoverage: false,
    risk: TVOSFocusRegressionRisk.medium,
    notes:
        'Dhikr needs guided-flow stability without losing the quick return into sidebar navigation.',
  ),
  TVOSFocusQaScenario(
    surfaceId: TVOSSurfaceId.kids,
    routePath: '/learn/kids/fun-learning',
    defaultSectionId: 'kids.primary',
    orderedSectionIds: <String>[
      'kids.primary',
      'kids.story',
      'kids.support',
    ],
    requiresLeftEdgeNavigationEscape: true,
    requiresContentFocusRestore: true,
    requiresNavigationRestore: true,
    requiresModalReturnCoverage: false,
    risk: TVOSFocusRegressionRisk.medium,
    notes:
        'Kids needs stable family-safe focus movement across path cards, story focus, and support guidance.',
  ),
];
