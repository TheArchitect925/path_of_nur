import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:path_of_nur/features/learn/salah/application/wudu_trainer_controller.dart';
import 'package:path_of_nur/features/learn/salah/presentation/wudu_quiz_page.dart';
import 'package:path_of_nur/features/learn/salah/presentation/wudu_trainer_page.dart';
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

  testWidgets('wudu trainer completion links to the Wudu quiz', (tester) async {
    final container = await makeTestContainer(
      overrides: <Override>[
        dailyNowProvider.overrideWith(
          (ref) => Stream<DateTime>.value(DateTime(2026, 3, 23, 12)),
        ),
      ],
    );
    addTearDown(container.dispose);

    final router = GoRouter(
      initialLocation: '/learn/salah/wudu/trainer',
      routes: <RouteBase>[
        GoRoute(
          path: '/learn/salah/wudu/trainer',
          name: 'learnWuduTrainer',
          builder: (context, state) => const WuduTrainerPage(),
        ),
        GoRoute(
          path: '/learn/salah/wudu/quiz',
          name: 'learnWuduQuiz',
          builder: (context, state) => const WuduQuizPage(),
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

    final trainerL10n = AppLocalizations.of(
      tester.element(find.byType(WuduTrainerPage)),
    );
    final controller = container.read(wuduTrainerControllerProvider.notifier);

    for (var i = 0; i < 20; i += 1) {
      if (container.read(wuduTrainerControllerProvider).guidedFinished) {
        break;
      }
      controller.completeCurrentStep();
      await pumpWuduFrames(tester);
    }
    expect(container.read(wuduTrainerControllerProvider).guidedFinished, isTrue);

    final quizLabel = find.text(trainerL10n.wuduQuizStartAction).first;
    await tester.ensureVisible(quizLabel);
    await pumpWuduFrames(tester);
    await tester.tap(quizLabel, warnIfMissed: false);
    await pumpWuduFrames(tester);

    final quizL10n = AppLocalizations.of(
      tester.element(find.byType(WuduQuizPage)),
    );
    expect(find.text(quizL10n.wuduQuizPageTitle), findsOneWidget);
    expect(find.text(quizL10n.wuduQuizStepOrderQuestion), findsOneWidget);
  });
}
