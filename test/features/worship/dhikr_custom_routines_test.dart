import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/worship/application/dhikr_custom_routines_provider.dart';
import 'package:path_of_nur/features/worship/application/dhikr_routine_catalog.dart';
import 'package:path_of_nur/features/worship/application/dhikr_routine_controller.dart';
import 'package:path_of_nur/features/worship/application/dhikr_controller.dart';
import 'package:path_of_nur/features/worship/domain/dhikr_custom_routine.dart';
import 'package:path_of_nur/features/worship/domain/dhikr_day_total.dart';
import 'package:path_of_nur/features/worship/domain/dhikr_routine.dart';
import 'package:path_of_nur/shared/persistence/app_database.dart';
import 'package:path_of_nur/shared/persistence/local_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  Future<ProviderContainer> makeContainer({
    Map<String, Object> seed = const <String, Object>{},
  }) async {
    SharedPreferences.setMockInitialValues(<String, Object>{
      'app.onboardingCompleted': true,
      ...seed,
    });
    final prefs = await SharedPreferences.getInstance();
    return ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        appDatabaseProvider.overrideWithValue(AppDatabase.inMemory()),
      ],
    );
  }

  const step = DhikrRoutineStep(
    id: 'subhanallah',
    title: 'SubhanAllah',
    arabic: 'سُبْحَانَ ٱللَّهِ',
    transliteration: 'SubhanAllah',
    translation: 'Glory be to Allah',
    count: 10,
    sourceRef: '',
  );

  test('ids carry the custom prefix and never a colon', () {
    final id = DhikrCustomRoutine.newId(DateTime(2026, 9, 4, 20));
    expect(DhikrCustomRoutine.isCustomId(id), isTrue);
    expect(id.contains(':'), isFalse);
    expect(DhikrDayTotal.routineBaseId(id), id);
  });

  test('routines round-trip through JSON and drop broken steps', () {
    final routine = DhikrCustomRoutine(
      id: 'custom-abc',
      name: 'Walk home',
      steps: const [step],
      createdAt: DateTime(2026, 9, 4),
    );
    final json = routine.toJson();
    (json['steps'] as List).add(<String, dynamic>{'title': 'no id'});
    final parsed = DhikrCustomRoutine.fromJson(json)!;
    expect(parsed.id, 'custom-abc');
    expect(parsed.name, 'Walk home');
    expect(parsed.steps, hasLength(1));
    expect(parsed.steps.single.count, 10);
    expect(parsed.createdAt, DateTime(2026, 9, 4));
    expect(
      DhikrCustomRoutine.fromJson(<String, dynamic>{'id': 'sleep'}),
      isNull,
    );
  });

  test('upsert and delete persist and the catalog lists custom last', () async {
    final container = await makeContainer();
    addTearDown(container.dispose);
    final notifier = container.read(dhikrCustomRoutinesProvider.notifier);
    final routine = DhikrCustomRoutine(
      id: DhikrCustomRoutine.newId(DateTime(2026, 9, 4, 20)),
      name: 'Walk home',
      steps: const [step],
      createdAt: DateTime(2026, 9, 4, 20),
    );
    notifier.upsert(routine);
    expect(container.read(dhikrCustomRoutinesProvider), hasLength(1));

    final catalog = container.read(dhikrRoutinesProvider);
    expect(catalog.last.id, routine.id);
    expect(catalog.last.kind, DhikrRoutineKind.custom);
    expect(catalog.last.customName, 'Walk home');
    expect(catalog.last.sessionLabel, 'Walk home');
    expect(container.read(dhikrRoutineByIdProvider(routine.id)), isNotNull);

    notifier.upsert(routine.copyWith(name: 'Walk home, slowly'));
    expect(
      container.read(dhikrCustomRoutinesProvider).single.name,
      'Walk home, slowly',
    );

    final stored = container
        .read(localStoreProvider)
        .getJsonList('worship.dhikr.routines.custom.v1.__default__');
    expect(stored, hasLength(1));

    notifier.delete(routine.id);
    expect(container.read(dhikrCustomRoutinesProvider), isEmpty);
    expect(container.read(dhikrRoutineByIdProvider(routine.id)), isNull);
  });

  test('a custom routine plays and logs under its own name', () async {
    final container = await makeContainer();
    addTearDown(container.dispose);
    final custom = DhikrCustomRoutine(
      id: DhikrCustomRoutine.newId(DateTime(2026, 9, 4, 20)),
      name: 'Walk home',
      steps: const [step],
      createdAt: DateTime(2026, 9, 4, 20),
    );
    container.read(dhikrCustomRoutinesProvider.notifier).upsert(custom);
    final routine = container.read(dhikrRoutineByIdProvider(custom.id))!;
    final player = container.read(dhikrRoutineControllerProvider.notifier);
    player.start(routine, now: DateTime(2026, 9, 4, 20));
    DhikrRoutineTapResult? last;
    for (var i = 0; i < 10; i++) {
      last = player.tap(routine, now: DateTime(2026, 9, 4, 20, 1, i));
    }
    expect(last!.outcome, DhikrRoutineTapOutcome.completed);
    final dhikr = container.read(dhikrControllerProvider);
    expect(dhikr.recentSessions.single.phraseLabel, 'Walk home');
    expect(dhikr.recentSessions.single.count, 10);
    expect(
      dhikr.dailyTotals[dhikrDayKey(DateTime(2026, 9, 4))]?.hasRoutine(
        custom.id,
      ),
      isTrue,
    );
  });
}
