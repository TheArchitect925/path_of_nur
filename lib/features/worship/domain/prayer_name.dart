import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/theme/islamic_icons.dart';
import '../../../core/theme/app_icons.dart';

enum PrayerName { fajr, dhuhr, asr, maghrib, isha, tahajjud }

const List<PrayerName> obligatoryPrayerNames = <PrayerName>[
  PrayerName.fajr,
  PrayerName.dhuhr,
  PrayerName.asr,
  PrayerName.maghrib,
  PrayerName.isha,
];

/// The clock behind date-less prayer labels ("today"). Dhuhr renames itself
/// to Jumu'ah on Fridays, so a hard DateTime.now() here made every widget
/// without a date in scope — and every test that seeded its own clock —
/// change behaviour on real Fridays. Production keeps the real clock; tests
/// pin it.
@visibleForTesting
DateTime Function() prayerLabelClock = DateTime.now;

extension PrayerNameX on PrayerName {
  String localizedLabel(AppLocalizations l10n) {
    return localizedLabelForDate(l10n, prayerLabelClock());
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
      case PrayerName.tahajjud:
        return l10n.notificationsPrayerNameTahajjud;
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
      case PrayerName.tahajjud:
        return 'Tahajjud';
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
      case PrayerName.tahajjud:
        return 'التهجد';
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
        return AppIcons.mosque;
      case PrayerName.isha:
        return IslamicIcons.lantern;
      case PrayerName.tahajjud:
        return IslamicIcons.lantern;
    }
  }
}
