import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// The Apple TV app calculates prayer times with a Swift port of the `adhan`
/// package, and `scripts/verify_tv_prayer_times.sh` holds that port to
/// `tools/tv_prayer_reference.json`, to the minute.
///
/// This test holds the reference itself to the package the phone uses today.
/// If `adhan` is upgraded and answers differently, it fails here first:
/// regenerate with `TZ=UTC dart run tools/tv_prayer_reference.dart --write`,
/// then bring the Swift port back into agreement.
void main() {
  test('the Apple TV prayer reference is what the phone library answers', () {
    final result = Process.runSync(
      'dart',
      ['run', 'tools/tv_prayer_reference.dart'],
      environment: {'TZ': 'UTC'},
    );
    expect(result.exitCode, 0, reason: '${result.stderr}');
    expect(
      result.stdout as String,
      File('tools/tv_prayer_reference.json').readAsStringSync(),
      reason:
          'Run: TZ=UTC dart run tools/tv_prayer_reference.dart --write, '
          'then bash scripts/verify_tv_prayer_times.sh',
    );
  }, timeout: const Timeout(Duration(minutes: 3)));
}
