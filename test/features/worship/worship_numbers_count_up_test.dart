import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/worship/presentation/worship_page.dart';
import 'package:path_of_nur/l10n/app_localizations.dart';
import 'package:path_of_nur/shared/application/daily_clock_provider.dart';
import 'package:path_of_nur/shared/motion/motion_preferences.dart';
import 'package:path_of_nur/shared/persistence/app_database.dart';
import 'package:path_of_nur/shared/persistence/local_store.dart';
import 'package:path_of_nur/shared/widgets/display/count_up_text.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The Prayer Room's numbers row: the offered and dhikr counts count up to
/// today's value on arrival; the fasting tile is a plain label.
void main() {
  Future<ProviderContainer> makeContainer({required bool reduceMotion}) async {
    final database = AppDatabase.inMemory();
    addTearDown(database.close);
    // One prayer offered on the test day, so there is something to count to.
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
        null,
        'onTime',
        'congregation',
        null,
        '2026-03-22T05:24:00.000',
      ],
    );
    SharedPreferences.setMockInitialValues(const <String, Object>{
      'app.onboardingCompleted': true,
    });
    final prefs = await SharedPreferences.getInstance();
    final container = ProviderContainer(
      overrides: <Override>[
        sharedPreferencesProvider.overrideWithValue(prefs),
        appDatabaseProvider.overrideWithValue(database),
        dailyNowProvider.overrideWith(
          (ref) =>
              Stream<DateTime>.value(DateTime.parse('2026-03-22T12:00:00')),
        ),
        effectiveReduceMotionProvider.overrideWithValue(reduceMotion),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  Future<void> pumpWorship(
    WidgetTester tester,
    ProviderContainer container,
  ) async {
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          localizationsDelegates: <LocalizationsDelegate<dynamic>>[
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(body: WorshipPage()),
        ),
      ),
    );
    await tester.pump();
    // The numbers row sits below the hero; the test viewport is short, so
    // scroll until the row has been built.
    final scrollable = find.byType(Scrollable).first;
    var attempts = 0;
    while (find.byType(CountUpText).evaluate().isEmpty && attempts < 30) {
      await tester.drag(scrollable, const Offset(0, -250));
      await tester.pump();
      attempts += 1;
    }
  }

  testWidgets('the offered count counts up to today\'s number', (tester) async {
    final container = await makeContainer(reduceMotion: false);
    await pumpWorship(tester, container);
    // Two counting tiles (Salah, Dhikr); the fasting tile is a label.
    expect(find.byType(CountUpText), findsNWidgets(2));
    // On the first frame the count has not started.
    expect(find.text('0 / 5'), findsOneWidget);
    await tester.pumpAndSettle();
    expect(find.text('1 / 5'), findsOneWidget);
    expect(find.text('0 / 5'), findsNothing);
  });

  testWidgets('under Reduce Motion the number is simply there', (tester) async {
    final container = await makeContainer(reduceMotion: true);
    await pumpWorship(tester, container);
    await tester.pump();
    expect(find.text('1 / 5'), findsOneWidget);
  });
}
