import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/shared/widgets/moon_phase_visual.dart';

void main() {
  group('moonAgeDays', () {
    test('is dark at the reference new moon epoch', () {
      // The function normalizes to local midnight, so allow up to a day of
      // timezone skew — irrelevant at phase-display precision.
      expect(moonIlluminatedFraction(DateTime.utc(2000, 1, 6)), lessThan(0.05));
    });

    test('is near full one half synodic month after the epoch', () {
      final nearFull = DateTime.utc(2000, 1, 21);
      expect(moonAgeDays(nearFull), closeTo(lunarSynodicMonthDays / 2, 1.2));
      expect(moonIlluminatedFraction(nearFull), greaterThan(0.9));
    });

    test('wraps back to new moon after a whole synodic month', () {
      final nextNew = DateTime.utc(2000, 2, 5);
      expect(moonIlluminatedFraction(nextNew), lessThan(0.05));
    });

    test('always stays within one synodic month', () {
      for (final date in [
        DateTime(1999, 7, 4),
        DateTime(2026, 8, 28),
        DateTime(2031, 12, 31),
      ]) {
        final age = moonAgeDays(date);
        expect(age, greaterThanOrEqualTo(0));
        expect(age, lessThan(lunarSynodicMonthDays));
        final fraction = moonIlluminatedFraction(date);
        expect(fraction, inInclusiveRange(0, 1));
      }
    });
  });
}
