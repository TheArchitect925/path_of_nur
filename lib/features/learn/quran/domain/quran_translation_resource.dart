enum QuranTranslationSourceType { bundledQuranPackage, quranFoundationApi }

enum QuranTranslationRuntimeStatus { enabled, planned }

class QuranTranslationResource {
  const QuranTranslationResource({
    required this.code,
    required this.languageCode,
    required this.sourceType,
    required this.runtimeStatus,
    required this.labelToken,
    this.translatorName,
    this.sourceResourceId,
    this.notes,
  });

  final String code;
  final String languageCode;
  final QuranTranslationSourceType sourceType;
  final QuranTranslationRuntimeStatus runtimeStatus;
  final String labelToken;
  final String? translatorName;
  final int? sourceResourceId;
  final String? notes;

  bool get isEnabled => runtimeStatus == QuranTranslationRuntimeStatus.enabled;
}
