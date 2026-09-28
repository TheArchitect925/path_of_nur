import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// HD-2 of the header redesign: the icon vocabulary is the law.
///
/// `lib/core/theme/app_icons.dart` names one glyph per concept. Three rules
/// keep the product from drifting back to the mixed bag the audit found
/// (1,746 rounded, 283 outlined, 94 plain; a burger for Fasting, a yoga pose
/// for dhikr):
///
///  * Material icons come from the rounded family, everywhere.
///  * The only non-rounded Material glyphs live in `app_icons.dart`, for the
///    few hollow state forms that have no rounded twin.
///  * The wrong-world glyphs are banned outright, vocabulary included.
///
/// Unlike the HD-0 ratchets this carries no allow-list: the sweep took every
/// file to zero, so any new offender is simply wrong.
void main() {
  const vocabulary = 'lib/core/theme/app_icons.dart';

  test('Material icons come from the rounded family', () {
    final pattern = RegExp(r'(?<![A-Za-z0-9_])Icons\.([a-z0-9_]+)');
    final offenders = <String>[];
    for (final file in _dartFiles()) {
      if (file.path == vocabulary) continue;
      final source = file.readAsStringSync();
      for (final match in pattern.allMatches(source)) {
        final name = match.group(1)!;
        if (!name.endsWith('_rounded')) {
          offenders.add('${file.path}: Icons.$name');
        }
      }
    }
    expect(
      offenders..sort(),
      isEmpty,
      reason:
          'Use the _rounded variant, an IslamicIcons glyph, or a concept from '
          'AppIcons (lib/core/theme/app_icons.dart). A hollow state form with '
          'no rounded twin belongs in AppIcons, not at the call site.',
    );
  });

  test('The vocabulary keeps its non-rounded exceptions to hollow states', () {
    // If this list grows, the new entry needs the same justification: a
    // state glyph whose hollow form the rounded family does not ship.
    const allowed = {
      'push_pin_outlined',
      'view_in_ar_outlined',
      'school_outlined',
    };
    final source = File(vocabulary).readAsStringSync();
    final nonRounded = RegExp(r'(?<![A-Za-z0-9_])Icons\.([a-z0-9_]+)')
        .allMatches(source)
        .map((m) => m.group(1)!)
        .where((n) => !n.endsWith('_rounded'))
        .toSet();
    expect(nonRounded, equals(allowed));
  });

  test('Wrong-world glyphs are gone for good', () {
    // Each of these headed a real destination in the audit. The concept it
    // stood for now has a proper glyph in AppIcons.
    const banned = {
      'fastfood': 'AppIcons.fasting',
      'self_improvement': 'AppIcons.reflection / dhikr / khushu',
      'smart_toy': 'AppIcons.assistant',
      'casino': 'AppIcons.random',
      'biotech': 'AppIcons.science',
      'sports_esports': 'AppIcons.games',
      'mosque': 'AppIcons.mosque (IslamicIcons.locationMosque)',
      'spa': 'AppIcons.reflection',
    };
    final pattern = RegExp(r'(?<![A-Za-z0-9_])Icons\.([a-z0-9_]+)');
    final offenders = <String>[];
    for (final file in _dartFiles()) {
      for (final match in pattern.allMatches(file.readAsStringSync())) {
        final name = match.group(1)!;
        for (final entry in banned.entries) {
          if (name == entry.key || name.startsWith('${entry.key}_')) {
            offenders.add('${file.path}: Icons.$name → use ${entry.value}');
          }
        }
      }
    }
    expect(offenders..sort(), isEmpty);
  });

  test('Landing headers and hub rows take their glyph from the vocabulary', () {
    // A landing's header chip and the row that opens it must agree; both
    // resolve through AppIcons so a concept cannot be drawn two ways. Generic
    // UI glyphs are fine elsewhere, but a `headerIcon:` or `HubLeadingIcon(`
    // naming a raw Material icon is a concept without a name.
    final pattern = RegExp(
      r'(headerIcon:\s*|HubLeadingIcon\(\s*)(const\s+)?Icons\.',
    );
    final offenders = <String>[];
    for (final file in _dartFiles()) {
      for (final match in pattern.allMatches(file.readAsStringSync())) {
        final line = file
            .readAsStringSync()
            .substring(0, match.start)
            .split('\n')
            .length;
        offenders.add('${file.path}:$line');
      }
    }
    expect(
      offenders..sort(),
      isEmpty,
      reason:
          'Name the concept in AppIcons and use it in both the header and '
          'the row.',
    );
  });
}

Iterable<File> _dartFiles() sync* {
  for (final entity in Directory('lib').listSync(recursive: true)) {
    if (entity is File && entity.path.endsWith('.dart')) yield entity;
  }
}
