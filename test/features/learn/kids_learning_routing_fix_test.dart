import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:path_of_nur/app/app_router.dart';
import 'package:path_of_nur/features/kids/bedtime_stories/presentation/bedtime_story_parent_dashboard_page.dart';
import 'package:path_of_nur/features/kids/bedtime_stories/presentation/kids_hadith_stories_page.dart';
import 'package:path_of_nur/features/kids/bedtime_stories/presentation/kids_story_library_page.dart';
import 'package:path_of_nur/features/kids/bedtime_stories/presentation/kids_story_reader_page.dart';
import 'package:path_of_nur/features/kids/play/presentation/kids_play_page.dart';
import 'package:path_of_nur/features/kids/rewards/presentation/kids_sticker_book_page.dart';
import 'package:path_of_nur/features/kids/shared/presentation/kids_landing_page.dart';
import 'package:path_of_nur/features/kids_arabic/presentation/kids_arabic_home_page.dart';
import 'package:path_of_nur/features/kids_dua_learning/presentation/kids_dua_landing_page.dart';
import 'package:path_of_nur/features/learn/hadith/presentation/kids_hadith_page.dart';
import 'package:path_of_nur/features/learn/quran/presentation/kids_quran_page.dart';
import 'package:path_of_nur/l10n/app_localizations.dart';
import 'package:path_of_nur/shared/application/daily_clock_provider.dart';

import '../../test_helpers/app_test_harness.dart';

/// Kids Learning is one room with four doors (K1 of the kids redesign).
/// Every door opens its real destination, the old tile routes still resolve,
/// and the pages that were folded into the doors are reachable from inside.
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

  Future<void> tapDoor(WidgetTester tester, String label) async {
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
    await tester.tap(labelFinder, warnIfMissed: false);
    await pumpRouteFrames(tester);
  }

  Future<AppLocalizations> english() =>
      AppLocalizations.delegate.load(const Locale('en'));

  testWidgets('Kids Learning is a room with four doors and a parents row', (
    tester,
  ) async {
    final container = await makeRoutingTestContainer();
    final router = container.read(appRouterProvider);
    await tester.pumpWidget(buildRouterTestApp(container));
    await pumpRouteFrames(tester);
    final l10n = await english();

    router.go('/learn/category/kids-learning');
    await pumpRouteFrames(tester);

    expect(find.byType(KidsLandingPage), findsOneWidget);
    for (final door in [
      l10n.kidsDoorStoriesTitle,
      l10n.kidsDoorLettersTitle,
      l10n.kidsDoorDuasTitle,
      l10n.kidsDoorPlayTitle,
      l10n.kidsDoorParentsTitle,
    ]) {
      await tester.scrollUntilVisible(
        find.text(door),
        300,
        scrollable: find.byType(Scrollable).first,
        maxScrolls: 40,
      );
      expect(find.text(door), findsWidgets, reason: 'missing door: $door');
    }
  });

  testWidgets('each door opens its real destination', (tester) async {
    final container = await makeRoutingTestContainer();
    final router = container.read(appRouterProvider);
    await tester.pumpWidget(buildRouterTestApp(container));
    await pumpRouteFrames(tester);
    final l10n = await english();

    router.go('/learn/category/kids-learning');
    await pumpRouteFrames(tester);
    await tapDoor(tester, l10n.kidsDoorStoriesTitle);
    expect(find.byType(KidsStoryLibraryPage), findsOneWidget);

    router.go('/learn/category/kids-learning');
    await pumpRouteFrames(tester);
    await tapDoor(tester, l10n.kidsDoorLettersTitle);
    expect(find.byType(KidsArabicHomePage), findsOneWidget);

    router.go('/learn/category/kids-learning');
    await pumpRouteFrames(tester);
    await tapDoor(tester, l10n.kidsDoorDuasTitle);
    expect(find.byType(KidsDuaLandingPage), findsOneWidget);

    router.go('/learn/category/kids-learning');
    await pumpRouteFrames(tester);
    await tapDoor(tester, l10n.kidsDoorPlayTitle);
    expect(find.byType(KidsPlayPage), findsOneWidget);
    // The rows sit below the hero art, past the test viewport's fold.
    for (final row in [
      l10n.kidsArabicPracticeTitle,
      l10n.kidsDuaPracticeTitle,
      l10n.kidsArabicColoringPagesTitle,
    ]) {
      await tester.scrollUntilVisible(
        find.text(row),
        300,
        scrollable: find.byType(Scrollable).first,
        maxScrolls: 40,
      );
      expect(find.text(row), findsOneWidget, reason: 'missing row: $row');
    }
  });

  testWidgets('the retired tile routes still resolve to their new homes', (
    tester,
  ) async {
    final container = await makeRoutingTestContainer();
    final router = container.read(appRouterProvider);
    await tester.pumpWidget(buildRouterTestApp(container));
    await pumpRouteFrames(tester);

    // "Kids Games" and "Fun Learning" both open Play.
    router.go('/learn/kids/games');
    await pumpRouteFrames(tester);
    expect(find.byType(KidsPlayPage), findsOneWidget);

    router.go('/learn/kids/fun-learning');
    await pumpRouteFrames(tester);
    expect(find.byType(KidsPlayPage), findsOneWidget);

    // The bedtime page is now the bedtime shelf of the one library.
    router.go('/learn/kids/bedtime-stories');
    await pumpRouteFrames(tester);
    expect(find.byType(KidsStoryLibraryPage), findsOneWidget);

    // The pages folded behind Stories keep their own routes.
    router.go('/learn/kids/quran');
    await pumpRouteFrames(tester);
    expect(find.byType(KidsQuranPage), findsOneWidget);

    router.go('/learn/kids/hadith');
    await pumpRouteFrames(tester);
    expect(find.byType(KidsHadithPage), findsOneWidget);

    router.go('/learn/kids/hadith-stories');
    await pumpRouteFrames(tester);
    expect(find.byType(KidsHadithStoriesPage), findsOneWidget);

    // Every story reads in the storybook (K2).
    router.go('/learn/kids/stories/story_telling_the_truth_v1/read');
    await pumpRouteFrames(tester);
    expect(find.byType(KidsStoryReaderPage), findsOneWidget);

    // One sticker book for everything a child finishes (K4).
    router.go('/learn/kids/stickers');
    await pumpRouteFrames(tester);
    expect(find.byType(KidsStickerBookPage), findsOneWidget);

    // One parents door (K5); an adult profile is not gated.
    router.go('/learn/kids/parents');
    await pumpRouteFrames(tester);
    expect(find.byType(BedtimeStoryParentDashboardPage), findsOneWidget);
  });
}
