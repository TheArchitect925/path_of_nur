import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/learn/dua/data/dua_seed_data.dart';
import 'package:path_of_nur/features/worship/application/dhikr_routine_catalog.dart';
import 'package:path_of_nur/features/worship/domain/dhikr_routine.dart';

void main() {
  group('parseDhikrRepeatCount', () {
    test('reads the prose forms the dua seed uses', () {
      expect(parseDhikrRepeatCount('Three times in the morning.'), 3);
      expect(parseDhikrRepeatCount('Recite 7 times.'), 7);
      expect(parseDhikrRepeatCount('Say it 100 times a day.'), 100);
      expect(parseDhikrRepeatCount('At the beginning of the morning.'), 1);
      expect(parseDhikrRepeatCount(''), 1);
    });
  });

  group('buildDhikrRoutines', () {
    test('after-salah is the Sahih Muslim 597 hundred', () {
      final routine = buildAfterSalahRoutine();
      expect(routine.kind, DhikrRoutineKind.afterSalah);
      expect(routine.steps.map((step) => step.count), [33, 33, 33, 1]);
      expect(routine.totalCount, 100);
      expect(routine.sourceRef, 'Sahih Muslim 597');
      expect(routine.steps.last.id, 'tahlil-closing');
      expect(routine.steps.first.arabic, isNotEmpty);
    });

    test('without the dua dataset only after-salah is offered', () {
      final routines = buildDhikrRoutines(null);
      expect(routines.map((routine) => routine.id), [
        kDhikrRoutineAfterSalahId,
      ]);
    });

    test('morning and evening come from the seeded adhkar with counts', () {
      final routines = buildDhikrRoutines(duaSeedDataset);
      final ids = routines.map((routine) => routine.id).toList();
      expect(ids, [
        kDhikrRoutineAfterSalahId,
        kDhikrRoutineMorningId,
        kDhikrRoutineEveningId,
      ]);

      final morning = routines[1];
      expect(morning.steps, hasLength(5));
      expect(morning.steps.map((step) => step.count), [1, 1, 1, 3, 3]);
      expect(morning.steps.every((step) => step.sourceRef.isNotEmpty), isTrue);
      expect(morning.steps.every((step) => step.arabic.isNotEmpty), isTrue);
      expect(morning.totalCount, 9);
      expect(morning.estimatedMinutes, greaterThanOrEqualTo(1));

      final evening = routines[2];
      expect(evening.steps, hasLength(5));
      expect(evening.steps.map((step) => step.count), [1, 1, 1, 3, 3]);
      expect(
        evening.steps.map((step) => step.id).toSet().intersection(
          morning.steps.map((step) => step.id).toSet(),
        ),
        isEmpty,
      );
    });

    test('session labels are stable canonical strings', () {
      final routines = buildDhikrRoutines(duaSeedDataset);
      expect(routines.map((routine) => routine.sessionLabel), [
        'After-salah tasbih',
        'Morning adhkar',
        'Evening adhkar',
      ]);
    });
  });
}
