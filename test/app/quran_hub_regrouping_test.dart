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
import 'package:path_of_nur/features/learn/presentation/widgets/learn_discovery_search_field.dart';
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
    expect(find.textContaining('Continue Learning'), findsNothing);
    expect(find.textContaining('Journey of the Qur'), findsNothing);
    expect(find.textContaining('Understanding Surah'), findsNothing);
    expect(find.textContaining('Short Surahs'), findsNothing);
    expect(find.textContaining('Memorize'), findsNothing);

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

      expect(find.text(l10n.quranDiscoverSectionTitle), findsOneWidget);
      expect(find.text(l10n.quranSummaryIslandTitle), findsOneWidget);
      expect(find.text(l10n.quranThemeDiscoveryIslandTitle), findsOneWidget);
      expect(find.text(l10n.quranPathwaysIslandTitle), findsOneWidget);
      expect(find.text(l10n.quranSpiritualMomentHubTitle), findsOneWidget);
      expect(find.text(l10n.quranPersonalizationHubTitle), findsOneWidget);

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

      expect(find.text(l10n.quranSummaryIslandTitle), findsOneWidget);
      expect(find.text(l10n.quranThemeDiscoveryIslandTitle), findsOneWidget);
      expect(find.text(l10n.quranPathwaysIslandTitle), findsOneWidget);
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
    final summaryFinder = find.text(l10n.quranSummaryIslandTitle).first;
    await tester.ensureVisible(summaryFinder);
    await tester.tap(summaryFinder);
    await pumpRouteFrames(tester);
    expect(find.byType(QuranSummaryPage), findsOneWidget);

    router.go('/quran');
    await pumpRouteFrames(tester);
    expect(find.byType(QuranAppHubPage), findsOneWidget);

    final searchFieldFinder = find.byType(LearnDiscoverySearchField);
    await tester.ensureVisible(searchFieldFinder);
    await tester.tap(searchFieldFinder);
    await pumpRouteFrames(tester);
    expect(find.byType(QuranSearchPage), findsOneWidget);
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
      await tester.tap(find.textContaining('Qur’an Learning').last);
      await pumpRouteFrames(tester);

      expect(find.byType(LearnQuranHubPage), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('quran home surfaces deeper study tools with working routes', (
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

    await tapHubActionLabel(
      tester,
      find.byType(QuranAppHubPage),
      l10n.quranKnowledgeSearchTitle,
    );
    expect(find.byType(QuranKnowledgeSearchPage), findsOneWidget);

    router.go('/quran');
    await pumpRouteFrames(tester);
    await tapHubActionLabel(
      tester,
      find.byType(QuranAppHubPage),
      l10n.quranHubMemorizeTitle,
    );
    expect(find.byType(QuranMemorizationReviewPage), findsOneWidget);

    router.go('/quran');
    await pumpRouteFrames(tester);
    await tapHubActionLabel(
      tester,
      find.byType(QuranAppHubPage),
      l10n.quranSurahInsightsBrowseTitle,
    );
    expect(find.byType(QuranSurahInsightsBrowsePage), findsOneWidget);

    router.go('/quran');
    await pumpRouteFrames(tester);
    await tapHubActionLabel(
      tester,
      find.byType(QuranAppHubPage),
      l10n.quranLearningPathsTitle,
    );
    expect(find.byType(QuranLearningPathsPage), findsOneWidget);

    router.go('/quran');
    await pumpRouteFrames(tester);
    await tapHubActionLabel(
      tester,
      find.byType(QuranAppHubPage),
      l10n.quranTopicsTitle,
    );
    expect(find.byType(QuranTopicExplorerPage), findsOneWidget);

    router.go('/quran');
    await pumpRouteFrames(tester);
    await tapHubActionLabel(
      tester,
      find.byType(QuranAppHubPage),
      l10n.quranTopWordsTitle,
    );
    expect(find.byType(QuranWordsPage), findsOneWidget);

    router.go('/quran');
    await pumpRouteFrames(tester);
    await tapHubActionLabel(
      tester,
      find.byType(QuranAppHubPage),
      l10n.quranWordReviewTitle,
    );
    expect(find.byType(QuranWordReviewPage), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
