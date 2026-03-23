import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/diagnostics/app_telemetry.dart';
import 'nav_tabs.dart';
import '../features/accounts_sync/application/accounts_sync_controller.dart';
import '../features/home/presentation/home_page.dart';
import '../features/journey/presentation/journey_page.dart';
import '../features/learn/journey/application/family_learning_provider.dart';
import '../features/learn/presentation/pages/learning_section_landing_page.dart';
import '../features/learn/presentation/pages/quran_app_hub_page.dart';
import '../features/onboarding/application/onboarding_state_provider.dart';
import '../features/worship/presentation/worship_page.dart';
import '../l10n/app_localizations.dart';
import '../shared/widgets/app_scaffold.dart';
import 'routes/core_support_routes.dart';
import 'routes/discovery_routes.dart';
import 'routes/journey_routes.dart';
import 'routes/learn_routes.dart';
import 'routes/router_deep_links.dart';
import 'routes/startup_routes.dart';
import 'routes/worship_routes.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final onboardingCompleted = ref.watch(onboardingCompletedProvider);
  final accountsSyncState = ref.watch(accountsSyncControllerProvider);
  final familyLearningContext = ref.watch(activeFamilyLearningContextProvider);
  final initial = onboardingCompleted ? NavTab.home.path : '/onboarding';
  final shellNavigatorKey = GlobalKey<NavigatorState>();

  return GoRouter(
    initialLocation: initial,
    observers: [TelemetryNavigatorObserver()],
    redirect: (context, state) {
      final deepLinkPath = mapAppDeepLink(state.uri);
      if (deepLinkPath != null) return deepLinkPath;

      final onOnboarding = state.matchedLocation == '/onboarding';
      if (!onboardingCompleted && !onOnboarding) {
        return '/onboarding';
      }
      if (onboardingCompleted && onOnboarding) {
        return NavTab.home.path;
      }

      final onSharedPicker = state.matchedLocation == '/profiles/launch';
      if (accountsSyncState.sharedDeviceModeEnabled &&
          accountsSyncState
              .sharedDeviceSafety
              .requireProfileSelectionOnLaunch &&
          accountsSyncState.sessionUnlockedProfileId == null &&
          onboardingCompleted &&
          !onSharedPicker &&
          !state.matchedLocation.startsWith('/accounts-sync')) {
        return '/profiles/launch';
      }
      final childLearningRedirect = _redirectChildLearningLocation(
        matchedLocation: state.matchedLocation,
        isChildProfile: familyLearningContext.visibilityPolicy.isChildProfile,
      );
      if (childLearningRedirect != null) {
        return childLearningRedirect;
      }
      return null;
    },
    errorBuilder: (context, state) => Scaffold(
      body: Builder(
        builder: (context) {
          AppTelemetry.logError(
            'router_error',
            metadata: {'location': state.uri.toString()},
            error: state.error,
          );
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline_rounded, size: 30),
                  const SizedBox(height: 12),
                  Text(
                    AppLocalizations.of(context).routerNotFoundTitle,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(state.uri.toString(), textAlign: TextAlign.center),
                ],
              ),
            ),
          );
        },
      ),
    ),
    routes: [
      ...buildStartupRoutes(),
      ShellRoute(
        navigatorKey: shellNavigatorKey,
        pageBuilder: (context, state, child) {
          return MaterialPage(
            child: AppShellScaffold(
              currentLocation: state.uri.toString(),
              child: child,
            ),
          );
        },
        routes: [
          ...buildCoreSupportRoutes(),
          ...buildDiscoveryRoutes(),
          ...buildLearnRoutes(),
          ...buildJourneyRoutes(),
          ...buildWorshipRoutes(),
          GoRoute(
            path: NavTab.learn.path,
            name: NavTab.learn.name,
            pageBuilder: (context, state) =>
                const MaterialPage(child: LearningSectionLandingPage()),
          ),
          ...NavTab.values
              .map(
                (tab) => GoRoute(
                  path: tab.path,
                  name: tab.name,
                  pageBuilder: (context, state) =>
                      MaterialPage(child: _buildTabPage(tab)),
                ),
              )
              .where((route) => route.path != NavTab.learn.path),
        ],
      ),
    ],
  );
});

String? _redirectChildLearningLocation({
  required String matchedLocation,
  required bool isChildProfile,
}) {
  if (!isChildProfile || !matchedLocation.startsWith('/learn')) {
    return null;
  }
  if (_isKidsLearningLocationAllowed(matchedLocation)) {
    if (matchedLocation == '/learn') {
      return '/learn/category/kids-learning';
    }
    return null;
  }
  return '/learn/category/kids-learning';
}

bool _isKidsLearningLocationAllowed(String matchedLocation) {
  return matchedLocation == '/learn' ||
      matchedLocation == '/learn/category/kids-learning' ||
      matchedLocation.startsWith('/learn/kids/') ||
      matchedLocation.startsWith('/learn/quizzes/crossword') ||
      matchedLocation.startsWith('/learn/quizzes/word-search') ||
      matchedLocation.startsWith('/learn/quizzes/matching') ||
      matchedLocation.startsWith('/learn/quizzes/ayah-completion') ||
      matchedLocation.startsWith('/learn/quizzes/hadith-reflection') ||
      matchedLocation.startsWith('/learn/quizzes/daily-challenge');
}

Widget _buildTabPage(NavTab tab) {
  switch (tab) {
    case NavTab.worship:
      return const WorshipPage();
    case NavTab.learn:
      return const LearningSectionLandingPage();
    case NavTab.home:
      return const HomePage();
    case NavTab.journey:
      return const JourneyPage();
    case NavTab.quran:
      return const QuranAppHubPage();
  }
}

NavTab navTabFromLocation(String location) {
  if (_isQuranLocation(location)) {
    return NavTab.quran;
  }
  for (final tab in NavTab.values) {
    if (location.startsWith(tab.path)) {
      return tab;
    }
  }
  return NavTab.home;
}

bool _isQuranLocation(String location) {
  return location.startsWith('/quran') ||
      location.startsWith('/quran-verse') ||
      location.startsWith('/learn/quran') ||
      location.startsWith('/learn/hub/quran');
}
