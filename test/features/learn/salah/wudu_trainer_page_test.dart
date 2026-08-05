import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:path_of_nur/features/journey/application/journey_progression_provider.dart';
import 'package:path_of_nur/features/learn/journey/application/learning_journey_progress_provider.dart';
import 'package:path_of_nur/features/learn/journey/presentation/learning_journey_island_page.dart';
import 'package:path_of_nur/features/learn/salah/application/wudu_trainer_controller.dart';
import 'package:path_of_nur/features/learn/salah/presentation/wudu_trainer_page.dart';
import 'package:path_of_nur/features/ocean/application/ocean_drops_provider.dart';
import 'package:path_of_nur/l10n/app_localizations.dart';
import 'package:path_of_nur/shared/application/daily_clock_provider.dart';

import '../../../test_helpers/app_test_harness.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<void> pumpWuduFrames(WidgetTester tester) async {
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 120));
    await tester.pump(const Duration(milliseconds: 180));
  }

  Future<void> scrollUntilVisible(WidgetTester tester, Finder finder) async {
    await tester.scrollUntilVisible(
      finder,
      240,
      scrollable: find.byType(Scrollable).first,
      maxScrolls: 60,
    );
    await pumpWuduFrames(tester);
  }

  testWidgets('Practice & Ibadah surfaces Wudu Trainer and routes to it', (
    tester,
  ) async {
    final container = await makeTestContainer(
      overrides: <Override>[
        dailyNowProvider.overrideWith(
          (ref) =>
              Stream<DateTime>.value(DateTime.parse('2026-03-23T12:00:00')),
        ),
      ],
    );
    addTearDown(container.dispose);

    final router = GoRouter(
      initialLocation: '/learn/island/practice-worship',
      routes: <RouteBase>[
        GoRoute(
          path: '/learn/island/:islandId',
          name: 'learnJourneyIsland',
          builder: (context, state) => LearningJourneyIslandPage(
            islandId: state.pathParameters['islandId'] ?? '',
          ),
        ),
        GoRoute(
          path: '/learn/salah/wudu/trainer',
          name: 'learnWuduTrainer',
          builder: (context, state) => const WuduTrainerPage(),
        ),
        GoRoute(
          path: '/learn/salah/wudu',
          name: 'learnWuduGuide',
          builder: (context, state) => const Scaffold(body: Text('guide')),
        ),
      ],
    );

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(
          routerConfig: router,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
        ),
      ),
    );
    await pumpWuduFrames(tester);

    final l10n = AppLocalizations.of(
      tester.element(find.byType(LearningJourneyIslandPage)),
    );

    await scrollUntilVisible(tester, find.text(l10n.wuduPracticeCardSubtitle));

    expect(find.text(l10n.wuduPracticeCardTitle), findsWidgets);
    expect(find.text(l10n.wuduPracticeCardSubtitle), findsOneWidget);

    final cardFinder = find.ancestor(
      of: find.text(l10n.wuduPracticeCardSubtitle),
      matching: find.byType(InkWell),
    );
    await tester.tap(cardFinder.first);
    await pumpWuduFrames(tester);

    expect(find.text(l10n.wuduTrainerPageTitle), findsWidgets);
    expect(find.text(l10n.wuduTrainerIntroTitle), findsOneWidget);
  });

  testWidgets('Wudu trainer progresses and rewards only once', (tester) async {
    final container = await makeTestContainer(
      overrides: <Override>[
        dailyNowProvider.overrideWith(
          (ref) =>
              Stream<DateTime>.value(DateTime.parse('2026-03-23T12:00:00')),
        ),
      ],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: const Scaffold(body: WuduTrainerPage()),
        ),
      ),
    );
    await pumpWuduFrames(tester);

    final controller = container.read(wuduTrainerControllerProvider.notifier);
    controller.resetProgress();
    await pumpWuduFrames(tester);

    expect(container.read(wuduTrainerControllerProvider).currentStepIndex, 0);

    controller.completeCurrentStep();
    await pumpWuduFrames(tester);
    expect(container.read(wuduTrainerControllerProvider).currentStepIndex, 1);

    controller.goPrevious();
    await pumpWuduFrames(tester);
    expect(container.read(wuduTrainerControllerProvider).currentStepIndex, 0);

    controller.goNext();
    await pumpWuduFrames(tester);
    expect(container.read(wuduTrainerControllerProvider).currentStepIndex, 1);

    for (var i = 0; i < 13; i += 1) {
      controller.completeCurrentStep();
      await pumpWuduFrames(tester);
    }

    final firstJourneyProgress = container.read(
      learningJourneyProgressProvider,
    );
    final firstJourneyStats = container.read(journeyProgressProvider);
    final firstDrops = container.read(oceanDropsProvider).totalLocalDrops;

    expect(
      firstJourneyProgress.completedStageIds.contains('wudu-trainer'),
      true,
    );
    expect(container.read(wuduTrainerControllerProvider).completedOnce, true);
    expect(firstJourneyStats.totalLearningStageCompletions, 1);
    expect(firstDrops, greaterThan(0));

    controller.restartGuided();
    await pumpWuduFrames(tester);
    expect(container.read(wuduTrainerControllerProvider).currentStepIndex, 0);

    for (var i = 0; i < 14; i += 1) {
      controller.completeCurrentStep();
      await pumpWuduFrames(tester);
    }

    final secondJourneyStats = container.read(journeyProgressProvider);
    final secondDrops = container.read(oceanDropsProvider).totalLocalDrops;

    expect(secondJourneyStats.totalLearningStageCompletions, 1);
    expect(secondDrops, firstDrops);
  });
}
