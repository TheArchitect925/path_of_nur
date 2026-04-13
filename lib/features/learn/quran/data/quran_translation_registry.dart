import '../../../../l10n/app_localizations.dart';
import '../domain/imported_quran_translation_bundle.dart';
import '../domain/quran_translation_resource.dart';
import 'imported_quran_translation_bundles.dart';
import 'imported_quran_translation_validator.dart';

const quranTranslationResources = <QuranTranslationResource>[
  QuranTranslationResource(
    code: 'en.sahih',
    languageCode: 'en',
    sourceType: QuranTranslationSourceType.bundledQuranPackage,
    runtimeStatus: QuranTranslationRuntimeStatus.enabled,
    labelToken: 'en.sahih',
  ),
  QuranTranslationResource(
    code: 'en.clear',
    languageCode: 'en',
    sourceType: QuranTranslationSourceType.bundledQuranPackage,
    runtimeStatus: QuranTranslationRuntimeStatus.enabled,
    labelToken: 'en.clear',
  ),
  QuranTranslationResource(
    code: 'ur.urdu',
    languageCode: 'ur',
    sourceType: QuranTranslationSourceType.bundledQuranPackage,
    runtimeStatus: QuranTranslationRuntimeStatus.enabled,
    labelToken: 'ur.urdu',
  ),
  QuranTranslationResource(
    code: 'bn.bengali',
    languageCode: 'bn',
    sourceType: QuranTranslationSourceType.bundledQuranPackage,
    runtimeStatus: QuranTranslationRuntimeStatus.enabled,
    labelToken: 'bn.bengali',
  ),
  QuranTranslationResource(
    code: 'id.indonesian',
    languageCode: 'id',
    sourceType: QuranTranslationSourceType.bundledQuranPackage,
    runtimeStatus: QuranTranslationRuntimeStatus.enabled,
    labelToken: 'id.indonesian',
  ),
  QuranTranslationResource(
    code: 'tr.saheeh',
    languageCode: 'tr',
    sourceType: QuranTranslationSourceType.bundledQuranPackage,
    runtimeStatus: QuranTranslationRuntimeStatus.enabled,
    labelToken: 'tr.saheeh',
  ),
  QuranTranslationResource(
    code: 'fa.dari',
    languageCode: 'fa',
    sourceType: QuranTranslationSourceType.bundledQuranPackage,
    runtimeStatus: QuranTranslationRuntimeStatus.enabled,
    labelToken: 'fa.dari',
  ),
  QuranTranslationResource(
    code: 'de.quran_foundation_candidate',
    languageCode: 'de',
    sourceType: QuranTranslationSourceType.quranFoundationApi,
    runtimeStatus: QuranTranslationRuntimeStatus.planned,
    labelToken: 'de.quran_foundation_candidate',
    translatorName: 'Frank Bubenheim and Nadeem Elyas',
    notes:
        'Reserved German lane for a reviewed Quran Foundation translation resource using the Frank Bubenheim and Nadeem Elyas translation after exact resource selection and access setup.',
  ),
];

final quranTranslationCodes = quranTranslationResources
    .where(
      (resource) => isQuranTranslationResourceAvailable(
        resource,
        importedBundles: importedQuranTranslationBundles,
      ),
    )
    .map((resource) => resource.code)
    .toList(growable: false);

bool isQuranTranslationResourceAvailable(
  QuranTranslationResource resource, {
  required Map<String, ImportedQuranTranslationBundle> importedBundles,
}) {
  if (!resource.isEnabled) return false;
  if (resource.sourceType == QuranTranslationSourceType.bundledQuranPackage) {
    return true;
  }

  final bundle = importedBundles[resource.code];
  if (bundle == null) return false;
  return validateImportedQuranTranslationBundle(bundle).isValid;
}

QuranTranslationResource? quranTranslationResourceForCode(String code) {
  for (final resource in quranTranslationResources) {
    if (resource.code == code) return resource;
  }
  return null;
}

String quranTranslationLabelForCode(AppLocalizations l10n, String code) {
  switch (code) {
    case 'en.sahih':
      return l10n.quranTranslationSahih;
    case 'en.clear':
      return l10n.quranTranslationClearQuran;
    case 'ur.urdu':
      return l10n.quranTranslationUrdu;
    case 'bn.bengali':
      return l10n.quranTranslationBengali;
    case 'id.indonesian':
      return l10n.quranTranslationIndonesian;
    case 'tr.saheeh':
      return l10n.quranTranslationTurkish;
    case 'fa.dari':
      return l10n.quranTranslationDari;
    default:
      return quranTranslationResourceForCode(code)?.translatorName ?? code;
  }
}
