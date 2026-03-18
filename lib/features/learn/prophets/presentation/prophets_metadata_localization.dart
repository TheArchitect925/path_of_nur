import '../../../../l10n/app_localizations.dart';
import '../domain/prophet_entry.dart';

String localizedProphetEraTitle(
  AppLocalizations l10n,
  ProphetEraGroup eraGroup,
) {
  return switch (eraGroup) {
    ProphetEraGroup.earlyHumanity => l10n.prophetsEraEarlyHumanityTitle,
    ProphetEraGroup.earlyCivilizations =>
      l10n.prophetsEraEarlyCivilizationsTitle,
    ProphetEraGroup.postFloodPeoples => l10n.prophetsEraPostFloodPeoplesTitle,
    ProphetEraGroup.ageOfIbrahim => l10n.prophetsEraAgeOfIbrahimTitle,
    ProphetEraGroup.childrenOfIsrael => l10n.prophetsEraChildrenOfIsraelTitle,
    ProphetEraGroup.laterIsraeliteProphets =>
      l10n.prophetsEraLaterIsraeliteProphetsTitle,
    ProphetEraGroup.finalMessenger => l10n.prophetsEraFinalMessengerTitle,
  };
}

String localizedProphetEraSubtitle(
  AppLocalizations l10n,
  ProphetEraGroup eraGroup,
) {
  return switch (eraGroup) {
    ProphetEraGroup.earlyHumanity => l10n.prophetsEraEarlyHumanitySubtitle,
    ProphetEraGroup.earlyCivilizations =>
      l10n.prophetsEraEarlyCivilizationsSubtitle,
    ProphetEraGroup.postFloodPeoples =>
      l10n.prophetsEraPostFloodPeoplesSubtitle,
    ProphetEraGroup.ageOfIbrahim => l10n.prophetsEraAgeOfIbrahimSubtitle,
    ProphetEraGroup.childrenOfIsrael =>
      l10n.prophetsEraChildrenOfIsraelSubtitle,
    ProphetEraGroup.laterIsraeliteProphets =>
      l10n.prophetsEraLaterIsraeliteProphetsSubtitle,
    ProphetEraGroup.finalMessenger => l10n.prophetsEraFinalMessengerSubtitle,
  };
}

String localizedProphetLocationConfidenceLabel(
  AppLocalizations l10n,
  ProphetLocationConfidence confidence,
) {
  return switch (confidence) {
    ProphetLocationConfidence.symbolic =>
      l10n.prophetsLocationConfidenceSymbolic,
    ProphetLocationConfidence.approximate =>
      l10n.prophetsLocationConfidenceApproximate,
    ProphetLocationConfidence.traditional =>
      l10n.prophetsLocationConfidenceTraditional,
    ProphetLocationConfidence.strong => l10n.prophetsLocationConfidenceStrong,
  };
}

String localizedProphetLocationConfidenceGuidance(
  AppLocalizations l10n,
  ProphetLocationConfidence confidence,
) {
  return switch (confidence) {
    ProphetLocationConfidence.symbolic =>
      l10n.prophetsLocationConfidenceSymbolicGuidance,
    ProphetLocationConfidence.approximate =>
      l10n.prophetsLocationConfidenceApproximateGuidance,
    ProphetLocationConfidence.traditional =>
      l10n.prophetsLocationConfidenceTraditionalGuidance,
    ProphetLocationConfidence.strong =>
      l10n.prophetsLocationConfidenceStrongGuidance,
  };
}
