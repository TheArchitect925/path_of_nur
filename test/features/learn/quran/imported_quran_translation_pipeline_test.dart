import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/learn/quran/data/imported_quran_translation_bundles.dart';
import 'package:path_of_nur/features/learn/quran/data/imported_quran_translation_dart_generator.dart';
import 'package:path_of_nur/features/learn/quran/data/imported_quran_translation_ingestion.dart';
import 'package:path_of_nur/features/learn/quran/data/imported_quran_translation_validator.dart';
import 'package:path_of_nur/features/learn/quran/data/quran_translation_registry.dart';
import 'package:path_of_nur/features/learn/quran/domain/imported_quran_translation_bundle.dart';

void main() {
  test('ingestion rejects duplicate verse keys from row-based imports', () {
    expect(
      () => parseImportedQuranTranslationBundleDocument({
        'code': 'de.quran_foundation_candidate',
        'translatorName': 'Frank Bubenheim and Nadeem Elyas',
        'sourceProvider': 'Quran Foundation',
        'verses': const [
          {'verseKey': '1:1', 'text': 'Im Namen Allahs'},
          {'verseKey': '1:1', 'text': 'Doppelt'},
        ],
      }),
      throwsA(
        isA<FormatException>().having(
          (error) => error.message,
          'message',
          contains('duplicate verse key'),
        ),
      ),
    );
  });

  test('validator reports missing and empty verses for incomplete bundles', () {
    final bundle = parseImportedQuranTranslationBundleDocument({
      'code': 'de.quran_foundation_candidate',
      'translatorName': 'Frank Bubenheim and Nadeem Elyas',
      'sourceProvider': 'Quran Foundation',
      'versesByVerseKey': const {
        '1:1': 'Im Namen Allahs, des Allerbarmers, des Barmherzigen.',
        '1:2': '',
      },
    });

    final validation = validateImportedQuranTranslationBundle(bundle);

    expect(validation.isValid, isFalse);
    expect(
      validation.issues.any(
        (issue) =>
            issue.type == ImportedQuranTranslationIssueType.emptyTranslation &&
            issue.verseKey == '1:2',
      ),
      isTrue,
    );
    expect(
      validation.issues.any(
        (issue) =>
            issue.type == ImportedQuranTranslationIssueType.missingVerse &&
            issue.verseKey == '1:3',
      ),
      isTrue,
    );
  });

  test(
    'German translation stays hidden until the imported bundle is valid',
    () {
      final germanResource = quranTranslationResourceForCode(
        'de.quran_foundation_candidate',
      );

      expect(germanResource, isNotNull);
      expect(
        isQuranTranslationResourceAvailable(
          germanResource!,
          importedBundles: importedQuranTranslationBundles,
        ),
        isFalse,
      );
      expect(
        quranTranslationCodes.contains('de.quran_foundation_candidate'),
        isFalse,
      );
    },
  );

  test('Dart bundle generation emits a const import bundle file', () {
    final dartSource = buildImportedQuranTranslationBundleDartFile(
      const ImportedQuranTranslationBundle(
        code: 'de.quran_foundation_candidate',
        translatorName: 'Frank Bubenheim and Nadeem Elyas',
        sourceProvider: 'Quran Foundation',
        verseTextsByVerseKey: {
          '1:1': 'Im Namen Allahs',
          '1:2': 'Alles Lob gebuhrt Allah',
        },
      ),
    );

    expect(
      dartSource,
      contains('const de_quran_foundation_candidateImportBundle'),
    );
    expect(dartSource, contains("'1:1': 'Im Namen Allahs'"));
    expect(dartSource, contains('const importedQuranTranslationBundles'));
  });
}
