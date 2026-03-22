import 'dart:math' as math;

import 'package:adhan/adhan.dart' as adhan;
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../l10n/app_localizations.dart';
import 'prayer_location_search_service.dart';
import '../reminders/adhan_options.dart';
import '../../shared/application/daily_clock_provider.dart';
import '../../shared/persistence/local_store.dart';

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

enum PrayerTimeMode { calculatedAdjusted, manual }

enum FridayReminderMode { normalDhuhr, customJumuah }

const int defaultJumuahDisplayMinutes = 13 * 60 + 30;

class PrayerClockTimes {
  const PrayerClockTimes({
    this.fajrMinutes,
    this.dhuhrMinutes,
    this.asrMinutes,
    this.maghribMinutes,
    this.ishaMinutes,
  });

  final int? fajrMinutes;
  final int? dhuhrMinutes;
  final int? asrMinutes;
  final int? maghribMinutes;
  final int? ishaMinutes;

  bool get isComplete =>
      fajrMinutes != null &&
      dhuhrMinutes != null &&
      asrMinutes != null &&
      maghribMinutes != null &&
      ishaMinutes != null;

  int? minuteForPrayer(String prayerId) {
    switch (prayerId) {
      case 'fajr':
        return fajrMinutes;
      case 'dhuhr':
        return dhuhrMinutes;
      case 'asr':
        return asrMinutes;
      case 'maghrib':
        return maghribMinutes;
      case 'isha':
        return ishaMinutes;
      default:
        return null;
    }
  }

  PrayerClockTimes copyWith({
    int? fajrMinutes,
    int? dhuhrMinutes,
    int? asrMinutes,
    int? maghribMinutes,
    int? ishaMinutes,
    bool clearFajr = false,
    bool clearDhuhr = false,
    bool clearAsr = false,
    bool clearMaghrib = false,
    bool clearIsha = false,
  }) {
    return PrayerClockTimes(
      fajrMinutes: clearFajr ? null : fajrMinutes ?? this.fajrMinutes,
      dhuhrMinutes: clearDhuhr ? null : dhuhrMinutes ?? this.dhuhrMinutes,
      asrMinutes: clearAsr ? null : asrMinutes ?? this.asrMinutes,
      maghribMinutes: clearMaghrib
          ? null
          : maghribMinutes ?? this.maghribMinutes,
      ishaMinutes: clearIsha ? null : ishaMinutes ?? this.ishaMinutes,
    );
  }

  PrayerClockTimes withPrayerMinutes(String prayerId, int? minutes) {
    switch (prayerId) {
      case 'fajr':
        return copyWith(fajrMinutes: minutes, clearFajr: minutes == null);
      case 'dhuhr':
        return copyWith(dhuhrMinutes: minutes, clearDhuhr: minutes == null);
      case 'asr':
        return copyWith(asrMinutes: minutes, clearAsr: minutes == null);
      case 'maghrib':
        return copyWith(maghribMinutes: minutes, clearMaghrib: minutes == null);
      case 'isha':
        return copyWith(ishaMinutes: minutes, clearIsha: minutes == null);
      default:
        return this;
    }
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'fajrMinutes': fajrMinutes,
    'dhuhrMinutes': dhuhrMinutes,
    'asrMinutes': asrMinutes,
    'maghribMinutes': maghribMinutes,
    'ishaMinutes': ishaMinutes,
  };

  static PrayerClockTimes fromJson(dynamic raw) {
    if (raw is! Map) return const PrayerClockTimes();
    return PrayerClockTimes(
      fajrMinutes: (raw['fajrMinutes'] as num?)?.toInt(),
      dhuhrMinutes: (raw['dhuhrMinutes'] as num?)?.toInt(),
      asrMinutes: (raw['asrMinutes'] as num?)?.toInt(),
      maghribMinutes: (raw['maghribMinutes'] as num?)?.toInt(),
      ishaMinutes: (raw['ishaMinutes'] as num?)?.toInt(),
    );
  }

  static PrayerClockTimes fromSchedule(List<PrayerScheduleItem> schedule) {
    int? minutesFor(String prayerId) {
      final item = schedule.where((entry) => entry.id == prayerId).firstOrNull;
      if (item == null) return null;
      return item.offerDateTime.hour * 60 + item.offerDateTime.minute;
    }

    return PrayerClockTimes(
      fajrMinutes: minutesFor('fajr'),
      dhuhrMinutes: minutesFor('dhuhr'),
      asrMinutes: minutesFor('asr'),
      maghribMinutes: minutesFor('maghrib'),
      ishaMinutes: minutesFor('isha'),
    );
  }
}

class PrayerTimeAdjustments {
  const PrayerTimeAdjustments({
    this.fajrOffsetMinutes = 0,
    this.dhuhrOffsetMinutes = 0,
    this.asrOffsetMinutes = 0,
    this.maghribOffsetMinutes = 0,
    this.ishaOffsetMinutes = 0,
    this.lastUpdatedAt,
  });

  final int fajrOffsetMinutes;
  final int dhuhrOffsetMinutes;
  final int asrOffsetMinutes;
  final int maghribOffsetMinutes;
  final int ishaOffsetMinutes;
  final DateTime? lastUpdatedAt;

  int offsetForPrayer(String prayerId) {
    switch (prayerId) {
      case 'fajr':
        return fajrOffsetMinutes;
      case 'dhuhr':
        return dhuhrOffsetMinutes;
      case 'asr':
        return asrOffsetMinutes;
      case 'maghrib':
        return maghribOffsetMinutes;
      case 'isha':
        return ishaOffsetMinutes;
      default:
        return 0;
    }
  }

  bool get hasAnyAdjustment =>
      fajrOffsetMinutes != 0 ||
      dhuhrOffsetMinutes != 0 ||
      asrOffsetMinutes != 0 ||
      maghribOffsetMinutes != 0 ||
      ishaOffsetMinutes != 0;

  PrayerTimeAdjustments copyWith({
    int? fajrOffsetMinutes,
    int? dhuhrOffsetMinutes,
    int? asrOffsetMinutes,
    int? maghribOffsetMinutes,
    int? ishaOffsetMinutes,
    DateTime? lastUpdatedAt,
    bool clearTimestamp = false,
  }) {
    return PrayerTimeAdjustments(
      fajrOffsetMinutes: fajrOffsetMinutes ?? this.fajrOffsetMinutes,
      dhuhrOffsetMinutes: dhuhrOffsetMinutes ?? this.dhuhrOffsetMinutes,
      asrOffsetMinutes: asrOffsetMinutes ?? this.asrOffsetMinutes,
      maghribOffsetMinutes: maghribOffsetMinutes ?? this.maghribOffsetMinutes,
      ishaOffsetMinutes: ishaOffsetMinutes ?? this.ishaOffsetMinutes,
      lastUpdatedAt: clearTimestamp
          ? null
          : (lastUpdatedAt ?? this.lastUpdatedAt),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'fajrOffsetMinutes': fajrOffsetMinutes,
    'dhuhrOffsetMinutes': dhuhrOffsetMinutes,
    'asrOffsetMinutes': asrOffsetMinutes,
    'maghribOffsetMinutes': maghribOffsetMinutes,
    'ishaOffsetMinutes': ishaOffsetMinutes,
    'lastUpdatedAt': lastUpdatedAt?.toIso8601String(),
  };

  static PrayerTimeAdjustments fromJson(dynamic raw) {
    if (raw is! Map) return const PrayerTimeAdjustments();
    return PrayerTimeAdjustments(
      fajrOffsetMinutes: (raw['fajrOffsetMinutes'] as num?)?.toInt() ?? 0,
      dhuhrOffsetMinutes: (raw['dhuhrOffsetMinutes'] as num?)?.toInt() ?? 0,
      asrOffsetMinutes: (raw['asrOffsetMinutes'] as num?)?.toInt() ?? 0,
      maghribOffsetMinutes: (raw['maghribOffsetMinutes'] as num?)?.toInt() ?? 0,
      ishaOffsetMinutes: (raw['ishaOffsetMinutes'] as num?)?.toInt() ?? 0,
      lastUpdatedAt: DateTime.tryParse(raw['lastUpdatedAt']?.toString() ?? ''),
    );
  }
}

class PrayerPreferences {
  const PrayerPreferences({
    required this.location,
    required this.madhab,
    required this.calculationMethod,
    this.useDeviceLocation = true,
    this.manualLatitude,
    this.manualLongitude,
    this.useStableDynamicIsland = false,
    this.useStableLockScreenWidget = false,
    this.prayerTimeMode = PrayerTimeMode.calculatedAdjusted,
    this.adjustments = const PrayerTimeAdjustments(),
    this.manualTimes = const PrayerClockTimes(),
    this.mosqueReferenceTimes = const PrayerClockTimes(),
    this.jumuahOverrideEnabled = false,
    this.jumuahTimeMinutes,
    this.fridayReminderMode = FridayReminderMode.normalDhuhr,
    this.activeProfileId = 'default',
    this.lastModeSwitchAt,
  });

  final String location;
  final PrayerMadhab madhab;
  final PrayerCalculationMethod calculationMethod;
  final bool useDeviceLocation;
  final double? manualLatitude;
  final double? manualLongitude;
  final bool useStableDynamicIsland;
  final bool useStableLockScreenWidget;
  final PrayerTimeMode prayerTimeMode;
  final PrayerTimeAdjustments adjustments;
  final PrayerClockTimes manualTimes;
  final PrayerClockTimes mosqueReferenceTimes;
  final bool jumuahOverrideEnabled;
  final int? jumuahTimeMinutes;
  final FridayReminderMode fridayReminderMode;
  final String activeProfileId;
  final DateTime? lastModeSwitchAt;

  PrayerPreferences copyWith({
    String? location,
    PrayerMadhab? madhab,
    PrayerCalculationMethod? calculationMethod,
    bool? useDeviceLocation,
    double? manualLatitude,
    double? manualLongitude,
    bool? useStableDynamicIsland,
    bool? useStableLockScreenWidget,
    PrayerTimeMode? prayerTimeMode,
    PrayerTimeAdjustments? adjustments,
    PrayerClockTimes? manualTimes,
    PrayerClockTimes? mosqueReferenceTimes,
    bool? jumuahOverrideEnabled,
    int? jumuahTimeMinutes,
    FridayReminderMode? fridayReminderMode,
    String? activeProfileId,
    DateTime? lastModeSwitchAt,
    bool clearJumuahTime = false,
    bool clearLastModeSwitchAt = false,
    bool clearManualCoordinates = false,
  }) {
    return PrayerPreferences(
      location: location ?? this.location,
      madhab: madhab ?? this.madhab,
      calculationMethod: calculationMethod ?? this.calculationMethod,
      useDeviceLocation: useDeviceLocation ?? this.useDeviceLocation,
      useStableDynamicIsland:
          useStableDynamicIsland ?? this.useStableDynamicIsland,
      useStableLockScreenWidget:
          useStableLockScreenWidget ?? this.useStableLockScreenWidget,
      prayerTimeMode: prayerTimeMode ?? this.prayerTimeMode,
      adjustments: adjustments ?? this.adjustments,
      manualTimes: manualTimes ?? this.manualTimes,
      mosqueReferenceTimes: mosqueReferenceTimes ?? this.mosqueReferenceTimes,
      jumuahOverrideEnabled:
          jumuahOverrideEnabled ?? this.jumuahOverrideEnabled,
      jumuahTimeMinutes: clearJumuahTime
          ? null
          : jumuahTimeMinutes ?? this.jumuahTimeMinutes,
      fridayReminderMode: fridayReminderMode ?? this.fridayReminderMode,
      activeProfileId: activeProfileId ?? this.activeProfileId,
      lastModeSwitchAt: clearLastModeSwitchAt
          ? null
          : lastModeSwitchAt ?? this.lastModeSwitchAt,
      manualLatitude: clearManualCoordinates
          ? null
          : manualLatitude ?? this.manualLatitude,
      manualLongitude: clearManualCoordinates
          ? null
          : manualLongitude ?? this.manualLongitude,
    );
  }
}

class PrayerScheduleItem {
  const PrayerScheduleItem({
    required this.id,
    required this.name,
    required this.arabicName,
    required this.category,
    required this.offerDateTime,
    required this.windowStartDateTime,
    required this.windowEndDateTime,
    required this.qazaDateTime,
    required this.totalRakats,
    this.overdueAtDateTime,
    this.makeUpAvailableDateTime,
  });

  final String id;
  final String name;
  final String arabicName;
  final String category;
  final DateTime offerDateTime;
  final DateTime windowStartDateTime;
  final DateTime windowEndDateTime;
  final DateTime qazaDateTime;
  final DateTime? overdueAtDateTime;
  final DateTime? makeUpAvailableDateTime;
  final int totalRakats;

  String get offerTime => _formatTime(offerDateTime);
  String get windowStart => _formatTime(windowStartDateTime);
  String get windowEnd => _formatTime(windowEndDateTime);
  String get qaza => _formatTime(qazaDateTime);
  DateTime get overdueDateTime => overdueAtDateTime ?? qazaDateTime;
  String get overdueAt => _formatTime(overdueDateTime);
  DateTime get makeUpFromDateTime => makeUpAvailableDateTime ?? overdueDateTime;
  String get makeUpFrom => _formatTime(makeUpFromDateTime);
  bool get hasDelayedMakeUpWindow =>
      makeUpFromDateTime.isAfter(overdueDateTime);

  String get qadaRuleSummary {
    final l10n = _prayerL10n();
    switch (id) {
      case 'fajr':
        return l10n.prayerQadaRuleFajrSummary;
      case 'dhuhr':
        return l10n.prayerQadaRuleDhuhrSummary;
      case 'asr':
        return l10n.prayerQadaRuleAsrSummary;
      case 'maghrib':
        return l10n.prayerQadaRuleMaghribSummary;
      case 'isha':
        return l10n.prayerQadaRuleIshaSummary;
      default:
        return l10n.prayerQadaRuleDefaultSummary;
    }
  }
}

class PrayerScheduleContext {
  const PrayerScheduleContext({
    required this.items,
    required this.nextPrayerId,
    required this.currentPrayerId,
    required this.remainingToNext,
    required this.progressToNext,
  });

  final List<PrayerScheduleItem> items;
  final String? nextPrayerId;
  final String? currentPrayerId;
  final Duration remainingToNext;
  final double progressToNext;
}

PrayerScheduleContext derivePrayerScheduleContext({
  required List<PrayerScheduleItem> schedule,
  required DateTime now,
}) {
  if (schedule.isEmpty) {
    return const PrayerScheduleContext(
      items: [],
      nextPrayerId: null,
      currentPrayerId: null,
      remainingToNext: Duration.zero,
      progressToNext: 0,
    );
  }

  PrayerScheduleItem? current;
  PrayerScheduleItem? next;

  for (var i = 0; i < schedule.length; i += 1) {
    final item = schedule[i];
    if (!now.isBefore(item.windowStartDateTime) &&
        now.isBefore(item.windowEndDateTime)) {
      current = item;
      next = i + 1 < schedule.length ? schedule[i + 1] : null;
      break;
    }
    if (now.isBefore(item.windowStartDateTime)) {
      next = item;
      break;
    }
  }

  next ??= schedule.first;
  if (current == null && now.isAfter(schedule.last.windowEndDateTime)) {
    current = schedule.last;
  }

  var nextStart = next.windowStartDateTime;
  if (!nextStart.isAfter(now)) {
    nextStart = nextStart.add(const Duration(days: 1));
  }

  final prevAnchor =
      current?.windowStartDateTime ?? now.subtract(const Duration(hours: 1));
  final total = math.max(1, nextStart.difference(prevAnchor).inSeconds);
  final elapsed = now.difference(prevAnchor).inSeconds.clamp(0, total);
  final progress = (elapsed / total).clamp(0.0, 1.0).toDouble();

  return PrayerScheduleContext(
    items: schedule,
    nextPrayerId: next.id,
    currentPrayerId: current?.id,
    remainingToNext: nextStart.difference(now),
    progressToNext: progress,
  );
}

class PrayerLocationState {
  const PrayerLocationState({
    required this.latitude,
    required this.longitude,
    required this.usingDeviceLocation,
  });

  final double latitude;
  final double longitude;
  final bool usingDeviceLocation;
}

class PrayerSettingsState {
  const PrayerSettingsState({
    required this.preferences,
    required this.notificationModes,
    required this.adhanSettings,
  });

  final PrayerPreferences preferences;
  final Map<String, PrayerNotificationMode> notificationModes;
  final AdhanSettings adhanSettings;

  PrayerSettingsState copyWith({
    PrayerPreferences? preferences,
    Map<String, PrayerNotificationMode>? notificationModes,
    AdhanSettings? adhanSettings,
  }) {
    return PrayerSettingsState(
      preferences: preferences ?? this.preferences,
      notificationModes: notificationModes ?? this.notificationModes,
      adhanSettings: adhanSettings ?? this.adhanSettings,
    );
  }
}

class _CityMeta {
  const _CityMeta({
    required this.label,
    required this.latitude,
    required this.longitude,
  });

  final String label;
  final double latitude;
  final double longitude;
}

const _cityMeta = <String, _CityMeta>{
  'Toronto, Canada': _CityMeta(
    label: 'Toronto, Canada',
    latitude: 43.6532,
    longitude: -79.3832,
  ),
  'Dubai, UAE': _CityMeta(
    label: 'Dubai, UAE',
    latitude: 25.2048,
    longitude: 55.2708,
  ),
  'London, UK': _CityMeta(
    label: 'London, UK',
    latitude: 51.5072,
    longitude: -0.1276,
  ),
  'Istanbul, Turkey': _CityMeta(
    label: 'Istanbul, Turkey',
    latitude: 41.0082,
    longitude: 28.9784,
  ),
  'Riyadh, Saudi Arabia': _CityMeta(
    label: 'Riyadh, Saudi Arabia',
    latitude: 24.7136,
    longitude: 46.6753,
  ),
};

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

final prayerSettingsProvider =
    StateNotifierProvider<PrayerSettingsController, PrayerSettingsState>((ref) {
      const defaults = PrayerPreferences(
        location: 'Toronto, Canada',
        madhab: PrayerMadhab.shafii,
        calculationMethod: PrayerCalculationMethod.muslimWorldLeague,
      );
      return PrayerSettingsController(
        defaults: defaults,
        store: ref.watch(localStoreProvider),
      );
    });

class PrayerSettingsController extends StateNotifier<PrayerSettingsState> {
  PrayerSettingsController({
    required PrayerPreferences defaults,
    required LocalStore store,
  }) : _store = store,
       super(
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
           adhanSettings: AdhanSettings.defaults,
         ),
       ) {
    _load(defaults);
  }

  final LocalStore _store;

  void updateLocation(String location) {
    final city = _cityMeta[location];
    state = state.copyWith(
      preferences: state.preferences.copyWith(
        location: location,
        useDeviceLocation: false,
        manualLatitude: city?.latitude,
        manualLongitude: city?.longitude,
        clearManualCoordinates: city == null,
      ),
    );
    _save();
  }

  void setManualLocation({
    required String label,
    required double latitude,
    required double longitude,
  }) {
    state = state.copyWith(
      preferences: state.preferences.copyWith(
        location: label,
        useDeviceLocation: false,
        manualLatitude: latitude,
        manualLongitude: longitude,
      ),
    );
    _save();
  }

  void useCurrentLocation() {
    state = state.copyWith(
      preferences: state.preferences.copyWith(
        useDeviceLocation: true,
        clearManualCoordinates: true,
      ),
    );
    _save();
  }

  void updateMadhab(PrayerMadhab madhab) {
    state = state.copyWith(
      preferences: state.preferences.copyWith(madhab: madhab),
    );
    _save();
  }

  void updateMethod(PrayerCalculationMethod method) {
    state = state.copyWith(
      preferences: state.preferences.copyWith(calculationMethod: method),
    );
    _save();
  }

  void setStableDynamicIsland(bool value) {
    state = state.copyWith(
      preferences: state.preferences.copyWith(useStableDynamicIsland: value),
    );
    _save();
  }

  void setStableLockScreenWidget(bool value) {
    state = state.copyWith(
      preferences: state.preferences.copyWith(useStableLockScreenWidget: value),
    );
    _save();
  }

  void switchPrayerTimeMode({
    required PrayerTimeMode mode,
    required DateTime date,
    required double latitude,
    required double longitude,
  }) {
    var nextManualTimes = state.preferences.manualTimes;
    if (mode == PrayerTimeMode.manual && !nextManualTimes.isComplete) {
      final todaySchedule = buildPrayerScheduleForDate(
        date: date,
        latitude: latitude,
        longitude: longitude,
        settings: state.preferences.copyWith(
          prayerTimeMode: PrayerTimeMode.calculatedAdjusted,
        ),
      );
      nextManualTimes = PrayerClockTimes.fromSchedule(todaySchedule);
    }
    state = state.copyWith(
      preferences: state.preferences.copyWith(
        prayerTimeMode: mode,
        manualTimes: nextManualTimes,
        lastModeSwitchAt: DateTime.now(),
      ),
    );
    _save();
  }

  String? updatePrayerAdjustment({
    required String prayerId,
    required int offsetMinutes,
    required DateTime date,
    required double latitude,
    required double longitude,
  }) {
    final clamped = offsetMinutes.clamp(-30, 30);
    var nextAdjustments = state.preferences.adjustments;
    switch (prayerId) {
      case 'fajr':
        nextAdjustments = nextAdjustments.copyWith(
          fajrOffsetMinutes: clamped,
          lastUpdatedAt: DateTime.now(),
        );
        break;
      case 'dhuhr':
        nextAdjustments = nextAdjustments.copyWith(
          dhuhrOffsetMinutes: clamped,
          lastUpdatedAt: DateTime.now(),
        );
        break;
      case 'asr':
        nextAdjustments = nextAdjustments.copyWith(
          asrOffsetMinutes: clamped,
          lastUpdatedAt: DateTime.now(),
        );
        break;
      case 'maghrib':
        nextAdjustments = nextAdjustments.copyWith(
          maghribOffsetMinutes: clamped,
          lastUpdatedAt: DateTime.now(),
        );
        break;
      case 'isha':
        nextAdjustments = nextAdjustments.copyWith(
          ishaOffsetMinutes: clamped,
          lastUpdatedAt: DateTime.now(),
        );
        break;
      default:
        return _prayerL10n().prayerUnknownAdjustment;
    }
    final validation = validatePrayerAdjustmentsForDate(
      date: date,
      latitude: latitude,
      longitude: longitude,
      settings: state.preferences.copyWith(adjustments: nextAdjustments),
    );
    if (validation != null) return validation;
    state = state.copyWith(
      preferences: state.preferences.copyWith(adjustments: nextAdjustments),
    );
    _save();
    return null;
  }

  String? updateManualPrayerTime({
    required String prayerId,
    required int minutes,
    required DateTime date,
    required double latitude,
    required double longitude,
  }) {
    final nextManualTimes = state.preferences.manualTimes.withPrayerMinutes(
      prayerId,
      minutes.clamp(0, 1439),
    );
    final validation = validateManualPrayerTimesForDate(
      date: date,
      latitude: latitude,
      longitude: longitude,
      settings: state.preferences.copyWith(
        prayerTimeMode: PrayerTimeMode.manual,
        manualTimes: nextManualTimes,
      ),
    );
    if (validation != null) return validation;
    state = state.copyWith(
      preferences: state.preferences.copyWith(manualTimes: nextManualTimes),
    );
    _save();
    return null;
  }

  void initializeManualTimesFromCalculated({
    required DateTime date,
    required double latitude,
    required double longitude,
  }) {
    final effectiveCalculatedSchedule = buildPrayerScheduleForDate(
      date: date,
      latitude: latitude,
      longitude: longitude,
      settings: state.preferences.copyWith(
        prayerTimeMode: PrayerTimeMode.calculatedAdjusted,
      ),
    );
    state = state.copyWith(
      preferences: state.preferences.copyWith(
        manualTimes: PrayerClockTimes.fromSchedule(effectiveCalculatedSchedule),
      ),
    );
    _save();
  }

  void updateMosqueReferenceTime({
    required String prayerId,
    required int? minutes,
  }) {
    state = state.copyWith(
      preferences: state.preferences.copyWith(
        mosqueReferenceTimes: state.preferences.mosqueReferenceTimes
            .withPrayerMinutes(prayerId, minutes),
      ),
    );
    _save();
  }

  void applyPrayerAdjustments(PrayerTimeAdjustments adjustments) {
    state = state.copyWith(
      preferences: state.preferences.copyWith(
        adjustments: adjustments.copyWith(lastUpdatedAt: DateTime.now()),
      ),
    );
    _save();
  }

  void updateJumuahSettings({
    bool? enabled,
    int? jumuahTimeMinutes,
    FridayReminderMode? fridayReminderMode,
    bool clearJumuahTime = false,
  }) {
    state = state.copyWith(
      preferences: state.preferences.copyWith(
        jumuahOverrideEnabled: enabled,
        jumuahTimeMinutes: jumuahTimeMinutes,
        fridayReminderMode: fridayReminderMode,
        clearJumuahTime: clearJumuahTime,
      ),
    );
    _save();
  }

  void resetPrayerAdjustment(String prayerId) {
    updatePrayerAdjustment(
      prayerId: prayerId,
      offsetMinutes: 0,
      date: DateTime.now(),
      latitude:
          _cityMeta[state.preferences.location]?.latitude ??
          _cityMeta.values.first.latitude,
      longitude:
          _cityMeta[state.preferences.location]?.longitude ??
          _cityMeta.values.first.longitude,
    );
  }

  void resetAllPrayerAdjustments() {
    state = state.copyWith(
      preferences: state.preferences.copyWith(
        adjustments: const PrayerTimeAdjustments(lastUpdatedAt: null),
      ),
    );
    _save();
  }

  void resetManualPrayerTimes() {
    state = state.copyWith(
      preferences: state.preferences.copyWith(
        manualTimes: const PrayerClockTimes(),
      ),
    );
    _save();
  }

  void updateNotificationMode(String prayerId, PrayerNotificationMode mode) {
    final updated = Map<String, PrayerNotificationMode>.from(
      state.notificationModes,
    );
    updated[prayerId] = mode;
    state = state.copyWith(notificationModes: updated);
    _save();
  }

  void setAdhanEnabled(bool value) {
    state = state.copyWith(
      adhanSettings: state.adhanSettings.copyWith(enabled: value),
    );
    _save();
  }

  void selectRegularAdhan(String id) {
    state = state.copyWith(
      adhanSettings: state.adhanSettings.copyWith(selectedRegularAdhanId: id),
    );
    _save();
  }

  void selectFajrAdhan(String id) {
    state = state.copyWith(
      adhanSettings: state.adhanSettings.copyWith(selectedFajrAdhanId: id),
    );
    _save();
  }

  void setAdhanVolume(double value) {
    state = state.copyWith(
      adhanSettings: state.adhanSettings.copyWith(
        volume: value.clamp(0.0, 1.0),
      ),
    );
    _save();
  }

  void setUseAppAdhanVolume(bool value) {
    state = state.copyWith(
      adhanSettings: state.adhanSettings.copyWith(useAppVolume: value),
    );
    _save();
  }

  void restoreDefaultAdhanSettings() {
    state = state.copyWith(adhanSettings: AdhanSettings.defaults);
    _save();
  }

  void _load(PrayerPreferences defaults) {
    final data = _store.getJsonMap('settings.prayer');
    if (data == null) return;

    final location = data['location'] as String?;
    final madhabName = data['madhab'] as String?;
    final methodName = data['calculationMethod'] as String?;
    final useDeviceLocation = data['useDeviceLocation'];
    final manualLatitude = data['manualLatitude'];
    final manualLongitude = data['manualLongitude'];
    final legacyUseStablePrayerWidgets = data['useStablePrayerWidgets'];
    final useStableDynamicIsland = data['useStableDynamicIsland'];
    final useStableLockScreenWidget = data['useStableLockScreenWidget'];
    final prayerTimeModeName = data['prayerTimeMode'] as String?;
    final adjustmentsRaw = data['adjustments'];
    final manualTimesRaw = data['manualTimes'];
    final mosqueReferenceTimesRaw = data['mosqueReferenceTimes'];
    final jumuahOverrideEnabled = data['jumuahOverrideEnabled'];
    final jumuahTimeMinutes = data['jumuahTimeMinutes'];
    final fridayReminderModeName = data['fridayReminderMode'] as String?;
    final activeProfileId = data['activeProfileId'] as String?;
    final lastModeSwitchAtRaw = data['lastModeSwitchAt'];
    final notificationsRaw = data['notificationModes'];
    final adhanSettingsRaw = data['adhanSettings'];

    PrayerMadhab madhab = defaults.madhab;
    for (final item in PrayerMadhab.values) {
      if (item.name == madhabName) {
        madhab = item;
        break;
      }
    }

    PrayerCalculationMethod method = defaults.calculationMethod;
    for (final item in PrayerCalculationMethod.values) {
      if (item.name == methodName) {
        method = item;
        break;
      }
    }

    PrayerTimeMode prayerTimeMode = PrayerTimeMode.calculatedAdjusted;
    for (final item in PrayerTimeMode.values) {
      if (item.name == prayerTimeModeName) {
        prayerTimeMode = item;
        break;
      }
    }

    FridayReminderMode fridayReminderMode = FridayReminderMode.normalDhuhr;
    for (final item in FridayReminderMode.values) {
      if (item.name == fridayReminderModeName) {
        fridayReminderMode = item;
        break;
      }
    }

    final restoredNotifications = Map<String, PrayerNotificationMode>.from(
      state.notificationModes,
    );
    if (notificationsRaw is Map) {
      for (final entry in notificationsRaw.entries) {
        final key = entry.key.toString();
        final valueName = entry.value?.toString();
        for (final mode in PrayerNotificationMode.values) {
          if (mode.name == valueName) {
            restoredNotifications[key] = mode;
            break;
          }
        }
      }
    }

    state = state.copyWith(
      preferences: PrayerPreferences(
        location: location ?? defaults.location,
        madhab: madhab,
        calculationMethod: method,
        useDeviceLocation: useDeviceLocation is bool
            ? useDeviceLocation
            : defaults.useDeviceLocation,
        useStableDynamicIsland: useStableDynamicIsland is bool
            ? useStableDynamicIsland
            : legacyUseStablePrayerWidgets is bool
            ? legacyUseStablePrayerWidgets
            : defaults.useStableDynamicIsland,
        useStableLockScreenWidget: useStableLockScreenWidget is bool
            ? useStableLockScreenWidget
            : legacyUseStablePrayerWidgets is bool
            ? legacyUseStablePrayerWidgets
            : defaults.useStableLockScreenWidget,
        prayerTimeMode: prayerTimeMode,
        adjustments: PrayerTimeAdjustments.fromJson(adjustmentsRaw),
        manualTimes: PrayerClockTimes.fromJson(manualTimesRaw),
        mosqueReferenceTimes: PrayerClockTimes.fromJson(
          mosqueReferenceTimesRaw,
        ),
        jumuahOverrideEnabled: jumuahOverrideEnabled is bool
            ? jumuahOverrideEnabled
            : defaults.jumuahOverrideEnabled,
        jumuahTimeMinutes:
            (jumuahTimeMinutes as num?)?.toInt() ?? defaults.jumuahTimeMinutes,
        fridayReminderMode: fridayReminderMode,
        activeProfileId: activeProfileId ?? defaults.activeProfileId,
        lastModeSwitchAt: DateTime.tryParse(
          lastModeSwitchAtRaw?.toString() ?? '',
        ),
        manualLatitude: manualLatitude is num
            ? manualLatitude.toDouble()
            : null,
        manualLongitude: manualLongitude is num
            ? manualLongitude.toDouble()
            : null,
      ),
      notificationModes: restoredNotifications,
      adhanSettings: AdhanSettings.fromJson(adhanSettingsRaw),
    );
  }

  void _save() {
    _store.setJsonMap('settings.prayer', {
      'location': state.preferences.location,
      'madhab': state.preferences.madhab.name,
      'calculationMethod': state.preferences.calculationMethod.name,
      'useDeviceLocation': state.preferences.useDeviceLocation,
      'useStableDynamicIsland': state.preferences.useStableDynamicIsland,
      'useStableLockScreenWidget': state.preferences.useStableLockScreenWidget,
      'prayerTimeMode': state.preferences.prayerTimeMode.name,
      'adjustments': state.preferences.adjustments.toJson(),
      'manualTimes': state.preferences.manualTimes.toJson(),
      'mosqueReferenceTimes': state.preferences.mosqueReferenceTimes.toJson(),
      'jumuahOverrideEnabled': state.preferences.jumuahOverrideEnabled,
      'jumuahTimeMinutes': state.preferences.jumuahTimeMinutes,
      'fridayReminderMode': state.preferences.fridayReminderMode.name,
      'activeProfileId': state.preferences.activeProfileId,
      'lastModeSwitchAt': state.preferences.lastModeSwitchAt?.toIso8601String(),
      'manualLatitude': state.preferences.manualLatitude,
      'manualLongitude': state.preferences.manualLongitude,
      'notificationModes': {
        for (final entry in state.notificationModes.entries)
          entry.key: entry.value.name,
      },
      'adhanSettings': state.adhanSettings.toJson(),
    });
  }
}

class PrayerLocationNotifier extends StateNotifier<PrayerLocationState> {
  PrayerLocationNotifier(this._store, this._preferences)
    : super(_fallbackForPreferences(_preferences)) {
    _loadLastKnown();
    _refresh();
  }

  final LocalStore _store;
  final PrayerPreferences _preferences;

  static PrayerLocationState _fallbackForPreferences(PrayerPreferences prefs) {
    if (!prefs.useDeviceLocation &&
        prefs.manualLatitude != null &&
        prefs.manualLongitude != null) {
      return PrayerLocationState(
        latitude: prefs.manualLatitude!,
        longitude: prefs.manualLongitude!,
        usingDeviceLocation: false,
      );
    }
    final fallback = _cityMeta[prefs.location] ?? _cityMeta.values.first;
    return PrayerLocationState(
      latitude: fallback.latitude,
      longitude: fallback.longitude,
      usingDeviceLocation: false,
    );
  }

  Future<void> _refresh() async {
    if (!_preferences.useDeviceLocation) {
      state = _fallbackForPreferences(_preferences);
      return;
    }
    if (!_supportsLocationPermissionChecks()) {
      state = _fallbackForPreferences(_preferences);
      return;
    }
    final status = await Permission.locationWhenInUse.status;
    if (!status.isGranted) {
      state = _fallbackForPreferences(_preferences);
      return;
    }

    final enabled = await Geolocator.isLocationServiceEnabled();
    if (!enabled) {
      state = _fallbackForPreferences(_preferences);
      return;
    }

    Position? pos;
    try {
      pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.low,
        ),
      );
    } catch (_) {
      pos = await Geolocator.getLastKnownPosition();
    }

    if (pos == null) {
      state = _fallbackForPreferences(_preferences);
      return;
    }

    state = PrayerLocationState(
      latitude: pos.latitude,
      longitude: pos.longitude,
      usingDeviceLocation: true,
    );
    _store.setJsonMap('settings.prayer.deviceCoordinates', {
      'lat': pos.latitude,
      'lng': pos.longitude,
    });
  }

  void _loadLastKnown() {
    if (!_preferences.useDeviceLocation) return;
    final data = _store.getJsonMap('settings.prayer.deviceCoordinates');
    if (data == null) return;
    final lat = data['lat'];
    final lng = data['lng'];
    if (lat is num && lng is num) {
      state = PrayerLocationState(
        latitude: lat.toDouble(),
        longitude: lng.toDouble(),
        usingDeviceLocation: true,
      );
    }
  }
}

bool _supportsLocationPermissionChecks() {
  if (kIsWeb) return false;
  return defaultTargetPlatform == TargetPlatform.android ||
      defaultTargetPlatform == TargetPlatform.iOS;
}

final prayerLocationProvider =
    StateNotifierProvider<PrayerLocationNotifier, PrayerLocationState>((ref) {
      final settings = ref.watch(prayerSettingsProvider).preferences;
      return PrayerLocationNotifier(ref.watch(localStoreProvider), settings);
    });

final availablePrayerLocationsProvider = Provider<List<String>>(
  (ref) => _cityMeta.keys.toList(),
);

final prayerLocationDisplayLabelProvider = FutureProvider<String>((ref) async {
  final preferences = ref.watch(prayerSettingsProvider).preferences;
  if (!preferences.useDeviceLocation) return preferences.location;
  final location = ref.watch(prayerLocationProvider);
  if (!location.usingDeviceLocation) return preferences.location;
  final service = ref.watch(prayerLocationSearchServiceProvider);
  return await service.reverseLookup(
        latitude: location.latitude,
        longitude: location.longitude,
      ) ??
      'Current location';
});

final prayerScheduleProvider = Provider<List<PrayerScheduleItem>>((ref) {
  final settings = ref.watch(prayerSettingsProvider).preferences;
  final location = ref.watch(prayerLocationProvider);
  final now = ref.watch(dailyNowProvider).value ?? DateTime.now();
  return buildPrayerScheduleForDate(
    date: now,
    latitude: location.latitude,
    longitude: location.longitude,
    settings: settings,
  );
});

final prayerBaseScheduleProvider = Provider<List<PrayerScheduleItem>>((ref) {
  final settings = ref.watch(prayerSettingsProvider).preferences;
  final location = ref.watch(prayerLocationProvider);
  final now = ref.watch(dailyNowProvider).value ?? DateTime.now();
  return buildPrayerScheduleForDate(
    date: now,
    latitude: location.latitude,
    longitude: location.longitude,
    settings: settings,
    applyAdjustments: false,
  );
});

final prayerScheduleContextProvider = Provider<PrayerScheduleContext>((ref) {
  final schedule = ref.watch(prayerScheduleProvider);
  final now = ref.watch(dailyNowProvider).value ?? DateTime.now();
  return derivePrayerScheduleContext(
    schedule: schedule,
    now: now,
  );
});

List<PrayerScheduleItem> buildPrayerScheduleForDate({
  required DateTime date,
  required double latitude,
  required double longitude,
  required PrayerPreferences settings,
  bool applyAdjustments = true,
}) {
  final baseSchedule = buildCalculatedPrayerScheduleForDate(
    date: date,
    latitude: latitude,
    longitude: longitude,
    settings: settings,
  );
  if (!applyAdjustments) {
    return baseSchedule;
  }
  if (settings.prayerTimeMode == PrayerTimeMode.manual &&
      settings.manualTimes.isComplete) {
    return buildManualPrayerScheduleForDate(
      date: date,
      latitude: latitude,
      longitude: longitude,
      settings: settings,
      baseSchedule: baseSchedule,
    ).map((item) => _applyFridayJumuahDisplayOverride(item, date)).toList(
      growable: false,
    );
  }
  return applyCalculatedPrayerAdjustments(
    date: date,
    latitude: latitude,
    longitude: longitude,
    settings: settings,
    baseSchedule: baseSchedule,
  ).map((item) => _applyFridayJumuahDisplayOverride(item, date)).toList(
    growable: false,
  );
}

List<PrayerScheduleItem> buildCalculatedPrayerScheduleForDate({
  required DateTime date,
  required double latitude,
  required double longitude,
  required PrayerPreferences settings,
}) {
  final coordinates = adhan.Coordinates(latitude, longitude);
  final params = _adhanMethod(settings.calculationMethod).getParameters();
  params.madhab = settings.madhab == PrayerMadhab.hanafi
      ? adhan.Madhab.hanafi
      : adhan.Madhab.shafi;

  final today = adhan.PrayerTimes(
    coordinates,
    adhan.DateComponents.from(date),
    params,
  );

  final tomorrow = adhan.PrayerTimes(
    coordinates,
    adhan.DateComponents.from(date.add(const Duration(days: 1))),
    params,
  );

  const adjustments = PrayerTimeAdjustments();
  final adjustedFajr = today.fajr.add(
    Duration(minutes: adjustments.fajrOffsetMinutes),
  );
  final adjustedDhuhr = today.dhuhr.add(
    Duration(minutes: adjustments.dhuhrOffsetMinutes),
  );
  final adjustedAsr = today.asr.add(
    Duration(minutes: adjustments.asrOffsetMinutes),
  );
  final adjustedMaghrib = today.maghrib.add(
    Duration(minutes: adjustments.maghribOffsetMinutes),
  );
  final adjustedIsha = today.isha.add(
    Duration(minutes: adjustments.ishaOffsetMinutes),
  );
  final tomorrowAdjustedFajr = tomorrow.fajr.add(
    Duration(minutes: adjustments.fajrOffsetMinutes),
  );
  final tahajjudStart = adjustedIsha.add(
    Duration(
      seconds:
          ((tomorrowAdjustedFajr.difference(adjustedIsha).inSeconds) * 0.66)
              .round(),
    ),
  );
  const safeSunriseQadaDelay = Duration(minutes: 20);

  return [
    PrayerScheduleItem(
      id: 'fajr',
      name: 'Fajr',
      arabicName: 'الفجر',
      category: 'Fardh',
      offerDateTime: adjustedFajr,
      windowStartDateTime: adjustedFajr,
      windowEndDateTime: today.sunrise,
      qazaDateTime: today.sunrise,
      overdueAtDateTime: today.sunrise,
      makeUpAvailableDateTime: today.sunrise.add(safeSunriseQadaDelay),
      totalRakats: 2,
    ),
    PrayerScheduleItem(
      id: 'dhuhr',
      name: 'Dhuhr',
      arabicName: 'الظهر',
      category: 'Fardh',
      offerDateTime: adjustedDhuhr,
      windowStartDateTime: adjustedDhuhr,
      windowEndDateTime: adjustedAsr,
      qazaDateTime: adjustedAsr,
      overdueAtDateTime: adjustedAsr,
      totalRakats: 4,
    ),
    PrayerScheduleItem(
      id: 'asr',
      name: 'Asr',
      arabicName: 'العصر',
      category: 'Fardh',
      offerDateTime: adjustedAsr,
      windowStartDateTime: adjustedAsr,
      windowEndDateTime: adjustedMaghrib,
      qazaDateTime: adjustedMaghrib,
      overdueAtDateTime: adjustedMaghrib,
      totalRakats: 4,
    ),
    PrayerScheduleItem(
      id: 'maghrib',
      name: 'Maghrib',
      arabicName: 'المغرب',
      category: 'Fardh',
      offerDateTime: adjustedMaghrib,
      windowStartDateTime: adjustedMaghrib,
      windowEndDateTime: adjustedIsha,
      qazaDateTime: adjustedIsha,
      overdueAtDateTime: adjustedIsha,
      totalRakats: 3,
    ),
    PrayerScheduleItem(
      id: 'isha',
      name: 'Isha',
      arabicName: 'العشاء',
      category: 'Fardh',
      offerDateTime: adjustedIsha,
      windowStartDateTime: adjustedIsha,
      windowEndDateTime: tahajjudStart,
      qazaDateTime: tomorrowAdjustedFajr,
      overdueAtDateTime: tomorrowAdjustedFajr,
      totalRakats: 4,
    ),
    PrayerScheduleItem(
      id: 'tahajjud',
      name: 'Tahajjud',
      arabicName: 'التهجد',
      category: 'Nafl',
      offerDateTime: tahajjudStart,
      windowStartDateTime: tahajjudStart,
      windowEndDateTime: tomorrowAdjustedFajr,
      qazaDateTime: tomorrowAdjustedFajr,
      totalRakats: 3,
    ),
  ];
}

List<PrayerScheduleItem> applyCalculatedPrayerAdjustments({
  required DateTime date,
  required double latitude,
  required double longitude,
  required PrayerPreferences settings,
  List<PrayerScheduleItem>? baseSchedule,
}) {
  final base =
      baseSchedule ??
      buildCalculatedPrayerScheduleForDate(
        date: date,
        latitude: latitude,
        longitude: longitude,
        settings: settings,
      );
  final adjustments = settings.adjustments;
  return base
      .map((item) {
        final minutes = adjustments.offsetForPrayer(item.id);
        if (minutes == 0) return item;
        final delta = Duration(minutes: minutes);
        return PrayerScheduleItem(
          id: item.id,
          name: item.name,
          arabicName: item.arabicName,
          category: item.category,
          offerDateTime: item.offerDateTime.add(delta),
          windowStartDateTime: item.windowStartDateTime.add(delta),
          windowEndDateTime: item.windowEndDateTime.add(delta),
          qazaDateTime: item.qazaDateTime.add(delta),
          overdueAtDateTime: item.overdueAtDateTime?.add(delta),
          makeUpAvailableDateTime: item.makeUpAvailableDateTime?.add(delta),
          totalRakats: item.totalRakats,
        );
      })
      .toList(growable: false);
}

List<PrayerScheduleItem> buildManualPrayerScheduleForDate({
  required DateTime date,
  required double latitude,
  required double longitude,
  required PrayerPreferences settings,
  List<PrayerScheduleItem>? baseSchedule,
}) {
  final base =
      baseSchedule ??
      buildCalculatedPrayerScheduleForDate(
        date: date,
        latitude: latitude,
        longitude: longitude,
        settings: settings,
      );
  final nextDayBase = buildCalculatedPrayerScheduleForDate(
    date: date.add(const Duration(days: 1)),
    latitude: latitude,
    longitude: longitude,
    settings: settings,
  );

  final manual = settings.manualTimes;
  final fajr = _dateWithMinutes(date, manual.fajrMinutes!);
  final dhuhr = _dateWithMinutes(date, manual.dhuhrMinutes!);
  final asr = _dateWithMinutes(date, manual.asrMinutes!);
  final maghrib = _dateWithMinutes(date, manual.maghribMinutes!);
  final isha = _dateWithMinutes(date, manual.ishaMinutes!);
  final nextFajr = _dateWithMinutes(
    date.add(const Duration(days: 1)),
    manual.fajrMinutes!,
  );
  final sunrise = base.firstWhere((item) => item.id == 'fajr').qazaDateTime;
  final tahajjudStart = isha.add(
    Duration(seconds: ((nextFajr.difference(isha).inSeconds) * 0.66).round()),
  );
  final nextSunrise = nextDayBase
      .firstWhere((item) => item.id == 'fajr')
      .qazaDateTime;
  const safeSunriseQadaDelay = Duration(minutes: 20);

  return [
    PrayerScheduleItem(
      id: 'fajr',
      name: 'Fajr',
      arabicName: 'الفجر',
      category: 'Fardh',
      offerDateTime: fajr,
      windowStartDateTime: fajr,
      windowEndDateTime: sunrise,
      qazaDateTime: sunrise,
      overdueAtDateTime: sunrise,
      makeUpAvailableDateTime: sunrise.add(safeSunriseQadaDelay),
      totalRakats: 2,
    ),
    PrayerScheduleItem(
      id: 'dhuhr',
      name: 'Dhuhr',
      arabicName: 'الظهر',
      category: 'Fardh',
      offerDateTime: dhuhr,
      windowStartDateTime: dhuhr,
      windowEndDateTime: asr,
      qazaDateTime: asr,
      overdueAtDateTime: asr,
      totalRakats: 4,
    ),
    PrayerScheduleItem(
      id: 'asr',
      name: 'Asr',
      arabicName: 'العصر',
      category: 'Fardh',
      offerDateTime: asr,
      windowStartDateTime: asr,
      windowEndDateTime: maghrib,
      qazaDateTime: maghrib,
      overdueAtDateTime: maghrib,
      totalRakats: 4,
    ),
    PrayerScheduleItem(
      id: 'maghrib',
      name: 'Maghrib',
      arabicName: 'المغرب',
      category: 'Fardh',
      offerDateTime: maghrib,
      windowStartDateTime: maghrib,
      windowEndDateTime: isha,
      qazaDateTime: isha,
      overdueAtDateTime: isha,
      totalRakats: 3,
    ),
    PrayerScheduleItem(
      id: 'isha',
      name: 'Isha',
      arabicName: 'العشاء',
      category: 'Fardh',
      offerDateTime: isha,
      windowStartDateTime: isha,
      windowEndDateTime: tahajjudStart,
      qazaDateTime: nextFajr,
      overdueAtDateTime: nextFajr,
      totalRakats: 4,
    ),
    PrayerScheduleItem(
      id: 'tahajjud',
      name: 'Tahajjud',
      arabicName: 'التهجد',
      category: 'Nafl',
      offerDateTime: tahajjudStart,
      windowStartDateTime: tahajjudStart,
      windowEndDateTime: nextFajr,
      qazaDateTime: nextSunrise,
      totalRakats: 3,
    ),
  ];
}

String? validatePrayerAdjustmentsForDate({
  required DateTime date,
  required double latitude,
  required double longitude,
  required PrayerPreferences settings,
}) {
  final schedule =
      buildPrayerScheduleForDate(
            date: date,
            latitude: latitude,
            longitude: longitude,
            settings: settings,
            applyAdjustments: true,
          )
          .where(
            (item) => const [
              'fajr',
              'dhuhr',
              'asr',
              'maghrib',
              'isha',
            ].contains(item.id),
          )
          .toList(growable: false);
  for (var i = 0; i < schedule.length - 1; i += 1) {
    final current = schedule[i];
    final next = schedule[i + 1];
    if (!current.offerDateTime.isBefore(next.offerDateTime)) {
      final l10n = _prayerL10n();
      return l10n.prayerValidationMustRemainBefore(
        _localizedPrayerName(current.id, l10n),
        _localizedPrayerName(next.id, l10n),
        _localizedPrayerName(current.id, l10n),
        _localizedPrayerName(current.id, l10n),
        _localizedPrayerName(next.id, l10n),
        _localizedPrayerName(next.id, l10n),
      );
    }
  }
  return null;
}

String? validateManualPrayerTimesForDate({
  required DateTime date,
  required double latitude,
  required double longitude,
  required PrayerPreferences settings,
}) {
  if (!settings.manualTimes.isComplete) {
    return _prayerL10n().prayerValidationEnterAllFiveDailySalahTimes;
  }
  final schedule =
      buildManualPrayerScheduleForDate(
            date: date,
            latitude: latitude,
            longitude: longitude,
            settings: settings,
          )
          .where((item) {
            return const [
              'fajr',
              'dhuhr',
              'asr',
              'maghrib',
              'isha',
            ].contains(item.id);
          })
          .toList(growable: false);
  for (var i = 0; i < schedule.length - 1; i += 1) {
    if (!schedule[i].offerDateTime.isBefore(schedule[i + 1].offerDateTime)) {
      final l10n = _prayerL10n();
      return l10n.prayerValidationMustRemainBefore(
        _localizedPrayerName(schedule[i].id, l10n),
        _localizedPrayerName(schedule[i + 1].id, l10n),
        _localizedPrayerName(schedule[i].id, l10n),
        _localizedPrayerName(schedule[i].id, l10n),
        _localizedPrayerName(schedule[i + 1].id, l10n),
        _localizedPrayerName(schedule[i + 1].id, l10n),
      );
    }
  }
  final baseFajr = buildCalculatedPrayerScheduleForDate(
    date: date,
    latitude: latitude,
    longitude: longitude,
    settings: settings,
  ).firstWhere((item) => item.id == 'fajr');
  if (!schedule.first.offerDateTime.isBefore(baseFajr.qazaDateTime)) {
    return _prayerL10n().prayerValidationFajrBeforeSunrise;
  }
  return null;
}

AppLocalizations _prayerL10n() {
  final locale = Intl.getCurrentLocale().replaceAll('-', '_').split('_');
  return lookupAppLocalizations(
    Locale.fromSubtags(
      languageCode: locale.isNotEmpty && locale.first.isNotEmpty
          ? locale.first
          : 'en',
      countryCode: locale.length > 1 ? locale.last : null,
    ),
  );
}

String _localizedPrayerName(String prayerId, AppLocalizations l10n) {
  return localizedPrayerNameForDate(prayerId: prayerId, l10n: l10n);
}

bool isJumuahDate(DateTime date) => date.weekday == DateTime.friday;

DateTime jumuahDisplayDateTimeFor(DateTime date) {
  return DateTime(
    date.year,
    date.month,
    date.day,
    defaultJumuahDisplayMinutes ~/ 60,
    defaultJumuahDisplayMinutes % 60,
  );
}

String localizedPrayerNameForDate({
  required String prayerId,
  required AppLocalizations l10n,
  DateTime? date,
}) {
  if (prayerId == 'dhuhr' && date != null && isJumuahDate(date)) {
    return l10n.settingsPrayerNameJumuah;
  }
  switch (prayerId) {
    case 'fajr':
      return l10n.settingsPrayerNameFajr;
    case 'dhuhr':
      return l10n.settingsPrayerNameDhuhr;
    case 'asr':
      return l10n.settingsPrayerNameAsr;
    case 'maghrib':
      return l10n.settingsPrayerNameMaghrib;
    case 'isha':
      return l10n.settingsPrayerNameIsha;
    default:
      return prayerId;
  }
}

String arabicPrayerNameForDate({required String prayerId, DateTime? date}) {
  if (prayerId == 'dhuhr' && date != null && isJumuahDate(date)) {
    return 'الجمعة';
  }
  switch (prayerId) {
    case 'fajr':
      return 'الفجر';
    case 'dhuhr':
      return 'الظهر';
    case 'asr':
      return 'العصر';
    case 'maghrib':
      return 'المغرب';
    case 'isha':
      return 'العشاء';
    case 'tahajjud':
      return 'التهجد';
    default:
      return prayerId;
  }
}

PrayerScheduleItem _applyFridayJumuahDisplayOverride(
  PrayerScheduleItem item,
  DateTime date,
) {
  if (item.id != 'dhuhr' || !isJumuahDate(date)) {
    return item;
  }
  final jumuahTime = jumuahDisplayDateTimeFor(date);
  return PrayerScheduleItem(
    id: item.id,
    name: item.name,
    arabicName: item.arabicName,
    category: item.category,
    offerDateTime: jumuahTime,
    windowStartDateTime: jumuahTime,
    windowEndDateTime: item.windowEndDateTime,
    qazaDateTime: item.qazaDateTime,
    overdueAtDateTime: item.overdueAtDateTime,
    makeUpAvailableDateTime: item.makeUpAvailableDateTime,
    totalRakats: 2,
  );
}

DateTime _dateWithMinutes(DateTime date, int minutes) {
  final normalized = minutes.clamp(0, 1439);
  return DateTime(
    date.year,
    date.month,
    date.day,
    normalized ~/ 60,
    normalized % 60,
  );
}

String _formatTime(DateTime value) => DateFormat.jm().format(value);

adhan.CalculationMethod _adhanMethod(PrayerCalculationMethod method) {
  switch (method) {
    case PrayerCalculationMethod.muslimWorldLeague:
      return adhan.CalculationMethod.muslim_world_league;
    case PrayerCalculationMethod.egyptian:
      return adhan.CalculationMethod.egyptian;
    case PrayerCalculationMethod.isna:
      return adhan.CalculationMethod.north_america;
    case PrayerCalculationMethod.karachi:
      return adhan.CalculationMethod.karachi;
    case PrayerCalculationMethod.ummAlQura:
      return adhan.CalculationMethod.umm_al_qura;
  }
}
