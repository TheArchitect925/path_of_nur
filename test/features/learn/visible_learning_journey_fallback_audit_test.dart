import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:path_of_nur/app/app_router.dart';
import 'package:path_of_nur/features/history/presentation/history_archive_page.dart';
import 'package:path_of_nur/features/learn/companion_surfaces/data/learn_companion_content.dart';
import 'package:path_of_nur/features/learn/companion_surfaces/presentation/character_companion_page.dart';
import 'package:path_of_nur/features/learn/companion_surfaces/presentation/daily_wisdom_companion_page.dart';
import 'package:path_of_nur/features/learn/companion_surfaces/presentation/seerah_companion_page.dart';
import 'package:path_of_nur/features/learn/journey/data/learning_journey_lesson_content.dart';
import 'package:path_of_nur/features/learn/journey/data/learning_journey_registry.dart';
import 'package:path_of_nur/features/learn/presentation/pages/quran_app_hub_page.dart';
import 'package:path_of_nur/l10n/app_localizations.dart';
import 'package:path_of_nur/features/worship/presentation/worship_section_pages.dart';
import 'package:path_of_nur/shared/application/daily_clock_provider.dart';

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

  Future<AppLocalizations> pumpL10nHarness(WidgetTester tester) async {
    late BuildContext capturedContext;

    await tester.pumpWidget(
      MaterialApp(
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: Scaffold(
          body: Builder(
            builder: (context) {
              capturedContext = context;
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
    await tester.pump();

    return AppLocalizations.of(capturedContext);
  }

  test('journey detail fallback actions prefer specific canonical owners', () {
    final shortSurahs = LearningJourneyRegistry.journeyById('short-surahs')!;
    final dailyDhikr = LearningJourneyRegistry.journeyById('daily-dhikr')!;
    final timeline = LearningJourneyRegistry.journeyById('timeline-of-islam')!;
    final seerah = LearningJourneyRegistry.journeyById('seerah-journey')!;
    final character = LearningJourneyRegistry.journeyById(
      'beautiful-character',
    )!;
    final dailyWisdom = LearningJourneyRegistry.journeyById('daily-wisdom')!;

    expect(
      shortSurahs.relatedTools.map((tool) => tool.routeName),
      contains('quranLearningHub'),
    );
    expect(
      shortSurahs.relatedTools.map((tool) => tool.routeName),
      isNot(contains('learnLegacy')),
    );

    expect(
      dailyDhikr.relatedTools.map((tool) => tool.routeName),
      contains('worshipDhikrPage'),
    );
    expect(
      dailyDhikr.relatedTools.map((tool) => tool.routeName),
      isNot(contains('learnLegacy')),
    );

    expect(
      timeline.relatedTools.map((tool) => tool.routeName),
      contains('learnHistoryArchive'),
    );
    expect(
      timeline.relatedTools.map((tool) => tool.routeName),
      isNot(contains('learnLegacy')),
    );

    expect(
      seerah.relatedTools.map((tool) => tool.routeName),
      contains('learnSeerahCompanion'),
    );
    expect(
      seerah.relatedTools.map((tool) => tool.routeName),
      isNot(contains('learnLegacy')),
    );

    expect(
      character.relatedTools.map((tool) => tool.routeName),
      contains('learnCharacterCompanion'),
    );
    expect(
      character.relatedTools.map((tool) => tool.routeName),
      isNot(contains('learnLegacy')),
    );

    expect(
      dailyWisdom.relatedTools.map((tool) => tool.routeName),
      contains('learnDailyWisdomCompanion'),
    );
  });

  testWidgets(
    'lesson fallback actions prefer owned companion surfaces where clear',
    (tester) async {
      final l10n = await pumpL10nHarness(tester);

      final shortSurahMeaning =
          LearningJourneyLessonContentRegistry.lessonForStage(
            'short-surahs-meaning',
            l10n,
          )!;
      final timelineKhulafa =
          LearningJourneyLessonContentRegistry.lessonForStage(
            'timeline-khulafa',
            l10n,
          )!;
      final timelineExpansion =
          LearningJourneyLessonContentRegistry.lessonForStage(
            'timeline-expansion',
            l10n,
          )!;
      final seerahHijrah = LearningJourneyLessonContentRegistry.lessonForStage(
        'seerah-hijrah',
        l10n,
      )!;
      final seerahMadinah = LearningJourneyLessonContentRegistry.lessonForStage(
        'seerah-madinah-society',
        l10n,
      )!;
      final wisdomDailyQuote =
          LearningJourneyLessonContentRegistry.lessonForStage(
            'wisdom-daily-quote',
            l10n,
          )!;

      expect(
        shortSurahMeaning.relatedTools.map((tool) => tool.routeName),
        contains('quranLearningHub'),
      );
      expect(
        shortSurahMeaning.relatedTools.map((tool) => tool.routeName),
        isNot(contains('learnLegacy')),
      );

      expect(
        timelineKhulafa.relatedTools.map((tool) => tool.routeName),
        contains('learnHistoryArchive'),
      );
      expect(
        timelineKhulafa.relatedTools.map((tool) => tool.routeName),
        isNot(contains('learnLegacy')),
      );

      expect(
        timelineExpansion.relatedTools.map((tool) => tool.routeName),
        contains('learnHistoryArchive'),
      );
      expect(
        timelineExpansion.relatedTools.map((tool) => tool.routeName),
        isNot(contains('learnLegacy')),
      );

      expect(
        seerahHijrah.relatedTools.map((tool) => tool.routeName),
        contains('learnSeerahCompanion'),
      );
      expect(
        seerahHijrah.relatedTools.map((tool) => tool.routeName),
        isNot(contains('learnLegacy')),
      );

      expect(
        seerahMadinah.relatedTools.map((tool) => tool.routeName),
        contains('learnSeerahCompanion'),
      );
      expect(
        seerahMadinah.relatedTools.map((tool) => tool.routeName),
        isNot(contains('learnLegacy')),
      );

      expect(
        wisdomDailyQuote.relatedTools.map((tool) => tool.routeName),
        contains('learnDailyWisdomCompanion'),
      );
      expect(
        wisdomDailyQuote.relatedTools.map((tool) => tool.routeName),
        isNot(contains('learnLegacy')),
      );
    },
  );

  testWidgets('replacement visible fallback routes resolve safely', (
    tester,
  ) async {
    final container = await makeRoutingTestContainer();
    final router = container.read(appRouterProvider);

    await tester.pumpWidget(buildRouterTestApp(container));
    await pumpRouteFrames(tester);

    router.goNamed('quranLearningHub');
    await pumpRouteFrames(tester);
    expect(find.byType(QuranAppHubPage), findsOneWidget);

    router.goNamed('worshipDhikrPage');
    await pumpRouteFrames(tester);
    expect(find.byType(WorshipDhikrPage), findsOneWidget);

    router.goNamed('learnHistoryArchive');
    await pumpRouteFrames(tester);
    expect(find.byType(HistoryArchivePage), findsOneWidget);

    router.goNamed('learnSeerahCompanion');
    await pumpRouteFrames(tester);
    expect(find.byType(SeerahCompanionPage), findsOneWidget);

    router.goNamed('learnCharacterCompanion');
    await pumpRouteFrames(tester);
    expect(find.byType(CharacterCompanionPage), findsOneWidget);

    router.goNamed('learnDailyWisdomCompanion');
    await pumpRouteFrames(tester);
    expect(find.byType(DailyWisdomCompanionPage), findsOneWidget);
  });

  testWidgets('seerah companion honors focused entry state', (tester) async {
    final container = await makeRoutingTestContainer();
    final router = container.read(appRouterProvider);
    final l10n = await AppLocalizations.delegate.load(const Locale('en'));

    await tester.pumpWidget(buildRouterTestApp(container));
    await pumpRouteFrames(tester);

    router.goNamed(
      'learnSeerahCompanion',
      queryParameters: const {'focus': 'hijrah'},
    );
    await pumpRouteFrames(tester);

    expect(find.byType(SeerahCompanionPage), findsOneWidget);
    expect(find.text(l10n.learningJourneySeerahHijrahTitle), findsWidgets);
    expect(
      find.text(l10n.learnSeerahCompanionHijrahDescription),
      findsOneWidget,
    );
    expect(
      find.text(l10n.learnSeerahCompanionHijrahWhyItMatters),
      findsOneWidget,
    );
    expect(
      find.text(l10n.learnSeerahCompanionHijrahNextExplore),
      findsOneWidget,
    );
  });

  testWidgets('direct companion paths honor focused query entry state', (
    tester,
  ) async {
    final container = await makeRoutingTestContainer();
    final router = container.read(appRouterProvider);
    final l10n = await AppLocalizations.delegate.load(const Locale('en'));

    await tester.pumpWidget(buildRouterTestApp(container));
    await pumpRouteFrames(tester);

    router.go('/learn/seerah?focus=hijrah');
    await pumpRouteFrames(tester);
    expect(find.byType(SeerahCompanionPage), findsOneWidget);
    expect(
      find.text(l10n.learnSeerahCompanionHijrahWhyItMatters),
      findsOneWidget,
    );

    router.go('/learn/character?focus=ikhlas');
    await pumpRouteFrames(tester);
    expect(find.byType(CharacterCompanionPage), findsOneWidget);
    expect(
      find.text(l10n.learningJourneyCharacterIkhlasStageSummary),
      findsOneWidget,
    );
  });

  testWidgets('daily wisdom keeps a richer curated rotation', (tester) async {
    final l10n = await pumpL10nHarness(tester);
    final entries = buildDailyWisdomEntries(l10n);

    expect(entries.length, greaterThanOrEqualTo(13));
    expect(entries.map((entry) => entry.id).toSet().length, entries.length);
  });

  testWidgets('character companion honors focused trait entry state', (
    tester,
  ) async {
    final container = await makeRoutingTestContainer();
    final router = container.read(appRouterProvider);
    final l10n = await AppLocalizations.delegate.load(const Locale('en'));

    await tester.pumpWidget(buildRouterTestApp(container));
    await pumpRouteFrames(tester);

    router.goNamed(
      'learnCharacterCompanion',
      queryParameters: const {'focus': 'ikhlas'},
    );
    await pumpRouteFrames(tester);

    expect(find.byType(CharacterCompanionPage), findsOneWidget);
    expect(
      find.text(l10n.learningJourneyCharacterIkhlasStageTitle),
      findsWidgets,
    );
    expect(
      find.text(l10n.learningJourneyCharacterIkhlasStageSummary),
      findsOneWidget,
    );
  });

  testWidgets('saved companion focus restores on standalone entry', (
    tester,
  ) async {
    final container = await makeTestContainer(
      seed: <String, Object>{
        'learn.companion.seerah.lastFocus': 'hijrah',
        'learn.companion.character.selectedTrait': 'ikhlas',
      },
      overrides: <Override>[
        dailyNowProvider.overrideWith(
          (ref) =>
              Stream<DateTime>.value(DateTime.parse('2026-03-23T12:00:00')),
        ),
      ],
    );
    final router = container.read(appRouterProvider);
    final l10n = await AppLocalizations.delegate.load(const Locale('en'));

    await tester.pumpWidget(buildRouterTestApp(container));
    await pumpRouteFrames(tester);

    router.go('/learn/seerah');
    await pumpRouteFrames(tester);
    expect(find.byType(SeerahCompanionPage), findsOneWidget);
    expect(
      find.text(l10n.learnSeerahCompanionHijrahWhyItMatters),
      findsOneWidget,
    );

    router.go('/learn/character');
    await pumpRouteFrames(tester);
    expect(find.byType(CharacterCompanionPage), findsOneWidget);
    expect(
      find.text(l10n.learningJourneyCharacterIkhlasStageSummary),
      findsOneWidget,
    );
  });

  testWidgets('daily wisdom journey handoff carries focused entry state', (
    tester,
  ) async {
    final l10n = await pumpL10nHarness(tester);
    final wisdomDailyQuote =
        LearningJourneyLessonContentRegistry.lessonForStage(
          'wisdom-daily-quote',
          l10n,
        )!;
    final focusedTool = wisdomDailyQuote.relatedTools.firstWhere(
      (tool) => tool.routeName == 'learnDailyWisdomCompanion',
    );

    expect(focusedTool.queryParameters['focus'], 'gratitude');
  });
}
