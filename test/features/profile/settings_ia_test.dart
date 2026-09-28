import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:path_of_nur/app/app_router.dart';
import 'package:path_of_nur/features/profile/presentation/settings/settings_catalog.dart';
import 'package:path_of_nur/features/profile/presentation/settings/settings_search_page.dart';
import 'package:path_of_nur/features/profile/presentation/settings_page.dart';
import 'package:path_of_nur/features/shared/legal_info_page.dart';
import 'package:path_of_nur/l10n/app_localizations.dart';
import 'package:path_of_nur/shared/application/daily_clock_provider.dart';
import 'package:path_of_nur/shared/widgets/display/compact_list_tile.dart';

import '../../test_helpers/app_test_harness.dart';

void main() {
  Future<void> pumpRouteFrames(WidgetTester tester) async {
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 120));
    await tester.pump(const Duration(milliseconds: 180));
  }

  Future<GoRouter> pumpRouter(
    WidgetTester tester, {
    String location = '/settings',
  }) async {
    await tester.binding.setSurfaceSize(const Size(1200, 3200));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    // The daily clock ticks on a real timer; without a fixed stream the
    // binding reports a pending timer when the tree is torn down.
    final container = await makeTestContainer(
      overrides: <Override>[
        dailyNowProvider.overrideWith(
          (ref) =>
              Stream<DateTime>.value(DateTime.parse('2026-03-22T12:00:00')),
        ),
      ],
    );
    addTearDown(container.dispose);

    final router = container.read(appRouterProvider);
    await tester.pumpWidget(buildRouterTestApp(container));
    router.go(location);
    await pumpRouteFrames(tester);
    return router;
  }

  AppLocalizations l10nOf(WidgetTester tester) {
    return AppLocalizations.of(tester.element(find.byType(SettingsPage).first));
  }

  testWidgets('settings landing lists every destination exactly once', (
    tester,
  ) async {
    await pumpRouter(tester);
    expect(find.byType(SettingsPage), findsOneWidget);

    final l10n = l10nOf(tester);
    final groups = settingsGroups(l10n);
    final routeNames = <String>[];
    for (final group in groups) {
      expect(find.text(group.title), findsWidgets);
      for (final destination in group.destinations) {
        routeNames.add(destination.routeName);
        expect(
          find.ancestor(
            of: find.text(destination.title).first,
            matching: find.byType(CompactListTile),
          ),
          findsWidgets,
          reason: '${destination.title} is missing from the landing list',
        );
      }
    }

    expect(
      routeNames.toSet().length,
      routeNames.length,
      reason: 'a settings destination is listed under more than one group',
    );
  });

  testWidgets('every settings destination route resolves to a real page', (
    tester,
  ) async {
    final router = await pumpRouter(tester);

    // Navigating by the catalog's own route name must land on a settings page
    // rather than the router's not-found screen.
    for (final category in SettingsCategory.values) {
      router.goNamed(settingsCategoryRouteName(category));
      await pumpRouteFrames(tester);
      expect(
        find.byType(SettingsPage),
        findsOneWidget,
        reason: '${category.name} route did not open a settings page',
      );
    }
  });

  testWidgets('settings search finds a control and routes to its page', (
    tester,
  ) async {
    await pumpRouter(tester, location: '/settings/search');
    expect(find.byType(SettingsSearchPage), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'adhan');
    await pumpRouteFrames(tester);

    final l10n = AppLocalizations.of(
      tester.element(find.byType(SettingsSearchPage)),
    );
    final row = find
        .ancestor(
          of: find.text(l10n.settingsAdhanChoiceTitle),
          matching: find.byType(CompactListTile),
        )
        .first;
    expect(row, findsOneWidget);

    await tester.ensureVisible(row);
    await pumpRouteFrames(tester);
    await tester.tap(row);
    await pumpRouteFrames(tester);
    expect(find.byType(SettingsPage), findsOneWidget);
  });

  testWidgets('settings search reports no matches for nonsense', (
    tester,
  ) async {
    await pumpRouter(tester, location: '/settings/search');
    await tester.enterText(find.byType(TextField), 'zzzzqqqq');
    await pumpRouteFrames(tester);

    final l10n = AppLocalizations.of(
      tester.element(find.byType(SettingsSearchPage)),
    );
    expect(find.text(l10n.settingsSearchEmptyTitle), findsOneWidget);
  });

  testWidgets('legal pages carry their own titles, not other pages names', (
    tester,
  ) async {
    final router = await pumpRouter(tester);

    for (final entry in <(String, LegalInfoKind)>[
      ('termsUsage', LegalInfoKind.terms),
      ('supportInfo', LegalInfoKind.support),
      ('privacyPolicy', LegalInfoKind.privacy),
    ]) {
      router.goNamed(entry.$1);
      await pumpRouteFrames(tester);
      final l10n = AppLocalizations.of(
        tester.element(find.byType(LegalInfoPage)),
      );
      final expected = switch (entry.$2) {
        LegalInfoKind.privacy => l10n.legalPrivacyTitle,
        LegalInfoKind.terms => l10n.legalTermsTitle,
        LegalInfoKind.support => l10n.legalSupportTitle,
      };
      expect(
        find.text(expected),
        findsWidgets,
        reason: '${entry.$1} is not titled $expected',
      );
      // The old bug: Terms was titled "About" and Support was titled
      // "Notifications & Reminders".
      expect(find.text(l10n.profileNotificationsTitle), findsNothing);
    }
  });
}
