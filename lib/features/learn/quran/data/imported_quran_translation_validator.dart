import 'package:quran/quran.dart' as q;

import '../domain/imported_quran_translation_bundle.dart';

enum ImportedQuranTranslationIssueType {
  missingVerse,
  emptyTranslation,
  unknownVerseKey,
}

class ImportedQuranTranslationIssue {
  const ImportedQuranTranslationIssue({
    required this.type,
    required this.message,
    this.verseKey,
  });

  final ImportedQuranTranslationIssueType type;
  final String message;
  final String? verseKey;
}

class ImportedQuranTranslationValidationResult {
  const ImportedQuranTranslationValidationResult({
    required this.bundleCode,
    required this.expectedVerseCount,
    required this.actualVerseCount,
    required this.issues,
  });

  final String bundleCode;
  final int expectedVerseCount;
  final int actualVerseCount;
  final List<ImportedQuranTranslationIssue> issues;

  bool get isValid => issues.isEmpty;
}

ImportedQuranTranslationValidationResult validateImportedQuranTranslationBundle(
  ImportedQuranTranslationBundle bundle,
) {
  final issues = <ImportedQuranTranslationIssue>[];
  final expectedVerseKeys = <String>{
    for (var surah = 1; surah <= q.totalSurahCount; surah += 1)
      for (var ayah = 1; ayah <= q.getVerseCount(surah); ayah += 1)
        '$surah:$ayah',
  };

  for (final verseKey in expectedVerseKeys) {
    final translation = bundle.verseTextsByVerseKey[verseKey];
    if (translation == null) {
      issues.add(
        ImportedQuranTranslationIssue(
          type: ImportedQuranTranslationIssueType.missingVerse,
          verseKey: verseKey,
          message:
              'Imported Qur\'an translation bundle ${bundle.code} is missing verse '
              '$verseKey.',
        ),
      );
      continue;
    }
    if (translation.trim().isEmpty) {
      issues.add(
        ImportedQuranTranslationIssue(
          type: ImportedQuranTranslationIssueType.emptyTranslation,
          verseKey: verseKey,
          message:
              'Imported Qur\'an translation bundle ${bundle.code} has an empty '
              'translation for verse $verseKey.',
        ),
      );
    }
  }

  for (final verseKey in bundle.verseTextsByVerseKey.keys) {
    if (!expectedVerseKeys.contains(verseKey)) {
      issues.add(
        ImportedQuranTranslationIssue(
          type: ImportedQuranTranslationIssueType.unknownVerseKey,
          verseKey: verseKey,
          message:
              'Imported Qur\'an translation bundle ${bundle.code} contains an '
              'unknown verse key: $verseKey.',
        ),
      );
    }
  }

  return ImportedQuranTranslationValidationResult(
    bundleCode: bundle.code,
    expectedVerseCount: q.totalVerseCount,
    actualVerseCount: bundle.verseCount,
    issues: issues,
  );
}
