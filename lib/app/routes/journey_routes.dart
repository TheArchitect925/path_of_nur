import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/journey/application/growth_models.dart';
import '../../features/journey/presentation/growth_entry_page.dart';
import '../../features/journey/presentation/growth_habit_detail_page.dart';
import '../../features/journey/presentation/growth_habits_page.dart';
import '../../features/journey/presentation/growth_path_detail_page.dart';
import '../../features/wallpaper/presentation/wallpaper_library_page.dart';

String _redirectWithQuery(String path, GoRouterState state) {
  return Uri(
    path: path,
    queryParameters: state.uri.queryParameters.isEmpty
        ? null
        : state.uri.queryParameters,
  ).toString();
}

List<RouteBase> buildJourneyRoutes() {
  return <RouteBase>[
    GoRoute(
      path: '/journey/wallpapers',
      name: 'wallpaperLibrary',
      pageBuilder: (context, state) =>
          const MaterialPage(child: WallpaperLibraryPage()),
    ),
    GoRoute(
      path: '/journey/growth/today',
      name: 'growthTodayDeepLink',
      pageBuilder: (context, state) => const MaterialPage(
        child: GrowthEntryPage(initialTab: GrowthInternalTab.today),
      ),
    ),
    GoRoute(
      path: '/journey/growth/reflection',
      name: 'growthReflectionDeepLink',
      pageBuilder: (context, state) => const MaterialPage(
        child: GrowthEntryPage(initialTab: GrowthInternalTab.reflection),
      ),
    ),
    GoRoute(
      path: '/journey/growth/journey',
      name: 'growthJourneyDeepLink',
      pageBuilder: (context, state) => const MaterialPage(
        child: GrowthEntryPage(initialTab: GrowthInternalTab.journey),
      ),
    ),
    GoRoute(
      path: '/journey/growth/habits',
      name: 'growthHabitsDeepLink',
      pageBuilder: (context, state) =>
          const MaterialPage(child: GrowthHabitsPage()),
    ),
    GoRoute(
      path: '/growth/today',
      name: 'growthTodayAlias',
      redirect: (context, state) =>
          _redirectWithQuery('/journey/growth/today', state),
    ),
    GoRoute(
      path: '/growth/reflection',
      name: 'growthReflectionAlias',
      redirect: (context, state) =>
          _redirectWithQuery('/journey/growth/reflection', state),
    ),
    GoRoute(
      path: '/growth/journey',
      name: 'growthJourneyAlias',
      redirect: (context, state) =>
          _redirectWithQuery('/journey/growth/journey', state),
    ),
    GoRoute(
      path: '/growth/habit/:habitId',
      name: 'growthHabitAlias',
      pageBuilder: (context, state) {
        final habitId = state.pathParameters['habitId'] ?? '';
        return MaterialPage(
          child: GrowthEntryPage(
            initialTab: GrowthInternalTab.today,
            focusHabitId: habitId,
          ),
        );
      },
    ),
    GoRoute(
      path: '/journey/path/:pathId',
      name: 'growthPathDetail',
      pageBuilder: (context, state) {
        final pathId = state.pathParameters['pathId'] ?? '';
        return MaterialPage(child: GrowthPathDetailPage(pathId: pathId));
      },
    ),
    GoRoute(
      path: '/journey/habit/:habitId',
      name: 'growthHabitDetail',
      pageBuilder: (context, state) {
        final habitId = state.pathParameters['habitId'] ?? '';
        return MaterialPage(child: GrowthHabitDetailPage(habitId: habitId));
      },
    ),
  ];
}
