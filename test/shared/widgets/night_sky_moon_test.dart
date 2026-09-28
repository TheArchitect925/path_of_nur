import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/shared/widgets/moon_phase_visual.dart';
import 'package:path_of_nur/shared/widgets/night_sky.dart';

/// A full moon used to paint as a flat pale disc, which reads as a dot
/// rather than a moon. The lit face now carries maria.
void main() {
  /// Picks a date whose moon is essentially full, so the lit face is a disc.
  DateTime fullMoonDate() {
    var best = DateTime(2026, 1, 1);
    var bestLit = 0.0;
    for (var day = 0; day < 60; day++) {
      final candidate = DateTime(2026, 8, 1).add(Duration(days: day));
      final lit = moonIlluminatedFraction(candidate);
      if (lit > bestLit) {
        bestLit = lit;
        best = candidate;
      }
    }
    expect(bestLit, greaterThan(0.98), reason: 'need a full moon to test');
    return best;
  }

  Future<List<int>> paintedMoonTones(DateTime now) async {
    const size = Size(400, 400);
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder, const Rect.fromLTWH(0, 0, 400, 400));
    MidnightSkyPainter(
      now: now,
      moonFraction: const Offset(0.5, 0.5),
    ).paint(canvas, size);
    final image = await recorder.endRecording().toImage(400, 400);
    final data = await image.toByteData();
    final tones = <int>{};
    // Sample only well inside the disc (radius is 0.052 * 400 ~= 20.8px at
    // this size), so the blurred outer glow cannot supply the variation.
    for (var x = 188; x < 212; x++) {
      final offset = ((200 * 400) + x) * 4;
      final r = data!.getUint8(offset);
      final g = data.getUint8(offset + 1);
      final b = data.getUint8(offset + 2);
      tones.add((r << 16) | (g << 8) | b);
    }
    return tones.toList();
  }

  testWidgets('a full moon face is shaded, not one flat disc', (tester) async {
    await tester.runAsync(() async {
      final tones = await paintedMoonTones(fullMoonDate());
      // A flat disc yields a single colour across the moon plus the sky
      // either side; the maria push this well past that.
      expect(
        tones.length,
        greaterThan(4),
        reason: 'the lit face should carry more than one tone',
      );
    });
  });
}
