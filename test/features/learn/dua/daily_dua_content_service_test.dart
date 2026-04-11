import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:path_of_nur/features/learn/dua/application/daily_dua_content_service.dart';
import 'package:path_of_nur/features/learn/dua/application/dua_repository.dart';
import 'package:path_of_nur/features/learn/dua/domain/dua_models.dart';
import 'package:path_of_nur/shared/persistence/local_store.dart';

void main() {
  late SharedPreferences prefs;
  late ProviderContainer container;
  const service = DailyDuaContentService();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    container = ProviderContainer(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
    );
  });

  tearDown(() {
    container.dispose();
  });

  Future<DuaDataset> loadDataset() {
    return container.read(duaDatasetProvider.future);
  }

  test('selects only verified strong duas by default', () async {
    final dataset = await loadDataset();
    final candidates = service.getContextualDuaCandidates(
      dataset: dataset,
      context: DailyDuaSelectionContext(
        currentDateTime: DateTime(2026, 4, 10, 7, 30),
        surface: duaSurfaceInApp,
        timeContexts: const <String>['morning', 'upon_waking'],
        maxItems: 8,
      ),
    );

    expect(candidates, isNotEmpty);
    expect(candidates.every((candidate) => candidate.item.isVerifiedStrong), isTrue);
  });

  test('morning context prefers morning or waking duas', () async {
    final dataset = await loadDataset();
    final candidate = service.getBestMatch(
      dataset: dataset,
      context: DailyDuaSelectionContext(
        currentDateTime: DateTime(2026, 4, 10, 6, 15),
        surface: duaSurfaceInApp,
        timeContexts: const <String>['morning', 'upon_waking'],
      ),
    );

    expect(candidate, isNotNull);
    expect(
      candidate!.item.timeContexts.any(
        (value) => value == 'morning' || value == 'upon_waking',
      ),
      isTrue,
    );
  });

  test('after salah context returns post-salah dua candidates', () async {
    final dataset = await loadDataset();
    final candidate = service.getBestMatch(
      dataset: dataset,
      context: DailyDuaSelectionContext(
        currentDateTime: DateTime(2026, 4, 10, 13, 10),
        surface: duaSurfaceInApp,
        prayerContexts: const <String>['after_salah'],
      ),
    );

    expect(candidate, isNotNull);
    expect(candidate!.item.prayerContexts, contains('after_salah'));
  });

  test('rain context returns weather dua when available', () async {
    final dataset = await loadDataset();
    final candidate = service.getBestMatch(
      dataset: dataset,
      context: DailyDuaSelectionContext(
        currentDateTime: DateTime(2026, 4, 10, 17, 45),
        surface: duaSurfaceInApp,
        weatherContexts: const <String>['rain'],
        allowGeneralVerified: true,
      ),
    );

    expect(candidate, isNotNull);
    expect(candidate!.item.weatherContexts, contains('rain'));
  });

  test('falls back gracefully when no exact context exists', () async {
    final dataset = await loadDataset();
    final candidate = service.getBestMatch(
      dataset: dataset,
      context: DailyDuaSelectionContext(
        currentDateTime: DateTime(2026, 4, 10, 14, 0),
        surface: duaSurfaceInApp,
        situationContexts: const <String>['not_a_real_context'],
      ),
    );

    expect(candidate, isNotNull);
    expect(candidate!.item.isDefaultSurfaceEligible, isTrue);
  });

  test('recent history avoids repeating the same dua when alternatives exist', () async {
    final dataset = await loadDataset();
    final baseContext = DailyDuaSelectionContext(
      currentDateTime: DateTime(2026, 4, 10, 9, 0),
      surface: duaSurfaceInApp,
      maxItems: 3,
    );
    final first = service.getBestMatch(dataset: dataset, context: baseContext);

    expect(first, isNotNull);

    final rotated = service.getBestMatch(
      dataset: dataset,
      context: baseContext.copyWith(
        recentlySeenIds: <String>[first!.item.id],
      ),
    );

    expect(rotated, isNotNull);
    expect(rotated!.item.id, isNot(first.item.id));
  });

  test('provider exposure returns a trusted prompt with overridden context', () async {
    final scopedContainer = ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        dailyDuaSelectionContextProvider.overrideWithValue(
          DailyDuaSelectionContext(
            currentDateTime: DateTime(2026, 4, 10, 22, 0),
            surface: duaSurfaceInApp,
            timeContexts: <String>['night', 'before_sleep'],
          ),
        ),
      ],
    );
    addTearDown(scopedContainer.dispose);
    await scopedContainer.read(duaDatasetProvider.future);
    final prompt = scopedContainer.read(currentDailyDuaPromptProvider);

    expect(prompt.value, isNotNull);
    expect(prompt.value!.item.isDefaultSurfaceEligible, isTrue);
  });
}
