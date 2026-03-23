import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/app/app_router.dart';
import 'package:path_of_nur/features/learn/presentation/pages/quran_app_hub_page.dart';
import 'package:path_of_nur/features/learn/presentation/pages/learn_quran_hub_page.dart';
import 'package:path_of_nur/features/learn/quran/presentation/quran_search_page.dart';
import 'package:path_of_nur/features/learn/quran/presentation/quran_surah_explorer_page.dart';
import 'package:path_of_nur/features/learn/quran/presentation/quran_reader_page.dart';
import 'package:path_of_nur/features/learn/quran/presentation/widgets/quran_learning_personalization_section.dart';
import 'package:path_of_nur/l10n/app_localizations.dart';
import 'package:path_of_nur/shared/application/daily_clock_provider.dart';
import 'package:path_of_nur/shared/widgets/quran_quote_block.dart';

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

  Finder pageScrollable(Finder pageFinder) {
    return find.descendant(of: pageFinder, matching: find.byType(Scrollable));
  }

  Future<void> scrollToLabel(
    WidgetTester tester,
    Finder pageFinder,
    String labelFragment,
  ) async {
    final scrollable = pageScrollable(pageFinder).first;
    final labelFinder = find.textContaining(labelFragment);

    for (var attempt = 0; attempt < 12; attempt += 1) {
      if (labelFinder.evaluate().isNotEmpty) {
        await tester.ensureVisible(labelFinder.first);
        await pumpRouteFrames(tester);
        return;
      }
      await tester.drag(scrollable, const Offset(0, -500));
      await pumpRouteFrames(tester);
    }

    expect(labelFinder, findsWidgets);
  }

  Future<void> tapHubActionLabel(
    WidgetTester tester,
    Finder pageFinder,
    String labelFragment,
  ) async {
    await scrollToLabel(tester, pageFinder, labelFragment);
    await tester.tap(find.textContaining(labelFragment).last);
    await pumpRouteFrames(tester);
  }

  testWidgets('main quran page prioritizes search and reading surfaces', (
    tester,
  ) async {
    final container = await makeContainer();
    final router = container.read(appRouterProvider);
    final l10n = await AppLocalizations.delegate.load(const Locale('en'));

    await tester.pumpWidget(buildRouterTestApp(container));
    await pumpRouteFrames(tester);

    router.go('/quran');
    await pumpRouteFrames(tester);
    expect(find.byType(QuranAppHubPage), findsOneWidget);
    final pageFinder = find.byType(QuranAppHubPage);
    expect(find.textContaining('Continue Learning'), findsNothing);
    expect(find.textContaining('Journey of the Qur'), findsNothing);
    expect(find.textContaining('Understanding Surah'), findsNothing);
    expect(find.textContaining('Qur’an Learning'), findsNothing);
    expect(find.textContaining('Short Surahs'), findsNothing);
    expect(find.textContaining('Study'), findsNothing);
    expect(find.textContaining('Memorize'), findsNothing);

    for (final label in <String>[
      l10n.quranHubReadQuranSectionTitle,
      l10n.quranHubContinueSectionTitle,
      l10n.quranHubDailyLightTitle,
      l10n.quranNotesTitle,
      l10n.learnCategoryQuranLearningTitle,
    ]) {
      await scrollToLabel(tester, pageFinder, label);
      expect(find.textContaining(label), findsWidgets);
    }
  });

  testWidgets('continue and read quran islands keep expected routes', (
    tester,
  ) async {
    final container = await makeContainer();
    final router = container.read(appRouterProvider);

    await tester.pumpWidget(buildRouterTestApp(container));
    await pumpRouteFrames(tester);

    router.go('/quran');
    await pumpRouteFrames(tester);
    final pageFinder = find.byType(QuranAppHubPage);

    await tapHubActionLabel(tester, pageFinder, 'Continue');
    expect(find.byType(QuranReaderPage), findsOneWidget);

    router.go('/quran');
    await pumpRouteFrames(tester);
    expect(find.byType(QuranAppHubPage), findsOneWidget);

    await tapHubActionLabel(tester, find.byType(QuranAppHubPage), 'Read Qur');
    expect(find.byType(QuranSurahExplorerPage), findsOneWidget);
  });

  testWidgets('quran home no longer shows the shared quote block', (
    tester,
  ) async {
    final container = await makeContainer();
    final router = container.read(appRouterProvider);
    final l10n = await AppLocalizations.delegate.load(const Locale('en'));

    await tester.pumpWidget(buildRouterTestApp(container));
    await pumpRouteFrames(tester);

    router.go('/quran');
    await pumpRouteFrames(tester);
    expect(find.byType(QuranQuoteBlock), findsNothing);

    router.go('/quran/search');
    await pumpRouteFrames(tester);
    expect(find.byType(QuranSearchPage), findsOneWidget);

    router.go('/quran/learning');
    await pumpRouteFrames(tester);
    expect(find.byType(LearnQuranHubPage), findsOneWidget);
    expect(find.byType(QuranLearningPersonalizationSection), findsOneWidget);
    expect(find.text(l10n.quranHubStudyTitle), findsOneWidget);
    expect(find.text(l10n.learnQuranHubTabUnderstand), findsWidgets);
    expect(find.text(l10n.learnQuranHubTabReflect), findsWidgets);
    expect(find.text(l10n.learnQuranHubTabPaths), findsWidgets);
    expect(find.text(l10n.learnQuranHubTabMemorize), findsWidgets);
  });

  testWidgets('quran home routes quran learning through the canonical quran owner', (
    tester,
  ) async {
    final container = await makeContainer();
    final router = container.read(appRouterProvider);

    await tester.pumpWidget(buildRouterTestApp(container));
    await pumpRouteFrames(tester);

    router.go('/quran');
    await pumpRouteFrames(tester);
    expect(find.byType(QuranAppHubPage), findsOneWidget);

    await scrollToLabel(tester, find.byType(QuranAppHubPage), 'Qur’an Learning');
    await tester.tap(find.textContaining('Qur’an Learning').last);
    await pumpRouteFrames(tester);

    expect(find.byType(LearnQuranHubPage), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
