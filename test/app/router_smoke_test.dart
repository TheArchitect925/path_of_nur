import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:path_of_nur/app/app_router.dart';
import 'package:path_of_nur/shared/application/daily_clock_provider.dart';
import 'package:path_of_nur/features/accounts_sync/presentation/accounts_profiles_sync_page.dart';
import 'package:path_of_nur/features/home/presentation/home_page.dart';
import 'package:path_of_nur/features/journey/presentation/journey_page.dart';
import 'package:path_of_nur/features/learn/presentation/learn_page.dart';
import 'package:path_of_nur/features/learn/presentation/pages/quran_app_hub_page.dart';
import 'package:path_of_nur/features/learn/quran/presentation/quran_search_page.dart';
import 'package:path_of_nur/features/learn/quran/presentation/quran_surah_explorer_page.dart';
import 'package:path_of_nur/features/ocean/presentation/ocean_drops_page.dart';
import 'package:path_of_nur/features/profile/presentation/profile_page.dart';
import 'package:path_of_nur/features/profile/presentation/profile_summary_page.dart';
import 'package:path_of_nur/features/profile/presentation/settings_page.dart';
import 'package:path_of_nur/features/worship/presentation/worship_page.dart';
import 'package:path_of_nur/features/onboarding/presentation/onboarding_page.dart';
import 'package:path_of_nur/features/shared/legal_info_page.dart';

import '../test_helpers/app_test_harness.dart';

void main() {
  Future<void> pumpRouteFrames(WidgetTester tester) async {
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 120));
    await tester.pump(const Duration(milliseconds: 180));
  }

  testWidgets('root shell routes open without runtime failures', (tester) async {
    final container = await makeTestContainer(
      overrides: <Override>[
        dailyNowProvider.overrideWith((ref) => Stream<DateTime>.value(
              DateTime.parse('2026-03-14T12:00:00'),
            )),
      ],
    );
    addTearDown(container.dispose);
    final router = container.read(appRouterProvider);

    await tester.pumpWidget(buildRouterTestApp(container));
    await pumpRouteFrames(tester);
    expect(find.byType(HomePage), findsOneWidget);

    final cases = <(String, Type)>[
      ('/worship', WorshipPage),
      ('/learn', LearnPage),
      ('/home', HomePage),
      ('/journey', JourneyPage),
      ('/profile', ProfilePage),
      ('/settings', SettingsPage),
      ('/accounts-sync', AccountsProfilesSyncPage),
      ('/accounts-sync/sync-details', SyncDetailsPage),
      ('/accounts-sync/backup', BackupRestoreHomePage),
      ('/profile/summary', ProfileSummaryPage),
      ('/legal/privacy', LegalInfoPage),
      ('/journey/ocean', OceanDropsPage),
    ];

    for (final (path, pageType) in cases) {
      router.go(path);
      await pumpRouteFrames(tester);
      expect(find.byType(pageType), findsOneWidget, reason: path);
      expect(tester.takeException(), isNull, reason: path);
    }
  });

  testWidgets('key quran routes open without runtime failures', (tester) async {
    final container = await makeTestContainer(
      overrides: <Override>[
        dailyNowProvider.overrideWith((ref) => Stream<DateTime>.value(
              DateTime.parse('2026-03-14T12:00:00'),
            )),
      ],
    );
    addTearDown(container.dispose);
    final router = container.read(appRouterProvider);

    await tester.pumpWidget(buildRouterTestApp(container));
    await pumpRouteFrames(tester);

    final cases = <(String, Type)>[
      ('/learn/hub/quran', QuranAppHubPage),
      ('/learn/quran/explorer', QuranSurahExplorerPage),
      ('/learn/quran/search', QuranSearchPage),
    ];

    for (final (path, pageType) in cases) {
      router.go(path);
      await pumpRouteFrames(tester);
      expect(find.byType(pageType), findsOneWidget, reason: path);
      expect(tester.takeException(), isNull, reason: path);
    }
  });

  testWidgets('onboarding redirect remains stable before first completion', (tester) async {
    final container = await makeTestContainer(
      seed: <String, Object>{'app.onboardingCompleted': false},
      overrides: <Override>[
        dailyNowProvider.overrideWith((ref) => Stream<DateTime>.value(
              DateTime.parse('2026-03-14T12:00:00'),
            )),
      ],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(buildRouterTestApp(container));
    await pumpRouteFrames(tester);
    await tester.pump(const Duration(seconds: 2));

    expect(find.byType(OnboardingPage), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
