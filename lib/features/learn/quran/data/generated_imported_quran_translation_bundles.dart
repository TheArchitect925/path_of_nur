import '../domain/imported_quran_translation_bundle.dart';

const germanBubenheimElyasImportBundle = ImportedQuranTranslationBundle(
  code: 'de.quran_foundation_candidate',
  translatorName: 'Frank Bubenheim and Nadeem Elyas',
  sourceProvider: 'Quran Foundation',
  notes:
      'Import placeholder only. Replace this generated file with the reviewed German Qur\'an translation bundle before enabling German in settings.',
  verseTextsByVerseKey: <String, String>{},
);

const importedQuranTranslationBundles =
    <String, ImportedQuranTranslationBundle>{
      'de.quran_foundation_candidate': germanBubenheimElyasImportBundle,
    };
