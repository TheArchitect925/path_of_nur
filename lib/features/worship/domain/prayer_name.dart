import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/theme/islamic_icons.dart';

enum PrayerName { fajr, dhuhr, asr, maghrib, isha }

extension PrayerNameX on PrayerName {
  String localizedLabel(AppLocalizations l10n) {
    return localizedLabelForDate(l10n, DateTime.now());
  }

  String localizedLabelForDate(AppLocalizations l10n, DateTime date) {
    switch (this) {
      case PrayerName.fajr:
        return l10n.settingsPrayerNameFajr;
      case PrayerName.dhuhr:
        return date.weekday == DateTime.friday
            ? l10n.settingsPrayerNameJumuah
            : l10n.settingsPrayerNameDhuhr;
      case PrayerName.asr:
        return l10n.settingsPrayerNameAsr;
      case PrayerName.maghrib:
        return l10n.settingsPrayerNameMaghrib;
      case PrayerName.isha:
        return l10n.settingsPrayerNameIsha;
    }
  }

  @Deprecated('Use localizedLabel(AppLocalizations) for user-visible text.')
  String get label {
    switch (this) {
      case PrayerName.fajr:
        return 'Fajr';
      case PrayerName.dhuhr:
        return 'Dhuhr';
      case PrayerName.asr:
        return 'Asr';
      case PrayerName.maghrib:
        return 'Maghrib';
      case PrayerName.isha:
        return 'Isha';
    }
  }

  String get arabic {
    return arabicForDate(DateTime.now());
  }

  String arabicForDate(DateTime date) {
    switch (this) {
      case PrayerName.fajr:
        return 'الفجر';
      case PrayerName.dhuhr:
        return date.weekday == DateTime.friday ? 'الجمعة' : 'الظهر';
      case PrayerName.asr:
        return 'العصر';
      case PrayerName.maghrib:
        return 'المغرب';
      case PrayerName.isha:
        return 'العشاء';
    }
  }

  IconData get icon {
    switch (this) {
      case PrayerName.fajr:
        return IslamicIcons.prayingPerson;
      case PrayerName.dhuhr:
        return IslamicIcons.prayer;
      case PrayerName.asr:
        return IslamicIcons.qibla;
      case PrayerName.maghrib:
        return IslamicIcons.mosque;
      case PrayerName.isha:
        return IslamicIcons.lantern;
    }
  }
}
