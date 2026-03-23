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
        seed: const <String, Object>{
          'learn.quran.readingStats': <String, Object>{
            'totalReadingSeconds': 1200,
            'totalSessions': 2,
            'secondsByDayKey': <String, int>{'2026-03-21': 1200},
          },
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

      expect(find.text(l10n.growthStatisticsSummaryTitleText), findsOneWidget);
      expect(find.text(l10n.growthStatisticsTrendsTitleText), findsOneWidget);
      expect(find.text(l10n.growthStatisticsInsightsTitleText), findsOneWidget);
      expect(find.text(l10n.growthStatisticsReportsTitleText), findsOneWidget);
      expect(
        find.text(l10n.growthStatisticsWeeklyTrendTitleText),
        findsOneWidget,
      );
      expect(
        find.text(l10n.growthStatisticsMonthlyTrendTitleText),
        findsOneWidget,
      );
      expect(find.text(l10n.growthStatisticsBestDayTitleText), findsOneWidget);
      expect(
        find.text(l10n.growthStatisticsRewardsInsightsTitleText),
        findsOneWidget,
      );
      expect(
        find.text(l10n.growthStatisticsShareWeeklyActionText),
        findsOneWidget,
      );
    },
  );
}
