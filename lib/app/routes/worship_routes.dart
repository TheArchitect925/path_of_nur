import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/learn/dua/presentation/dua_hub_page.dart';
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
      path: '/worship/fasting',
      name: 'worshipFastingPage',
      pageBuilder: (context, state) =>
          const MaterialPage(child: WorshipFastingPage()),
    ),
    GoRoute(
      path: '/worship/tracking',
      name: 'worshipTrackingPage',
      pageBuilder: (context, state) =>
          const MaterialPage(child: WorshipTrackingPage()),
    ),
    GoRoute(
      path: '/worship/reminders',
      name: 'worshipRemindersPage',
      pageBuilder: (context, state) =>
          const MaterialPage(child: WorshipRemindersPage()),
    ),
    GoRoute(
      path: '/worship/duas',
      name: 'worshipDuasPage',
      pageBuilder: (context, state) => const MaterialPage(
        child: DuaHubPage(entryContext: DuaHubEntryContext.worship),
      ),
    ),
  ];
}
