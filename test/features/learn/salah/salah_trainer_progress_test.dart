import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:path_of_nur/features/journey/application/journey_progression_provider.dart';
import 'package:path_of_nur/features/learn/salah/application/salah_guided_settings_provider.dart';
import 'package:path_of_nur/features/learn/salah/application/salah_trainer_provider.dart';
import 'package:path_of_nur/features/learn/salah/data/salah_trainer_data.dart';
import 'package:path_of_nur/features/learn/salah/models/salah_trainer_models.dart';
import 'package:path_of_nur/features/worship/domain/fasting_status.dart';
import 'package:path_of_nur/shared/persistence/local_store.dart';

import '../../../test_helpers/app_test_harness.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Override journeySnapshotOverride() {
    return journeyActivitySnapshotProvider.overrideWith(
      (ref) => JourneyActivitySnapshot(
        now: DateTime(2026, 9, 4, 12),
        prayerCompletedToday: 0,
        prayerMissedToday: 0,
        fajrCompletedToday: false,
        prayerProgress: 0,
        dhikrSessionsToday: 0,
        dhikrCountToday: 0,
        dhikrProgress: 0,
        fastingStatus: FastingStatus.notFasting,
        quranEngagementsToday: 0,
        quranProgress: 0,
        reflectionEntriesToday: 0,
        reflectionProgress: 0,
        learningStageCompletionsToday: 0,
        streakExemptionActive: false,
      ),
    );
  }

  Future<ProviderContainer> container({
    Map<String, Object> seed = const {},
  }) async {
    final c = await makeTestContainer(
      seed: seed,
      overrides: <Override>[journeySnapshotOverride()],
    );
    addTearDown(c.dispose);
    return c;
  }

  test('a guided session survives reopening the app', () async {
    final first = await container();
    final notifier = first.read(salahTrainerProgressProvider.notifier);

    notifier.saveGuidedSession(
      prayerId: SalahPrayerId.isha,
      surahId: 'al_falaq',
      stepIndex: 12,
      totalSteps: 40,
    );

    final persisted = first
        .read(localStoreProvider)
        .dumpAll()
        .map((key, value) => MapEntry(key, value as Object));
    final reopened = await container(seed: persisted);

    final session = reopened
        .read(salahTrainerProgressProvider)
        .sessionFor(SalahPrayerId.isha);
    expect(session, isNotNull);
    expect(session!.stepIndex, 12);
    expect(session.totalSteps, 40);
    expect(session.surahId, 'al_falaq');
    expect(session.hasProgress, isTrue);
  });

  test('completing a prayer clears its session', () async {
    final c = await container();
    final notifier = c.read(salahTrainerProgressProvider.notifier);
    notifier.saveGuidedSession(
      prayerId: SalahPrayerId.fajr,
      surahId: 'an_nas',
      stepIndex: 3,
      totalSteps: 20,
    );

    notifier.completePrayer(SalahPrayerId.fajr);

    final state = c.read(salahTrainerProgressProvider);
    expect(state.completedPrayerIds, contains('fajr'));
    expect(state.sessionFor(SalahPrayerId.fajr), isNull);
  });

  test('the surah pool grows by one for every surah practiced', () async {
    final c = await container();
    final notifier = c.read(salahTrainerProgressProvider.notifier);

    expect(c.read(salahUnlockedSurahIdsProvider), initialUnlockedSurahIds);

    notifier.setSurahProgress('al_ikhlas', SalahSurahProgress.learning);
    expect(c.read(salahUnlockedSurahIdsProvider), hasLength(3));

    notifier.setSurahProgress('al_ikhlas', SalahSurahProgress.practiced);
    expect(c.read(salahUnlockedSurahIdsProvider), hasLength(4));

    notifier.setSurahProgress('an_nas', SalahSurahProgress.memorized);
    final unlocked = c.read(salahUnlockedSurahIdsProvider);
    expect(unlocked, hasLength(5));
    expect(unlocked, isNot(contains('al_fatihah')));
    expect(
      unlocked,
      salahUnlockedSurahIdsFor(c.read(salahTrainerProgressProvider)),
      reason: 'the provider and the notifier share one rule',
    );
  });

  test(
    'chooseGuidedSurahId honours a resumable session, then the fixed pick',
    () async {
      final c = await container();
      final notifier = c.read(salahTrainerProgressProvider.notifier);

      notifier.setGuidedSurahMode(GuidedSurahMode.fixed);
      notifier.setFixedSurah('al_falaq');
      expect(
        notifier.chooseGuidedSurahId(prayerId: SalahPrayerId.asr),
        'al_falaq',
      );

      notifier.saveGuidedSession(
        prayerId: SalahPrayerId.asr,
        surahId: 'an_nas',
        stepIndex: 4,
        totalSteps: 30,
      );
      expect(
        notifier.chooseGuidedSurahId(prayerId: SalahPrayerId.asr),
        'an_nas',
        reason: 'resuming keeps the surah the session was built on',
      );
      expect(
        notifier.chooseGuidedSurahId(
          prayerId: SalahPrayerId.asr,
          preferSession: false,
        ),
        'al_falaq',
      );

      notifier.setFixedSurah('al_fil');
      expect(
        notifier.chooseGuidedSurahId(prayerId: SalahPrayerId.maghrib, seed: 7),
        isIn(initialUnlockedSurahIds),
        reason: 'a locked fixed surah falls back to a random unlocked one',
      );
    },
  );

  test('guided settings persist and reject unknown repeat counts', () async {
    final first = await container();
    final settings = first.read(salahGuidedSettingsProvider.notifier);

    settings.setPace(SalahTrainerPace.unhurried);
    settings.setTasbihRepeats(5);
    settings.setTasbihRepeats(4);
    settings.setShowTranslation(false);
    settings.setFocusMode(true);

    final persisted = first
        .read(localStoreProvider)
        .dumpAll()
        .map((key, value) => MapEntry(key, value as Object));
    final reopened = await container(seed: persisted);
    final state = reopened.read(salahGuidedSettingsProvider);

    expect(state.pace, SalahTrainerPace.unhurried);
    expect(state.tasbihRepeats, 5);
    expect(state.showTranslation, isFalse);
    expect(state.focusMode, isTrue);
  });
}
