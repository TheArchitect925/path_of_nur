import '../../../../l10n/app_localizations.dart';
import '../domain/quran_surah.dart';

/// Where a surah was revealed, in the child's language.
String kidsQuranRevelationPlaceLabel(AppLocalizations l10n, QuranSurah surah) {
  final normalized = surah.revelationPlace.trim().toLowerCase();
  if (normalized == 'madinah' || normalized == 'medinan') {
    return l10n.kidsQuranRevelationMadinah;
  }
  return l10n.kidsQuranRevelationMakkah;
}
