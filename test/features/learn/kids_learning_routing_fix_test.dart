import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:path_of_nur/app/app_router.dart';
import 'package:path_of_nur/features/kids/bedtime_stories/presentation/kids_hadith_stories_page.dart';
import 'package:path_of_nur/features/kids/bedtime_stories/presentation/kids_story_library_page.dart';
import 'package:path_of_nur/features/kids_dua_learning/presentation/kids_dua_landing_page.dart';
import 'package:path_of_nur/features/learn/hadith/presentation/kids_hadith_page.dart';
import 'package:path_of_nur/features/learn/presentation/kids_learning_localizations.dart';
import 'package:path_of_nur/features/learn/presentation/pages/learn_category_page.dart';
import 'package:path_of_nur/features/learn/presentation/pages/learn_kids_fun_learning_page.dart';
import 'package:path_of_nur/features/learn/presentation/pages/learn_kids_games_page.dart';
import 'package:path_of_nur/features/learn/quran/presentation/kids_quran_page.dart';
import 'package:path_of_nur/l10n/app_localizations.dart';
import 'package:path_of_nur/shared/application/daily_clock_provider.dart';
import 'package:path_of_nur/shared/widgets/section_hub_scaffold.dart';

import '../../test_helpers/app_test_harness.dart';

void main() {
  Future<ProviderContainer> makeRoutingTestContainer() {
    return makeTestContainer(
      overrides: <Override>[
        dailyNowProvider.overrideWith(
          (ref) =>
              Stream<DateTime>.value(DateTime.parse('2026-03-23T12:00:00')),
        ),
      ],
    );
  }

  Future<void> pumpRouteFrames(WidgetTester tester) async {
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 120));
    await tester.pump(const Duration(milliseconds: 180));
  }

  Future<void> tapActionCard(WidgetTester tester, String label) async {
    if (find.text(label).evaluate().isEmpty) {
      final scrollableFinder = find.byType(Scrollable).first;
      tester.state<ScrollableState>(scrollableFinder).position.jumpTo(0);
      await tester.pump();
      await tester.scrollUntilVisible(
        find.text(label),
        400,
        scrollable: scrollableFinder,
        maxScrolls: 60,
      );
      await pumpRouteFrames(tester);
    }
    final labelFinder = find.text(label).first;
    await tester.ensureVisible(labelFinder);
    await pumpRouteFrames(tester);
    final cardFinder = find.ancestor(
      of: labelFinder,
      matching: find.byType(SectionHubActionCard),
    );
    await tester.tap(cardFinder.first);
    await pumpRouteFrames(tester);
  }

  testWidgets(
    'kids learning islands open their real kids destinations instead of generic category fallbacks',
    (tester) async {
      final container = await makeRoutingTestContainer();
      final router = container.read(appRouterProvider);

      await tester.pumpWidget(buildRouterTestApp(container));
      await pumpRouteFrames(tester);

      final l10n = await AppLocalizations.delegate.load(const Locale('en'));

      router.go('/learn/category/kids-learning');
      await pumpRouteFrames(tester);
      expect(find.byType(LearnCategoryPage), findsOneWidget);

      await tapActionCard(tester, l10n.learnHubSubcategoryKidsQuranTitleText);
      expect(find.byType(KidsQuranPage), findsOneWidget);

      router.go('/learn/category/kids-learning');
      await pumpRouteFrames(tester);
      await tapActionCard(tester, l10n.learnHubSubcategoryKidsHadithTitleText);
      expect(find.byType(KidsHadithPage), findsOneWidget);

      router.go('/learn/category/kids-learning');
      await pumpRouteFrames(tester);
      await tapActionCard(
        tester,
        l10n.learnHubSubcategoryKidsHadithStoriesTitleText,
      );
      expect(find.byType(KidsHadithStoriesPage), findsOneWidget);

      router.go('/learn/category/kids-learning');
      await pumpRouteFrames(tester);
      await tapActionCard(tester, l10n.kidsStoryCollectionProphets);
      expect(find.byType(KidsStoryLibraryPage), findsOneWidget);
      expect(find.text(l10n.kidsStoryCollectionProphets), findsWidgets);

      router.go('/learn/category/kids-learning');
      await pumpRouteFrames(tester);
      await tapActionCard(tester, l10n.learnHubSubcategoryKidsStoriesTitle);
      expect(find.byType(KidsStoryLibraryPage), findsOneWidget);
      expect(find.text(l10n.kidsStoryLibraryTitle), findsWidgets);

      router.go('/learn/category/kids-learning');
      await pumpRouteFrames(tester);
      await tapActionCard(tester, l10n.kidsDuaLandingTitle);
      expect(find.byType(KidsDuaLandingPage), findsOneWidget);
    },
  );

  testWidgets('Kids Games routes to a non-empty games destination', (
    tester,
  ) async {
    final container = await makeRoutingTestContainer();
    final router = container.read(appRouterProvider);

    await tester.pumpWidget(buildRouterTestApp(container));
    await pumpRouteFrames(tester);

    final l10n = await AppLocalizations.delegate.load(const Locale('en'));

    router.go('/learn/category/kids-learning');
    await pumpRouteFrames(tester);
    await tapActionCard(tester, l10n.learnHubSubcategoryKidsGamesTitle);

    expect(find.byType(LearnKidsGamesPage), findsOneWidget);
    expect(find.text(l10n.kidsArabicPracticeTitle), findsOneWidget);
    expect(find.text(l10n.kidsDuaPracticeTitle), findsOneWidget);
    expect(find.text(l10n.kidsArabicColoringPagesTitle), findsOneWidget);
  });

  testWidgets('Fun Learning no longer routes to an empty misleading page', (
    tester,
  ) async {
    final container = await makeRoutingTestContainer();
    final router = container.read(appRouterProvider);

    await tester.pumpWidget(buildRouterTestApp(container));
    await pumpRouteFrames(tester);

    final l10n = await AppLocalizations.delegate.load(const Locale('en'));

    router.go('/learn/category/kids-learning');
    await pumpRouteFrames(tester);
    await tapActionCard(tester, l10n.learnHubSubcategoryKidsFunLearningTitle);

    expect(find.byType(LearnKidsFunLearningPage), findsOneWidget);
    expect(find.text(l10n.kidsStoryLibraryTitle), findsOneWidget);
    expect(find.text(l10n.kidsSeerahJourneysTitle), findsWidgets);
    expect(find.text(l10n.kidsDuaStoriesTitle), findsOneWidget);
  });
}
