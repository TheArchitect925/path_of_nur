import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:path_of_nur/features/learn/quran_teaching/domain/quran_teaching_icon_registry.dart';
import 'package:path_of_nur/features/shared/legal_info_page.dart';
import 'package:path_of_nur/l10n/app_localizations.dart';
import 'package:path_of_nur/shared/application/daily_clock_provider.dart';
import 'package:path_of_nur/shared/persistence/local_store.dart';
import 'package:path_of_nur/shared/widgets/app_scaffold.dart';
import 'package:path_of_nur/features/salah/presentation/salah_page.dart';
import 'package:path_of_nur/features/worship/presentation/worship_section_pages.dart';

void main() {
  testWidgets('Legal support page renders', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
        child: const MaterialApp(
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: LegalInfoPage(kind: LegalInfoKind.support),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Pushed pages no longer carry a header icon (header redesign, A1);
    // the page is identified by its title.
    final l10n = await AppLocalizations.delegate.load(const Locale('en'));
    expect(find.byType(LegalInfoPage), findsOneWidget);
    expect(find.text(l10n.legalSupportTitle), findsOneWidget);
  });

  testWidgets('worship page moon card shows all five prayers with times', (
    WidgetTester tester,
  ) async {
    // Phase 3b: the Salah Hub's Times tab now embeds the full salah-times
    // experience (SalahTimesPage) with all five prayers.
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          dailyNowProvider.overrideWith(
            (ref) =>
                Stream<DateTime>.value(DateTime.parse('2026-03-22T12:00:00')),
          ),
        ],
        child: MaterialApp(
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: const Scaffold(body: WorshipPrayerPage()),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 120));
    await tester.pump(const Duration(milliseconds: 180));

    await tester.scrollUntilVisible(
      find.byType(SalahTimesPage),
      400,
      scrollable: find.byType(Scrollable).first,
      maxScrolls: 60,
    );
    final timingsCard = find.byType(SalahTimesPage).first;
    expect(timingsCard, findsOneWidget);

    const prayerNames = ['Fajr', 'Dhuhr', 'Asr', 'Maghrib', 'Isha'];
    for (final prayerName in prayerNames) {
      expect(
        find.descendant(of: timingsCard, matching: find.text(prayerName)),
        findsAtLeastNWidgets(1),
      );
    }

    // Each prayer card in the merged Times tab carries a real offer time.
    final offerTimeLabels = find.descendant(
      of: timingsCard,
      matching: find.textContaining(':'),
    );
    expect(offerTimeLabels, findsAtLeastNWidgets(5));
  });

  testWidgets(
    'app shell can swap root tab content without duplicate key errors',
    (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      Widget buildShell(String location, String label) {
        return ProviderScope(
          overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
          child: MaterialApp(
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            home: AppShellScaffold(
              currentLocation: location,
              child: Center(child: Text(label)),
            ),
          ),
        );
      }

      await tester.pumpWidget(buildShell('/home', 'Home'));
      await tester.pump();
      await tester.pumpWidget(buildShell('/learn', 'Learn'));
      await tester.pump();
      await tester.pumpWidget(buildShell('/profile', 'Profile'));
      await tester.pump();

      expect(find.text('Profile'), findsAtLeastNWidgets(1));
      expect(tester.takeException(), isNull);
    },
  );

  test(
    'quran teaching icon registry resolves current and legacy payloads safely',
    () {
      final icon = QuranTeachingIconRegistry.iconFromJson(const {
        'iconId': 'menu_book_rounded',
      });
      expect(icon, Icons.menu_book_rounded);

      final legacyIcon = QuranTeachingIconRegistry.iconFromJson({
        'iconCodePoint': Icons.short_text_rounded.codePoint,
      });
      expect(legacyIcon, Icons.short_text_rounded);

      final serialized = QuranTeachingIconRegistry.iconToJson(
        Icons.rule_rounded,
      );
      expect(serialized['iconId'], 'rule_rounded');
      expect(serialized['iconCodePoint'], Icons.rule_rounded.codePoint);
    },
  );
}
