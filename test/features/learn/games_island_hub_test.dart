import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:path_of_nur/features/learn/crossword/presentation/crossword_home_page.dart';
import 'package:path_of_nur/features/learn/journey/application/family_learning_provider.dart';
import 'package:path_of_nur/features/learn/journey/domain/family_learning_models.dart';
import 'package:path_of_nur/features/learn/knowledge_games/daily/presentation/daily_knowledge_challenge_hub_page.dart';
import 'package:path_of_nur/features/learn/presentation/data/games_island_catalog.dart';
import 'package:path_of_nur/features/learn/presentation/pages/games_island_page.dart';
import 'package:path_of_nur/features/learn/presentation/pages/learn_games_browse_all_page.dart';
import 'package:path_of_nur/l10n/app_localizations.dart';
import 'package:path_of_nur/shared/application/daily_clock_provider.dart';
import 'package:path_of_nur/shared/widgets/section_hub_scaffold.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../../test_helpers/app_test_harness.dart' show makeTestContainer;

void main() {
  const adultVisibilityContext = ActiveFamilyLearningContext(
    activeProfileId: 'adult-test',
    activeGuardianProfileId: 'adult-test',
    activeChildProfile: null,
    familyGroup: null,
    switchableProfileIds: <String>['adult-test'],
    visibilityPolicy: FamilyLearningVisibilityPolicy(
      isChildProfile: false,
      isGuardianProfile: true,
      guidedOnly: false,
      showBrowseAll: true,
      showLegacyLearning: true,
      showAdvancedJourneys: true,
      showSecondaryExploration: true,
      showTrivia: true,
      showDiscovery: true,
    ),
  );

  Future<ProviderContainer> makeRoutingTestContainer() {
    return makeTestContainer(
      overrides: <Override>[
        dailyNowProvider.overrideWith(
          (ref) =>
              Stream<DateTime>.value(DateTime.parse('2026-03-23T12:00:00')),
        ),
        activeFamilyLearningContextProvider.overrideWithValue(
          adultVisibilityContext,
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

  Widget buildGamesHubTestApp(
    ProviderContainer container, {
    String initialLocation = '/games',
  }) {
    final router = GoRouter(
      initialLocation: initialLocation,
      routes: [
        GoRoute(
          path: '/games',
          name: 'learnGamesIsland',
          builder: (context, state) => ProviderScope(
            overrides: [
              activeFamilyLearningContextProvider.overrideWithValue(
                adultVisibilityContext,
              ),
            ],
            child: const GamesIslandPage(),
          ),
        ),
        GoRoute(
          path: '/games/browse',
          name: 'learnGamesBrowseAll',
          builder: (context, state) => ProviderScope(
            overrides: [
              activeFamilyLearningContextProvider.overrideWithValue(
                adultVisibilityContext,
              ),
            ],
            child: LearnGamesBrowseAllPage(
              initialQuery: state.uri.queryParameters['q'],
            ),
          ),
        ),
        GoRoute(
          path: '/crossword',
          name: 'learnCrosswordHome',
          builder: (context, state) => const CrosswordHomePage(),
        ),
        GoRoute(
          path: '/daily-knowledge',
          name: 'learnDailyKnowledgeHub',
          builder: (context, state) => const DailyKnowledgeChallengeHubPage(),
        ),
      ],
    );

    return UncontrolledProviderScope(
      container: container,
      child: MaterialApp.router(
        routerConfig: router,
        locale: const Locale('en'),
        builder: (context, child) => Scaffold(body: child ?? const SizedBox()),
        localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
      ),
    );
  }

  testWidgets('Games hub is surfaced as Quizzes & Games', (tester) async {
    final container = await makeRoutingTestContainer();
    final l10n = await AppLocalizations.delegate.load(const Locale('en'));

    await tester.pumpWidget(buildGamesHubTestApp(container));
    await pumpRouteFrames(tester);

    expect(find.byType(GamesIslandPage), findsOneWidget);
    expect(find.text(l10n.learnGamesHubTitleText), findsOneWidget);
  });

  test('Games catalog exposes the in-page section and option lists directly', () async {
    final l10n = await AppLocalizations.delegate.load(const Locale('en'));
    final sections = GamesIslandCatalog.sections(l10n);
    final sectionTitles = sections.map((section) => section.title).toList(growable: false);
    final cardTitles = sections
        .expand((section) => section.cards)
        .map((card) => card.title)
        .toList(growable: false);
    final routeNames = sections
        .expand((section) => section.cards)
        .map((card) => card.routeTarget.routeName)
        .toList(growable: false);

    expect(
      sectionTitles,
      containsAll(<String>[
        l10n.learnGamesIslandSectionDailyTitle,
        l10n.learnGamesIslandSectionKnowledgeTitle,
        l10n.learnGamesIslandSectionQuranTitle,
        l10n.learnGamesIslandSectionHadithTitle,
        l10n.learnGamesIslandSectionModesTitle,
        l10n.learnGamesIslandSectionGrowthTitle,
        l10n.learnGamesIslandSectionPacksTitle,
      ]),
    );
    expect(
      cardTitles,
      containsAll(<String>[
        l10n.learnGamesDailyKnowledgeTodayTitleText,
        l10n.learnGamesKnowledgeCrosswordTitleText,
        l10n.learnGamesKnowledgeWordSearchTitleText,
        l10n.learnGamesKnowledgeMatchingTitleText,
        l10n.learnGamesQuranAyahCompletionTitleText,
        l10n.learnGamesQuranAdultShortSurahsTitleText,
        l10n.learnGamesQuranMemorizationSetTitleText,
        l10n.learnGamesQuranDailyAyahTitleText,
        l10n.learnGamesHadithReflectionHomeTitleText,
        l10n.learnGamesHadithPatienceTitleText,
        l10n.learnGamesHadithAngerTitleText,
        l10n.learnGamesHadithFamilyTitleText,
        l10n.learnGamesChallengeDailyRunTitleText,
        l10n.learnGamesChallengeReviewModeTitleText,
        l10n.learnGamesChallengeTriviaTitleText,
        l10n.learnGamesGrowthSpiritualTitleText,
        l10n.learnGamesGrowthChooseIntentionTitleText,
        l10n.learnGamesGrowthDailyReflectionTitleText,
        l10n.learnGamesGrowthThemeFocusTitleText,
        l10n.learnGamesPackAdultFoundationsTitleText,
        l10n.learnGamesPackProphetsTitleText,
        l10n.learnGamesPackDuasTitleText,
        l10n.learnGamesPackDailyRotationTitleText,
      ]),
    );
    expect(routeNames, isNot(contains('learnGamesSection')));
  });

  testWidgets('Browse All search and routing work with real destinations', (
    tester,
  ) async {
    final container = await makeRoutingTestContainer();
    final l10n = await AppLocalizations.delegate.load(const Locale('en'));

    await tester.pumpWidget(
      buildGamesHubTestApp(container, initialLocation: '/games/browse'),
    );
    await pumpRouteFrames(tester);

    expect(find.byType(LearnGamesBrowseAllPage), findsOneWidget);

    await tester.enterText(find.byType(TextField).first, 'crossword');
    await pumpRouteFrames(tester);

    expect(find.text(l10n.learnGamesKnowledgeCrosswordTitleText), findsWidgets);

    await tapActionCard(tester, l10n.learnGamesKnowledgeCrosswordTitleText);
    expect(find.byType(CrosswordHomePage), findsOneWidget);

    final router = GoRouter.of(tester.element(find.byType(CrosswordHomePage)));
    router.go('/games/browse');
    await pumpRouteFrames(tester);

    await tester.enterText(find.byType(TextField).first, 'prophets');
    await pumpRouteFrames(tester);
    expect(find.text(l10n.learnGamesPackProphetsTitleText), findsWidgets);
  });

  testWidgets('Browse All opens the daily knowledge destination directly', (
    tester,
  ) async {
    final container = await makeRoutingTestContainer();
    final l10n = await AppLocalizations.delegate.load(const Locale('en'));

    await tester.pumpWidget(
      buildGamesHubTestApp(container, initialLocation: '/games/browse'),
    );
    await pumpRouteFrames(tester);

    await tapActionCard(
      tester,
      '${l10n.learnGamesDailyKnowledgeTodayTitleText} • ${l10n.learnGamesIslandTodayBadge}',
    );
    expect(find.byType(DailyKnowledgeChallengeHubPage), findsOneWidget);
  });
}
