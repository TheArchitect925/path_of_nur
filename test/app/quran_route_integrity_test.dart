import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:path_of_nur/app/app_router.dart';
import 'package:path_of_nur/features/learn/presentation/pages/learn_quran_hub_page.dart';
import 'package:path_of_nur/features/learn/presentation/pages/quran_app_hub_page.dart';
import 'package:path_of_nur/features/learn/quran/presentation/quran_reflections_page.dart';
import 'package:path_of_nur/l10n/app_localizations.dart';
import 'package:path_of_nur/shared/application/daily_clock_provider.dart';

import '../test_helpers/app_test_harness.dart';

void main() {
  Future<void> pumpRouteFrames(WidgetTester tester) async {
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 120));
    await tester.pump(const Duration(milliseconds: 180));
  }

  Future<ProviderContainer> makeContainer() {
    return makeTestContainer(
      overrides: <Override>[
        dailyNowProvider.overrideWith(
          (ref) =>
              Stream<DateTime>.value(DateTime.parse('2026-03-14T12:00:00')),
        ),
      ],
    );
  }

  Future<void> tapReflectionsAction(
    WidgetTester tester,
    Finder hostPageFinder,
  ) async {
    final context = tester.element(hostPageFinder);
    final l10n = AppLocalizations.of(context);
    await tester.scrollUntilVisible(
      find.text(l10n.quranHubRelatedToolsTitle),
      240,
      scrollable: find.byType(Scrollable).first,
    );
    final iconFinder = find.byIcon(Icons.collections_bookmark_outlined);
    final chipFinder = find.ancestor(
      of: iconFinder,
      matching: find.byType(ActionChip),
    );
    final chip = tester.widget<ActionChip>(chipFinder.first);
    chip.onPressed?.call();
    await pumpRouteFrames(tester);
  }

  testWidgets('canonical and compatibility quran reflections routes resolve', (
    tester,
  ) async {
    final container = await makeContainer();
    final router = container.read(appRouterProvider);

    await tester.pumpWidget(buildRouterTestApp(container));
    await pumpRouteFrames(tester);

    for (final path in <String>[
      '/quran/reflections',
      '/learn/quran/reflections',
    ]) {
      router.go(path);
      await pumpRouteFrames(tester);
      expect(find.byType(QuranReflectionsPage), findsOneWidget, reason: path);
      expect(tester.takeException(), isNull, reason: path);
    }
  });

  testWidgets('quran app hub reflections action navigates successfully', (
    tester,
  ) async {
    final container = await makeContainer();
    final router = container.read(appRouterProvider);

    await tester.pumpWidget(buildRouterTestApp(container));
    await pumpRouteFrames(tester);

    router.go('/quran');
    await pumpRouteFrames(tester);
    expect(find.byType(QuranAppHubPage), findsOneWidget);

    await tapReflectionsAction(tester, find.byType(QuranAppHubPage));

    expect(find.byType(QuranReflectionsPage), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('quran learning study hub routes load without exceptions', (
    tester,
  ) async {
    final container = await makeContainer();
    final router = container.read(appRouterProvider);

    await tester.pumpWidget(buildRouterTestApp(container));
    await pumpRouteFrames(tester);

    for (final path in <String>[
      '/quran/learning?tab=reflect',
      '/learn/hub/quran/learning',
    ]) {
      router.go(path);
      await pumpRouteFrames(tester);
      expect(find.byType(LearnQuranHubPage), findsOneWidget, reason: path);
      expect(tester.takeException(), isNull, reason: path);
    }
  });
}
