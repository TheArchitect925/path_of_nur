import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/app/app_router.dart';
import 'package:path_of_nur/features/learn/divine_life_lessons/presentation/divine_life_lessons_page.dart';
import 'package:path_of_nur/features/learn/presentation/pages/learn_category_page.dart';
import 'package:path_of_nur/features/learn/presentation/pages/learn_explore_all_knowledge_page.dart';
import 'package:path_of_nur/l10n/app_localizations.dart';
import 'package:path_of_nur/shared/application/daily_clock_provider.dart';
import 'package:path_of_nur/shared/widgets/display/art_header_card.dart';
import 'package:path_of_nur/shared/widgets/display/compact_list_tile.dart';

import '../../test_helpers/app_test_harness.dart';

void main() {
  Future<void> pumpRouteFrames(WidgetTester tester) async {
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 120));
    await tester.pump(const Duration(milliseconds: 180));
  }

  Finder hubRowFinder(String label) {
    return find.ancestor(
      of: find.text(label).first,
      matching: find.byType(CompactListTile),
    );
  }

  Future<void> tapHubRow(WidgetTester tester, String label) async {
    final rowFinder = hubRowFinder(label);
    await tester.ensureVisible(rowFinder);
    await pumpRouteFrames(tester);
    await tester.tap(rowFinder.first);
    await pumpRouteFrames(tester);
  }

  Future<ProviderContainer> pumpLanding(WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(1200, 2600));
    addTearDown(() => tester.binding.setSurfaceSize(null));

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
    router.go('/learn');
    await pumpRouteFrames(tester);
    return container;
  }

  testWidgets('learn landing shows path hero and the six browse groups', (
    tester,
  ) async {
    await pumpLanding(tester);
    final l10n = await AppLocalizations.delegate.load(const Locale('en'));

    // No path chosen yet: the hero invites the user to pick one.
    expect(find.byType(ArtHeaderCard), findsOneWidget);
    expect(find.text(l10n.learnLandingChoosePathTitle), findsOneWidget);

    // Six art-led topic groups plus the Explore All row.
    expect(find.text(l10n.learnLandingBrowseTitle), findsOneWidget);
    expect(find.byType(ArtLeadingThumb), findsNWidgets(6));
    for (final label in <String>[
      l10n.learnHubCategoryQuranHadithTitle,
      l10n.learnHubCategoryFoundationsTitle,
      l10n.learnHubCategoryWorshipPracticeTitle,
      l10n.learnHubCategoryCharacterAdabTitle,
      l10n.learnHubCategoryProphetsStoriesTitle,
      l10n.learnHubCategoryQuizzesGamesTitleText,
    ]) {
      expect(hubRowFinder(label), findsOneWidget, reason: label);
    }
    expect(hubRowFinder(l10n.learnHubLandingExploreAllTitle), findsOneWidget);

    // The retitled group reads Qur'an & Sunnah.
    expect(l10n.learnHubCategoryQuranHadithTitle, 'Qur’an & Sunnah');
  });

  testWidgets('landing group rows route into their category pages', (
    tester,
  ) async {
    final container = await pumpLanding(tester);
    final router = container.read(appRouterProvider);
    final l10n = await AppLocalizations.delegate.load(const Locale('en'));

    await tapHubRow(tester, l10n.learnHubCategoryCharacterAdabTitle);
    expect(find.byType(LearnCategoryPage), findsOneWidget);
    // Life lessons moved under Character in the Phase 4 taxonomy.
    expect(
      find.text(l10n.learnCategoryDivineLifeLessonsTitle),
      findsWidgets,
    );

    router.go('/learn');
    await pumpRouteFrames(tester);
    await tapHubRow(tester, l10n.learnHubLandingExploreAllTitle);
    expect(find.byType(LearnExploreAllKnowledgePage), findsOneWidget);
  });

  testWidgets('divine life lessons stays reachable from its new group', (
    tester,
  ) async {
    final container = await pumpLanding(tester);
    final router = container.read(appRouterProvider);
    final l10n = await AppLocalizations.delegate.load(const Locale('en'));

    router.go('/learn/category/character-adab');
    await pumpRouteFrames(tester);
    final tile = find.text(l10n.learnCategoryDivineLifeLessonsTitle);
    await tester.ensureVisible(tile.first);
    await pumpRouteFrames(tester);
    await tester.tap(tile.first);
    await pumpRouteFrames(tester);
    expect(find.byType(DivineLifeLessonsPage), findsOneWidget);
  });
}
