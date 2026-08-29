import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/home/presentation/home_page.dart';
import 'package:path_of_nur/features/worship/application/prayer_controller.dart';
import 'package:path_of_nur/features/worship/domain/prayer_name.dart';
import 'package:path_of_nur/l10n/app_localizations.dart';
import 'package:path_of_nur/shared/application/daily_clock_provider.dart';

import '../../test_helpers/app_test_harness.dart';

/// The salah tracker counts the five obligatory prayers. Tahajjud is a
/// bonus: offering it is shown on its own rather than inflating a
/// denominator that offering it never moved.
void main() {
  Future<ProviderContainer> makeContainer(WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(430, 2400));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final container = await makeTestContainer(
      overrides: <Override>[
        dailyNowProvider.overrideWith(
          (ref) =>
              Stream<DateTime>.value(DateTime.parse('2026-03-22T12:00:00')),
        ),
      ],
    );
    addTearDown(container.dispose);
    return container;
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
  }

  Future<void> pumpFrames(WidgetTester tester) async {
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 150));
    await tester.pump(const Duration(milliseconds: 250));
  }

  testWidgets(
    'the tracker counts five, with no bonus until Tahajjud is offered',
    (tester) async {
      final container = await makeContainer(tester);
      await pumpPage(tester, container, const HomePage());
      await pumpFrames(tester);

      final l10n = await AppLocalizations.delegate.load(const Locale('en'));
      expect(find.textContaining('5+1'), findsNothing);
      expect(find.textContaining('/ 5'), findsWidgets);
      expect(find.text(l10n.homeShortcutDailyCaption), findsWidgets);
      expect(
        find.textContaining('Tahajjud'),
        findsNothing,
        reason: 'no bonus before Tahajjud is offered',
      );
    },
  );

  testWidgets('offering Tahajjud shows a separate bonus, not a sixth prayer', (
    tester,
  ) async {
    final container = await makeContainer(tester);
    // Let the day's records load first, then offer Tahajjud the way someone
    // would with the app already open.
    await pumpPage(tester, container, const HomePage());
    await pumpFrames(tester);
    container
        .read(prayerControllerProvider.notifier)
        .markCompleted(PrayerName.tahajjud);
    await pumpFrames(tester);

    // The fraction still counts only the five obligatory prayers...
    expect(find.textContaining('/ 5'), findsWidgets);
    expect(find.textContaining('/ 6'), findsNothing);
    expect(find.textContaining('5+1'), findsNothing);
    // ...and the bonus is called out on its own.
    expect(find.textContaining('Tahajjud'), findsWidgets);
  });
}
