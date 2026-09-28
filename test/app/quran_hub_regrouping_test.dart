import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/app/app_router.dart';
import 'package:path_of_nur/features/learn/presentation/pages/quran_app_hub_page.dart';
import 'package:path_of_nur/features/learn/quran/application/quran_khatm_provider.dart';
import 'package:path_of_nur/features/learn/quran/domain/quran_khatm_models.dart';
import 'package:path_of_nur/features/learn/quran/presentation/quran_bookmarks_page.dart';
import 'package:path_of_nur/features/learn/quran/presentation/quran_focus_recitation_page.dart';
import 'package:path_of_nur/features/learn/quran/presentation/quran_khatm_plan_page.dart';
import 'package:path_of_nur/features/learn/quran/presentation/quran_learning_paths_page.dart';
import 'package:path_of_nur/features/learn/quran/presentation/quran_memorization_review_page.dart';
import 'package:path_of_nur/features/learn/quran/presentation/quran_search_page.dart';
import 'package:path_of_nur/features/learn/quran/presentation/quran_summary_page.dart';
import 'package:path_of_nur/features/learn/quran/presentation/quran_surah_explorer_page.dart';
import 'package:path_of_nur/features/learn/quran/presentation/quran_topic_explorer_page.dart';
import 'package:path_of_nur/features/learn/quran/presentation/quran_words_page.dart';
import 'package:path_of_nur/features/learn/quran_teaching/presentation/quran_teaching_section_page.dart';
import 'package:path_of_nur/l10n/app_localizations.dart';
import 'package:path_of_nur/shared/application/daily_clock_provider.dart';
import 'package:path_of_nur/shared/widgets/display/compact_list_tile.dart';
import 'package:path_of_nur/shared/widgets/main_page_search_launcher.dart';

import '../test_helpers/app_test_harness.dart';

/// Phase 7a: the Qur'an tab is reader-first — continue hero, reading plan,
/// today's ayah, then Read / Understand / Practice as one grouped list.
void main() {
  Future<void> pumpRouteFrames(WidgetTester tester) async {
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 120));
    await tester.pump(const Duration(milliseconds: 180));
  }

  Future<ProviderContainer> makeContainer(WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(1200, 3000));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final container = await makeTestContainer(
      overrides: <Override>[
        dailyNowProvider.overrideWith(
          (ref) =>
              Stream<DateTime>.value(DateTime.parse('2026-03-14T12:00:00')),
        ),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  Future<void> tapRow(WidgetTester tester, String label) async {
    // Match the label inside a hub row (the hero repeats some labels as
    // buttons, e.g. "All surahs").
    final row = find.ancestor(
      of: find.text(label),
      matching: find.byType(CompactListTile),
    );
    await tester.ensureVisible(row.first);
    await pumpRouteFrames(tester);
    await tester.tap(row.first);
    await pumpRouteFrames(tester);
  }

  testWidgets('quran tab is reader-first with three grouped lists', (
    tester,
  ) async {
    final container = await makeContainer(tester);
    final router = container.read(appRouterProvider);
    final l10n = await AppLocalizations.delegate.load(const Locale('en'));

    await tester.pumpWidget(buildRouterTestApp(container));
    router.go('/quran');
    await pumpRouteFrames(tester);

    expect(find.byType(QuranAppHubPage), findsOneWidget);
    // Continue hero with resume state and actions.
    expect(find.text(l10n.quranTabContinueAction), findsOneWidget);
    expect(find.text(l10n.quranTabListenAction), findsOneWidget);
    // Plan + today rows.
    expect(find.text(l10n.quranTabPlanTitle), findsOneWidget);
    expect(find.text(l10n.quranTabPlanNoneSubtitle), findsOneWidget);
    expect(find.text(l10n.quranTabTodayAyahTitle), findsOneWidget);
    // The three groups.
    for (final group in <String>[
      l10n.quranTabGroupRead,
      l10n.quranTabGroupUnderstand,
      l10n.quranTabGroupPractice,
    ]) {
      expect(find.text(group), findsOneWidget, reason: group);
    }
    // Old machinery is gone: no search launcher card.
    expect(find.byType(MainPageSearchLauncher), findsNothing);
  });

  testWidgets('every hub row opens its destination', (tester) async {
    final l10n = await AppLocalizations.delegate.load(const Locale('en'));
    final cases = <(String, Type)>[
      (l10n.quranTabAllSurahsTitle, QuranSurahExplorerPage),
      (l10n.quranTabBookmarksTitle, QuranBookmarksPage),
      (l10n.quranTabListenTitle, QuranFocusRecitationPage),
      (l10n.quranTabSummariesTitle, QuranSummaryPage),
      (l10n.quranTabTopicsTitle, QuranTopicExplorerPage),
      (l10n.quranTabPathwaysTitle, QuranLearningPathsPage),
      (l10n.quranTabLearnArabicTitle, QuranTeachingSectionPage),
      (l10n.quranTabMemorizationTitle, QuranMemorizationReviewPage),
      (l10n.quranTabWordPracticeTitle, QuranWordsPage),
    ];

    for (final (label, pageType) in cases) {
      final container = await makeContainer(tester);
      final router = container.read(appRouterProvider);
      await tester.pumpWidget(buildRouterTestApp(container));
      router.go('/quran');
      await pumpRouteFrames(tester);

      await tapRow(tester, label);
      expect(find.byType(pageType), findsOneWidget, reason: label);
      expect(tester.takeException(), isNull, reason: label);

      await tester.pumpWidget(const SizedBox.shrink());
      await pumpRouteFrames(tester);
    }
  });

  testWidgets('retired quran routes redirect to their canonical owners', (
    tester,
  ) async {
    final container = await makeContainer(tester);
    final router = container.read(appRouterProvider);

    await tester.pumpWidget(buildRouterTestApp(container));
    await pumpRouteFrames(tester);

    router.go('/quran/learning?tab=reflect');
    await pumpRouteFrames(tester);
    expect(find.byType(QuranAppHubPage), findsOneWidget);
    expect(router.state.uri.path, '/quran');

    router.go('/quran/knowledge-search?q=mercy');
    await pumpRouteFrames(tester);
    expect(find.byType(QuranSearchPage), findsOneWidget);
    expect(router.state.uri.path, '/quran/search');
    expect(router.state.uri.queryParameters['q'], 'mercy');

    router.go('/quran/insights/paths');
    await pumpRouteFrames(tester);
    expect(find.byType(QuranLearningPathsPage), findsOneWidget);
    expect(router.state.uri.path, '/quran/paths');
  });

  testWidgets('pathways page carries the merged insight pathways section', (
    tester,
  ) async {
    final container = await makeContainer(tester);
    final router = container.read(appRouterProvider);
    final l10n = await AppLocalizations.delegate.load(const Locale('en'));

    await tester.pumpWidget(buildRouterTestApp(container));
    router.go('/quran/paths');
    await pumpRouteFrames(tester);

    expect(find.byType(QuranLearningPathsPage), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text(l10n.quranAyahInsightPathsTitle),
      600,
      scrollable: find.byType(Scrollable).first,
      maxScrolls: 80,
    );
    expect(find.text(l10n.quranAyahInsightPathsTitle), findsOneWidget);
  });

  testWidgets('khatm plan starts from the tab and tracks juz progress', (
    tester,
  ) async {
    final container = await makeContainer(tester);
    final router = container.read(appRouterProvider);
    final l10n = await AppLocalizations.delegate.load(const Locale('en'));

    await tester.pumpWidget(buildRouterTestApp(container));
    router.go('/quran');
    await pumpRouteFrames(tester);

    await tapRow(tester, l10n.quranTabPlanTitle);
    expect(find.byType(QuranKhatmPlanPage), findsOneWidget);

    await tester.tap(find.text(l10n.quranKhatmPaceOneJuz));
    await pumpRouteFrames(tester);

    final plan = container.read(quranKhatmPlanProvider);
    expect(plan, isNotNull);
    expect(plan!.paceMode, QuranKhatmPaceMode.juzPerDay);
    expect(find.text(l10n.quranKhatmTodayPortionTitle), findsOneWidget);

    // Marking today's portion advances the plan through juz 1 exactly.
    await tester.ensureVisible(find.text(l10n.quranKhatmMarkDoneAction).first);
    await pumpRouteFrames(tester);
    await tester.tap(find.text(l10n.quranKhatmMarkDoneAction).first);
    await pumpRouteFrames(tester);
    expect(
      container.read(quranKhatmPlanProvider)!.completedIndex,
      QuranGlobalPosition.juzStartIndex(2) - 1,
    );

    // The tab row now reads "Juz 2 of 30 · today's portion read".
    router.go('/quran');
    await pumpRouteFrames(tester);
    expect(find.textContaining(l10n.quranTabPlanJuzLabel(2)), findsWidgets);
  });
}
