import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/diagnostics/app_telemetry.dart';
import 'nav_tabs.dart';
import '../features/accounts_sync/application/accounts_sync_controller.dart';
import '../features/editorial_dashboard/application/editorial_dashboard_access_provider.dart';
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
import 'routes/router_policies.dart';
import 'routes/startup_routes.dart';
import 'routes/worship_routes.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  // The router is created exactly once per container. Redirect inputs are
  // read fresh on every navigation, and provider changes nudge the router
  // through refreshListenable so active locations re-run the redirect —
  // recreating GoRouter here would reset navigation state and leak the
  // previous instance's bindings.
  final refreshNotifier = ValueNotifier<int>(0);
  void bump() => refreshNotifier.value++;
  ref.listen(onboardingCompletedProvider, (_, _) => bump());
  ref.listen(accountsSyncControllerProvider, (_, _) => bump());
  ref.listen(activeFamilyLearningContextProvider, (_, _) => bump());
  ref.listen(editorialDashboardFeatureEnabledProvider, (_, _) => bump());
  ref.listen(
    editorialDashboardAccessProvider.select((value) => value.isSessionUnlocked),
    (_, _) => bump(),
  );
  const initial = '/startup';
  final shellNavigatorKey = GlobalKey<NavigatorState>();

  final router = GoRouter(
    initialLocation: initial,
    observers: [TelemetryNavigatorObserver()],
    refreshListenable: refreshNotifier,
    redirect: (context, state) {
      final onboardingCompleted = ref.read(onboardingCompletedProvider);
      final accountsSyncState = ref.read(accountsSyncControllerProvider);
      final familyLearningContext = ref.read(
        activeFamilyLearningContextProvider,
      );
      final editorialDashboardEnabled = ref.read(
        editorialDashboardFeatureEnabledProvider,
      );
      final editorialDashboardUnlocked = ref
          .read(editorialDashboardAccessProvider)
          .isSessionUnlocked;

      final deepLinkPath = mapAppDeepLink(state.uri);
      if (deepLinkPath != null) return deepLinkPath;

      final onboardingRedirect = _onboardingRedirect(
        matchedLocation: state.matchedLocation,
        uri: state.uri,
        onboardingCompleted: onboardingCompleted,
      );
      if (onboardingRedirect != null) {
        return onboardingRedirect;
      }

      final sharedDeviceRedirect = _sharedDeviceLaunchRedirect(
        matchedLocation: state.matchedLocation,
        onboardingCompleted: onboardingCompleted,
        accountsSyncState: accountsSyncState,
      );
      if (sharedDeviceRedirect != null) {
        return sharedDeviceRedirect;
      }

      final childLearningRedirect = redirectChildLearningLocation(
        matchedLocation: state.matchedLocation,
        isChildProfile: familyLearningContext.visibilityPolicy.isChildProfile,
      );
      if (childLearningRedirect != null) {
        return childLearningRedirect;
      }

      final editorialDashboardRedirect = _editorialDashboardRedirect(
        matchedLocation: state.matchedLocation,
        featureEnabled: editorialDashboardEnabled,
        unlocked: editorialDashboardUnlocked,
      );
      if (editorialDashboardRedirect != null) {
        return editorialDashboardRedirect;
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
  ref.onDispose(() {
    router.dispose();
    refreshNotifier.dispose();
  });
  return router;
});

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

String? _editorialDashboardRedirect({
  required String matchedLocation,
  required bool featureEnabled,
  required bool unlocked,
}) {
  if (!matchedLocation.startsWith('/internal/editorial')) {
    return null;
  }
  if (!featureEnabled) {
    return '/settings/about';
  }
  final onPin = matchedLocation == '/internal/editorial/pin';
  if (!unlocked && !onPin) {
    return '/internal/editorial/pin';
  }
  if (unlocked && onPin) {
    return '/internal/editorial';
  }
  return null;
}

NavTab navTabFromLocation(String location) {
  if (isQuranLocation(location)) {
    return NavTab.quran;
  }
  for (final tab in NavTab.values) {
    if (location.startsWith(tab.path)) {
      return tab;
    }
  }
  return NavTab.home;
}

String? _onboardingRedirect({
  required String matchedLocation,
  required Uri uri,
  required bool onboardingCompleted,
}) {
  final onOnboarding = matchedLocation == '/onboarding';
  final onStartup = matchedLocation == '/startup';
  final onboardingPreview = uri.queryParameters['preview'] == '1';
  if (onStartup) {
    return null;
  }
  if (!onboardingCompleted && !onOnboarding) {
    return '/onboarding';
  }
  if (onboardingCompleted && onOnboarding && !onboardingPreview) {
    return NavTab.home.path;
  }
  return null;
}

String? _sharedDeviceLaunchRedirect({
  required String matchedLocation,
  required bool onboardingCompleted,
  required AccountsSyncState accountsSyncState,
}) {
  final onSharedPicker = matchedLocation == '/profiles/launch';
  final onStartup = matchedLocation == '/startup';
  if (onStartup) {
    return null;
  }
  if (accountsSyncState.sharedDeviceModeEnabled &&
      accountsSyncState.sharedDeviceSafety.requireProfileSelectionOnLaunch &&
      accountsSyncState.sessionUnlockedProfileId == null &&
      onboardingCompleted &&
      !onSharedPicker &&
      !matchedLocation.startsWith('/accounts-sync')) {
    return '/profiles/launch';
  }
  return null;
}
