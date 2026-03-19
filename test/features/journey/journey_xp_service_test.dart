import 'package:flutter_test/flutter_test.dart';

import 'package:path_of_nur/features/journey/xp/application/journey_xp_providers.dart';
import 'package:path_of_nur/features/journey/xp/application/journey_xp_service.dart';
import 'package:path_of_nur/features/journey/xp/data/journey_xp_repository.dart';
import 'package:path_of_nur/features/journey/xp/domain/journey_xp_levels.dart';
import 'package:path_of_nur/features/journey/xp/domain/journey_xp_models.dart';
import 'package:path_of_nur/shared/persistence/app_database.dart';

import '../../test_helpers/app_test_harness.dart';

void main() {
  test('level lookup uses handcrafted thresholds', () {
    expect(xpLevelForTotalXp(0).level, 1);
    expect(xpLevelForTotalXp(35).level, 2);
    expect(xpLevelForTotalXp(121601).level, 99);
    expect(xpLevelForTotalXp(121602).level, 100);
  });

  test('summary calculation exposes level progress and xp remaining', () {
    final database = AppDatabase.inMemory();
    addTearDown(database.close);
    final repository = JourneyXpRepository(database: database, scopeId: 'test');
    final service = JourneyXpService(repository);

    service.awardLearningXp(
      context: XpContext(
        sourceRef: 'lesson:alpha',
        sourceModule: 'learn',
        occurredAt: DateTime(2026, 3, 18, 9),
      ),
    );
    service.awardQuranXp(
      context: XpContext(
        sourceRef: 'quran:session:1',
        sourceModule: 'quran',
        occurredAt: DateTime(2026, 3, 18, 10),
      ),
    );

    final summary = repository.getXpSummary();

    expect(summary.totalXp, 15);
    expect(summary.todayXp, 15);
    expect(summary.currentLevel, 1);
    expect(summary.xpRemainingToNextLevel, 20);
    expect(summary.progressPercent, closeTo(15 / 35, 0.0001));
  });

  test('duplicate prevention blocks same sourceRef and event type', () {
    final database = AppDatabase.inMemory();
    addTearDown(database.close);
    final repository = JourneyXpRepository(database: database, scopeId: 'test');
    final service = JourneyXpService(repository);

    final first = service.awardLearningXp(
      context: XpContext(
        sourceRef: 'lesson:repeatable',
        sourceModule: 'learn',
        occurredAt: DateTime(2026, 3, 18, 9),
      ),
    );
    final second = service.awardLearningXp(
      context: XpContext(
        sourceRef: 'lesson:repeatable',
        sourceModule: 'learn',
        occurredAt: DateTime(2026, 3, 18, 10),
      ),
    );

    expect(first, hasLength(1));
    expect(second, isEmpty);
    expect(repository.getXpSummary().totalXp, 10);
  });

  test('all-five-prayers bonus awards once per day', () {
    final database = AppDatabase.inMemory();
    addTearDown(database.close);
    final repository = JourneyXpRepository(database: database, scopeId: 'test');
    final service = JourneyXpService(repository);

    final first = service.awardPrayerXp(
      prayerId: 'isha',
      context: XpContext(
        sourceRef: 'prayer:2026-03-18:isha',
        sourceModule: 'prayer',
        occurredAt: DateTime(2026, 3, 18, 21),
        eventDateKey: '2026-03-18',
      ),
      allFiveCompleted: true,
    );
    final second = service.awardPrayerXp(
      prayerId: 'maghrib',
      context: XpContext(
        sourceRef: 'prayer:2026-03-18:maghrib-retry',
        sourceModule: 'prayer',
        occurredAt: DateTime(2026, 3, 18, 21, 5),
        eventDateKey: '2026-03-18',
      ),
      allFiveCompleted: true,
    );

    expect(
      first.where(
        (entry) => entry.eventType == XpEventType.allFivePrayersBonus,
      ),
      hasLength(1),
    );
    expect(
      second.where(
        (entry) => entry.eventType == XpEventType.allFivePrayersBonus,
      ),
      isEmpty,
    );
  });

  test('jumuah bonus awards once per Friday', () {
    final database = AppDatabase.inMemory();
    addTearDown(database.close);
    final repository = JourneyXpRepository(database: database, scopeId: 'test');
    final service = JourneyXpService(repository);

    final first = service.awardPrayerXp(
      prayerId: 'dhuhr',
      context: XpContext(
        sourceRef: 'prayer:2026-03-20:dhuhr',
        sourceModule: 'prayer',
        occurredAt: DateTime(2026, 3, 20, 13),
        eventDateKey: '2026-03-20',
      ),
      isJumuah: true,
    );
    final second = service.awardPrayerXp(
      prayerId: 'dhuhr',
      context: XpContext(
        sourceRef: 'prayer:2026-03-20:dhuhr:again',
        sourceModule: 'prayer',
        occurredAt: DateTime(2026, 3, 20, 13, 15),
        eventDateKey: '2026-03-20',
      ),
      isJumuah: true,
    );

    expect(
      first.where((entry) => entry.eventType == XpEventType.jumuahBonus),
      hasLength(1),
    );
    expect(
      second.where((entry) => entry.eventType == XpEventType.jumuahBonus),
      isEmpty,
    );
  });

  test('laylat al-qadr multiplier applies to eligible worship entries', () {
    final database = AppDatabase.inMemory();
    addTearDown(database.close);
    final repository = JourneyXpRepository(database: database, scopeId: 'test');
    final service = JourneyXpService(
      repository,
      config: const JourneyXpRuleConfig(
        laylatAlQadrMultiplierEnabled: true,
        laylatAlQadrMultiplier: 5,
      ),
    );

    final entries = service.awardQiyamXp(
      context: XpContext(
        sourceRef: 'qiyam:night27',
        sourceModule: 'prayer',
        occurredAt: DateTime(2026, 3, 26, 2, 30),
        eventDateKey: '2026-03-26',
        eligibleForLaylatAlQadrMultiplier: true,
      ),
    );

    expect(entries, hasLength(2));
    expect(entries.first.awardedXp, 12);
    expect(entries.last.eventType, XpEventType.laylatAlQadrMultiplier);
    expect(entries.last.awardedXp, 48);
    expect(repository.getXpSummary().totalXp, 60);
  });

  test('controller exposes card-friendly summary state', () async {
    final container = await makeTestContainer();
    addTearDown(container.dispose);

    final controller = container.read(journeyXpSummaryProvider.notifier);
    controller.awardPrayerXp(
      prayerId: 'fajr',
      occurredAt: DateTime(2026, 3, 18, 5, 15),
      sourceRef: 'prayer:2026-03-18:fajr',
      dayKey: '2026-03-18',
    );

    final summary = container.read(journeyXpSummaryProvider);
    expect(summary.totalXp, 12);
    expect(summary.todayXp, 12);
    expect(summary.currentLevelTitle, 'Niyyah');
  });
}
