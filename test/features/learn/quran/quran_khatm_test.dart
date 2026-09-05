import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/learn/quran/application/quran_khatm_provider.dart';
import 'package:path_of_nur/features/learn/quran/domain/quran_khatm_models.dart';
import 'package:path_of_nur/shared/persistence/local_store.dart';
import 'package:quran/quran.dart' as q;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('QuranGlobalPosition', () {
    test('index and position round-trip across the whole mushaf', () {
      expect(QuranGlobalPosition.indexOf(1, 1), 1);
      expect(QuranGlobalPosition.indexOf(2, 1), 8);
      expect(QuranGlobalPosition.totalAyahs, 6236);
      expect(QuranGlobalPosition.indexOf(114, 6), 6236);
      for (final index in <int>[1, 7, 8, 293, 3000, 6235, 6236]) {
        final (surah, ayah) = QuranGlobalPosition.positionOf(index);
        expect(QuranGlobalPosition.indexOf(surah, ayah), index);
        expect(ayah, lessThanOrEqualTo(q.getVerseCount(surah)));
      }
    });

    test('juz boundaries agree with package data (manual spot checks)', () {
      // Juz 1 starts at 1:1, juz 2 at 2:142, juz 30 at 78:1.
      expect(QuranGlobalPosition.juzStartIndex(1), 1);
      expect(
        QuranGlobalPosition.juzStartIndex(2),
        QuranGlobalPosition.indexOf(2, 142),
      );
      expect(
        QuranGlobalPosition.juzStartIndex(30),
        QuranGlobalPosition.indexOf(78, 1),
      );
      // Every juz start maps back to that juz, and boundaries partition the
      // mushaf (package data overlaps by a verse at some seams, so the model
      // keeps its own consistent boundary definition).
      for (var juz = 1; juz <= 30; juz++) {
        expect(
          QuranGlobalPosition.juzOf(QuranGlobalPosition.juzStartIndex(juz)),
          juz,
          reason: 'juz $juz start',
        );
        if (juz > 1) {
          expect(
            QuranGlobalPosition.juzOf(
              QuranGlobalPosition.juzStartIndex(juz) - 1,
            ),
            juz - 1,
            reason: 'juz $juz predecessor',
          );
        }
      }
    });

    test('juz equivalent is exact at boundaries and monotonic', () {
      expect(QuranGlobalPosition.juzEquivalent(0), 0);
      expect(
        QuranGlobalPosition.juzEquivalent(
          QuranGlobalPosition.juzStartIndex(2) - 1,
        ),
        closeTo(1, 0.001),
      );
      expect(QuranGlobalPosition.juzEquivalent(6236), 30);
      var previous = -1.0;
      for (var index = 0; index <= 6236; index += 97) {
        final value = QuranGlobalPosition.juzEquivalent(index);
        expect(value, greaterThanOrEqualTo(previous));
        previous = value;
      }
    });
  });

  group('khatmPortionFor', () {
    QuranKhatmPlan plan({
      QuranKhatmPaceMode mode = QuranKhatmPaceMode.juzPerDay,
      double juzPerDay = 1,
      int pagesPerDay = 10,
      String? targetDateIso,
      int completedIndex = 0,
    }) {
      return QuranKhatmPlan(
        paceMode: mode,
        juzPerDay: juzPerDay,
        pagesPerDay: pagesPerDay,
        targetDateIso: targetDateIso,
        startedAtIso: '2026-08-29T00:00:00',
        completedIndex: completedIndex,
        lastPortionDayKey: null,
      );
    }

    final today = DateTime(2026, 8, 29);

    test('one juz per day from zero covers exactly juz 1', () {
      final portion = khatmPortionFor(plan(), today);
      expect(portion.startIndex, 1);
      expect(portion.endIndex, QuranGlobalPosition.juzStartIndex(2) - 1);
    });

    test('a juz-per-day portion crosses juz boundaries correctly', () {
      // Completed through the middle of juz 1; one juz/day must end in juz 2.
      final start = QuranGlobalPosition.juzStartIndex(2) ~/ 2;
      final portion = khatmPortionFor(plan(completedIndex: start), today);
      expect(QuranGlobalPosition.juzOf(portion.endIndex), 2);
      // Manual count: portion spans a whole juz-equivalent.
      expect(
        QuranGlobalPosition.juzEquivalent(portion.endIndex) -
            QuranGlobalPosition.juzEquivalent(start),
        closeTo(1, 0.02),
      );
    });

    test('pages per day ends at a mushaf page end', () {
      final portion = khatmPortionFor(
        plan(mode: QuranKhatmPaceMode.pagesPerDay, pagesPerDay: 2),
        today,
      );
      expect(portion.startIndex, 1);
      expect(portion.endIndex, QuranGlobalPosition.pageEndIndex(2));
      final (surah, ayah) = QuranGlobalPosition.positionOf(
        portion.endIndex + 1,
      );
      expect(q.getPageNumber(surah, ayah), 3);
    });

    test('finish-by splits the remainder evenly over the days left', () {
      final portion = khatmPortionFor(
        plan(
          mode: QuranKhatmPaceMode.finishBy,
          targetDateIso: '2026-09-27T00:00:00',
        ),
        today,
      );
      // 30 days including today: ceil(6236/30) = 208.
      expect(portion.ayahCount, 208);
    });

    test('the final portion never overruns the mushaf', () {
      final portion = khatmPortionFor(plan(completedIndex: 6230), today);
      expect(portion.endIndex, 6236);
      expect(portion.startIndex, 6231);
    });
  });

  group('QuranKhatmPlanNotifier', () {
    late SharedPreferences prefs;

    setUp(() async {
      SharedPreferences.setMockInitialValues(<String, Object>{
        'settings.prayer': jsonEncode(<String, Object?>{
          'location': 'toronto',
          'useDeviceLocation': false,
          'manualLatitude': 43.6532,
          'manualLongitude': -79.3832,
        }),
      });
      prefs = await SharedPreferences.getInstance();
    });

    ProviderContainer createContainer() {
      return ProviderContainer(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      );
    }

    test('start, mark done, and juz-equivalent survive a reload', () {
      final container = createContainer();
      addTearDown(container.dispose);
      final notifier = container.read(quranKhatmPlanProvider.notifier);
      notifier.startPlan(paceMode: QuranKhatmPaceMode.juzPerDay, juzPerDay: 1);
      notifier.markPortionDone(DateTime(2026, 8, 29));

      final plan = container.read(quranKhatmPlanProvider)!;
      expect(plan.completedIndex, QuranGlobalPosition.juzStartIndex(2) - 1);
      expect(plan.lastPortionDayKey, '2026-08-29');
      expect(
        container.read(quranKhatmJuzEquivalentProvider),
        closeTo(1, 0.001),
      );

      // A fresh container reads the same plan back from the store.
      final reloaded = createContainer();
      addTearDown(reloaded.dispose);
      expect(
        reloaded.read(quranKhatmPlanProvider)?.completedIndex,
        plan.completedIndex,
      );
    });

    test('setCompletedThrough syncs to an explicit reader position', () {
      final container = createContainer();
      addTearDown(container.dispose);
      final notifier = container.read(quranKhatmPlanProvider.notifier);
      notifier.startPlan(paceMode: QuranKhatmPaceMode.pagesPerDay);
      notifier.setCompletedThrough(2, 142);
      expect(container.read(quranKhatmJuzEquivalentProvider), closeTo(1, 0.01));
    });
  });
}
