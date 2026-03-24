import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:path_of_nur/app/app_router.dart';
import 'package:path_of_nur/features/learn/companion_surfaces/presentation/character_companion_page.dart';
import 'package:path_of_nur/features/learn/companion_surfaces/presentation/daily_wisdom_companion_page.dart';
import 'package:path_of_nur/features/learn/companion_surfaces/presentation/seerah_companion_page.dart';
import 'package:path_of_nur/features/learn/glossary/presentation/glossary_page.dart';
import 'package:path_of_nur/features/history/presentation/history_archive_page.dart';
import 'package:path_of_nur/features/learn/divine_life_lessons/presentation/divine_life_lessons_page.dart';
import 'package:path_of_nur/features/learn/hadith/presentation/hadith_landing_page.dart';
import 'package:path_of_nur/features/learn/presentation/pages/learn_category_page.dart';
import 'package:path_of_nur/features/learn/presentation/pages/learn_quran_hub_page.dart';
import 'package:path_of_nur/features/learn/presentation/application/learn_hub_providers.dart';
import 'package:path_of_nur/features/learn/presentation/data/learn_category_catalog.dart';
import 'package:path_of_nur/features/learn/presentation/data/learn_hub_taxonomy.dart';
import 'package:path_of_nur/features/learn/presentation/models/learn_hub_models.dart';
import 'package:path_of_nur/features/learn/prophets/presentation/prophets_page.dart';
import 'package:path_of_nur/features/learn/world/presentation/world_landing_page.dart';
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

  testWidgets('Foundations hides the bottom knowledge section', (tester) async {
    final container = await makeRoutingTestContainer();
    final router = container.read(appRouterProvider);

    await tester.pumpWidget(buildRouterTestApp(container));
    await pumpRouteFrames(tester);

    final l10n = await AppLocalizations.delegate.load(const Locale('en'));
    router.go('/learn/category/foundations');
    await pumpRouteFrames(tester);

    expect(find.byType(LearnCategoryPage), findsOneWidget);
    expect(find.text(l10n.learnHubSubcategoriesSectionTitle), findsOneWidget);
    expect(find.text(l10n.learnHubKnowledgeSectionTitle), findsNothing);
    expect(
      find.text(l10n.learnHubSubcategoryCoreKnowledgeTitle),
      findsOneWidget,
    );
  });

  testWidgets('Quran and Hadith section entries open their dedicated pages', (
    tester,
  ) async {
    final container = await makeRoutingTestContainer();
    final router = container.read(appRouterProvider);

    await tester.pumpWidget(buildRouterTestApp(container));
    await pumpRouteFrames(tester);

    final l10n = await AppLocalizations.delegate.load(const Locale('en'));

    router.go('/learn/category/quran-hadith');
    await pumpRouteFrames(tester);
    await tapActionCard(tester, l10n.learnCategoryQuranLearningTitle);
    expect(find.byType(LearnQuranHubPage), findsOneWidget);

    router.go('/learn/category/quran-hadith');
    await pumpRouteFrames(tester);
    await tapActionCard(tester, l10n.learnCategoryHadithTitle);
    expect(find.byType(HadithLandingPage), findsOneWidget);

    router.go('/learn/category/quran-hadith');
    await pumpRouteFrames(tester);
    await tapActionCard(tester, l10n.learnCategoryDivineLifeLessonsTitle);
    expect(find.byType(DivineLifeLessonsPage), findsOneWidget);

    router.go('/learn/category/quran-hadith');
    await pumpRouteFrames(tester);
    await tapActionCard(tester, l10n.learnCategoryWorldCreationTitle);
    expect(find.byType(WorldLandingPage), findsOneWidget);
  });

  testWidgets('Stories of the Prophets opens the prophets list page', (
    tester,
  ) async {
    final container = await makeRoutingTestContainer();
    final router = container.read(appRouterProvider);

    await tester.pumpWidget(buildRouterTestApp(container));
    await pumpRouteFrames(tester);

    final l10n = await AppLocalizations.delegate.load(const Locale('en'));

    router.go('/learn/category/prophets-stories');
    await pumpRouteFrames(tester);
    await tapActionCard(tester, l10n.learnCategoryStoriesOfProphetsTitle);

    expect(find.byType(ProphetsPage), findsOneWidget);

    router.go('/learn/category/prophets-stories');
    await pumpRouteFrames(tester);
    await tapActionCard(tester, l10n.learningJourneySeerahJourneyTitle);
    expect(find.byType(SeerahCompanionPage), findsOneWidget);
  });

  test('Arabic and Language category routes directly to Arabic Learning', () {
    final target = LearnHubTaxonomy.categoryRouteTarget(
      LearnHubCategoryId.arabicLanguage,
    );
    expect(target.routeName, 'quranArabic');
  });

  testWidgets('Tools and Explore surfaces Historical Calendar correctly', (
    tester,
  ) async {
    final container = await makeRoutingTestContainer();
    final router = container.read(appRouterProvider);

    await tester.pumpWidget(buildRouterTestApp(container));
    await pumpRouteFrames(tester);

    final l10n = await AppLocalizations.delegate.load(const Locale('en'));

    router.go('/learn/category/tools-explore');
    await pumpRouteFrames(tester);

    expect(find.text(l10n.historyArchiveTitle), findsOneWidget);
    expect(find.text(l10n.learningJourneyDailyWisdomTitle), findsOneWidget);
    expect(find.text(l10n.learnGlossaryTitle), findsOneWidget);
    await tapActionCard(tester, l10n.historyArchiveTitle);

    expect(find.byType(HistoryArchivePage), findsOneWidget);

    router.go('/learn/category/tools-explore');
    await pumpRouteFrames(tester);
    await tapActionCard(tester, l10n.learnGlossaryTitle);
    expect(find.byType(GlossaryPage), findsOneWidget);

    router.go('/learn/category/tools-explore');
    await pumpRouteFrames(tester);
    await tapActionCard(tester, l10n.learningJourneyDailyWisdomTitle);
    expect(find.byType(DailyWisdomCompanionPage), findsOneWidget);
  });

  test('Character and Adab now routes into the owned companion surface', () {
    final target = LearnHubTaxonomy.categoryRouteTarget(
      LearnHubCategoryId.characterAdab,
    );
    expect(target.routeName, 'learnCharacterCompanion');
  });

  test('companion surfaces carry stronger taxonomy search metadata', () async {
    final l10n = await AppLocalizations.delegate.load(const Locale('en'));
    final subcategories = LearnHubTaxonomy.subcategories(l10n);

    final seerah = subcategories.firstWhere(
      (item) => item.id == 'seerah-journey',
    );
    expect(seerah.routeTarget.routeName, 'learnSeerahCompanion');
    expect(
      seerah.searchKeywords,
      containsAll(<String>['hijrah', 'makkah', 'final sermon']),
    );

    final character = subcategories.firstWhere(
      (item) => item.id == 'character-adab',
    );
    expect(character.routeTarget.routeName, 'learnCharacterCompanion');
    expect(
      character.searchKeywords,
      containsAll(<String>['ikhlas', 'sabr', 'humility']),
    );

    final wisdom = subcategories.firstWhere(
      (item) => item.id == 'daily-wisdom',
    );
    expect(wisdom.routeTarget.routeName, 'learnDailyWisdomCompanion');
    expect(
      wisdom.searchKeywords,
      containsAll(<String>['gratitude', 'hope', 'remembrance']),
    );
  });

  test(
    'companion surfaces stay discoverable in catalog and learn suggestions',
    () async {
      final activeIds = LearnCategoryCatalog.activeItems
          .map((item) => item.id)
          .toSet();
      expect(
        activeIds,
        containsAll(<String>[
          'glossary',
          'seerah-companion',
          'character-companion',
          'daily-wisdom-companion',
        ]),
      );

      final container = await makeRoutingTestContainer();
      addTearDown(container.dispose);
      final featured = container.read(learnHubFeaturedItemsProvider);
      final featuredRoutes = featured
          .map((item) => item.routeTarget.routeName)
          .toList(growable: false);

      expect(featuredRoutes, contains('learnSeerahCompanion'));
      expect(featuredRoutes, contains('learnCharacterCompanion'));
      expect(featuredRoutes, contains('learnDailyWisdomCompanion'));
    },
  );

  test(
    'Glossary is lightly surfaced through tools and catalog metadata',
    () async {
      final l10n = await AppLocalizations.delegate.load(const Locale('en'));
      final subcategories = LearnHubTaxonomy.subcategories(l10n);

      final glossary = subcategories.firstWhere(
        (item) => item.id == 'glossary',
      );
      expect(glossary.categoryId, LearnHubCategoryId.toolsExplore);
      expect(glossary.routeTarget.routeName, 'learnGlossary');
      expect(
        glossary.searchKeywords,
        containsAll(<String>['glossary', 'definitions', 'salah']),
      );

      final catalogGlossary = LearnCategoryCatalog.activeItems.firstWhere(
        (item) => item.id == 'glossary',
      );
      expect(catalogGlossary.routeName, 'learnGlossary');
      expect(
        catalogGlossary.searchKeywords,
        containsAll(<String>['glossary', 'dhikr', 'sunnah']),
      );
    },
  );

  testWidgets('Character and Adab opens the owned companion surface', (
    tester,
  ) async {
    final container = await makeRoutingTestContainer();
    final router = container.read(appRouterProvider);

    await tester.pumpWidget(buildRouterTestApp(container));
    await pumpRouteFrames(tester);

    router.goNamed('learnCharacterCompanion');
    await pumpRouteFrames(tester);

    expect(find.byType(CharacterCompanionPage), findsOneWidget);
  });
}
