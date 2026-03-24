import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/learn/quran/application/quran_guided_learning_paths_provider.dart';
import 'package:path_of_nur/features/learn/quran/application/quran_user_intent_provider.dart';
import 'package:path_of_nur/features/learn/quran/domain/quran_guided_learning_path_models.dart';
import 'package:path_of_nur/features/learn/quran/domain/quran_reference_models.dart';
import 'package:path_of_nur/features/learn/quran/domain/quran_user_intent_models.dart';

import '../../../test_helpers/app_test_harness.dart';

void main() {
  test('quran user intent restores a persisted memorization focus safely', () async {
    final container = await makeTestContainer(
      seed: <String, Object>{
        'learn.quran.user_intent.v1': jsonEncode(<String, Object?>{
          'intent': 'memorize',
          'updatedAtIso': '2026-03-24T10:00:00.000Z',
        }),
      },
    );
    addTearDown(container.dispose);

    final summary = container.read(quranUserIntentSummaryProvider);

    expect(summary.selectedIntent, QuranUserIntent.memorize);
    expect(summary.preferredReaderMode, QuranReaderStudyMode.memorization);
    expect(summary.suggestedPath?.type, QuranGuidedLearningPathType.memorizationSupport);
  });

  test('guided-path focus prefers the current continue path when available', () async {
    final container = await makeTestContainer();
    addTearDown(container.dispose);

    container
        .read(quranGuidedLearningContinuityProvider.notifier)
        .markStepOpened(
          pathId: 'surah-study-starter',
          stepId: 'surah-open-insight',
        );
    container
        .read(quranUserIntentStateProvider.notifier)
        .setIntent(QuranUserIntent.guidedPath);

    final summary = container.read(quranUserIntentSummaryProvider);

    expect(summary.selectedIntent, QuranUserIntent.guidedPath);
    expect(summary.suggestedPath?.id, 'surah-study-starter');
    expect(summary.preferredReaderMode, QuranReaderStudyMode.study);
  });
}
