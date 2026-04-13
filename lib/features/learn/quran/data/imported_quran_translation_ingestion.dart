import 'dart:convert';

import '../domain/imported_quran_translation_bundle.dart';

class ImportedQuranTranslationEntry {
  const ImportedQuranTranslationEntry({
    required this.verseKey,
    required this.text,
  });

  final String verseKey;
  final String text;
}

ImportedQuranTranslationBundle parseImportedQuranTranslationBundleDocument(
  Map<String, dynamic> json,
) {
  final code = (json['code'] as String?)?.trim();
  final translatorName = (json['translatorName'] as String?)?.trim();
  final sourceProvider = (json['sourceProvider'] as String?)?.trim();
  final sourceResourceId = json['sourceResourceId'] as int?;
  final notes = (json['notes'] as String?)?.trim();

  if (code == null || code.isEmpty) {
    throw const FormatException(
      'Imported Qur\'an translation document is missing a non-empty code.',
    );
  }
  if (translatorName == null || translatorName.isEmpty) {
    throw const FormatException(
      'Imported Qur\'an translation document is missing translatorName.',
    );
  }
  if (sourceProvider == null || sourceProvider.isEmpty) {
    throw const FormatException(
      'Imported Qur\'an translation document is missing sourceProvider.',
    );
  }

  return ImportedQuranTranslationBundle(
    code: code,
    translatorName: translatorName,
    sourceProvider: sourceProvider,
    sourceResourceId: sourceResourceId,
    notes: notes == null || notes.isEmpty ? null : notes,
    verseTextsByVerseKey: _parseVerseTextsByVerseKey(json),
  );
}

Map<String, dynamic> encodeImportedQuranTranslationBundleDocument(
  ImportedQuranTranslationBundle bundle,
) {
  final sortedVerseEntries = bundle.verseTextsByVerseKey.entries.toList()
    ..sort((a, b) => _compareVerseKeys(a.key, b.key));

  return <String, dynamic>{
    'code': bundle.code,
    'translatorName': bundle.translatorName,
    'sourceProvider': bundle.sourceProvider,
    'sourceResourceId': bundle.sourceResourceId,
    'notes': bundle.notes,
    'versesByVerseKey': <String, String>{
      for (final entry in sortedVerseEntries) entry.key: entry.value,
    },
  };
}

String prettyPrintImportedQuranTranslationBundleDocument(
  ImportedQuranTranslationBundle bundle,
) {
  return const JsonEncoder.withIndent(
    '  ',
  ).convert(encodeImportedQuranTranslationBundleDocument(bundle));
}

Map<String, String> _parseVerseTextsByVerseKey(Map<String, dynamic> json) {
  final canonicalMap = json['versesByVerseKey'];
  if (canonicalMap is Map) {
    return canonicalMap.map((rawKey, rawValue) {
      final verseKey = (rawKey as String).trim();
      final text = (rawValue as String).trim();
      if (verseKey.isEmpty) {
        throw const FormatException(
          'Imported Qur\'an translation document contains an empty verse key.',
        );
      }
      return MapEntry(verseKey, text);
    });
  }

  final verseRows = json['verses'];
  if (verseRows is! List) {
    throw const FormatException(
      'Imported Qur\'an translation document must contain versesByVerseKey or verses.',
    );
  }

  final rows = verseRows
      .map((row) => _parseVerseRow(row as Map<String, dynamic>))
      .toList(growable: false);

  final seenVerseKeys = <String>{};
  final verseMap = <String, String>{};
  for (final row in rows) {
    if (!seenVerseKeys.add(row.verseKey)) {
      throw FormatException(
        'Imported Qur\'an translation document contains a duplicate verse key: '
        '${row.verseKey}.',
      );
    }
    verseMap[row.verseKey] = row.text;
  }
  return verseMap;
}

ImportedQuranTranslationEntry _parseVerseRow(Map<String, dynamic> row) {
  final verseKey = (row['verseKey'] as String?)?.trim();
  final text = (row['text'] as String?)?.trim();
  if (verseKey == null || verseKey.isEmpty) {
    throw const FormatException(
      'Imported Qur\'an translation verse rows must include a non-empty verseKey.',
    );
  }
  if (text == null) {
    throw const FormatException(
      'Imported Qur\'an translation verse rows must include text.',
    );
  }
  return ImportedQuranTranslationEntry(verseKey: verseKey, text: text);
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
