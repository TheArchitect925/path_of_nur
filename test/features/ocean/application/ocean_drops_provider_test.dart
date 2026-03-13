import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/ocean/application/community_ocean.dart';
import 'package:path_of_nur/features/ocean/application/ocean_drops_provider.dart';
import 'package:path_of_nur/shared/persistence/local_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  Future<OceanDropService> createService() async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final prefs = await SharedPreferences.getInstance();
    return OceanDropService(LocalStore(prefs));
  }

  test('awards prayer drops once per prayer slot per day', () async {
    final service = await createService();

    final first = service.awardDrop(
      actionType: oceanActionPrayerCompleted,
      sourceModule: oceanSourcePrayer,
      referenceId: 'fajr',
      metadata: {'timestamp': '2026-03-12T05:30:00.000'},
    );
    final second = service.awardDrop(
      actionType: oceanActionPrayerCompleted,
      sourceModule: oceanSourcePrayer,
      referenceId: 'fajr',
      metadata: {'timestamp': '2026-03-12T06:15:00.000'},
    );
    final nextDay = service.awardDrop(
      actionType: oceanActionPrayerCompleted,
      sourceModule: oceanSourcePrayer,
      referenceId: 'fajr',
      metadata: {'timestamp': '2026-03-13T05:30:00.000'},
    );

    expect(first, 1);
    expect(second, 0);
    expect(nextDay, 1);
    expect(service.getTotalDrops(), 2);
  });

  test('awards lesson completion only once for the same reference', () async {
    final service = await createService();

    expect(
      service.awardDrop(
        actionType: oceanActionLessonCompleted,
        sourceModule: oceanSourceLearn,
        referenceId: 'life:intention-001',
      ),
      1,
    );
    expect(
      service.awardDrop(
        actionType: oceanActionLessonCompleted,
        sourceModule: oceanSourceLearn,
        referenceId: 'life:intention-001',
      ),
      0,
    );
    expect(service.getTotalDrops(), 1);
  });

  test('free dhikr carry awards one drop per hundred counts', () async {
    final service = await createService();

    expect(
      service.awardDrop(
        actionType: oceanActionDhikrFreeHundredReached,
        sourceModule: oceanSourceDhikr,
        referenceId: 'free_dhikr',
        metadata: {'countDelta': 50},
      ),
      0,
    );
    expect(service.state.freeDhikrCarryCount, 50);

    expect(
      service.awardDrop(
        actionType: oceanActionDhikrFreeHundredReached,
        sourceModule: oceanSourceDhikr,
        referenceId: 'free_dhikr',
        metadata: {'countDelta': 150},
      ),
      2,
    );
    expect(service.state.freeDhikrCarryCount, 0);
    expect(service.getTotalDrops(), 2);
  });

  test('awarded drops feed personal and community totals together', () async {
    final service = await createService();

    service.awardDrop(
      actionType: oceanActionPrayerCompleted,
      sourceModule: oceanSourcePrayer,
      referenceId: 'dhuhr',
      metadata: {'timestamp': '2026-03-12T13:15:00.000'},
    );

    expect(service.getPersonalWaterStats().totalPersonalDrops, BigInt.one);
    expect(
      service.getCommunityOceanStats().totalCommunityDrops,
      BigInt.from(500001),
    );
  });

  test('community and personal stage helpers use the configured thresholds', () {
    final communityStage = CommunityOceanLogic.getCommunityStageProgress(
      BigInt.from(2000000),
    );
    final personalStage = CommunityOceanLogic.getPersonalStageProgress(
      BigInt.from(1500),
    );

    expect(communityStage.currentStage.title, 'Spring');
    expect(communityStage.nextStage?.title, 'Stream');
    expect(personalStage.currentStage.title, 'Brook');
    expect(personalStage.nextStage?.title, 'Pond');
  });

  test('water equivalents format into human friendly units', () {
    final milliliters = CommunityOceanLogic.convertDropsToReadableWater(
      BigInt.from(5420),
    );
    final liters = CommunityOceanLogic.convertDropsToReadableWater(
      BigInt.from(20000),
    );

    expect(milliliters.fullLabel, '271 mL');
    expect(liters.fullLabel, '1 liters');
    expect(
      CommunityOceanLogic.formatLargeDropCount(
        BigInt.parse('1200000000'),
      ),
      '1.2B',
    );
  });
}
