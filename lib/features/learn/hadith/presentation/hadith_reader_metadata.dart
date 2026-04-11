import '../../../../l10n/app_localizations.dart';
import '../domain/hadith_foundation_models.dart';

String formatHadithReferenceForDisplay(
  AppLocalizations l10n,
  HadithEntry entry,
) {
  final reference = (entry.displaySourceReference ?? '').trim();
  if (reference.isEmpty) return '';
  if (RegExp(r'^\d+$').hasMatch(reference)) {
    return l10n.hadithReferenceHadithNumber(reference);
  }
  return reference;
}
