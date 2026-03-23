import '../../../l10n/app_localizations.dart';
import '../../../l10n/home_prayer_localizations.dart';

enum PrayerOfferTiming { onTime, late, qada }

enum PrayerOfferPlace { alone, congregation, masjid }

extension PrayerOfferTimingX on PrayerOfferTiming {
  String localizedLabel(AppLocalizations l10n) {
    switch (this) {
      case PrayerOfferTiming.onTime:
        return l10n.salahQuickTrackOnTime;
      case PrayerOfferTiming.late:
        return l10n.salahQuickTrackLate;
      case PrayerOfferTiming.qada:
        return l10n.salahQuickTrackQada;
    }
  }
}

extension PrayerOfferPlaceX on PrayerOfferPlace {
  String localizedLabel(AppLocalizations l10n) {
    switch (this) {
      case PrayerOfferPlace.alone:
        return l10n.prayerOfferPlaceAloneText;
      case PrayerOfferPlace.congregation:
        return l10n.prayerOfferPlaceCongregationText;
      case PrayerOfferPlace.masjid:
        return l10n.prayerOfferPlaceMasjidText;
    }
  }
}
