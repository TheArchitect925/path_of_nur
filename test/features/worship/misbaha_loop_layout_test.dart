import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/worship/presentation/dhikr/widgets/misbaha_ring.dart';

void main() {
  group('MisbahaLoopLayout', () {
    test('a 33 target is one full string', () {
      final layout = MisbahaLoopLayout.resolve(count: 12, target: 33);
      expect(layout.beadsPerLoop, 33);
      expect(layout.loops, 1);
      expect(layout.loopIndex, 0);
      expect(layout.filledBeads, 12);
      expect(layout.activeBeads, 33);
      expect(layout.hasLoops, isFalse);
    });

    test('99 runs three loops and starts each one empty', () {
      expect(MisbahaLoopLayout.resolve(count: 33, target: 99).loopIndex, 1);
      expect(MisbahaLoopLayout.resolve(count: 33, target: 99).filledBeads, 0);
      final last = MisbahaLoopLayout.resolve(count: 99, target: 99);
      expect(last.loopIndex, 2);
      expect(last.filledBeads, 33);
    });

    test('100 leaves a one-bead final loop', () {
      final layout = MisbahaLoopLayout.resolve(count: 100, target: 100);
      expect(layout.loops, 4);
      expect(layout.loopIndex, 3);
      expect(layout.activeBeads, 1);
      expect(layout.filledBeads, 1);
    });

    test('small targets use one bead per count', () {
      final layout = MisbahaLoopLayout.resolve(count: 2, target: 7);
      expect(layout.beadsPerLoop, 7);
      expect(layout.filledBeads, 2);
    });

    test('over-count and bad targets stay sane', () {
      final over = MisbahaLoopLayout.resolve(count: 500, target: 33);
      expect(over.filledBeads, 33);
      final bad = MisbahaLoopLayout.resolve(count: 3, target: 0);
      expect(bad.beadsPerLoop, 33);
      expect(bad.filledBeads, 3);
    });
  });
}
