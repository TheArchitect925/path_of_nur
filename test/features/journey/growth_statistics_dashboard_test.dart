import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/journey/application/journey_stats_provider.dart';
import 'package:path_of_nur/features/journey/presentation/growth_statistics_localizations.dart';
import 'package:path_of_nur/features/journey/presentation/growth_tracking_dashboard_page.dart';
import 'package:path_of_nur/l10n/app_localizations.dart';
import 'package:path_of_nur/shared/persistence/app_database.dart';

import '../../test_helpers/app_test_harness.dart';

void main() {
  testWidgets(
    'statistics page renders new summary, trends, insights, and reports sections',
    (tester) async {
      final database = AppDatabase.inMemory();
      addTearDown(database.close);

      final container = await makeTestContainer(
        database: database,
        seed: <String, Object>{
          'learn.quran.readingStats': jsonEncode(<String, Object>{
            'totalReadingSeconds': 1200,
            'totalSessions': 2,
            'secondsByDayKey': <String, int>{'2026-03-21': 1200},
          }),
        },
        overrides: <Override>[
          journeyStatsNowProvider.overrideWithValue(
            DateTime.parse('2026-03-22T12:00:00.000'),
          ),
        ],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            home: const GrowthTrackingDashboardPage(),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      final l10n = await AppLocalizations.delegate.load(const Locale('en'));

      Future<void> expectSectionVisible(String text) async {
        await tester.scrollUntilVisible(
          find.text(text),
          400,
          scrollable: find.byType(Scrollable).first,
          maxScrolls: 60,
        );
        expect(find.text(text), findsOneWidget);
      }

      // Sections are asserted in page order because scrollUntilVisible only
      // scrolls forward.
      expect(find.text(l10n.growthStatisticsSummaryTitleText), findsOneWidget);
      await expectSectionVisible(l10n.growthStatisticsTrendsTitleText);
      await expectSectionVisible(l10n.growthStatisticsWeeklyTrendTitleText);
      await expectSectionVisible(l10n.growthStatisticsMonthlyTrendTitleText);
      await expectSectionVisible(l10n.growthStatisticsInsightsTitleText);
      await expectSectionVisible(l10n.growthStatisticsBestDayTitleText);
      await expectSectionVisible(l10n.growthStatisticsRewardsInsightsTitleText);
      await expectSectionVisible(l10n.growthStatisticsReportsTitleText);
      await expectSectionVisible(l10n.growthStatisticsShareWeeklyActionText);
    },
  );
}
