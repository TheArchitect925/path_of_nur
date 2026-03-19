import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/worship/application/dhikr_anti_rush_detector.dart';

void main() {
  group('DhikrAntiRushDetector', () {
    test('triggers only for clearly excessive rapid taps', () {
      final detector = DhikrAntiRushDetector();
      final start = DateTime(2026, 1, 1, 12);

      var triggered = false;
      for (var i = 0; i < 7; i += 1) {
        triggered = detector.registerTap(
          start.add(Duration(milliseconds: i * 200)),
        );
      }
      expect(triggered, isFalse);

      triggered = detector.registerTap(
        start.add(const Duration(milliseconds: 1400)),
      );
      expect(triggered, isTrue);
    });

    test('does not trigger for normal paced taps', () {
      final detector = DhikrAntiRushDetector();
      final start = DateTime(2026, 1, 1, 12);

      var triggered = false;
      for (var i = 0; i < 8; i += 1) {
        triggered = detector.registerTap(
          start.add(Duration(milliseconds: i * 400)),
        );
      }

      expect(triggered, isFalse);
    });

    test('respects cooldown before prompting again', () {
      final detector = DhikrAntiRushDetector();
      final start = DateTime(2026, 1, 1, 12);

      for (var i = 0; i < 8; i += 1) {
        detector.registerTap(start.add(Duration(milliseconds: i * 200)));
      }

      var triggered = false;
      final secondBurst = start.add(const Duration(seconds: 10));
      for (var i = 0; i < 8; i += 1) {
        triggered = detector.registerTap(
          secondBurst.add(Duration(milliseconds: i * 200)),
        );
      }
      expect(triggered, isFalse);

      final thirdBurst = start.add(const Duration(seconds: 50));
      for (var i = 0; i < 8; i += 1) {
        triggered = detector.registerTap(
          thirdBurst.add(Duration(milliseconds: i * 200)),
        );
      }
      expect(triggered, isTrue);
    });
  });
}
