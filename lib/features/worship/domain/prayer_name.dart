import 'package:flutter/material.dart';
import '../../../shared/theme/islamic_icons.dart';

enum PrayerName {
  fajr,
  dhuhr,
  asr,
  maghrib,
  isha,
}

extension PrayerNameX on PrayerName {
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
    switch (this) {
      case PrayerName.fajr:
        return 'الفجر';
      case PrayerName.dhuhr:
        return 'الظهر';
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
