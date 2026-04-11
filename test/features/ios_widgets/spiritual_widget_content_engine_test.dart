import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:path_of_nur/core/prayer/prayer_preferences.dart';
import 'package:path_of_nur/features/ios_widgets/application/spiritual_widget_content_engine.dart';
import 'package:path_of_nur/features/learn/dua/application/daily_dua_content_service.dart';
import 'package:path_of_nur/features/learn/dua/application/dua_repository.dart';
import 'package:path_of_nur/shared/persistence/local_store.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late SharedPreferences prefs;
  late ProviderContainer container;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    container = ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        prayerScheduleContextProvider.overrideWithValue(
          PrayerScheduleContext(
            items: const <PrayerScheduleItem>[],
            nextPrayerId: 'fajr',
            currentPrayerId: 'fajr',
            remainingToNext: const Duration(hours: 1),
            progressToNext: 0.4,
          ),
        ),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  test(
    'home widget dua selection stays release-safe and surface-eligible',
    () async {
      await container.read(duaDatasetProvider.future);
      final engine = container.read(spiritualWidgetContentEngineProvider);
      final bundle = engine.build(
        now: DateTime(2026, 4, 10, 7, 30),
        duaSurface: duaSurfaceHomeWidget,
      );

      expect(bundle.dua, isNotNull);
      final selected = container
          .read(duaDatasetProvider)
          .value!
          .items
          .firstWhere((item) => item.id == bundle.dua!.id);

      expect(selected.isVerifiedStrong, isTrue);
      expect(selected.needsReview, isFalse);
      expect(selected.excludeFromDefaultSurface, isFalse);
      expect(selected.surfaceEligibility, contains(duaSurfaceHomeWidget));
    },
  );

  test('watch dua selection stays release-safe and watch-eligible', () async {
    await container.read(duaDatasetProvider.future);
    final engine = container.read(spiritualWidgetContentEngineProvider);
    final bundle = engine.build(
      now: DateTime(2026, 4, 10, 22, 0),
      duaSurface: duaSurfaceWatch,
    );

    expect(bundle.dua, isNotNull);
    final selected = container
        .read(duaDatasetProvider)
        .value!
        .items
        .firstWhere((item) => item.id == bundle.dua!.id);

    expect(selected.isVerifiedStrong, isTrue);
    expect(selected.needsReview, isFalse);
    expect(selected.excludeFromDefaultSurface, isFalse);
    expect(selected.surfaceEligibility, contains(duaSurfaceWatch));
  });
}
