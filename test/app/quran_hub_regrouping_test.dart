import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/app/app_router.dart';
import 'package:path_of_nur/features/learn/presentation/pages/quran_app_hub_page.dart';
import 'package:path_of_nur/features/learn/presentation/pages/learn_quran_hub_page.dart';
import 'package:path_of_nur/features/learn/quran/presentation/quran_knowledge_search_page.dart';
import 'package:path_of_nur/features/learn/quran/presentation/quran_learning_paths_page.dart';
import 'package:path_of_nur/features/learn/quran/presentation/quran_memorization_review_page.dart';
import 'package:path_of_nur/features/learn/quran/presentation/quran_search_page.dart';
import 'package:path_of_nur/features/learn/quran/presentation/quran_surah_insight_page.dart';
import 'package:path_of_nur/features/learn/quran/presentation/quran_summary_page.dart';
import 'package:path_of_nur/features/learn/quran/presentation/quran_topic_explorer_page.dart';
import 'package:path_of_nur/features/learn/quran/presentation/quran_word_review_page.dart';
import 'package:path_of_nur/features/learn/quran/presentation/quran_words_page.dart';
import 'package:path_of_nur/features/learn/quran/presentation/widgets/quran_learning_personalization_section.dart';
import 'package:path_of_nur/l10n/app_localizations.dart';
import 'package:path_of_nur/shared/application/daily_clock_provider.dart';
import 'package:path_of_nur/shared/content/learning_quote.dart';
import 'package:path_of_nur/shared/widgets/main_page_search_launcher.dart';
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

  // Matches text containing the label without spilling into longer words
  // (e.g. a 'Memorize' label must not match a 'Memorized' stat chip).
  Finder labelTextFinder(String labelFragment) {
    return find.textContaining(
      RegExp('${RegExp.escape(labelFragment)}(?!\\w)'),
    );
  }

  Future<void> scrollToFinder(
    WidgetTester tester,
    Finder pageFinder,
    Finder target,
  ) async {
    final scrollable = pageScrollable(pageFinder).first;

    for (var attempt = 0; attempt < 24; attempt += 1) {
      if (target.hitTestable().evaluate().isNotEmpty) {
        return;
      }
      if (target.evaluate().isEmpty) {
        await tester.drag(scrollable, const Offset(0, -500));
      } else if (attempt.isEven) {
        await tester.ensureVisible(target.first);
      } else {
        await tester.drag(scrollable, const Offset(0, -140));
      }
      await pumpRouteFrames(tester);
    }

    expect(target.hitTestable(), findsWidgets);
  }

  Future<void> scrollToLabel(
    WidgetTester tester,
    Finder pageFinder,
    String labelFragment,
  ) async {
    await scrollToFinder(tester, pageFinder, labelTextFinder(labelFragment));
  }

  Future<void> resetScroll(WidgetTester tester, Finder pageFinder) async {
    tester
        .state<ScrollableState>(pageScrollable(pageFinder).first)
        .position
        .jumpTo(0);
    await pumpRouteFrames(tester);
  }

  // Hub navigation actions live in the action grids and the related-tools
  // chips; scoping avoids matching same-named labels on other hub cards
  // (e.g. the intent focus card also shows a 'Memorize' label).
  Finder hubActionSurface() {
    return find.byWidgetPredicate((widget) {
      final typeName = widget.runtimeType.toString();
      return typeName == 'SectionHubActionGrid' ||
          typeName == '_SecondaryToolChip';
    });
  }

  Future<void> tapHubActionLabel(
    WidgetTester tester,
    Finder pageFinder,
    String labelFragment,
  ) async {
    final target = find.descendant(
      of: hubActionSurface(),
      matching: labelTextFinder(labelFragment),
    );
    await scrollToFinder(tester, pageFinder, target);
    await tester.tap(target.hitTestable().last);
    await pumpRouteFrames(tester);
  }

  Future<void> tapAncestorInkWellForText(
    WidgetTester tester,
    String text,
  ) async {
    final inkWellFinder = find.ancestor(
      of: find.text(text).first,
      matching: find.byType(InkWell),
    );
    final inkWell = tester.widget<InkWell>(inkWellFinder.first);
    inkWell.onTap?.call();
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
    expect(find.textContaining('Continue Learning'), findsNothing);
    expect(find.textContaining('Journey of the Qur'), findsNothing);
    expect(find.textContaining('Understanding Surah'), findsNothing);
    expect(find.textContaining('Short Surahs'), findsNothing);
    expect(find.textContaining('Memorize'), findsNothing);

    await scrollToLabel(
      tester,
      find.byType(QuranAppHubPage),
      l10n.quranDiscoverSectionTitle,
    );
    expect(find.text(l10n.quranDiscoverSectionTitle), findsOneWidget);
  });

  testWidgets(
    'discover the quran card groups and collapses discovery surfaces',
    (tester) async {
      final container = await makeContainer();
      final router = container.read(appRouterProvider);
      final l10n = await AppLocalizations.delegate.load(const Locale('en'));

      await tester.pumpWidget(buildRouterTestApp(container));
      await pumpRouteFrames(tester);

      router.go('/quran');
      await pumpRouteFrames(tester);

      final hubPage = find.byType(QuranAppHubPage);
      await scrollToLabel(tester, hubPage, l10n.quranDiscoverSectionTitle);
      expect(find.text(l10n.quranDiscoverSectionTitle), findsOneWidget);

      // The discovery group starts collapsed; expand it to surface islands.
      await tester.tap(find.text(l10n.quranDiscoverSectionTitle));
      await pumpRouteFrames(tester);

      for (final islandTitle in <String>[
        l10n.quranSummaryIslandTitle,
        l10n.quranThemeDiscoveryIslandTitle,
        l10n.quranPathwaysIslandTitle,
        l10n.quranSpiritualMomentHubTitle,
        l10n.quranPersonalizationHubTitle,
      ]) {
        await scrollToLabel(tester, hubPage, islandTitle);
        expect(find.text(islandTitle), findsOneWidget);
      }

      await resetScroll(tester, hubPage);
      await scrollToLabel(tester, hubPage, l10n.quranDiscoverSectionTitle);
      await tester.tap(find.text(l10n.quranDiscoverSectionTitle));
      await pumpRouteFrames(tester);

      expect(
        find.text(l10n.quranSummaryIslandTitle).hitTestable(),
        findsNothing,
      );
      expect(
        find.text(l10n.quranThemeDiscoveryIslandTitle).hitTestable(),
        findsNothing,
      );
      expect(
        find.text(l10n.quranPathwaysIslandTitle).hitTestable(),
        findsNothing,
      );
      expect(
        find.text(l10n.quranSpiritualMomentHubTitle).hitTestable(),
        findsNothing,
      );
      expect(
        find.text(l10n.quranPersonalizationHubTitle).hitTestable(),
        findsNothing,
      );

      await tester.tap(find.text(l10n.quranDiscoverSectionTitle));
      await pumpRouteFrames(tester);

      for (final islandTitle in <String>[
        l10n.quranSummaryIslandTitle,
        l10n.quranThemeDiscoveryIslandTitle,
        l10n.quranPathwaysIslandTitle,
      ]) {
        await scrollToLabel(tester, hubPage, islandTitle);
        expect(find.text(islandTitle), findsOneWidget);
      }
    },
  );

  testWidgets('summary and search surfaces keep expected routes', (
    tester,
  ) async {
    final container = await makeContainer();
    final router = container.read(appRouterProvider);
    final l10n = await AppLocalizations.delegate.load(const Locale('en'));

    await tester.pumpWidget(buildRouterTestApp(container));
    await pumpRouteFrames(tester);

    router.go('/quran');
    await pumpRouteFrames(tester);
    final hubPage = find.byType(QuranAppHubPage);
    await scrollToLabel(tester, hubPage, l10n.quranDiscoverSectionTitle);
    await tester.tap(find.text(l10n.quranDiscoverSectionTitle));
    await pumpRouteFrames(tester);
    await scrollToLabel(tester, hubPage, l10n.quranSummaryIslandTitle);
    await tapAncestorInkWellForText(tester, l10n.quranSummaryIslandTitle);
    expect(find.byType(QuranSummaryPage), findsOneWidget);

    router.go('/quran');
    await pumpRouteFrames(tester);
    expect(find.byType(QuranAppHubPage), findsOneWidget);

    await resetScroll(tester, find.byType(QuranAppHubPage));
    final searchLauncherFinder = find.byType(MainPageSearchLauncher);
    await scrollToFinder(
      tester,
      find.byType(QuranAppHubPage),
      searchLauncherFinder,
    );
    final launcher = tester.widget<GestureDetector>(
      find
          .descendant(
            of: searchLauncherFinder,
            matching: find.byType(GestureDetector),
          )
          .first,
    );
    launcher.onTap?.call();
    await pumpRouteFrames(tester);
    expect(find.byType(EditableText), findsWidgets);
    expect(find.byType(QuranSearchPage), findsNothing);
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
    // The hub keeps a dedicated Messenger-guidance entry quote, but the
    // shared default learning quote must no longer appear on quran home.
    final sharedLearningQuoteRef = buildLearningCompactQuote().ref;
    final hubQuoteBlocks = tester.widgetList<QuranQuoteBlock>(
      find.descendant(
        of: find.byType(QuranAppHubPage),
        matching: find.byType(QuranQuoteBlock),
      ),
    );
    expect(
      hubQuoteBlocks.where(
        (block) => block.quote.ref == sharedLearningQuoteRef,
      ),
      isEmpty,
    );

    router.go('/quran/search');
    await pumpRouteFrames(tester);
    expect(find.byType(QuranSearchPage), findsOneWidget);

    router.go('/quran/learning');
    await pumpRouteFrames(tester);
    expect(find.byType(LearnQuranHubPage), findsOneWidget);

    final learnPage = find.byType(LearnQuranHubPage);
    await scrollToLabel(tester, learnPage, l10n.quranHubStudyTitle);
    expect(find.text(l10n.quranHubStudyTitle), findsOneWidget);

    // The Qur'an Companion group starts collapsed; expand it so the
    // personalization section mounts.
    await scrollToLabel(tester, learnPage, l10n.quranCompanionSectionTitle);
    await tester.tap(find.text(l10n.quranCompanionSectionTitle));
    await pumpRouteFrames(tester);
    await tester.scrollUntilVisible(
      find.byType(QuranLearningPersonalizationSection),
      400,
      scrollable: pageScrollable(learnPage).first,
      maxScrolls: 60,
    );
    expect(find.byType(QuranLearningPersonalizationSection), findsOneWidget);

    await resetScroll(tester, learnPage);
    for (final tabLabel in <String>[
      l10n.learnQuranHubTabUnderstand,
      l10n.learnQuranHubTabReflect,
      l10n.learnQuranHubTabPaths,
      l10n.learnQuranHubTabMemorize,
    ]) {
      await scrollToLabel(tester, learnPage, tabLabel);
      expect(find.text(tabLabel), findsWidgets);
    }
  });

  testWidgets(
    'quran home routes quran learning through the canonical quran owner',
    (tester) async {
      final container = await makeContainer();
      final router = container.read(appRouterProvider);

      await tester.pumpWidget(buildRouterTestApp(container));
      await pumpRouteFrames(tester);

      router.go('/quran');
      await pumpRouteFrames(tester);
      expect(find.byType(QuranAppHubPage), findsOneWidget);

      await scrollToLabel(
        tester,
        find.byType(QuranAppHubPage),
        'Qur’an Learning',
      );
      await tapAncestorInkWellForText(tester, 'Qur’an Learning');

      expect(find.byType(LearnQuranHubPage), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('quran home surfaces deeper study tools with working routes', (
    tester,
  ) async {
    final l10n = await AppLocalizations.delegate.load(const Locale('en'));
    final routeCases = <({String label, Type pageType})>[
      (
        label: l10n.quranKnowledgeSearchTitle,
        pageType: QuranKnowledgeSearchPage,
      ),
      (
        label: l10n.quranHubMemorizeTitle,
        pageType: QuranMemorizationReviewPage,
      ),
      (
        label: l10n.quranSurahInsightsBrowseTitle,
        pageType: QuranSurahInsightsBrowsePage,
      ),
      (label: l10n.quranLearningPathsTitle, pageType: QuranLearningPathsPage),
      (label: l10n.quranTopicsTitle, pageType: QuranTopicExplorerPage),
      (label: l10n.quranTopWordsTitle, pageType: QuranWordsPage),
      (label: l10n.quranWordReviewTitle, pageType: QuranWordReviewPage),
    ];

    for (final routeCase in routeCases) {
      final container = await makeContainer();
      addTearDown(container.dispose);
      final router = container.read(appRouterProvider);

      await tester.pumpWidget(buildRouterTestApp(container));
      await pumpRouteFrames(tester);

      router.go('/quran');
      await pumpRouteFrames(tester);
      expect(find.byType(QuranAppHubPage), findsOneWidget);

      await tapHubActionLabel(
        tester,
        find.byType(QuranAppHubPage),
        routeCase.label,
      );
      expect(find.byType(routeCase.pageType), findsOneWidget);
      expect(tester.takeException(), isNull);

      await tester.pumpWidget(const SizedBox.shrink());
      await pumpRouteFrames(tester);
    }
  });
}
