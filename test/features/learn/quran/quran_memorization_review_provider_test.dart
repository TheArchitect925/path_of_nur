import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/learn/quran/application/quran_learning_system_service.dart';
import 'package:path_of_nur/shared/application/daily_clock_provider.dart';
import 'package:path_of_nur/shared/persistence/local_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('Quran memorization review providers', () {
    test(
      'toggleVerse stores and removes generic ayah memorization safely',
      () async {
        SharedPreferences.setMockInitialValues(const <String, Object>{});
        final prefs = await SharedPreferences.getInstance();
        final container = ProviderContainer(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(prefs),
            dailyNowProvider.overrideWith(
              (ref) => Stream.value(DateTime(2026, 3, 24)),
            ),
          ],
        );
        addTearDown(container.dispose);

        final notifier = container.read(
          quranMemorizationProgressProvider.notifier,
        );

        notifier.toggleVerse(surahNumber: 2, ayahNumber: 255);
        expect(
          container
              .read(quranMemorizationEntryForAyahProvider((2, 255)))
              ?.verseId,
          'q_2_255',
        );

        notifier.toggleVerse(surahNumber: 2, ayahNumber: 255);
        expect(
          container.read(quranMemorizationEntryForAyahProvider((2, 255))),
          isNull,
        );
      },
    );

    test(
      'review entries expose generic ayah references from stored progress',
      () async {
        SharedPreferences.setMockInitialValues(const <String, Object>{});
        final prefs = await SharedPreferences.getInstance();
        final container = ProviderContainer(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(prefs),
            dailyNowProvider.overrideWith(
              (ref) => Stream.value(DateTime(2026, 3, 24)),
            ),
          ],
        );
        addTearDown(container.dispose);

        container
            .read(quranMemorizationProgressProvider.notifier)
            .toggleVerse(surahNumber: 67, ayahNumber: 2);

        final entries = container.read(quranMemorizationReviewEntriesProvider);
        expect(entries, hasLength(1));
        expect(entries.first.surahNumber, 67);
        expect(entries.first.ayahNumber, 2);
        expect(entries.first.progress.verseId, 'q_67_2');
      },
    );

    test(
      'markReviewed stores rhythm metadata and review grouping stays calm',
      () async {
        SharedPreferences.setMockInitialValues(const <String, Object>{});
        final prefs = await SharedPreferences.getInstance();
        final container = ProviderContainer(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(prefs),
            dailyNowProvider.overrideWith(
              (ref) => Stream.value(DateTime(2026, 3, 24)),
            ),
          ],
        );
        addTearDown(container.dispose);

        final notifier = container.read(
          quranMemorizationProgressProvider.notifier,
        );

        notifier.toggleVerse(
          surahNumber: 2,
          ayahNumber: 153,
          now: DateTime(2026, 3, 20),
        );
        notifier.markReviewed(
          'q_2_153',
          success: true,
          now: DateTime(2026, 3, 21),
        );

        final progress = container.read(
          quranMemorizationEntryForAyahProvider((2, 153)),
        );
        expect(progress, isNotNull);
        expect(progress!.addedAt, DateTime(2026, 3, 20));
        expect(progress.lastReviewed, DateTime(2026, 3, 21));
        expect(progress.reviewCount, 1);
        expect(progress.lastReviewSuccessful, isTrue);

        final sections = container.read(
          quranMemorizationReviewSectionsProvider,
        );
        expect(sections.reviewToday, hasLength(1));
        expect(sections.continueReview, isEmpty);
        expect(sections.recentlyMemorized, isEmpty);
      },
    );
  });
}
