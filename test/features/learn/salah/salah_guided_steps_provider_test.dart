import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:path_of_nur/core/prayer/prayer_preferences.dart';
import 'package:path_of_nur/features/learn/salah/application/salah_trainer_provider.dart';
import 'package:path_of_nur/features/learn/salah/data/salah_trainer_data.dart';
import 'package:path_of_nur/features/learn/salah/models/salah_trainer_models.dart';
import 'package:path_of_nur/l10n/app_localizations_en.dart';

void main() {
  /// English content without a locale store behind it.
  ProviderContainer makeContainer({
    PrayerMadhab madhhab = PrayerMadhab.hanafi,
  }) {
    final container = ProviderContainer(
      overrides: [
        salahTrainerContentProvider.overrideWithValue(
          buildSalahTrainerContent(AppLocalizationsEn()),
        ),
        salahTrainerMadhhabProvider.overrideWithValue(madhhab),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  List<GuidedPrayerStep> stepsFor(
    ProviderContainer container,
    SalahPrayerId prayerId, {
    String surahId = 'al_ikhlas',
  }) {
    return container.read(
      salahGuidedStepsProvider((prayerId: prayerId, surahId: surahId)),
    );
  }

  test('al-Fatihah recites its seven ayahs from the bundled Husary clips', () {
    final container = makeContainer();

    final steps = stepsFor(container, SalahPrayerId.fajr);
    final fatihah = steps.firstWhere(
      (item) => item.step.kind == SalahRecitationKind.fatihah,
    );

    expect(fatihah.surahId, 'al_fatihah');
    expect(fatihah.step.segments, hasLength(7));
    expect(fatihah.step.isSilent, isFalse);
    expect(
      fatihah.step.segments.first.audioAssetPath,
      'assets/audio/salah/husary/001001.mp3',
    );
    expect(fatihah.step.segments.last.ayahNumber, 7);
  });

  test('the chosen short surah fills the additional-surah step', () {
    final container = makeContainer();

    final steps = stepsFor(container, SalahPrayerId.fajr, surahId: 'al_ikhlas');
    final extra = steps
        .where((item) => item.step.kind == SalahRecitationKind.additionalSurah)
        .toList();

    expect(extra, hasLength(2), reason: 'both Fajr rakahs carry a surah');
    expect(extra.first.surahId, 'al_ikhlas');
    expect(extra.first.step.segments, hasLength(4));
    expect(
      extra.first.step.segments.first.audioAssetPath,
      'assets/audio/salah/husary/112001.mp3',
    );
    expect(extra.first.step.isSilent, isFalse);
  });

  test('an unknown surah leaves the placeholder silent', () {
    final container = makeContainer();

    final steps = stepsFor(container, SalahPrayerId.fajr, surahId: 'nope');
    final extra = steps.firstWhere(
      (item) => item.step.kind == SalahRecitationKind.additionalSurah,
    );

    expect(extra.surahId, isNull);
    expect(extra.step.isSilent, isTrue);
  });

  test('tasbih steps repeat three times and are entered with a takbir', () {
    final container = makeContainer();

    final steps = stepsFor(container, SalahPrayerId.fajr);
    final ruku = steps.firstWhere((item) => item.step.id == 'ruku');
    final sujud = steps.firstWhere((item) => item.step.id == 'first_sujud');
    final qawmah = steps.firstWhere(
      (item) => item.step.id == 'standing_after_ruku',
    );

    expect(ruku.step.repeatCount, 3);
    expect(ruku.step.entryTakbir, isTrue);
    expect(sujud.step.repeatCount, 3);
    expect(sujud.step.entryTakbir, isTrue);
    expect(
      sujud.step.segments.single.audioAssetPath,
      salahAdhkarAssetPath('sujud'),
    );
    expect(qawmah.step.entryTakbir, isFalse);
    expect(qawmah.step.repeatCount, 1);
  });

  test('later rakahs rise with a plain takbir and skip the extra surah', () {
    final container = makeContainer();

    final steps = stepsFor(container, SalahPrayerId.dhuhr);
    final rakahThree = steps.where((item) => item.rakahNumber == 3).toList();

    expect(rakahThree.first.step.id, 'takbir_rising');
    expect(
      rakahThree.any(
        (item) => item.step.kind == SalahRecitationKind.additionalSurah,
      ),
      isFalse,
    );
    expect(
      steps.where((item) => item.step.id == 'takbir_al_ihram'),
      hasLength(1),
      reason: 'the opening takbir happens once',
    );
  });

  test('Witr keeps qunut before ruku in its final rakah', () {
    final container = makeContainer();

    final steps = stepsFor(container, SalahPrayerId.witr);
    final ids = steps
        .where((item) => item.rakahNumber == 3)
        .map((item) => item.step.id)
        .toList();

    expect(ids.indexOf('qunut'), greaterThan(-1));
    expect(ids.indexOf('qunut'), lessThan(ids.indexOf('ruku')));
    expect(ids.last, 'taslim_left');
  });

  test('every adhkar slot is a declared recording id', () {
    for (final prayer in buildSalahTrainerContent(
      AppLocalizationsEn(),
    ).prayers) {
      for (final rakah in prayer.guidedRakahs) {
        for (final step in rakah.steps) {
          if (step.isSilent || step.surahId != null) continue;
          final path = step.segments.single.audioAssetPath;
          expect(path, isNotNull, reason: '${step.id} needs an audio slot');
          final id = path!.split('/').last.replaceAll('.mp3', '');
          expect(
            salahAdhkarAudioIds,
            contains(id),
            reason: '${step.id} points at an undeclared clip $id',
          );
        }
      }
    }
  });

  group('madhhab', () {
    List<String> fajrRakahTwo(ProviderContainer container) =>
        stepsFor(container, SalahPrayerId.fajr)
            .where((item) => item.rakahNumber == 2)
            .map((item) => item.step.id)
            .toList();

    test(
      'Shafi\'i Fajr recites qunut after rising from ruku, opens with Wajjahtu',
      () {
        final container = makeContainer(madhhab: PrayerMadhab.shafii);
        final ids = fajrRakahTwo(container);

        expect(
          ids.indexOf('qunut_fajr'),
          ids.indexOf('standing_after_ruku') + 1,
        );
        final opening = stepsFor(
          container,
          SalahPrayerId.fajr,
        ).firstWhere((item) => item.step.id == 'opening_supplication');
        expect(opening.step.segments.single.id, 'opening_wajjahtu');
        expect(
          opening.step.segments.single.audioAssetPath,
          salahAdhkarAssetPath('opening_wajjahtu'),
        );
        expect(ids.last, 'taslim_left');
      },
    );

    test(
      'Maliki Fajr puts qunut before ruku, skips the opening dua and the second salam',
      () {
        final container = makeContainer(madhhab: PrayerMadhab.maliki);
        final ids = fajrRakahTwo(container);

        expect(ids.indexOf('qunut_fajr'), ids.indexOf('ruku') - 1);
        expect(ids, isNot(contains('taslim_left')));
        expect(ids.last, 'taslim_right');
        final all = stepsFor(
          container,
          SalahPrayerId.fajr,
        ).map((item) => item.step.id);
        expect(all, isNot(contains('opening_supplication')));
        final qunut = stepsFor(
          container,
          SalahPrayerId.fajr,
        ).firstWhere((item) => item.step.id == 'qunut_fajr');
        expect(qunut.step.isOptional, isTrue);
        expect(qunut.step.madhhabNotes[PrayerMadhab.maliki], isNotNull);
      },
    );

    test('Hanafi and Hanbali Fajr have no qunut and keep Subhanaka', () {
      for (final madhhab in [PrayerMadhab.hanafi, PrayerMadhab.hanbali]) {
        final container = makeContainer(madhhab: madhhab);
        final ids = fajrRakahTwo(container);
        expect(ids, isNot(contains('qunut_fajr')), reason: madhhab.name);
        final opening = stepsFor(
          container,
          SalahPrayerId.fajr,
        ).firstWhere((item) => item.step.id == 'opening_supplication');
        expect(opening.step.segments.single.id, 'opening_supplication');
      }
    });

    test('qunut is only added to Fajr', () {
      final container = makeContainer(madhhab: PrayerMadhab.shafii);
      for (final prayer in [
        SalahPrayerId.dhuhr,
        SalahPrayerId.asr,
        SalahPrayerId.isha,
      ]) {
        expect(
          stepsFor(container, prayer).map((item) => item.step.id),
          isNot(contains('qunut_fajr')),
          reason: prayer.name,
        );
      }
    });

    test('every step note is written for the school it is shown to', () {
      final content = buildSalahTrainerContent(AppLocalizationsEn());
      final noted = <String>{};
      for (final prayer in content.prayers) {
        for (final rakah in prayer.guidedRakahs) {
          for (final step in rakah.steps) {
            if (step.madhhabNotes.isNotEmpty) {
              noted.add(step.id);
              expect(
                step.madhhabNotes.keys,
                PrayerMadhab.values.toSet(),
                reason: '${step.id} notes every school',
              );
            }
          }
        }
      }
      expect(
        noted,
        containsAll(['takbir_al_ihram', 'ruku', 'tashahhud', 'taslim_right']),
      );
    });
  });
}
