import 'package:flutter_test/flutter_test.dart';

import 'package:path_of_nur/features/learn/salah/models/salah_trainer_models.dart';

void main() {
  const arabic = 'سُبْحَانَ رَبِّيَ الْعَظِيمِ';

  test('estimate spreads the real duration across every word', () {
    final timing = RecitationTimingModel.estimate(
      idPrefix: 'ruku',
      arabic: arabic,
      transliteration: 'Subhana rabbiyal azim.',
      translation: 'Glory is to my Lord, the Magnificent.',
      totalDurationMs: 2350,
    );

    expect(timing.wordTimings, hasLength(3));
    expect(timing.totalDurationMs, 2350);
    expect(timing.wordTimings.first.startMs, 0);
    expect(timing.wordTimings.last.endMs, 2350);
    for (var i = 1; i < timing.wordTimings.length; i += 1) {
      expect(
        timing.wordTimings[i].startMs,
        timing.wordTimings[i - 1].endMs,
        reason: 'words tile the clip without gaps',
      );
      expect(
        timing.wordTimings[i].endMs,
        greaterThan(timing.wordTimings[i].startMs),
      );
    }
    expect(timing.wordTimings[1].transliteration, 'rabbiyal');
  });

  test('activeWordAt follows the playhead and pins to the last word', () {
    final timing = RecitationTimingModel.estimate(
      idPrefix: 'ruku',
      arabic: arabic,
      transliteration: '',
      translation: '',
      totalDurationMs: 3000,
    );

    expect(timing.activeWordAt(0), 0);
    expect(timing.activeWordAt(timing.wordTimings[1].startMs), 1);
    expect(timing.activeWordAt(2999), 2);
    expect(timing.activeWordAt(99999), 2);
    expect(RecitationTimingModel.empty.activeWordAt(10), -1);
  });

  test('empty text or zero duration produces an empty timing', () {
    expect(
      RecitationTimingModel.estimate(
        idPrefix: 'x',
        arabic: '   ',
        transliteration: '',
        translation: '',
        totalDurationMs: 1000,
      ).isEmpty,
      isTrue,
    );
    expect(
      RecitationTimingModel.estimate(
        idPrefix: 'x',
        arabic: arabic,
        transliteration: '',
        translation: '',
        totalDurationMs: 0,
      ).isEmpty,
      isTrue,
    );
  });

  test('spoken estimate grows with word count and slows on request', () {
    final normal = RecitationTimingModel.estimateSpokenMs(arabic);
    final slow = RecitationTimingModel.estimateSpokenMs(arabic, slow: true);
    expect(normal, 900 + 3 * 300);
    expect(slow, greaterThan(normal));
  });
}
