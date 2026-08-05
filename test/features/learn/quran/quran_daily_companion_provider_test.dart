import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/learn/journey/application/learning_journey_progress_provider.dart';
import 'package:path_of_nur/features/learn/journey/data/learning_journey_registry.dart';
import 'package:path_of_nur/features/learn/quran/application/quran_daily_reflection_provider.dart';
import 'package:path_of_nur/features/learn/quran/domain/quran_reference_models.dart';
import 'package:path_of_nur/features/learn/quran/domain/quran_user_intent_models.dart';
import 'package:path_of_nur/shared/application/daily_clock_provider.dart';

import '../../../test_helpers/app_test_harness.dart';

void main() {
  Future<ProviderContainer> makeCompanionContainer() {
    return makeTestContainer(
      overrides: <Override>[
        dailyNowProvider.overrideWith(
          (ref) =>
              Stream<DateTime>.value(DateTime.parse('2026-03-24T09:00:00')),
        ),
      ],
    );
  }

  test(
    'daily companion summary stays deterministic for the same day',
    () async {
      final container = await makeCompanionContainer();
      addTearDown(container.dispose);

      final first = container.read(quranDailyCompanionSummaryProvider);
      final second = container.read(quranDailyCompanionSummaryProvider);

      expect(
        first.reflection.assignment.entry.id,
        second.reflection.assignment.entry.id,
      );
      expect(first.relatedLinks.length, lessThanOrEqualTo(2));
      expect(first.meaningCue.trim(), isNotEmpty);
      expect(first.practicalTakeaway.trim(), isNotEmpty);
    },
  );

  test(
    'daily companion summary exposes a path suggestion or continuation',
    () async {
      final container = await makeCompanionContainer();
      addTearDown(container.dispose);

      final summary = container.read(quranDailyCompanionSummaryProvider);

      expect(
        summary.suggestedPath != null || summary.continuePath != null,
        isTrue,
      );
    },
  );

  test(
    'daily companion summary adapts to a persisted reflection focus',
    () async {
      final container = await makeTestContainer(
        seed: <String, Object>{
          'learn.quran.user_intent.v1':
              '{"intent":"reflect","updatedAtIso":"2026-03-24T11:00:00.000Z"}',
        },
        overrides: <Override>[
          dailyNowProvider.overrideWith(
            (ref) =>
                Stream<DateTime>.value(DateTime.parse('2026-03-24T09:00:00')),
          ),
        ],
      );
      addTearDown(container.dispose);

      final summary = container.read(quranDailyCompanionSummaryProvider);

      expect(summary.activeIntent, QuranUserIntent.reflect);
      expect(summary.preferredReaderMode, QuranReaderStudyMode.reflection);
      expect(summary.suggestedPath?.id, 'mercy-and-hope');
    },
  );

  test(
    'daily companion summary aligns with the active journey when a strong theme mapping exists',
    () async {
      final journey = LearningJourneyRegistry.journeyById('daily-dhikr')!;
      final stage = LearningJourneyRegistry.stageById('dhikr-what-is')!;
      final container = await makeTestContainer(
        overrides: <Override>[
          dailyNowProvider.overrideWith(
            (ref) =>
                Stream<DateTime>.value(DateTime.parse('2026-03-24T09:00:00')),
          ),
          learningJourneyContinueProvider.overrideWithValue(
            LearningJourneyContinueState(
              hasJourney: true,
              journey: journey,
              stage: stage,
              journeyCompleted: false,
            ),
          ),
        ],
      );
      addTearDown(container.dispose);

      final summary = container.read(quranDailyCompanionSummaryProvider);

      expect(summary.selectionSource.name, 'journeyTheme');
      expect(summary.journeyContext?.journeyId, 'daily-dhikr');
      expect(summary.journeyContext?.stageId, 'dhikr-what-is');
      expect(summary.reflection.assignment.entry.ref.surah, 13);
      expect(summary.reflection.assignment.entry.ref.ayah, 28);
      expect(summary.themes.first.id, 'remembrance');
    },
  );
}
