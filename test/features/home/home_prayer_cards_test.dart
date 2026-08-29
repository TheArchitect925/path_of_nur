import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:path_of_nur/features/home/presentation/home_page.dart';
import 'package:path_of_nur/features/worship/presentation/worship_page.dart';
import 'package:path_of_nur/l10n/app_localizations.dart';
import 'package:path_of_nur/shared/application/daily_clock_provider.dart';
import 'package:path_of_nur/shared/persistence/app_database.dart';
import 'package:path_of_nur/shared/persistence/local_store.dart';

void main() {
  Future<ProviderContainer> makeHomeContainer({
    required AppDatabase database,
    List<Override> overrides = const <Override>[],
  }) async {
    SharedPreferences.setMockInitialValues(const <String, Object>{
      'app.onboardingCompleted': true,
    });
    final prefs = await SharedPreferences.getInstance();
    return ProviderContainer(
      overrides: <Override>[
        sharedPreferencesProvider.overrideWithValue(prefs),
        appDatabaseProvider.overrideWithValue(database),
        ...overrides,
      ],
    );
  }

  Future<void> pumpPage(
    WidgetTester tester,
    ProviderContainer container,
    Widget child,
  ) async {
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
          home: Scaffold(body: child),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 120));
    await tester.pump(const Duration(milliseconds: 180));
  }

  testWidgets(
    'completed home prayer card opens tracker details and reflects linked dhikr state',
    (tester) async {
      final database = AppDatabase.inMemory();
      addTearDown(database.close);
      database.execute(
        '''
        INSERT INTO prayer_records(
          scope_id, day_key, prayer, status, completed_at_iso,
          post_salah_adhkar_completed_at_iso, timing, place, notes, updated_at_iso
        ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?);
        ''',
        <Object?>[
          defaultStructuredDataScopeId,
          '2026-03-22',
          'fajr',
          'completed',
          '2026-03-22T05:20:00.000',
          '2026-03-22T05:24:00.000',
          'onTime',
          'congregation',
          null,
          '2026-03-22T05:24:00.000',
        ],
      );

      final container = await makeHomeContainer(
        database: database,
        overrides: <Override>[
          dailyNowProvider.overrideWith(
            (ref) =>
                Stream<DateTime>.value(DateTime.parse('2026-03-22T12:00:00')),
          ),
        ],
      );
      addTearDown(container.dispose);

      // The daily timings tracker moved from Home to the Ibadah landing
      // in the calm-navigation redesign.
      await pumpPage(tester, container, const WorshipPage());

      expect(find.byType(WorshipPage), findsOneWidget);
      expect(find.text('Post-salah dhikr logged'), findsOneWidget);

      final prayerDetailsCallToAction = find
          .text('Tap to update prayer details')
          .first;
      await tester.scrollUntilVisible(
        prayerDetailsCallToAction,
        240,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pump(const Duration(milliseconds: 200));
      await tester.tap(prayerDetailsCallToAction);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      expect(find.text('How was it offered?'), findsOneWidget);
      expect(find.text('Where was it offered?'), findsOneWidget);
      expect(find.text('In congregation'), findsWidgets);
    },
  );

  testWidgets('home prayer timings show Tahajjud beside the daily prayers', (
    tester,
  ) async {
    final database = AppDatabase.inMemory();
    addTearDown(database.close);

    final container = await makeHomeContainer(
      database: database,
      overrides: <Override>[
        dailyNowProvider.overrideWith(
          (ref) =>
              Stream<DateTime>.value(DateTime.parse('2026-03-22T12:00:00')),
        ),
      ],
    );
    addTearDown(container.dispose);

    await pumpPage(tester, container, const WorshipPage());

    expect(find.text('Tahajjud'), findsOneWidget);
    expect(find.text('التهجد'), findsOneWidget);

    // The 5+1 tracker total still shows on Home's salah hero stats.
    await pumpPage(tester, container, const HomePage());
    expect(find.textContaining('5+1'), findsWidgets);
  });
}
