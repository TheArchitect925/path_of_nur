import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:path_of_nur/features/journey/drops/application/journey_drops_providers.dart';
import 'package:path_of_nur/features/journey/xp/application/journey_xp_providers.dart';
import 'package:path_of_nur/features/learn/salah/application/wudu_quiz_controller.dart';
import 'package:path_of_nur/l10n/app_localizations.dart';
import 'package:path_of_nur/shared/persistence/local_store.dart';

import '../../../test_helpers/app_test_harness.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('quiz progress persists and resumes at the current question', () async {
    final l10n = lookupAppLocalizations(const Locale('en'));
    final first = await makeTestContainer(
      overrides: [wuduQuizLocalizationsProvider.overrideWithValue(l10n)],
    );
    addTearDown(first.dispose);

    final controller = first.read(wuduQuizControllerProvider.notifier);
    final firstQuestion = controller.currentQuestion();
    controller.selectAnswer(firstQuestion.id, firstQuestion.correctOptionId);
    controller.submitCurrentAnswer();
    controller.goNext();

    final progressedState = first.read(wuduQuizControllerProvider);
    expect(progressedState.currentQuestionIndex, 1);
    expect(progressedState.submittedQuestionIds, contains(firstQuestion.id));

    final persisted = first
        .read(localStoreProvider)
        .dumpAll()
        .map((key, value) => MapEntry(key, value as Object));

    final reopened = await makeTestContainer(
      seed: persisted,
      overrides: [wuduQuizLocalizationsProvider.overrideWithValue(l10n)],
    );
    addTearDown(reopened.dispose);

    final reopenedState = reopened.read(wuduQuizControllerProvider);
    expect(reopenedState.currentQuestionIndex, 1);
    expect(reopenedState.submittedQuestionIds, contains(firstQuestion.id));
    expect(reopenedState.finished, isFalse);
  });

  test('quiz completion awards rewards once and does not duplicate', () async {
    final l10n = lookupAppLocalizations(const Locale('en'));
    final first = await makeTestContainer(
      overrides: [wuduQuizLocalizationsProvider.overrideWithValue(l10n)],
    );
    addTearDown(first.dispose);

    final controller = first.read(wuduQuizControllerProvider.notifier);
    for (var index = 0; index < controller.totalQuestions(); index += 1) {
      final question = controller.currentQuestion();
      controller.selectAnswer(question.id, question.correctOptionId);
      controller.submitCurrentAnswer();
      controller.goNext();
    }

    final completedState = first.read(wuduQuizControllerProvider);
    final firstXp = first.read(journeyXpSummaryProvider).totalXp;
    final firstDrops = first.read(journeyDropSummaryProvider).totalDrops;

    expect(completedState.finished, isTrue);
    expect(completedState.completedOnce, isTrue);
    expect(completedState.rewardSummary, isNotNull);
    expect(firstXp, greaterThan(0));
    expect(firstDrops, greaterThan(0));

    controller.restartQuiz();
    for (var index = 0; index < controller.totalQuestions(); index += 1) {
      final question = controller.currentQuestion();
      controller.selectAnswer(question.id, question.correctOptionId);
      controller.submitCurrentAnswer();
      controller.goNext();
    }

    final secondXp = first.read(journeyXpSummaryProvider).totalXp;
    final secondDrops = first.read(journeyDropSummaryProvider).totalDrops;

    expect(secondXp, firstXp);
    expect(secondDrops, firstDrops);
  });

  test('invalid persisted quiz state falls back safely', () async {
    final l10n = lookupAppLocalizations(const Locale('en'));
    final container = await makeTestContainer(
      seed: <String, Object>{
        'learn.salah.wudu.quiz.v1': jsonEncode(<String, Object?>{
          'currentQuestionIndex': 999,
          'selectedAnswers': <String, String>{'unknown-question': 'bad-answer'},
          'submittedQuestionIds': <String>['unknown-question'],
          'finished': false,
          'completedOnce': false,
        }),
      },
      overrides: [wuduQuizLocalizationsProvider.overrideWithValue(l10n)],
    );
    addTearDown(container.dispose);

    final state = container.read(wuduQuizControllerProvider);
    expect(state.currentQuestionIndex, 3);
    expect(state.selectedAnswers, isEmpty);
    expect(state.submittedQuestionIds, isEmpty);
    expect(state.finished, isFalse);
  });
}
