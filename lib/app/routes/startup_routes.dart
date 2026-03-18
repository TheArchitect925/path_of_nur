import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/accounts_sync/presentation/accounts_profiles_sync_page.dart';
import '../../features/onboarding/presentation/onboarding_page.dart';

List<RouteBase> buildStartupRoutes() {
  return <RouteBase>[
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
