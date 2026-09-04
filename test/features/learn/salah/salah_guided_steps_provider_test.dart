import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:path_of_nur/features/learn/salah/application/salah_trainer_provider.dart';
import 'package:path_of_nur/features/learn/salah/data/salah_trainer_data.dart';
import 'package:path_of_nur/features/learn/salah/models/salah_trainer_models.dart';

void main() {
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
    final container = ProviderContainer();
    addTearDown(container.dispose);

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
    final container = ProviderContainer();
    addTearDown(container.dispose);

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
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final steps = stepsFor(container, SalahPrayerId.fajr, surahId: 'nope');
    final extra = steps.firstWhere(
      (item) => item.step.kind == SalahRecitationKind.additionalSurah,
    );

    expect(extra.surahId, isNull);
    expect(extra.step.isSilent, isTrue);
  });

  test('tasbih steps repeat three times and are entered with a takbir', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

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
    final container = ProviderContainer();
    addTearDown(container.dispose);

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
    final container = ProviderContainer();
    addTearDown(container.dispose);

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
    for (final prayer in salahPrayers) {
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
}
