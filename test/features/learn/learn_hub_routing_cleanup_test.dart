import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:path_of_nur/app/app_router.dart';
import 'package:path_of_nur/features/history/presentation/history_archive_page.dart';
import 'package:path_of_nur/features/learn/divine_life_lessons/presentation/divine_life_lessons_page.dart';
import 'package:path_of_nur/features/learn/hadith/presentation/hadith_landing_page.dart';
import 'package:path_of_nur/features/learn/presentation/pages/learn_category_page.dart';
import 'package:path_of_nur/features/learn/presentation/pages/learn_quran_hub_page.dart';
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

  testWidgets('Foundations hides the bottom knowledge section', (
    tester,
  ) async {
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
    expect(find.text(l10n.learnHubSubcategoryCoreKnowledgeTitle), findsOneWidget);
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
    await tapActionCard(tester, l10n.historyArchiveTitle);

    expect(find.byType(HistoryArchivePage), findsOneWidget);
  });

  test('Character and Adab remains a direct entry into Divine Life Lessons', () {
    final target = LearnHubTaxonomy.categoryRouteTarget(
      LearnHubCategoryId.characterAdab,
    );
    expect(target.routeName, 'learnLifeLanding');
  });
}
