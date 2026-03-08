import 'package:flutter_riverpod/flutter_riverpod.dart';

enum PrayerCalculationMethod {
  muslimWorldLeague,
  egyptian,
  isna,
  karachi,
  ummAlQura,
}

enum PrayerMadhab { shafii, hanafi, maliki, hanbali }

enum PrayerNotificationMode {
  none,
  notificationOnly,
  adhanWithSound,
  reminderBeforeQaza,
}

class PrayerPreferences {
  const PrayerPreferences({
    required this.location,
    required this.madhab,
    required this.calculationMethod,
  });

  final String location;
  final PrayerMadhab madhab;
  final PrayerCalculationMethod calculationMethod;

  PrayerPreferences copyWith({
    String? location,
    PrayerMadhab? madhab,
    PrayerCalculationMethod? calculationMethod,
  }) {
    return PrayerPreferences(
      location: location ?? this.location,
      madhab: madhab ?? this.madhab,
      calculationMethod: calculationMethod ?? this.calculationMethod,
    );
  }
}

class PrayerScheduleItem {
  const PrayerScheduleItem({
    required this.id,
    required this.name,
    required this.arabicName,
    required this.category,
    required this.offerTime,
    required this.windowStart,
    required this.windowEnd,
    required this.qaza,
    required this.totalRakats,
  });

  final String id;
  final String name;
  final String arabicName;
  final String category;
  final String offerTime;
  final String windowStart;
  final String windowEnd;
  final String qaza;
  final int totalRakats;
}

class _CityTimings {
  const _CityTimings({
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
    required this.method,
  });

  final int fajr;
  final int sunrise;
  final int dhuhr;
  final int asr;
  final int maghrib;
  final int isha;
  final int method;
}

const _minutesPerHour = 60;

final Map<String, String> prayerMethodLabels = {
  'MWL': 'Muslim World League',
  'EGY': 'Egyptian General Authority',
  'ISNA': 'Islamic Society of North America',
  'KAR': 'University of Karachi',
  'QUR': 'Umm al-Qura University',
};

final Map<String, String> prayerMadhabLabels = {
  "Shafi'i": "Shafi'i",
  'Hanafi': 'Hanafi',
  'Maliki': 'Maliki',
  'Hanbali': 'Hanbali',
};

final Map<PrayerCalculationMethod, String> prayerMethodKey = {
  PrayerCalculationMethod.muslimWorldLeague: 'MWL',
  PrayerCalculationMethod.egyptian: 'EGY',
  PrayerCalculationMethod.isna: 'ISNA',
  PrayerCalculationMethod.karachi: 'KAR',
  PrayerCalculationMethod.ummAlQura: 'QUR',
};

final Map<PrayerMadhab, String> prayerMadhabKey = {
  PrayerMadhab.shafii: "Shafi'i",
  PrayerMadhab.hanafi: 'Hanafi',
  PrayerMadhab.maliki: 'Maliki',
  PrayerMadhab.hanbali: 'Hanbali',
};

final Map<String, _CityTimings> _cityTimings = {
  'Toronto, Canada': _CityTimings(
    fajr: 5 * 60 + 58,
    sunrise: 7 * 60 + 8,
    dhuhr: 12 * 60 + 17,
    asr: 16 * 60 + 27,
    maghrib: 18 * 60 + 15,
    isha: 19 * 60 + 45,
    method: 0,
  ),
  'Dubai, UAE': _CityTimings(
    fajr: 4 * 60 + 54,
    sunrise: 6 * 60 + 0,
    dhuhr: 11 * 60 + 56,
    asr: 15 * 60 + 21,
    maghrib: 18 * 60 + 13,
    isha: 19 * 60 + 33,
    method: 2,
  ),
  'London, UK': _CityTimings(
    fajr: 4 * 60 + 45,
    sunrise: 5 * 60 + 58,
    dhuhr: 12 * 60 + 56,
    asr: 16 * 60 + 58,
    maghrib: 21 * 60 + 12,
    isha: 22 * 60 + 28,
    method: 3,
  ),
  'Istanbul, Turkey': _CityTimings(
    fajr: 4 * 60 + 50,
    sunrise: 6 * 60 + 4,
    dhuhr: 12 * 60 + 23,
    asr: 16 * 60 + 2,
    maghrib: 19 * 60 + 8,
    isha: 20 * 60 + 10,
    method: 1,
  ),
  'Riyadh, Saudi Arabia': _CityTimings(
    fajr: 5 * 60 + 14,
    sunrise: 6 * 60 + 27,
    dhuhr: 12 * 60 + 0,
    asr: 15 * 60 + 48,
    maghrib: 18 * 60 + 27,
    isha: 19 * 60 + 36,
    method: 2,
  ),
};

class PrayerSettingsState {
  const PrayerSettingsState({
    required this.preferences,
    required this.notificationModes,
  });

  final PrayerPreferences preferences;
  final Map<String, PrayerNotificationMode> notificationModes;

  PrayerSettingsState copyWith({
    PrayerPreferences? preferences,
    Map<String, PrayerNotificationMode>? notificationModes,
  }) {
    return PrayerSettingsState(
      preferences: preferences ?? this.preferences,
      notificationModes: notificationModes ?? this.notificationModes,
    );
  }
}

final prayerSettingsProvider =
    StateNotifierProvider<PrayerSettingsController, PrayerSettingsState>((ref) {
      const defaults = PrayerPreferences(
        location: 'Toronto, Canada',
        madhab: PrayerMadhab.shafii,
        calculationMethod: PrayerCalculationMethod.muslimWorldLeague,
      );
      return PrayerSettingsController(defaults);
    });

class PrayerSettingsController extends StateNotifier<PrayerSettingsState> {
  PrayerSettingsController(PrayerPreferences defaults)
    : super(
        PrayerSettingsState(
          preferences: defaults,
          notificationModes: {
            'fajr': PrayerNotificationMode.none,
            'dhuhr': PrayerNotificationMode.none,
            'asr': PrayerNotificationMode.none,
            'maghrib': PrayerNotificationMode.none,
            'isha': PrayerNotificationMode.none,
            'tahajjud': PrayerNotificationMode.none,
          },
        ),
      );

  void updateLocation(String location) {
    state = state.copyWith(
      preferences: state.preferences.copyWith(location: location),
    );
  }

  void updateMadhab(PrayerMadhab madhab) {
    state = state.copyWith(
      preferences: state.preferences.copyWith(madhab: madhab),
    );
  }

  void updateMethod(PrayerCalculationMethod method) {
    state = state.copyWith(
      preferences: state.preferences.copyWith(calculationMethod: method),
    );
  }

  void updateNotificationMode(String prayerId, PrayerNotificationMode mode) {
    final updated = Map<String, PrayerNotificationMode>.from(
      state.notificationModes,
    );
    updated[prayerId] = mode;
    state = state.copyWith(notificationModes: updated);
  }
}

final availablePrayerLocationsProvider = Provider<List<String>>(
  (ref) => _cityTimings.keys.toList(),
);

final prayerScheduleProvider = Provider<List<PrayerScheduleItem>>((ref) {
  final settings = ref.watch(prayerSettingsProvider).preferences;
  final timings =
      _cityTimings[settings.location] ?? _cityTimings['Toronto, Canada']!;

  final methodShift =
      {
        PrayerCalculationMethod.muslimWorldLeague: 0,
        PrayerCalculationMethod.egyptian: 2,
        PrayerCalculationMethod.isna: 3,
        PrayerCalculationMethod.karachi: 1,
        PrayerCalculationMethod.ummAlQura: -2,
      }[settings.calculationMethod] ??
      0;

  int asrMinutes =
      timings.asr +
      (settings.madhab == PrayerMadhab.hanafi ? 9 : 0) +
      (methodShift > 0 ? (methodShift / 2).round() : 0);

  final fajr = _normalizeMinute(timings.fajr + methodShift);
  final sunrise = _normalizeMinute(timings.sunrise + methodShift);
  final dhuhr = _normalizeMinute(timings.dhuhr + methodShift);
  final asr = _normalizeMinute(asrMinutes);
  final maghrib = _normalizeMinute(timings.maghrib + methodShift);
  final isha = _normalizeMinute(timings.isha + methodShift);
  final tahajjudStart = _normalizeMinute(isha + 95);

  return [
    PrayerScheduleItem(
      id: 'fajr',
      name: 'Fajr',
      arabicName: 'الفجر',
      category: 'Fardh',
      offerTime: _formatTime(fajr),
      windowStart: _formatTime(fajr),
      windowEnd: _formatTime(sunrise),
      qaza: 'Until sunrise (${_formatTime(sunrise)})',
      totalRakats: 2,
    ),
    PrayerScheduleItem(
      id: 'dhuhr',
      name: 'Dhuhr',
      arabicName: 'الظهر',
      category: 'Fardh',
      offerTime: _formatTime(dhuhr),
      windowStart: _formatTime(dhuhr),
      windowEnd: _formatTime(asr),
      qaza: 'Until Asr (${_formatTime(asr)})',
      totalRakats: 4,
    ),
    PrayerScheduleItem(
      id: 'asr',
      name: 'Asr',
      arabicName: 'العصر',
      category: 'Fardh',
      offerTime: _formatTime(asr),
      windowStart: _formatTime(asr),
      windowEnd: _formatTime(maghrib),
      qaza: 'Until Maghrib (${_formatTime(maghrib)})',
      totalRakats: 4,
    ),
    PrayerScheduleItem(
      id: 'maghrib',
      name: 'Maghrib',
      arabicName: 'المغرب',
      category: 'Fardh',
      offerTime: _formatTime(maghrib),
      windowStart: _formatTime(maghrib),
      windowEnd: _formatTime(isha),
      qaza: 'Until Isha (${_formatTime(isha)})',
      totalRakats: 3,
    ),
    PrayerScheduleItem(
      id: 'isha',
      name: 'Isha',
      arabicName: 'العشاء',
      category: 'Fardh',
      offerTime: _formatTime(isha),
      windowStart: _formatTime(isha),
      windowEnd: _formatTime(tahajjudStart),
      qaza: 'Until midnight (${_formatTime(23 * 60 + 59)})',
      totalRakats: 4,
    ),
    PrayerScheduleItem(
      id: 'tahajjud',
      name: 'Tahajjud',
      arabicName: 'التهجد',
      category: 'Nafl',
      offerTime: '${_formatTime(tahajjudStart)} onward',
      windowStart: _formatTime(tahajjudStart),
      windowEnd: _formatTime(fajr),
      qaza: 'Before Fajr (${_formatTime(fajr)})',
      totalRakats: 3,
    ),
  ];
});

String _formatTime(int minuteOfDay) {
  final normalized =
      ((minuteOfDay % (24 * _minutesPerHour)) + (24 * _minutesPerHour)) %
      (24 * _minutesPerHour);
  final hour = normalized ~/ _minutesPerHour;
  final minute = normalized % _minutesPerHour;
  final suffix = hour >= 12 ? 'PM' : 'AM';
  final displayHour = hour % 12 == 0 ? 12 : hour % 12;
  final minuteText = minute.toString().padLeft(2, '0');
  return '$displayHour:$minuteText $suffix';
}

int _normalizeMinute(int minute) =>
    (minute % (24 * _minutesPerHour) + (24 * _minutesPerHour)) %
    (24 * _minutesPerHour);
