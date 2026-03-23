import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/app/app_router.dart';
import 'package:path_of_nur/features/garden/presentation/garden_page.dart';
import 'package:path_of_nur/features/journey/presentation/growth_browse_all_page.dart';
import 'package:path_of_nur/features/journey/presentation/growth_habits_page.dart';
import 'package:path_of_nur/features/journey/presentation/growth_section_pages.dart';
import 'package:path_of_nur/features/journey/presentation/growth_tracking_dashboard_page.dart';
import 'package:path_of_nur/features/journey/spiritual_growth/presentation/spiritual_growth_page.dart';
import 'package:path_of_nur/l10n/app_localizations.dart';
import 'package:path_of_nur/shared/application/daily_clock_provider.dart';
import 'package:path_of_nur/shared/widgets/section_hub_scaffold.dart';

import '../../test_helpers/app_test_harness.dart';

void main() {
  Future<void> pumpRouteFrames(WidgetTester tester) async {
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 120));
    await tester.pump(const Duration(milliseconds: 180));
  }

  int comparePositions(Offset left, Offset right) {
    final dyCompare = left.dy.compareTo(right.dy);
    if (dyCompare != 0) return dyCompare;
    return left.dx.compareTo(right.dx);
  }

  Future<void> tapIslandCard(WidgetTester tester, String label) async {
    final labelFinder = find.text(label).first;
    await tester.ensureVisible(labelFinder);
    await pumpRouteFrames(tester);

    final cardFinder = find.ancestor(
      of: labelFinder,
      matching: find.byType(SectionHubActionCard),
    );
    await tester.tap(cardFinder.first);
    await pumpRouteFrames(tester);
  }

  testWidgets('growth home shows the cleaned island set in order', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1200, 2200));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final container = await makeTestContainer(
      overrides: <Override>[
        dailyNowProvider.overrideWith(
          (ref) =>
              Stream<DateTime>.value(DateTime.parse('2026-03-22T12:00:00')),
        ),
      ],
    );
    final router = container.read(appRouterProvider);

    await tester.pumpWidget(buildRouterTestApp(container));
    router.go('/journey');
    await pumpRouteFrames(tester);

    final l10n = await AppLocalizations.delegate.load(const Locale('en'));

    final titles = <String>[
      l10n.growthTabToday,
      l10n.growthTabPaths,
      l10n.growthTabHabits,
      l10n.growthTabJourney,
      l10n.growthTabReflection,
      l10n.spiritualGrowthTitle,
      l10n.growthStatisticsTitle,
      l10n.gardenPageTitle,
      l10n.growthHomeBrowseAllTitle,
    ];

    for (final title in titles) {
      expect(find.text(title), findsOneWidget, reason: title);
    }

    final positions = {
      for (final title in titles) title: tester.getTopLeft(find.text(title)),
    };

    for (var index = 0; index < titles.length - 1; index++) {
      expect(
        comparePositions(
          positions[titles[index]]!,
          positions[titles[index + 1]]!,
        ),
        lessThan(0),
        reason: '${titles[index]} should appear before ${titles[index + 1]}',
      );
    }
  });

  testWidgets(
    'growth home routes Browse All and Statistics islands correctly',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(1200, 2200));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final container = await makeTestContainer(
        overrides: <Override>[
          dailyNowProvider.overrideWith(
            (ref) =>
                Stream<DateTime>.value(DateTime.parse('2026-03-22T12:00:00')),
          ),
        ],
      );

      await tester.pumpWidget(buildRouterTestApp(container));
      await pumpRouteFrames(tester);
      final l10n = await AppLocalizations.delegate.load(const Locale('en'));

      final router = container.read(appRouterProvider);
      router.go('/journey');
      await pumpRouteFrames(tester);

      await tapIslandCard(tester, l10n.growthHomeBrowseAllTitle);
      expect(find.text(l10n.growthBrowseAllDailyFocusTitle), findsOneWidget);

      router.go('/journey');
      await pumpRouteFrames(tester);

      await tapIslandCard(tester, l10n.growthStatisticsTitle);
      expect(find.text(l10n.growthStatisticsTitle), findsAtLeastNWidgets(1));
      expect(
        find.text(l10n.growthTrackingOverviewTitle),
        findsAtLeastNWidgets(1),
      );
      expect(
        find.text(l10n.journeyStatsQuranReadingTitle),
        findsAtLeastNWidgets(1),
      );
      expect(
        find.text(l10n.journeyStatsTimeReflectionTitle),
        findsAtLeastNWidgets(1),
      );
      expect(
        find.text(l10n.journeyStatsTotalAdhkarCompletedTitle),
        findsAtLeastNWidgets(1),
      );
    },
  );

  testWidgets('growth home islands open their dedicated destination pages', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1200, 2200));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final container = await makeTestContainer(
      overrides: <Override>[
        dailyNowProvider.overrideWith(
          (ref) =>
              Stream<DateTime>.value(DateTime.parse('2026-03-22T12:00:00')),
        ),
      ],
    );

    await tester.pumpWidget(buildRouterTestApp(container));
    await pumpRouteFrames(tester);

    final router = container.read(appRouterProvider);
    router.go('/journey');
    await pumpRouteFrames(tester);
    final l10n = await AppLocalizations.delegate.load(const Locale('en'));

    final cases = <(String, Type)>[
      (l10n.growthTabToday, GrowthTodaySectionPage),
      (l10n.growthTabPaths, GrowthPathsSectionPage),
      (l10n.growthTabHabits, GrowthHabitsPage),
      (l10n.growthTabJourney, GrowthJourneySectionPage),
      (l10n.growthTabReflection, GrowthReflectionSectionPage),
      (l10n.spiritualGrowthTitle, SpiritualGrowthPage),
      (l10n.growthStatisticsTitle, GrowthTrackingDashboardPage),
      (l10n.gardenPageTitle, GardenPage),
      (l10n.growthHomeBrowseAllTitle, GrowthBrowseAllPage),
    ];

    for (final (label, pageType) in cases) {
      router.go('/journey');
      await pumpRouteFrames(tester);

      await tapIslandCard(tester, label);

      expect(find.byType(pageType), findsOneWidget, reason: label);
    }
  });
}
