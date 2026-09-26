import 'package:flutter_test/flutter_test.dart';

import '../../tools/motion_ratchet.dart';

/// The motion ratchet (2026-09-26): a spinner or a fade over glass can only
/// ever leave the app, never come back. `tools/motion_ratchet.dart` counts
/// the patterns; `tools/motion_ratchet_baseline.json` holds the counts as
/// they stood when a slice last landed. Like the copy-lint ratchet this
/// fails in both directions:
///
///  * a count above its baseline is new drift — use the motion primitives
///    (`SkeletonCard`, `SettleIn`, `InkReveal`) instead;
///  * a count below its baseline is an improvement to lock — run
///    `dart run tools/motion_ratchet.dart --write-baseline` and commit it.
void main() {
  test('motion patterns stay on the ratchet baseline', () {
    final baseline = readMotionBaseline();
    expect(
      baseline,
      isNotEmpty,
      reason: 'Run: dart run tools/motion_ratchet.dart --write-baseline',
    );
    final actual = countMotionPatterns();
    final regressions = <String>[];
    final improvements = <String>[];
    for (final rule in {...baseline.keys, ...actual.keys}) {
      final now = actual[rule] ?? 0;
      final base = baseline[rule] ?? 0;
      if (now > base) {
        regressions.add('$rule: $now (baseline $base)');
      } else if (now < base) {
        improvements.add('$rule: $now (baseline $base)');
      }
    }
    expect(
      regressions..sort(),
      isEmpty,
      reason:
          'New motion breaks the vocabulary (lib/core/theme/app_motion.dart). '
          'A spinner becomes a SkeletonCard; a fade on glass becomes a '
          'SettleIn with the content in SettleFade.',
    );
    expect(
      improvements..sort(),
      isEmpty,
      reason:
          'Motion improved; lock it in with '
          '`dart run tools/motion_ratchet.dart --write-baseline` and commit the '
          'baseline.',
    );
  });
}
