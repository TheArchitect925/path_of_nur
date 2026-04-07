import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:path_of_nur/app/app_router.dart';
import 'package:path_of_nur/shared/application/daily_clock_provider.dart';
import 'package:path_of_nur/features/accounts_sync/presentation/accounts_profiles_sync_page.dart';
import 'package:path_of_nur/features/home/presentation/home_page.dart';
import 'package:path_of_nur/features/journey/presentation/journey_page.dart';
import 'package:path_of_nur/features/journey/presentation/growth_browse_all_page.dart';
import 'package:path_of_nur/features/journey/presentation/growth_habit_detail_page.dart';
import 'package:path_of_nur/features/journey/presentation/growth_section_pages.dart';
import 'package:path_of_nur/features/journey/presentation/growth_tracking_dashboard_page.dart';
import 'package:path_of_nur/features/learn/dua/presentation/dua_hub_page.dart';
import 'package:path_of_nur/features/learn/presentation/pages/learn_explore_all_knowledge_page.dart';
import 'package:path_of_nur/features/learn/presentation/pages/learning_section_landing_page.dart';
import 'package:path_of_nur/features/learn/presentation/pages/learn_quizzes_hub_page.dart';
import 'package:path_of_nur/features/learn/presentation/learn_page.dart';
import 'package:path_of_nur/features/learn/presentation/pages/quran_app_hub_page.dart';
import 'package:path_of_nur/features/learn/guided_paths/presentation/daily_dhikr_path_next_steps_page.dart';
import 'package:path_of_nur/features/learn/guided_paths/presentation/foundations_path_next_steps_page.dart';
import 'package:path_of_nur/features/learn/guided_paths/presentation/kids_starter_path_bridge_page.dart';
import 'package:path_of_nur/features/learn/guided_paths/presentation/kids_starter_path_next_steps_page.dart';
import 'package:path_of_nur/features/learn/guided_paths/presentation/quran_beginner_soft_bridge_page.dart';
import 'package:path_of_nur/features/learn/guided_paths/presentation/stories_path_bridge_page.dart';
import 'package:path_of_nur/features/learn/guided_paths/presentation/stories_path_next_steps_page.dart';
import 'package:path_of_nur/features/learn/prophets/presentation/prophets_page.dart';
import 'package:path_of_nur/features/learn/quran/presentation/quran_reflections_page.dart';
import 'package:path_of_nur/features/learn/quran/presentation/quran_search_page.dart';
import 'package:path_of_nur/features/learn/quran/presentation/quran_surah_explorer_page.dart';
import 'package:path_of_nur/features/ocean/presentation/ocean_dashboard_page.dart';
import 'package:path_of_nur/features/faq/pages/faq_landing_page.dart';
import 'package:path_of_nur/features/profile/presentation/profile_summary_page.dart';
import 'package:path_of_nur/features/profile/presentation/settings_page.dart';
import 'package:path_of_nur/features/worship/presentation/worship_page.dart';
import 'package:path_of_nur/features/onboarding/presentation/onboarding_page.dart';
import 'package:path_of_nur/features/shared/legal_info_page.dart';
import 'package:path_of_nur/features/kids_arabic/presentation/kids_arabic_practice_page.dart';
import 'package:path_of_nur/features/kids_arabic/presentation/kids_arabic_mini_phrases_page.dart';
import 'package:path_of_nur/features/kids_arabic/presentation/kids_arabic_reading_mode_page.dart';
import 'package:path_of_nur/features/kids_arabic/presentation/kids_arabic_words_page.dart';

import '../test_helpers/app_test_harness.dart';

void main() {
  Future<void> pumpRouteFrames(WidgetTester tester) async {
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 120));
    await tester.pump(const Duration(milliseconds: 180));
  }

  Future<void> pumpAppReady(WidgetTester tester) async {
    await pumpRouteFrames(tester);
    await tester.pump(const Duration(seconds: 3));
  }

  testWidgets('root shell routes open without runtime failures', (
    tester,
  ) async {
    final container = await makeTestContainer(
      overrides: <Override>[
        dailyNowProvider.overrideWith(
          (ref) =>
              Stream<DateTime>.value(DateTime.parse('2026-03-14T12:00:00')),
        ),
      ],
    );
    final router = container.read(appRouterProvider);

    await tester.pumpWidget(buildRouterTestApp(container));
    await pumpAppReady(tester);
    expect(find.byType(HomePage), findsOneWidget);

    final cases = <(String, Type)>[
      ('/worship', WorshipPage),
      ('/learn', LearningSectionLandingPage),
      ('/home', HomePage),
      ('/journey', JourneyPage),
      ('/quran', QuranAppHubPage),
      ('/settings', SettingsPage),
      ('/learn/legacy', LearnPage),
      ('/accounts-sync', AccountsProfilesSyncPage),
      ('/accounts-sync/sync-details', SyncDetailsPage),
      ('/accounts-sync/backup', BackupRestoreHomePage),
      ('/profile/summary', ProfileSummaryPage),
      ('/legal/privacy', LegalInfoPage),
      ('/journey/ocean', OceanDashboardPage),
      ('/journey/statistics', GrowthTrackingDashboardPage),
      ('/journey/browse', GrowthBrowseAllPage),
      ('/learn/kids/arabic/practice', KidsArabicPracticePage),
      ('/learn/kids/arabic/words', KidsArabicWordsPage),
      ('/learn/kids/arabic/phrases', KidsArabicMiniPhrasesPage),
      ('/learn/kids/arabic/words/reading', KidsArabicReadingModePage),
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
        dailyNowProvider.overrideWith(
          (ref) =>
              Stream<DateTime>.value(DateTime.parse('2026-03-14T12:00:00')),
        ),
      ],
    );
    final router = container.read(appRouterProvider);

    await tester.pumpWidget(buildRouterTestApp(container));
    await pumpAppReady(tester);

    final cases = <(String, Type)>[
      ('/learn/hub/quran', QuranAppHubPage),
      ('/learn/quran/explorer', QuranSurahExplorerPage),
      ('/learn/quran/reflections', QuranReflectionsPage),
      ('/learn/quran/search', QuranSearchPage),
      ('/quran/reflections', QuranReflectionsPage),
    ];

    for (final (path, pageType) in cases) {
      router.go(path);
      await pumpRouteFrames(tester);
      expect(find.byType(pageType), findsOneWidget, reason: path);
      expect(tester.takeException(), isNull, reason: path);
    }
  });

  testWidgets('legacy learn aliases resolve to explicit product routes', (
    tester,
  ) async {
    final container = await makeTestContainer(
      overrides: <Override>[
        dailyNowProvider.overrideWith(
          (ref) =>
              Stream<DateTime>.value(DateTime.parse('2026-03-14T12:00:00')),
        ),
      ],
    );
    final router = container.read(appRouterProvider);

    await tester.pumpWidget(buildRouterTestApp(container));
    await pumpAppReady(tester);

    final cases = <(String, Type)>[
      ('/learn/section/prophets?tab=quiz', ProphetsPage),
      ('/learn/section/duas', DuaHubPage),
      ('/learn/section/quizzes', LearnQuizzesHubPage),
      ('/learn/section/faq', FaqLandingPage),
      ('/growth/today', GrowthTodaySectionPage),
      ('/growth/habit/h_morning_adhkar', GrowthHabitDetailPage),
      ('/journey/tracking', GrowthTrackingDashboardPage),
      ('/learn/kids/arabic/words/reading', KidsArabicReadingModePage),
    ];

    for (final (path, pageType) in cases) {
      router.go(path);
      await pumpRouteFrames(tester);
      expect(find.byType(pageType), findsOneWidget, reason: path);
      expect(tester.takeException(), isNull, reason: path);
    }
  });

  testWidgets(
    'canonical and compatibility learn discovery routes stay aligned',
    (tester) async {
      final container = await makeTestContainer(
        overrides: <Override>[
          dailyNowProvider.overrideWith(
            (ref) =>
                Stream<DateTime>.value(DateTime.parse('2026-03-14T12:00:00')),
          ),
        ],
      );
      final router = container.read(appRouterProvider);

      await tester.pumpWidget(buildRouterTestApp(container));
      await pumpAppReady(tester);

      final cases = <(String, Type)>[
        ('/learn/explore', LearnExploreAllKnowledgePage),
        ('/learn/browse', LearnExploreAllKnowledgePage),
        ('/learn/prophets', ProphetsPage),
        ('/learn/hub/prophets', ProphetsPage),
      ];

      for (final (path, pageType) in cases) {
        router.go(path);
        await pumpRouteFrames(tester);
        expect(find.byType(pageType), findsOneWidget, reason: path);
        expect(tester.takeException(), isNull, reason: path);
      }
    },
  );

  testWidgets(
    'guided path bridge and next-step routes open without runtime failures',
    (tester) async {
      final container = await makeTestContainer(
        overrides: <Override>[
          dailyNowProvider.overrideWith(
            (ref) =>
                Stream<DateTime>.value(DateTime.parse('2026-03-14T12:00:00')),
          ),
        ],
      );
      final router = container.read(appRouterProvider);

      await tester.pumpWidget(buildRouterTestApp(container));
      await pumpAppReady(tester);

      final cases = <(String, Type)>[
        ('/learn/paths/foundations/next', FoundationsPathNextStepsPage),
        ('/learn/paths/daily-dhikr/next', DailyDhikrPathNextStepsPage),
        ('/learn/paths/quran-beginner/bridge', QuranBeginnerSoftBridgePage),
        ('/learn/paths/kids-starter/bridge', KidsStarterPathBridgePage),
        ('/learn/paths/kids-starter/next', KidsStarterPathNextStepsPage),
        ('/learn/paths/stories/bridge', StoriesPathBridgePage),
        ('/learn/paths/stories/next', StoriesPathNextStepsPage),
      ];

      for (final (path, pageType) in cases) {
        router.go(path);
        await pumpRouteFrames(tester);
        expect(find.byType(pageType), findsOneWidget, reason: path);
        expect(tester.takeException(), isNull, reason: path);
      }
    },
  );

  testWidgets('onboarding redirect remains stable before first completion', (
    tester,
  ) async {
    final container = await makeTestContainer(
      seed: <String, Object>{'app.onboardingCompleted': false},
      overrides: <Override>[
        dailyNowProvider.overrideWith(
          (ref) =>
              Stream<DateTime>.value(DateTime.parse('2026-03-14T12:00:00')),
        ),
      ],
    );

    await tester.pumpWidget(buildRouterTestApp(container));
    await pumpAppReady(tester);
    await tester.pump(const Duration(seconds: 2));

    expect(find.byType(OnboardingPage), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'completed onboarding does not allow returning to onboarding route',
    (tester) async {
      final container = await makeTestContainer(
        overrides: <Override>[
          dailyNowProvider.overrideWith(
            (ref) =>
                Stream<DateTime>.value(DateTime.parse('2026-03-14T12:00:00')),
          ),
        ],
      );
      final router = container.read(appRouterProvider);

      await tester.pumpWidget(buildRouterTestApp(container));
      await pumpAppReady(tester);

      router.go('/onboarding');
      await pumpRouteFrames(tester);

      expect(find.byType(HomePage), findsOneWidget);
      expect(find.byType(OnboardingPage), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );
}
