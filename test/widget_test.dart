import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:path_of_nur/features/shared/legal_info_page.dart';
import 'package:path_of_nur/l10n/app_localizations.dart';
import 'package:path_of_nur/shared/persistence/local_store.dart';
import 'package:path_of_nur/shared/widgets/premium_card.dart';
import 'package:path_of_nur/features/worship/presentation/worship_page.dart';

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

    expect(find.byType(LegalInfoPage), findsOneWidget);
    expect(find.byIcon(Icons.support_agent_rounded), findsOneWidget);
  });

  testWidgets('worship page moon card shows all five prayers with times',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
        child: MaterialApp(
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: const Scaffold(body: WorshipPage()),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final moonCard =
        find.widgetWithText(PremiumCard, 'Moon Phase').first;
    expect(moonCard, findsOneWidget);

    const prayerNames = ['Fajr', 'Dhuhr', 'Asr', 'Maghrib', 'Isha'];
    for (final prayerName in prayerNames) {
      expect(
        find.descendant(
          of: moonCard,
          matching: find.textContaining('$prayerName '),
        ),
        findsAtLeastNWidgets(1),
      );
    }
  });
}
