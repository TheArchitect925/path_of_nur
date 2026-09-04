import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/learn/dua/presentation/dua_hub_page.dart';
import '../../features/worship/presentation/dhikr/dhikr_counter_page.dart';
import '../../features/worship/presentation/dhikr/dhikr_insights_page.dart';
import '../../features/worship/presentation/dhikr/dhikr_routine_page.dart';
import '../../features/worship/presentation/worship_section_pages.dart';

List<RouteBase> buildWorshipRoutes() {
  return <RouteBase>[
    GoRoute(
      path: '/worship/prayer',
      name: 'worshipPrayerPage',
      pageBuilder: (context, state) =>
          const MaterialPage(child: WorshipPrayerPage()),
    ),
    GoRoute(
      path: '/worship/dhikr',
      name: 'worshipDhikrPage',
      pageBuilder: (context, state) =>
          const MaterialPage(child: WorshipDhikrPage()),
    ),
    GoRoute(
      path: '/worship/dhikr/count',
      name: 'worshipDhikrCounter',
      pageBuilder: (context, state) =>
          const MaterialPage(child: DhikrCounterPage()),
    ),
    GoRoute(
      path: '/worship/dhikr/routine/:routineId',
      name: 'worshipDhikrRoutine',
      pageBuilder: (context, state) => MaterialPage(
        child: DhikrRoutinePage(
          routineId: state.pathParameters['routineId'] ?? '',
          prayerId: state.uri.queryParameters['prayer'],
        ),
      ),
    ),
    GoRoute(
      path: '/worship/dhikr/insights',
      name: 'worshipDhikrInsights',
      pageBuilder: (context, state) =>
          const MaterialPage(child: DhikrInsightsPage()),
    ),
    GoRoute(
      path: '/worship/fasting',
      name: 'worshipFastingPage',
      pageBuilder: (context, state) =>
          const MaterialPage(child: WorshipFastingPage()),
    ),
    // The Tracking and Reminders router pages retired with the Prayer Room
    // (calm-navigation Phase 3b); their routes redirect to the surfaces that
    // hold the content now.
    GoRoute(
      path: '/worship/tracking',
      name: 'worshipTrackingPage',
      redirect: (context, state) => '/worship/prayer',
    ),
    GoRoute(
      path: '/worship/reminders',
      name: 'worshipRemindersPage',
      redirect: (context, state) => '/settings/notifications-reminders',
    ),
    GoRoute(
      path: '/worship/duas',
      name: 'worshipDuasPage',
      pageBuilder: (context, state) => const MaterialPage(child: DuaHubPage()),
    ),
  ];
}
