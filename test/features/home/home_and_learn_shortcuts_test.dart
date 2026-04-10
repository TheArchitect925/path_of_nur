import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/home/presentation/home_page.dart';
import 'package:path_of_nur/features/learn/presentation/pages/learning_section_landing_page.dart';
import 'package:path_of_nur/l10n/app_localizations.dart';
import 'package:path_of_nur/shared/application/daily_clock_provider.dart';
import 'package:path_of_nur/shared/widgets/main_page_shortcut_configs.dart';

import '../../test_helpers/app_test_harness.dart';

void main() {
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
    'home page shows the shortcut pill and expands shortcut actions',
    (tester) async {
      final container = await makeTestContainer(
        overrides: <Override>[
          dailyNowProvider.overrideWith(
            (ref) =>
                Stream<DateTime>.value(DateTime.parse('2026-04-07T12:00:00')),
          ),
        ],
      );
      addTearDown(container.dispose);

      await pumpPage(tester, container, const HomePage());

      final homeContext = tester.element(find.byType(HomePage));
      final l10n = AppLocalizations.of(homeContext);
      final homeShortcuts = buildHomePageShortcuts(
        l10n,
        salahProgressText: '0/0',
        dhikrProgressText: '0/0',
      );
      final openShortcuts = find.text(l10n.homeShortcutOpen);
      expect(openShortcuts, findsOneWidget);

      await tester.tap(openShortcuts);
      await tester.pump();

      for (final item in homeShortcuts) {
        expect(find.text(item.label), findsWidgets);
      }
    },
  );

  testWidgets(
    'canonical learn landing shows the pre-restructure shortcut layout',
    (tester) async {
      final container = await makeTestContainer(
        overrides: <Override>[
          dailyNowProvider.overrideWith(
            (ref) =>
                Stream<DateTime>.value(DateTime.parse('2026-04-07T12:00:00')),
          ),
        ],
      );
      addTearDown(container.dispose);

      await pumpPage(tester, container, const LearningSectionLandingPage());

      final learnContext = tester.element(
        find.byType(LearningSectionLandingPage),
      );
      final l10n = AppLocalizations.of(learnContext);
      expect(find.text(l10n.learnShortcutOpen), findsOneWidget);
    },
  );
}
