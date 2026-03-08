import 'package:flutter/material.dart';

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
        return Icons.wb_twilight_rounded;
      case PrayerName.dhuhr:
        return Icons.wb_sunny_outlined;
      case PrayerName.asr:
        return Icons.cloud_outlined;
      case PrayerName.maghrib:
        return Icons.wb_cloudy_outlined;
      case PrayerName.isha:
        return Icons.nightlight_outlined;
    }
  }
}

