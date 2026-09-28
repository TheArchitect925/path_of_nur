import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/worship/application/dhikr_controller.dart';
import 'package:path_of_nur/features/worship/application/dhikr_history_provider.dart';
import 'package:path_of_nur/features/worship/application/dhikr_routine_catalog.dart';
import 'package:path_of_nur/features/worship/application/dhikr_routine_controller.dart';
import 'package:path_of_nur/features/worship/data/dhikr_repository.dart';
import 'package:path_of_nur/features/worship/domain/dhikr_day_total.dart';
import 'package:path_of_nur/shared/persistence/app_database.dart';
import 'package:path_of_nur/shared/persistence/local_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  Future<ProviderContainer> makeContainer({
    AppDatabase? database,
    Map<String, Object> seed = const <String, Object>{},
  }) async {
    SharedPreferences.setMockInitialValues(<String, Object>{
      'app.onboardingCompleted': true,
      ...seed,
    });
    final prefs = await SharedPreferences.getInstance();
    final appDatabase = database ?? AppDatabase.inMemory();
    return ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        appDatabaseProvider.overrideWithValue(appDatabase),
      ],
    );
  }

  test('after-salah routine advances by itself and logs one session', () async {
    final container = await makeContainer();
    addTearDown(container.dispose);
    final routine = buildAfterSalahRoutine();
    final notifier = container.read(dhikrRoutineControllerProvider.notifier);
    final start = DateTime(2026, 9, 4, 17, 5);

    notifier.start(routine, prayerId: 'asr', now: start);
    expect(container.read(dhikrRoutineControllerProvider)?.stepIndex, 0);

    DhikrRoutineTapResult? last;
    for (var i = 0; i < 33; i++) {
      last = notifier.tap(routine, now: start.add(Duration(seconds: i)));
    }
    expect(last!.outcome, DhikrRoutineTapOutcome.stepAdvanced);
    expect(container.read(dhikrRoutineControllerProvider)?.stepIndex, 1);
    expect(container.read(dhikrRoutineControllerProvider)?.stepCount, 0);

    for (var i = 0; i < 66; i++) {
      last = notifier.tap(routine, now: start.add(Duration(seconds: 40 + i)));
    }
    expect(container.read(dhikrRoutineControllerProvider)?.stepIndex, 3);

    last = notifier.tap(routine, now: start.add(const Duration(minutes: 3)));
    expect(last.outcome, DhikrRoutineTapOutcome.completed);
    expect(last.completion?.routine.id, kDhikrRoutineAfterSalahId);
    expect(last.completion?.duration, const Duration(minutes: 3));
    expect(container.read(dhikrRoutineControllerProvider), isNull);

    final dhikr = container.read(dhikrControllerProvider);
    expect(dhikr.recentSessions, hasLength(1));
    expect(dhikr.recentSessions.first.phraseLabel, 'After-salah tasbih');
    expect(dhikr.recentSessions.first.count, 100);
    final today = dhikr.dailyTotals[dhikrDayKey(start)];
    expect(today?.count, 100);
    expect(today?.sessions, 1);
    expect(today?.routineEntries, ['after-salah:asr']);
    expect(dhikr.phraseTotals['After-salah tasbih'], 100);
  });

  test('undo steps back across a step boundary and skip moves on', () async {
    final container = await makeContainer();
    addTearDown(container.dispose);
    final routine = buildAfterSalahRoutine();
    final notifier = container.read(dhikrRoutineControllerProvider.notifier);
    notifier.start(routine);
    for (var i = 0; i < 33; i++) {
      notifier.tap(routine);
    }
    expect(container.read(dhikrRoutineControllerProvider)?.stepIndex, 1);
    notifier.undo(routine);
    final progress = container.read(dhikrRoutineControllerProvider)!;
    expect(progress.stepIndex, 0);
    expect(progress.stepCount, 32);

    final skipped = notifier.skipStep(routine);
    expect(skipped.outcome, DhikrRoutineTapOutcome.stepAdvanced);
    expect(container.read(dhikrRoutineControllerProvider)?.stepIndex, 1);
  });

  test('a routine left half-way resumes in a fresh container', () async {
    final database = AppDatabase.inMemory();
    final first = await makeContainer(database: database);
    final routine = buildAfterSalahRoutine();
    first.read(dhikrRoutineControllerProvider.notifier).start(routine);
    for (var i = 0; i < 40; i++) {
      first.read(dhikrRoutineControllerProvider.notifier).tap(routine);
    }
    final stored = first
        .read(localStoreProvider)
        .getJsonMap('worship.dhikr.routine.active.v1.__default__');
    first.dispose();

    final second = await makeContainer(
      database: database,
      seed: <String, Object>{
        'worship.dhikr.routine.active.v1.__default__':
            '{"routineId":"${stored!['routineId']}","stepIndex":${stored['stepIndex']},"stepCount":${stored['stepCount']},"startedAtIso":"${stored['startedAtIso']}"}',
      },
    );
    addTearDown(second.dispose);
    final resumed = second.read(dhikrRoutineControllerProvider);
    expect(resumed?.routineId, kDhikrRoutineAfterSalahId);
    expect(resumed?.stepIndex, 1);
    expect(resumed?.stepCount, 7);
  });

  test('starting another routine abandons the current one', () async {
    final container = await makeContainer();
    addTearDown(container.dispose);
    final routine = buildAfterSalahRoutine();
    final notifier = container.read(dhikrRoutineControllerProvider.notifier);
    notifier.start(routine);
    notifier.tap(routine);
    notifier.abandon();
    expect(container.read(dhikrRoutineControllerProvider), isNull);
    expect(container.read(dhikrControllerProvider).recentSessions, isEmpty);
  });

  test('free sessions feed the streak and survive a reload', () async {
    final database = AppDatabase.inMemory();
    final container = await makeContainer(database: database);
    addTearDown(container.dispose);
    final notifier = container.read(dhikrControllerProvider.notifier);
    for (var i = 0; i < 5; i++) {
      notifier.increment();
    }
    notifier.finishSession();
    expect(container.read(dhikrStreakProvider), 1);
    expect(container.read(dhikrHeatmapValuesProvider).last, 5);

    final repository = container.read(dhikrRepositoryProvider);
    final totals = repository.loadDailyTotals();
    expect(totals.values.single.count, 5);
    expect(repository.loadPhraseTotals()['SubhanAllah'], 5);

    notifier.reloadFromStorage();
    expect(container.read(dhikrControllerProvider).dailyTotals, hasLength(1));
  });

  test('existing sessions are folded into totals once', () async {
    final database = AppDatabase.inMemory();
    database.execute(
      '''
      INSERT INTO dhikr_sessions(
        scope_id, session_id, phrase_label, count, target, started_at_iso, finished_at_iso
      ) VALUES (?, ?, ?, ?, ?, ?, ?);
      ''',
      <Object?>[
        '__default__',
        'legacy-1',
        'Alhamdulillah',
        33,
        33,
        '2026-09-01T08:00:00.000',
        '2026-09-01T08:03:00.000',
      ],
    );
    final container = await makeContainer(database: database);
    addTearDown(container.dispose);
    final state = container.read(dhikrControllerProvider);
    expect(state.dailyTotals['2026-09-01']?.count, 33);
    expect(state.phraseTotals['Alhamdulillah'], 33);
  });
}
