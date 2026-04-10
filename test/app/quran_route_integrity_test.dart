import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:path_of_nur/app/app_router.dart';
import 'package:path_of_nur/features/learn/presentation/pages/learn_quran_hub_page.dart';
import 'package:path_of_nur/features/learn/presentation/pages/quran_app_hub_page.dart';
import 'package:path_of_nur/features/learn/quran/presentation/quran_knowledge_search_page.dart';
import 'package:path_of_nur/features/learn/quran/presentation/quran_daily_companion_page.dart';
import 'package:path_of_nur/features/learn/quran/presentation/quran_memorization_review_page.dart';
import 'package:path_of_nur/features/learn/quran/presentation/quran_ayah_insights_paths_page.dart';
import 'package:path_of_nur/features/learn/quran/presentation/quran_learning_paths_page.dart';
import 'package:path_of_nur/features/learn/quran/presentation/quran_reader_page.dart';
import 'package:path_of_nur/features/learn/quran/presentation/quran_reflections_page.dart';
import 'package:path_of_nur/features/learn/quran/presentation/quran_surah_insight_page.dart';
import 'package:path_of_nur/features/learn/quran/presentation/quran_topic_explorer_page.dart';
import 'package:path_of_nur/features/learn/quran/presentation/quran_word_review_page.dart';
import 'package:path_of_nur/features/learn/quran/presentation/quran_words_page.dart';
import 'package:path_of_nur/l10n/app_localizations.dart';
import 'package:path_of_nur/shared/application/daily_clock_provider.dart';

import '../test_helpers/app_test_harness.dart';

void main() {
  Future<void> pumpRouteFrames(WidgetTester tester) async {
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 120));
    await tester.pump(const Duration(milliseconds: 180));
  }

  Future<ProviderContainer> makeContainer({
    Map<String, Object> seed = const <String, Object>{},
  }) {
    return makeTestContainer(
      seed: seed,
      overrides: <Override>[
        dailyNowProvider.overrideWith(
          (ref) =>
              Stream<DateTime>.value(DateTime.parse('2026-03-14T12:00:00')),
        ),
      ],
    );
  }

  Future<void> tapReflectionsAction(
    WidgetTester tester,
    Finder hostPageFinder,
  ) async {
    final context = tester.element(hostPageFinder);
    final l10n = AppLocalizations.of(context);
    await tester.scrollUntilVisible(
      find.text(l10n.quranHubRelatedToolsTitle),
      240,
      scrollable: find.byType(Scrollable).first,
    );
    final labelFinder = find.text(l10n.quranReflectionsHubEntryTitle);
    final chipFinder = find.ancestor(
      of: labelFinder,
      matching: find.byType(InkWell),
    );
    final chip = tester.widget<InkWell>(chipFinder.first);
    chip.onTap?.call();
    await pumpRouteFrames(tester);
  }

  testWidgets('canonical and compatibility quran reflections routes resolve', (
    tester,
  ) async {
    final container = await makeContainer();
    final router = container.read(appRouterProvider);

    await tester.pumpWidget(buildRouterTestApp(container));
    await pumpRouteFrames(tester);

    for (final path in <String>[
      '/quran/reflections',
      '/learn/quran/reflections',
    ]) {
      router.go(path);
      await pumpRouteFrames(tester);
      expect(find.byType(QuranReflectionsPage), findsOneWidget, reason: path);
      expect(tester.takeException(), isNull, reason: path);
    }
  });

  testWidgets('quran app hub reflections action navigates successfully', (
    tester,
  ) async {
    final container = await makeContainer();
    final router = container.read(appRouterProvider);

    await tester.pumpWidget(buildRouterTestApp(container));
    await pumpRouteFrames(tester);

    router.go('/quran');
    await pumpRouteFrames(tester);
    expect(find.byType(QuranAppHubPage), findsOneWidget);

    await tapReflectionsAction(tester, find.byType(QuranAppHubPage));

    expect(find.byType(QuranReflectionsPage), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('quran learning study hub routes load without exceptions', (
    tester,
  ) async {
    final container = await makeContainer();
    final router = container.read(appRouterProvider);

    await tester.pumpWidget(buildRouterTestApp(container));
    await pumpRouteFrames(tester);

    for (final path in <String>[
      '/quran/learning?tab=reflect',
      '/learn/hub/quran/learning',
    ]) {
      router.go(path);
      await pumpRouteFrames(tester);
      expect(find.byType(LearnQuranHubPage), findsOneWidget, reason: path);
      expect(tester.takeException(), isNull, reason: path);
    }
  });

  testWidgets('broader quran study routes stay directly reachable', (
    tester,
  ) async {
    final container = await makeContainer();
    final router = container.read(appRouterProvider);

    await tester.pumpWidget(buildRouterTestApp(container));
    await pumpRouteFrames(tester);

    final cases = <(String, Type)>[
      ('/quran/knowledge-search', QuranKnowledgeSearchPage),
      ('/quran/daily', QuranDailyCompanionPage),
      (
        '/quran/insights/paths/character-adab-starter',
        QuranAyahInsightPathDetailPage,
      ),
      ('/quran/paths', QuranLearningPathsPage),
      ('/quran/paths/beginner-understanding', QuranLearningPathDetailPage),
      ('/quran/surah-insights', QuranSurahInsightsBrowsePage),
      ('/quran/topics', QuranTopicExplorerPage),
      ('/quran/topics/patience', QuranTopicExplorerPage),
      ('/quran/top-words', QuranWordsPage),
      ('/quran/word-review', QuranWordReviewPage),
      ('/quran/review', QuranMemorizationReviewPage),
    ];

    for (final (path, pageType) in cases) {
      router.go(path);
      await pumpRouteFrames(tester);
      expect(find.byType(pageType), findsOneWidget, reason: path);
      expect(tester.takeException(), isNull, reason: path);
    }
  });

  testWidgets('journey-context quran reader entry remains route-safe', (
    tester,
  ) async {
    final container = await makeContainer();
    final router = container.read(appRouterProvider);

    await tester.pumpWidget(buildRouterTestApp(container));
    await pumpRouteFrames(tester);

    router.go(
      '/quran/surah/9?ayah=40&journeyId=seerah-journey&stageId=seerah-hijrah&topicId=trust-in-allah',
    );
    await pumpRouteFrames(tester);

    expect(find.byType(QuranReaderPage), findsOneWidget);
    expect(find.text('Journey context'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('journey context stays above surah-wide study cues', (
    tester,
  ) async {
    final container = await makeContainer();
    final router = container.read(appRouterProvider);

    await tester.pumpWidget(buildRouterTestApp(container));
    await pumpRouteFrames(tester);

    router.go(
      '/quran/surah/20?ayah=14&journeyId=seerah-journey&stageId=seerah-hijrah&topicId=trust-in-allah',
    );
    await pumpRouteFrames(tester);

    final journeyContext = find.text('Journey context');
    final surahInsights = find.text('Surah themes & insights');

    expect(journeyContext, findsOneWidget);
    expect(surahInsights, findsOneWidget);
    expect(
      tester.getTopLeft(journeyContext).dy,
      lessThan(tester.getTopLeft(surahInsights).dy),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('memorization review quran reader entry remains route-safe', (
    tester,
  ) async {
    final container = await makeContainer();
    final router = container.read(appRouterProvider);

    await tester.pumpWidget(buildRouterTestApp(container));
    await pumpRouteFrames(tester);

    router.go('/quran/surah/2?ayah=153&review=memorization');
    await pumpRouteFrames(tester);

    expect(find.byType(QuranReaderPage), findsOneWidget);
    expect(find.text('Memorization focus'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('memorization review reader metadata query remains route-safe', (
    tester,
  ) async {
    final container = await makeContainer();
    final router = container.read(appRouterProvider);

    await tester.pumpWidget(buildRouterTestApp(container));
    await pumpRouteFrames(tester);

    router.go(
      '/quran/surah/2?ayah=153&review=memorization&mode=memorization&reviewCount=3&lastReviewed=2026-03-23T00:00:00.000',
    );
    await pumpRouteFrames(tester);

    expect(find.byType(QuranReaderPage), findsOneWidget);
    expect(find.text('Memorization focus'), findsOneWidget);
    expect(find.textContaining('Reviewed 3 times'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('explicit study mode quran reader entry remains route-safe', (
    tester,
  ) async {
    final container = await makeContainer();
    final router = container.read(appRouterProvider);

    await tester.pumpWidget(buildRouterTestApp(container));
    await pumpRouteFrames(tester);

    router.go('/quran/surah/18?ayah=1&mode=study');
    await pumpRouteFrames(tester);

    expect(find.byType(QuranReaderPage), findsOneWidget);
    expect(find.text('Study mode'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('theme-focused quran reader entry infers theme mode safely', (
    tester,
  ) async {
    final container = await makeContainer();
    final router = container.read(appRouterProvider);

    await tester.pumpWidget(buildRouterTestApp(container));
    await pumpRouteFrames(tester);

    router.go('/quran/surah/55?topicId=gratitude');
    await pumpRouteFrames(tester);

    expect(find.byType(QuranReaderPage), findsOneWidget);
    expect(find.text('Theme mode'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'persisted reflection intent can shape default reader mode safely',
    (tester) async {
      final container = await makeContainer(
        seed: <String, Object>{
          'learn.quran.user_intent.v1': jsonEncode(<String, Object?>{
            'intent': 'reflect',
            'updatedAtIso': '2026-03-24T12:00:00.000Z',
          }),
        },
      );
      final router = container.read(appRouterProvider);

      await tester.pumpWidget(buildRouterTestApp(container));
      await pumpRouteFrames(tester);

      router.go('/quran/surah/18?ayah=1');
      await pumpRouteFrames(tester);

      expect(find.byType(QuranReaderPage), findsOneWidget);
      expect(find.text('Reflection mode'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
