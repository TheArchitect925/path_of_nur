import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  final l10nDir = Directory('lib/l10n');
  final englishFile = File('${l10nDir.path}/app_en.arb');
  final englishData =
      jsonDecode(englishFile.readAsStringSync()) as Map<String, dynamic>;
  final englishKeys = englishData.keys
      .where((key) => !key.startsWith('@'))
      .toSet();
  final localeFiles =
      l10nDir
          .listSync()
          .whereType<File>()
          .where((file) {
            final name = file.uri.pathSegments.last;
            return name.startsWith('app_') &&
                name.endsWith('.arb') &&
                name != 'app_en.arb';
          })
          .toList(growable: false)
        ..sort((a, b) => a.path.compareTo(b.path));

  test('non-English locale files keep parity with the English keyset', () {
    for (final file in localeFiles) {
      final data = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
      final localeKeys = data.keys.where((key) => !key.startsWith('@')).toSet();
      final missingKeys = englishKeys.difference(localeKeys).toList()..sort();
      expect(
        missingKeys,
        isEmpty,
        reason: '${file.path} is missing: ${missingKeys.join(', ')}',
      );
    }
  });

  test(
    'hadith reader provenance and chapter labels no longer fall back to English',
    () {
      const watchedKeys = <String>[
        'hadithProvenanceLabel',
        'hadithProvenanceSeeded',
        'hadithProvenanceEditorialOverride',
        'hadithProvenanceImported',
        'hadithProvenanceUnknown',
        'hadithProvenancePipelineValue',
        'hadithSourceChapterLabel',
      ];

      for (final file in localeFiles) {
        final data =
            jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
        final localeName = file.uri.pathSegments.last;
        for (final key in watchedKeys) {
          final englishValue = englishData[key];
          final localeValue = data[key];
          expect(localeValue, isNotNull, reason: '$localeName missing $key');
          expect(
            localeValue,
            isNot(englishValue),
            reason: '$localeName still falls back to English for $key',
          );
        }
      }
    },
  );
}
