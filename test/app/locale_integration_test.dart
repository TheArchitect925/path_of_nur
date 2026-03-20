import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:path_of_nur/core/localization/locale_provider.dart';
import 'package:path_of_nur/features/home/presentation/home_page.dart';
import 'package:path_of_nur/features/journey/presentation/journey_page.dart';
import 'package:path_of_nur/features/learn/presentation/learn_page.dart';
import 'package:path_of_nur/features/learn/presentation/pages/learning_section_landing_page.dart';
import 'package:path_of_nur/features/learn/presentation/pages/quran_app_hub_page.dart';
import 'package:path_of_nur/features/profile/presentation/settings_page.dart';
import 'package:path_of_nur/features/worship/presentation/worship_page.dart';

import 'package:path_of_nur/shared/application/daily_clock_provider.dart';

import 'package:path_of_nur/app/app_router.dart';
import '../test_helpers/app_test_harness.dart';

void main() {
  Future<void> pumpRouteFrames(WidgetTester tester) async {
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 120));
    await tester.pump(const Duration(milliseconds: 180));
  }

  test('unsupported locale codes resolve back to local system locale', () async {
    final container = await makeTestContainer();
    addTearDown(container.dispose);
    final notifier = container.read(appLocaleProvider.notifier);

    notifier.setLocale(const Locale('ar'));
    expect(container.read(appLocaleProvider), const Locale('ar'));

    notifier.setLocale(const Locale('fr', 'FR'));
    expect(container.read(appLocaleProvider), isNull);
  });

  testWidgets(
    'locale changes propagate across routes and directionality updates',
    (tester) async {
      final container = await makeTestContainer(
        overrides: [
          dailyNowProvider.overrideWith(
            (ref) => Stream<DateTime>.value(
              DateTime.parse('2026-03-14T12:00:00'),
            ),
          ),
        ],
      );
      addTearDown(container.dispose);
      final router = container.read(appRouterProvider);
      final localeNotifier = container.read(appLocaleProvider.notifier);

      localeNotifier.setLocale(const Locale('en'));
      await tester.pumpWidget(buildRouterTestApp(container));
      await pumpRouteFrames(tester);

      var homeContext = tester.element(find.byType(HomePage));
      expect(Localizations.localeOf(homeContext).languageCode, 'en');
      expect(Directionality.of(homeContext), TextDirection.ltr);

      localeNotifier.setLocale(const Locale('ar'));
      await pumpRouteFrames(tester);

      homeContext = tester.element(find.byType(HomePage));
      expect(Localizations.localeOf(homeContext).languageCode, 'ar');
      expect(Directionality.of(homeContext), TextDirection.rtl);

      router.go('/settings');
      await pumpRouteFrames(tester);
      await pumpRouteFrames(tester);

      final settingsContext = tester.element(find.byType(SettingsPage));
      expect(Localizations.localeOf(settingsContext).languageCode, 'ar');
      expect(Directionality.of(settingsContext), TextDirection.rtl);
      expect(find.byType(SettingsPage), findsOneWidget);
      expect(find.byType(HomePage), findsNothing);
      expect(tester.takeException(), isNull);

      localeNotifier.setLocale(const Locale('fr', 'FR'));
      await pumpRouteFrames(tester);

      final fallbackContext = tester.element(find.byType(SettingsPage));
      expect(Localizations.localeOf(fallbackContext).languageCode, isNot('fr'));
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('locale sweep keeps routed pages localized consistently',
      (tester) async {
    final container = await makeTestContainer(
      overrides: [
        dailyNowProvider.overrideWith(
          (ref) => Stream<DateTime>.value(
            DateTime.parse('2026-03-14T12:00:00'),
          ),
        ),
      ],
    );
    addTearDown(container.dispose);
    final router = container.read(appRouterProvider);
    final localeNotifier = container.read(appLocaleProvider.notifier);

    await tester.pumpWidget(buildRouterTestApp(container));
    await pumpRouteFrames(tester);

    final expectedPrimaryType = <String, Type>{
      '/home': HomePage,
      '/worship': WorshipPage,
      '/learn': LearningSectionLandingPage,
      '/learn/legacy': LearnPage,
      '/journey': JourneyPage,
      '/quran': QuranAppHubPage,
      '/settings': SettingsPage,
    };

    final localeSteps = <Locale>[const Locale('en'), const Locale('ar')];
    for (final locale in localeSteps) {
      localeNotifier.setLocale(locale);
      await pumpRouteFrames(tester);

      final expectedLocale = container.read(appLocaleProvider) ??
          const Locale('en');
      for (final entry in expectedPrimaryType.entries) {
        final route = entry.key;
        router.go(route);
        await pumpRouteFrames(tester);
        expect(find.byType(entry.value), findsOneWidget, reason: route);
        final context = tester.element(find.byType(Navigator).first);
        final activeLocale = Localizations.localeOf(context);
        expect(activeLocale, expectedLocale, reason: '$route:$locale');
        if (expectedLocale.languageCode == 'ar') {
          expect(Directionality.of(context), TextDirection.rtl);
        } else {
          expect(Directionality.of(context), TextDirection.ltr);
        }
      }
    }

    localeNotifier.setLocale(const Locale('fr', 'FR'));
    await pumpRouteFrames(tester);
    final fallbackLocale = container.read(appLocaleProvider) ?? const Locale('en');
    expect(fallbackLocale.languageCode, isNot('fr'));

    router.go('/settings');
    await pumpRouteFrames(tester);
    final fallbackContext = tester.element(find.byType(SettingsPage));
    expect(Localizations.localeOf(fallbackContext).languageCode,
        fallbackLocale.languageCode);
    expect(tester.takeException(), isNull);
  });
}
