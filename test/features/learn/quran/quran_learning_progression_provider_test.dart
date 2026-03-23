import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/journey/drops/application/journey_drops_providers.dart';
import 'package:path_of_nur/features/journey/xp/application/journey_xp_providers.dart';
import 'package:path_of_nur/features/learn/quran/application/quran_ayah_enrichment_provider.dart';
import 'package:path_of_nur/features/learn/quran/application/quran_daily_reflection_provider.dart';
import 'package:path_of_nur/features/learn/quran/application/quran_learning_progression_provider.dart';
import 'package:path_of_nur/features/learn/quran/domain/quran_content_refs.dart';

import '../../../test_helpers/app_test_harness.dart';

void main() {
  test(
    'daily reflection completion marks the entry complete without double xp',
    () async {
      final container = await makeTestContainer();
      addTearDown(container.dispose);

      final summary = container.read(quranDailyReflectionSummaryProvider);

      final changed = container
          .read(quranDailyReflectionStateProvider.notifier)
          .completeToday(
            assignment: QuranDailyReflectionAssignment(
              dateKey: '2026-03-22',
              entry: summary.assignment.entry,
              isFirstTimeStarter: summary.assignment.isFirstTimeStarter,
            ),
            now: DateTime(2026, 3, 22, 9),
          );

      expect(changed, isTrue);
      expect(
        container.read(
          quranLearningEntryCompletedProvider(summary.assignment.entry.id),
        ),
        isTrue,
      );
      expect(container.read(journeyXpSummaryProvider).totalXp, 5);
    },
  );

  test(
    'completing an insight rewards once and completion is anti-spam',
    () async {
      final container = await makeTestContainer();
      addTearDown(container.dispose);

      final entry = container
          .read(quranAyahEnrichmentEntriesProvider)
          .firstWhere((item) => item.id == 'character_justice_5_8');

      final first = container
          .read(quranLearningProgressStateProvider.notifier)
          .completeEntry(entry: entry, sourceSurface: 'test');
      final xpAfterFirst = container.read(journeyXpSummaryProvider).totalXp;
      final dropsAfterFirst = container.read(journeyDropHistoryProvider).length;

      final second = container
          .read(quranLearningProgressStateProvider.notifier)
          .completeEntry(entry: entry, sourceSurface: 'test');

      expect(first, isTrue);
      expect(second, isFalse);
      expect(xpAfterFirst, 8);
      expect(container.read(journeyXpSummaryProvider).totalXp, xpAfterFirst);
      expect(
        container.read(journeyDropHistoryProvider),
        hasLength(dropsAfterFirst),
      );
    },
  );

  test(
    'path completion awards step completion once and path completion once',
    () async {
      final container = await makeTestContainer();
      addTearDown(container.dispose);

      final path = container.read(
        quranAyahInsightPathProvider('worship-remembrance-starter'),
      )!;
      final controller = container.read(
        quranLearningProgressStateProvider.notifier,
      );

      for (final entry in path.entries) {
        controller.completeEntry(
          entry: entry,
          sourcePathId: path.path.id,
          sourceSurface: 'path_test',
        );
      }

      expect(
        container
            .read(quranAyahInsightPathProgressProvider(path.path.id))
            ?.isCompleted,
        isTrue,
      );
      expect(
        container.read(quranLearningProgressStateProvider).completedPathIds,
        contains(path.path.id),
      );
      expect(
        container.read(journeyXpSummaryProvider).totalXp,
        (8 * path.entries.length) + 12,
      );
    },
  );

  test('first reflection note reward only happens once', () async {
    final container = await makeTestContainer();
    addTearDown(container.dispose);

    final controller = container.read(
      quranLearningProgressStateProvider.notifier,
    );

    final first = controller.rewardFirstReflectionNote(
      ref: const QuranQuoteRef(surah: 20, ayah: 14),
      sourceEnrichmentId: 'worship_salah_20_14',
      sourceSurface: 'test',
    );
    final xpAfterFirst = container.read(journeyXpSummaryProvider).totalXp;

    final second = controller.rewardFirstReflectionNote(
      ref: const QuranQuoteRef(surah: 2, ayah: 186),
      sourceEnrichmentId: 'worship_dua_2_186',
      sourceSurface: 'test',
    );

    expect(first, isTrue);
    expect(second, isFalse);
    expect(xpAfterFirst, 5);
    expect(container.read(journeyXpSummaryProvider).totalXp, 5);
  });
}
