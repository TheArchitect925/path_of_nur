import 'dart:convert';
import 'dart:io';

import 'package:path_of_nur/features/learn/quran/data/imported_quran_translation_dart_generator.dart';
import 'package:path_of_nur/features/learn/quran/data/imported_quran_translation_ingestion.dart';
import 'package:path_of_nur/features/learn/quran/data/imported_quran_translation_validator.dart';

Future<void> main(List<String> args) async {
  if (args.length != 2) {
    stderr.writeln(
      'Usage: dart run tool/import_quran_translation_bundle.dart <input.json> <output.json|output.dart>',
    );
    exitCode = 64;
    return;
  }

  final inputFile = File(args[0]);
  final outputFile = File(args[1]);
  if (!await inputFile.exists()) {
    stderr.writeln('Input file not found: ${inputFile.path}');
    exitCode = 66;
    return;
  }

  final raw = await inputFile.readAsString();
  final decoded = jsonDecode(raw);
  if (decoded is! Map<String, dynamic>) {
    stderr.writeln('Input JSON must decode to an object.');
    exitCode = 65;
    return;
  }

  final bundle = parseImportedQuranTranslationBundleDocument(decoded);
  final validation = validateImportedQuranTranslationBundle(bundle);
  if (!validation.isValid) {
    stderr.writeln(
      'Imported Qur\'an translation bundle validation failed with '
      '${validation.issues.length} issue(s).',
    );
    for (final issue in validation.issues.take(20)) {
      stderr.writeln('- ${issue.message}');
    }
    if (validation.issues.length > 20) {
      stderr.writeln(
        '- ${validation.issues.length - 20} additional issue(s) omitted.',
      );
    }
    exitCode = 65;
    return;
  }

  await outputFile.parent.create(recursive: true);
  if (outputFile.path.endsWith('.dart')) {
    await outputFile.writeAsString(
      '${buildImportedQuranTranslationBundleDartFile(bundle)}\n',
    );
  } else {
    await outputFile.writeAsString(
      '${prettyPrintImportedQuranTranslationBundleDocument(bundle)}\n',
    );
  }

  stdout.writeln(
    'Validated ${bundle.code} with ${bundle.verseCount} verses and wrote '
    '${outputFile.path}.',
  );
}
