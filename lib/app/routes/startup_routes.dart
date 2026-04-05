import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/accounts_sync/presentation/accounts_profiles_sync_page.dart';
import '../../features/onboarding/presentation/onboarding_page.dart';
import '../../features/startup/presentation/app_loading_screen.dart';

List<RouteBase> buildStartupRoutes() {
  return <RouteBase>[
    GoRoute(
      path: '/startup',
      name: 'startup',
      pageBuilder: (context, state) =>
          const MaterialPage(child: AppLoadingScreen()),
    ),
    GoRoute(
      path: '/onboarding',
      name: 'onboarding',
      pageBuilder: (context, state) =>
          const MaterialPage(child: OnboardingPage()),
    ),
    GoRoute(
      path: '/profiles/launch',
      name: 'sharedProfilePicker',
      pageBuilder: (context, state) =>
          const MaterialPage(child: SharedDeviceProfilePickerPage()),
    ),
  ];
}
