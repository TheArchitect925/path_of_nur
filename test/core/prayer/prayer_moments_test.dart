import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/core/prayer/prayer_moments.dart';
import 'package:path_of_nur/core/prayer/prayer_preferences.dart';
import 'package:path_of_nur/shared/application/daily_clock_provider.dart';

PrayerScheduleItem _asr(DateTime start) => PrayerScheduleItem(
  id: 'asr',
  name: 'Asr',
  arabicName: 'العصر',
  category: 'fard',
  offerDateTime: start,
  windowStartDateTime: start,
  windowEndDateTime: start.add(const Duration(hours: 2)),
  qazaDateTime: start.add(const Duration(hours: 2)),
  totalRakats: 4,
);

Future<String?> _justArrived({required Duration sinceStart}) async {
  final now = DateTime(2026, 9, 26, 15, 47);
  final container = ProviderContainer(
    overrides: [
      dailyNowProvider.overrideWith((ref) => Stream.value(now)),
      prayerScheduleContextProvider.overrideWithValue(
        PrayerScheduleContext(
          items: [_asr(now.subtract(sinceStart))],
          nextPrayerId: 'maghrib',
          currentPrayerId: 'asr',
          remainingToNext: const Duration(hours: 2),
          progressToNext: 0,
        ),
      ),
    ],
  );
  addTearDown(container.dispose);
  await container.read(dailyNowProvider.future);
  return container.read(prayerJustArrivedProvider);
}

void main() {
  test('a prayer that came in half a minute ago is the moment', () async {
    expect(await _justArrived(sinceStart: const Duration(seconds: 30)), 'asr');
  });

  test('after a minute the moment has passed', () async {
    expect(await _justArrived(sinceStart: const Duration(seconds: 61)), isNull);
  });

  test('a prayer still ahead is not the moment', () async {
    expect(
      await _justArrived(sinceStart: const Duration(seconds: -30)),
      isNull,
    );
  });
}
