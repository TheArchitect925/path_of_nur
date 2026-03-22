import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/journey/presentation/growth_habit_calendar_page.dart';
import '../../features/journey/presentation/growth_habit_dashboard_page.dart';
import '../../features/journey/presentation/growth_habit_detail_page.dart';
import '../../features/journey/presentation/growth_habits_page.dart';
import '../../features/journey/presentation/growth_habit_settings_page.dart';
import '../../features/journey/presentation/growth_path_detail_page.dart';
import '../../features/journey/presentation/growth_section_pages.dart';
import '../../features/journey/presentation/growth_tracking_dashboard_page.dart';
import '../../features/journey/spiritual_growth/presentation/spiritual_growth_intention_picker_page.dart';
import '../../features/journey/spiritual_growth/presentation/spiritual_growth_page.dart';
import '../../features/journey/spiritual_growth/presentation/spiritual_growth_reflection_page.dart';
import '../../features/journey/spiritual_growth/presentation/spiritual_growth_themes_page.dart';
import '../../features/garden/presentation/garden_page.dart';
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
      path: '/journey/spiritual-growth',
      name: 'spiritualGrowthPage',
      pageBuilder: (context, state) =>
          const MaterialPage(child: SpiritualGrowthPage()),
    ),
    GoRoute(
      path: '/journey/spiritual-growth/intentions',
      name: 'spiritualGrowthIntentions',
      pageBuilder: (context, state) =>
          const MaterialPage(child: SpiritualGrowthIntentionPickerPage()),
    ),
    GoRoute(
      path: '/journey/spiritual-growth/reflection',
      name: 'spiritualGrowthReflection',
      pageBuilder: (context, state) =>
          const MaterialPage(child: SpiritualGrowthReflectionPage()),
    ),
    GoRoute(
      path: '/journey/spiritual-growth/themes',
      name: 'spiritualGrowthThemes',
      pageBuilder: (context, state) =>
          const MaterialPage(child: SpiritualGrowthThemesPage()),
    ),
    GoRoute(
      path: '/journey/wallpapers',
      name: 'wallpaperLibrary',
      pageBuilder: (context, state) =>
          const MaterialPage(child: WallpaperLibraryPage()),
    ),
    GoRoute(
      path: '/journey/today',
      name: 'growthTodayPage',
      pageBuilder: (context, state) =>
          const MaterialPage(child: GrowthTodaySectionPage()),
    ),
    GoRoute(
      path: '/journey/reflection',
      name: 'growthReflectionPage',
      pageBuilder: (context, state) =>
          const MaterialPage(child: GrowthReflectionSectionPage()),
    ),
    GoRoute(
      path: '/journey/progress',
      name: 'growthJourneyPage',
      pageBuilder: (context, state) =>
          const MaterialPage(child: GrowthJourneySectionPage()),
    ),
    GoRoute(
      path: '/journey/paths',
      name: 'growthPathsPage',
      pageBuilder: (context, state) =>
          const MaterialPage(child: GrowthPathsSectionPage()),
    ),
    GoRoute(
      path: '/journey/habits',
      name: 'growthHabitsPage',
      pageBuilder: (context, state) =>
          const MaterialPage(child: GrowthHabitsPage()),
    ),
    GoRoute(
      path: '/journey/tracking',
      name: 'growthTrackingDashboard',
      pageBuilder: (context, state) =>
          const MaterialPage(child: GrowthTrackingDashboardPage()),
    ),
    GoRoute(
      path: '/journey/tracking/habits',
      name: 'growthHabitDashboard',
      pageBuilder: (context, state) =>
          const MaterialPage(child: GrowthHabitDashboardPage()),
    ),
    GoRoute(
      path: '/journey/tracking/habits/settings',
      name: 'growthHabitSettings',
      pageBuilder: (context, state) =>
          const MaterialPage(child: GrowthHabitSettingsPage()),
    ),
    GoRoute(
      path: '/journey/tracking/habits/calendar',
      name: 'growthHabitCalendar',
      pageBuilder: (context, state) =>
          const MaterialPage(child: GrowthHabitCalendarPage()),
    ),
    GoRoute(
      path: '/journey/garden',
      name: 'gardenPage',
      pageBuilder: (context, state) =>
          const MaterialPage(child: GardenPage()),
    ),
    GoRoute(
      path: '/growth/today',
      name: 'growthTodayAlias',
      redirect: (context, state) =>
          _redirectWithQuery('/journey/today', state),
    ),
    GoRoute(
      path: '/growth/reflection',
      name: 'growthReflectionAlias',
      redirect: (context, state) =>
          _redirectWithQuery('/journey/reflection', state),
    ),
    GoRoute(
      path: '/growth/journey',
      name: 'growthJourneyAlias',
      redirect: (context, state) =>
          _redirectWithQuery('/journey/progress', state),
    ),
    GoRoute(
      path: '/journey/growth/today',
      redirect: (context, state) => _redirectWithQuery('/journey/today', state),
    ),
    GoRoute(
      path: '/journey/growth/reflection',
      redirect: (context, state) =>
          _redirectWithQuery('/journey/reflection', state),
    ),
    GoRoute(
      path: '/journey/growth/journey',
      redirect: (context, state) =>
          _redirectWithQuery('/journey/progress', state),
    ),
    GoRoute(
      path: '/journey/growth/habits',
      redirect: (context, state) =>
          _redirectWithQuery('/journey/habits', state),
    ),
    GoRoute(
      path: '/growth/habit/:habitId',
      name: 'growthHabitAlias',
      pageBuilder: (context, state) {
        final habitId = state.pathParameters['habitId'] ?? '';
        return MaterialPage(
          child: GrowthHabitDetailPage(habitId: habitId),
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
