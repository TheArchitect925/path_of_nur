import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// The Apple TV app looks its strings up by their English text, outside the
/// ARB and its lint. `tools/tv_strings.py` is the same discipline for the
/// television: the tables stay in step with the Swift, and the copy follows
/// `docs/voice_and_copy_guide.md`.
///
/// Five sections are in the rail. Their copy is held to the guide outright
/// and must be translated in every shipped language. The six sections still
/// held back are counted, and the count can only fall: lock a fall with
/// `python3 tools/tv_strings.py --lint` and `tools/tv_strings_baseline.json`.
void main() {
  test('Apple TV string tables match the Swift that uses them', () async {
    final result = await Process.run('python3', ['tools/tv_strings.py']);
    expect(
      result.exitCode,
      0,
      reason:
          'Run: python3 tools/tv_strings.py --write\n'
          '${result.stdout}\n${result.stderr}',
    );
  });

  test('Apple TV copy on screen follows the voice guide', () async {
    final result = await Process.run('python3', [
      'tools/tv_strings.py',
      '--lint',
    ]);
    expect(result.exitCode, 0, reason: '${result.stderr}');
    final report = jsonDecode(result.stdout as String) as Map<String, dynamic>;

    final released = (report['released'] as Map<String, dynamic>).map(
      (rule, keys) => MapEntry(rule, (keys as List).cast<String>()),
    );
    for (final entry in released.entries) {
      expect(
        entry.value,
        isEmpty,
        reason: 'Released Apple TV copy breaks "${entry.key}"',
      );
    }

    final untranslated = (report['untranslated'] as Map<String, dynamic>).map(
      (locale, keys) => MapEntry(locale, (keys as List).cast<String>()),
    );
    for (final entry in untranslated.entries) {
      expect(
        entry.value,
        isEmpty,
        reason: 'Released Apple TV copy has no ${entry.key} translation',
      );
    }

    final baseline =
        ((jsonDecode(File('tools/tv_strings_baseline.json').readAsStringSync())
                    as Map<String, dynamic>)['held_back']
                as Map<String, dynamic>)
            .map((rule, count) => MapEntry(rule, count as int));
    final heldBack = (report['held_back'] as Map<String, dynamic>).map(
      (rule, count) => MapEntry(rule, count as int),
    );
    for (final rule in {...baseline.keys, ...heldBack.keys}) {
      expect(
        heldBack[rule] ?? 0,
        baseline[rule] ?? 0,
        reason:
            'Held-back Apple TV copy moved on "$rule". If the count fell, '
            'write the new number into tools/tv_strings_baseline.json.',
      );
    }
  });
}
