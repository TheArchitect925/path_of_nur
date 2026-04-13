import '../domain/imported_quran_translation_bundle.dart';

String buildImportedQuranTranslationBundleDartFile(
  ImportedQuranTranslationBundle bundle,
) {
  final buffer = StringBuffer()
    ..writeln("import '../domain/imported_quran_translation_bundle.dart';")
    ..writeln()
    ..writeln(
      'const ${_bundleIdentifierForCode(bundle.code)} = ImportedQuranTranslationBundle(',
    )
    ..writeln("  code: ${_singleQuoted(bundle.code)},")
    ..writeln("  translatorName: ${_singleQuoted(bundle.translatorName)},")
    ..writeln("  sourceProvider: ${_singleQuoted(bundle.sourceProvider)},");

  if (bundle.sourceResourceId != null) {
    buffer.writeln('  sourceResourceId: ${bundle.sourceResourceId},');
  }
  if (bundle.notes != null) {
    buffer.writeln('  notes: ${_singleQuoted(bundle.notes!)},');
  }

  buffer
    ..writeln('  verseTextsByVerseKey: <String, String>{')
    ..write(_buildSortedVerseMapLines(bundle))
    ..writeln('  },')
    ..writeln(');')
    ..writeln()
    ..writeln(
      'const importedQuranTranslationBundles = <String, ImportedQuranTranslationBundle>{',
    )
    ..writeln(
      "  ${_singleQuoted(bundle.code)}: ${_bundleIdentifierForCode(bundle.code)},",
    )
    ..writeln('};');

  return buffer.toString().trimRight();
}

String _buildSortedVerseMapLines(ImportedQuranTranslationBundle bundle) {
  final entries = bundle.verseTextsByVerseKey.entries.toList()
    ..sort((a, b) => _compareVerseKeys(a.key, b.key));
  final buffer = StringBuffer();
  for (final entry in entries) {
    buffer.writeln(
      "    ${_singleQuoted(entry.key)}: ${_singleQuoted(entry.value)},",
    );
  }
  return buffer.toString();
}

String _bundleIdentifierForCode(String code) {
  final sanitized = code.replaceAll(RegExp(r'[^a-zA-Z0-9]+'), '_');
  return '${sanitized}ImportBundle';
}

String _singleQuoted(String value) {
  final escaped = value.replaceAll('\\', r'\\').replaceAll("'", r"\'");
  return "'$escaped'";
}

int _compareVerseKeys(String left, String right) {
  final leftParts = left.split(':');
  final rightParts = right.split(':');
  if (leftParts.length != 2 || rightParts.length != 2) {
    return left.compareTo(right);
  }
  final leftSurah = int.tryParse(leftParts[0]);
  final leftAyah = int.tryParse(leftParts[1]);
  final rightSurah = int.tryParse(rightParts[0]);
  final rightAyah = int.tryParse(rightParts[1]);
  if (leftSurah == null ||
      leftAyah == null ||
      rightSurah == null ||
      rightAyah == null) {
    return left.compareTo(right);
  }
  final bySurah = leftSurah.compareTo(rightSurah);
  if (bySurah != 0) return bySurah;
  return leftAyah.compareTo(rightAyah);
}
