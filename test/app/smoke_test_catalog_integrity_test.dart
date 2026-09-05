import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Guards the MCSnow import contract described in CLAUDE.md.
///
/// `SMOKE_TESTS.md` is imported into MCSnow, and imports upsert on ID. Two rows
/// sharing an ID therefore do not fail loudly — one silently overwrites the
/// other and a smoke test case is lost on every import. Because IDs are stable
/// and must never be renumbered, the only safe moment to catch a collision is
/// before it lands.
void main() {
  final catalog = File('SMOKE_TESTS.md');
  final lines = catalog.readAsLinesSync();

  /// Collects the leading `| <PREFIX>-<id> |` cell of every row in the file.
  List<String> idsWithPrefix(String prefix) {
    final rowId = RegExp('^\\|\\s*($prefix-[A-Za-z0-9-]+)\\s*\\|');
    return [
      for (final line in lines)
        if (rowId.firstMatch(line) case final match?) match.group(1)!,
    ];
  }

  List<String> duplicatesIn(List<String> ids) {
    final seen = <String>{};
    final duplicated = <String>{};
    for (final id in ids) {
      if (!seen.add(id)) duplicated.add(id);
    }
    return duplicated.toList()..sort();
  }

  test('SMOKE_TESTS.md exists at the repo root', () {
    expect(
      catalog.existsSync(),
      isTrue,
      reason:
          'CLAUDE.md requires SMOKE_TESTS.md at the repo root so MCSnow can '
          'import it.',
    );
  });

  test('no smoke test ID is used twice', () {
    final ids = idsWithPrefix('PON-T');
    expect(
      ids,
      isNotEmpty,
      reason: 'Expected PON-T rows in SMOKE_TESTS.md — has the format changed?',
    );

    final duplicated = duplicatesIn(ids);
    expect(
      duplicated,
      isEmpty,
      reason:
          'Duplicate smoke test IDs in SMOKE_TESTS.md: '
          '${duplicated.join(', ')}.\n'
          'MCSnow upserts on ID, so each duplicate silently overwrites the '
          'earlier case and loses it on every import. Give the row that was '
          'added SECOND a fresh ID after the current maximum — never renumber '
          'the row that was there first, because MCSnow already holds a case '
          'against that ID.',
    );
  });

  test('no epic or story ID is used twice', () {
    for (final prefix in const ['PON-E', 'PON-S']) {
      final duplicated = duplicatesIn(idsWithPrefix(prefix));
      expect(
        duplicated,
        isEmpty,
        reason:
            'Duplicate $prefix IDs in SMOKE_TESTS.md: '
            '${duplicated.join(', ')}. Backlog rows upsert on ID too, so a '
            'collision silently drops one of them.',
      );
    }
  });

  test('every smoke test row carries a story: tag', () {
    final testRow = RegExp(r'^\|\s*(PON-T-[A-Za-z0-9-]+)\s*\|');
    final untagged = <String>[];
    for (final line in lines) {
      final match = testRow.firstMatch(line);
      if (match == null) continue;
      if (!line.contains('story:')) untagged.add(match.group(1)!);
    }
    expect(
      untagged,
      isEmpty,
      reason:
          'Smoke test rows missing a required story: tag in Notes: '
          '${untagged.join(', ')}. Without it the case is not attached to a '
          'work item on import.',
    );
  });
}
