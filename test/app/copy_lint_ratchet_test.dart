import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// V0 of the voice and copy work (2026-09-07): a ratchet, not a cleanup.
///
/// `tools/copy_lint.py` counts, per rule, how many English strings break
/// `docs/voice_and_copy_guide.md`. `tools/copy_lint_baseline.json` holds the
/// counts as they stood when a slice last landed. This test fails in two
/// directions, like the header conformance allow-lists:
///
///  * a count above its baseline is new drift — fix the string;
///  * a count below its baseline is a real improvement that must be locked —
///    run `python3 tools/copy_lint.py --write-baseline` and commit the file.
///
/// The baseline can therefore only ever go down, and the later phases
/// (mechanics, chrome by exposure, prose, native surfaces) can land over
/// several sessions without anyone reintroducing "a calm space for…".
void main() {
  test('English copy stays on the copy-lint baseline', () async {
    final baselineFile = File('tools/copy_lint_baseline.json');
    expect(
      baselineFile.existsSync(),
      isTrue,
      reason: 'Run: python3 tools/copy_lint.py --write-baseline',
    );
    final baseline =
        ((jsonDecode(baselineFile.readAsStringSync())
                    as Map<String, dynamic>)['counts']
                as Map<String, dynamic>)
            .map((k, v) => MapEntry(k, v as int));

    final result = await Process.run('python3', [
      'tools/copy_lint.py',
      '--json',
    ]);
    expect(
      result.exitCode,
      0,
      reason: 'copy_lint.py failed:\n${result.stderr}',
    );
    final actual =
        ((jsonDecode(result.stdout as String) as Map<String, dynamic>)['counts']
                as Map<String, dynamic>)
            .map((k, v) => MapEntry(k, v as int));

    final regressions = <String>[];
    final improvements = <String>[];
    for (final rule in {...baseline.keys, ...actual.keys}) {
      final now = actual[rule] ?? 0;
      final base = baseline[rule] ?? 0;
      if (now > base) {
        regressions.add(
          '$rule: $now (baseline $base) — python3 tools/copy_lint.py --list $rule',
        );
      } else if (now < base) {
        improvements.add('$rule: $now (baseline $base)');
      }
    }

    expect(
      regressions..sort(),
      isEmpty,
      reason:
          'New copy breaks the voice guide (docs/voice_and_copy_guide.md). '
          'Rewrite the string rather than raising the baseline.',
    );
    expect(
      improvements..sort(),
      isEmpty,
      reason:
          'Copy improved; lock it in with '
          '`python3 tools/copy_lint.py --write-baseline` and commit the baseline.',
    );
  }, timeout: const Timeout(Duration(minutes: 3)));
}
