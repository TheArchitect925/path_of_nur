import 'dart:math' as math;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../worship/domain/prayer_calendar_mode.dart';
import '../domain/profile_age_preferences.dart';
import '../../../shared/persistence/local_store.dart';

enum ProfileThemePreference { system, dark, light }

const double kGlassTransparencyLevelMin = 0.0;
const double kGlassTransparencyLevelMax = 1.0;
const double kGlassTransparencyLevelDefault = 0.145;
const double kGlassSurfaceAlphaMin = 0.82;
const double kGlassSurfaceAlphaMax = 0.95;

double glassSurfaceAlphaFromLevel(double level) {
  final clamped = normalizedGlassTransparencyLevel(level);
  final eased = 1 - math.pow(1 - clamped, 2).toDouble();
  return kGlassSurfaceAlphaMax -
      ((kGlassSurfaceAlphaMax - kGlassSurfaceAlphaMin) * eased);
}

double normalizedGlassTransparencyLevel(double level) {
  return level.clamp(kGlassTransparencyLevelMin, kGlassTransparencyLevelMax);
}

class ProfileSettingsState {
  const ProfileSettingsState({
    required this.themePreference,
    required this.ageRange,
    required this.kidsUiThemeMode,
    required this.reduceMotion,
    required this.pageTransitionStyle,
    required this.highContrastText,
    required this.ramadanModeEnabled,
    required this.lossModeEnabled,
    required this.gentleModeEnabled,
    required this.unwellModeEnabled,
    required this.kidsModeEnabled,
    required this.privateTrackingMode,
    required this.minimalTrackingMode,
    required this.hideGrowthVisuals,
    required this.reflectionOnlyMode,
    required this.prayerReminders,
    required this.prayerReminderFollowUpEnabled,
    required this.prayerReminderFollowUpDelayMinutes,
    required this.prayerReminderSnoozeMinutes,
    required this.dhikrReminders,
    required this.quranReminders,
    required this.reflectionReminders,
    required this.fastingReminders,
    required this.onThisDayReminders,
    required this.moonriseReminders,
    required this.moonsetReminders,
    required this.appThemeMode,
    required this.prayerCalendarMode,
    required this.disableGlassTransparency,
    required this.disableColoredGlass,
    required this.dressUpFridays,
    required this.glassTransparencyLevel,
    required this.disableBackground,
    this.ramadanStartDateIso,
    this.ramadanEndDateIso,
  });

  final ProfileThemePreference themePreference;
  final ProfileAgeRange ageRange;
  final KidsUiThemeMode kidsUiThemeMode;
  final bool reduceMotion;
  final AppPageTransitionStyle pageTransitionStyle;
  final bool highContrastText;
  final bool ramadanModeEnabled;
  final bool lossModeEnabled;
  final bool gentleModeEnabled;
  final bool unwellModeEnabled;
  final bool kidsModeEnabled;
  final bool privateTrackingMode;
  final bool minimalTrackingMode;
  final bool hideGrowthVisuals;
  final bool reflectionOnlyMode;
  final bool prayerReminders;
  final bool prayerReminderFollowUpEnabled;
  final int prayerReminderFollowUpDelayMinutes;
  final int prayerReminderSnoozeMinutes;
  final bool dhikrReminders;
  final bool quranReminders;
  final bool reflectionReminders;
  final bool fastingReminders;
  final bool onThisDayReminders;
  final bool moonriseReminders;
  final bool moonsetReminders;
  final AppThemeMode appThemeMode;
  final PrayerCalendarMode prayerCalendarMode;
  final bool disableGlassTransparency;
  final bool disableColoredGlass;

  /// Wear the Jumu'ah (Masjid Emerald) theme every Friday, reverting after.
  final bool dressUpFridays;
  final double glassTransparencyLevel;
  final bool disableBackground;
  final String? ramadanStartDateIso;
  final String? ramadanEndDateIso;

  bool get effectiveKidsUiThemeEnabled =>
      resolveKidsUiThemeEnabled(ageRange: ageRange, mode: kidsUiThemeMode);

  double get glassSurfaceAlpha =>
      glassSurfaceAlphaFromLevel(glassTransparencyLevel);

  int get glassTransparencyPercent =>
      (glassTransparencyLevel * 100).round().clamp(0, 100);

  ProfileSettingsState copyWith({
    ProfileThemePreference? themePreference,
    ProfileAgeRange? ageRange,
    KidsUiThemeMode? kidsUiThemeMode,
    bool? reduceMotion,
    AppPageTransitionStyle? pageTransitionStyle,
    bool? highContrastText,
    bool? ramadanModeEnabled,
    bool? lossModeEnabled,
    bool? gentleModeEnabled,
    bool? unwellModeEnabled,
    bool? kidsModeEnabled,
    bool? privateTrackingMode,
    bool? minimalTrackingMode,
    bool? hideGrowthVisuals,
    bool? reflectionOnlyMode,
    bool? prayerReminders,
    bool? prayerReminderFollowUpEnabled,
    int? prayerReminderFollowUpDelayMinutes,
    int? prayerReminderSnoozeMinutes,
    bool? dhikrReminders,
    bool? quranReminders,
    bool? reflectionReminders,
    bool? fastingReminders,
    bool? onThisDayReminders,
    bool? moonriseReminders,
    bool? moonsetReminders,
    AppThemeMode? appThemeMode,
    PrayerCalendarMode? prayerCalendarMode,
    bool? disableGlassTransparency,
    bool? disableColoredGlass,
    bool? dressUpFridays,
    double? glassTransparencyLevel,
    bool? disableBackground,
    String? ramadanStartDateIso,
    String? ramadanEndDateIso,
  }) {
    return ProfileSettingsState(
      themePreference: themePreference ?? this.themePreference,
      ageRange: ageRange ?? this.ageRange,
      kidsUiThemeMode: kidsUiThemeMode ?? this.kidsUiThemeMode,
      reduceMotion: reduceMotion ?? this.reduceMotion,
      pageTransitionStyle: pageTransitionStyle ?? this.pageTransitionStyle,
      highContrastText: highContrastText ?? this.highContrastText,
      ramadanModeEnabled: ramadanModeEnabled ?? this.ramadanModeEnabled,
      lossModeEnabled: lossModeEnabled ?? this.lossModeEnabled,
      gentleModeEnabled: gentleModeEnabled ?? this.gentleModeEnabled,
      unwellModeEnabled: unwellModeEnabled ?? this.unwellModeEnabled,
      kidsModeEnabled: kidsModeEnabled ?? this.kidsModeEnabled,
      privateTrackingMode: privateTrackingMode ?? this.privateTrackingMode,
      minimalTrackingMode: minimalTrackingMode ?? this.minimalTrackingMode,
      hideGrowthVisuals: hideGrowthVisuals ?? this.hideGrowthVisuals,
      reflectionOnlyMode: reflectionOnlyMode ?? this.reflectionOnlyMode,
      prayerReminders: prayerReminders ?? this.prayerReminders,
      prayerReminderFollowUpEnabled:
          prayerReminderFollowUpEnabled ?? this.prayerReminderFollowUpEnabled,
      prayerReminderFollowUpDelayMinutes:
          prayerReminderFollowUpDelayMinutes ??
          this.prayerReminderFollowUpDelayMinutes,
      prayerReminderSnoozeMinutes:
          prayerReminderSnoozeMinutes ?? this.prayerReminderSnoozeMinutes,
      dhikrReminders: dhikrReminders ?? this.dhikrReminders,
      quranReminders: quranReminders ?? this.quranReminders,
      reflectionReminders: reflectionReminders ?? this.reflectionReminders,
      fastingReminders: fastingReminders ?? this.fastingReminders,
      onThisDayReminders: onThisDayReminders ?? this.onThisDayReminders,
      moonriseReminders: moonriseReminders ?? this.moonriseReminders,
      moonsetReminders: moonsetReminders ?? this.moonsetReminders,
      appThemeMode: appThemeMode ?? this.appThemeMode,
      prayerCalendarMode: prayerCalendarMode ?? this.prayerCalendarMode,
      disableGlassTransparency:
          disableGlassTransparency ?? this.disableGlassTransparency,
      disableColoredGlass: disableColoredGlass ?? this.disableColoredGlass,
      dressUpFridays: dressUpFridays ?? this.dressUpFridays,
      glassTransparencyLevel: glassTransparencyLevel == null
          ? this.glassTransparencyLevel
          : normalizedGlassTransparencyLevel(glassTransparencyLevel),
      disableBackground: disableBackground ?? this.disableBackground,
      ramadanStartDateIso: ramadanStartDateIso ?? this.ramadanStartDateIso,
      ramadanEndDateIso: ramadanEndDateIso ?? this.ramadanEndDateIso,
    );
  }
}

class ProfileSettingsNotifier extends StateNotifier<ProfileSettingsState> {
  ProfileSettingsNotifier(this._store)
    : super(
        const ProfileSettingsState(
          themePreference: ProfileThemePreference.light,
          ageRange: ProfileAgeRange.adult,
          kidsUiThemeMode: KidsUiThemeMode.auto,
          reduceMotion: false,
          pageTransitionStyle: AppPageTransitionStyle.defaultSystem,
          highContrastText: false,
          ramadanModeEnabled: false,
          lossModeEnabled: false,
          gentleModeEnabled: true,
          unwellModeEnabled: false,
          kidsModeEnabled: false,
          privateTrackingMode: false,
          minimalTrackingMode: false,
          hideGrowthVisuals: false,
          reflectionOnlyMode: false,
          prayerReminders: true,
          prayerReminderFollowUpEnabled: true,
          prayerReminderFollowUpDelayMinutes: 20,
          prayerReminderSnoozeMinutes: 10,
          dhikrReminders: true,
          quranReminders: false,
          reflectionReminders: false,
          fastingReminders: false,
          onThisDayReminders: false,
          moonriseReminders: true,
          moonsetReminders: true,
          appThemeMode: AppThemeMode.noorGlass,
          prayerCalendarMode: PrayerCalendarMode.gregorian,
          disableGlassTransparency: false,
          disableColoredGlass: false,
          dressUpFridays: false,
          glassTransparencyLevel: kGlassTransparencyLevelDefault,
          disableBackground: false,
        ),
      ) {
    _load();
  }

  final LocalStore _store;

  void setThemePreference(ProfileThemePreference value) {
    state = state.copyWith(themePreference: value);
    _save();
  }

  void setAgeRange(ProfileAgeRange value) {
    state = state.copyWith(
      ageRange: value,
      kidsModeEnabled: resolveKidsUiThemeEnabled(
        ageRange: value,
        mode: state.kidsUiThemeMode,
      ),
    );
    _save();
  }

  void setKidsUiThemeMode(KidsUiThemeMode value) {
    state = state.copyWith(
      kidsUiThemeMode: value,
      kidsModeEnabled: resolveKidsUiThemeEnabled(
        ageRange: state.ageRange,
        mode: value,
      ),
    );
    _save();
  }

  void setReduceMotion(bool value) {
    state = state.copyWith(reduceMotion: value);
    _save();
  }

  void setPageTransitionStyle(AppPageTransitionStyle value) {
    state = state.copyWith(pageTransitionStyle: value);
    _save();
  }

  void setHighContrastText(bool value) {
    state = state.copyWith(highContrastText: value);
    _save();
  }

  void setRamadanModeEnabled(bool value) {
    state = state.copyWith(
      ramadanModeEnabled: value,
      lossModeEnabled: value ? false : state.lossModeEnabled,
      gentleModeEnabled: value ? false : state.gentleModeEnabled,
      unwellModeEnabled: value ? false : state.unwellModeEnabled,
    );
    _save();
  }

  void setLossModeEnabled(bool value) {
    state = state.copyWith(
      lossModeEnabled: value,
      ramadanModeEnabled: value ? false : state.ramadanModeEnabled,
      gentleModeEnabled: value ? false : state.gentleModeEnabled,
      unwellModeEnabled: value ? false : state.unwellModeEnabled,
    );
    _save();
  }

  void setGentleModeEnabled(bool value) {
    state = state.copyWith(
      gentleModeEnabled: value,
      ramadanModeEnabled: value ? false : state.ramadanModeEnabled,
      lossModeEnabled: value ? false : state.lossModeEnabled,
      unwellModeEnabled: value ? false : state.unwellModeEnabled,
    );
    _save();
  }

  void setUnwellModeEnabled(bool value) {
    state = state.copyWith(
      unwellModeEnabled: value,
      ramadanModeEnabled: value ? false : state.ramadanModeEnabled,
      lossModeEnabled: value ? false : state.lossModeEnabled,
      gentleModeEnabled: value ? false : state.gentleModeEnabled,
    );
    _save();
  }

  void setKidsModeEnabled(bool value) {
    state = state.copyWith(
      kidsUiThemeMode: value ? KidsUiThemeMode.on : KidsUiThemeMode.off,
      kidsModeEnabled: value,
    );
    _save();
  }

  void setRamadanDateRange({DateTime? start, DateTime? end}) {
    state = state.copyWith(
      ramadanStartDateIso: start?.toIso8601String(),
      ramadanEndDateIso: end?.toIso8601String(),
    );
    _save();
  }

  void clearRamadanDateRange() {
    state = state.copyWith(ramadanStartDateIso: '', ramadanEndDateIso: '');
    _save();
  }

  void setPrivateTrackingMode(bool value) {
    state = state.copyWith(privateTrackingMode: value);
    _save();
  }

  void setMinimalTrackingMode(bool value) {
    state = state.copyWith(minimalTrackingMode: value);
    _save();
  }

  void setHideGrowthVisuals(bool value) {
    state = state.copyWith(hideGrowthVisuals: value);
    _save();
  }

  void setReflectionOnlyMode(bool value) {
    state = state.copyWith(reflectionOnlyMode: value);
    _save();
  }

  void setPrayerReminders(bool value) {
    state = state.copyWith(prayerReminders: value);
    _save();
  }

  void setPrayerReminderFollowUpEnabled(bool value) {
    state = state.copyWith(prayerReminderFollowUpEnabled: value);
    _save();
  }

  void setPrayerReminderFollowUpDelayMinutes(int value) {
    state = state.copyWith(
      prayerReminderFollowUpDelayMinutes: value.clamp(1, 120),
    );
    _save();
  }

  void setPrayerReminderSnoozeMinutes(int value) {
    state = state.copyWith(prayerReminderSnoozeMinutes: value.clamp(1, 60));
    _save();
  }

  void setDhikrReminders(bool value) {
    state = state.copyWith(dhikrReminders: value);
    _save();
  }

  void setQuranReminders(bool value) {
    state = state.copyWith(quranReminders: value);
    _save();
  }

  void setReflectionReminders(bool value) {
    state = state.copyWith(reflectionReminders: value);
    _save();
  }

  void setFastingReminders(bool value) {
    state = state.copyWith(fastingReminders: value);
    _save();
  }

  void setOnThisDayReminders(bool value) {
    state = state.copyWith(onThisDayReminders: value);
    _save();
  }

  void setMoonriseReminders(bool value) {
    state = state.copyWith(moonriseReminders: value);
    _save();
  }

  void setMoonsetReminders(bool value) {
    state = state.copyWith(moonsetReminders: value);
    _save();
  }

  void setAppThemeMode(AppThemeMode mode) {
    state = state.copyWith(
      appThemeMode: mode,
      themePreference: state.themePreference == ProfileThemePreference.system
          ? ProfileThemePreference.system
          : _manualThemePreferenceForMode(mode),
    );
    _save();
  }

  void setFollowSystemTheme(bool value) {
    state = state.copyWith(
      themePreference: value
          ? ProfileThemePreference.system
          : _manualThemePreferenceForMode(state.appThemeMode),
    );
    _save();
  }

  void setPrayerCalendarMode(PrayerCalendarMode mode) {
    state = state.copyWith(prayerCalendarMode: mode);
    _save();
  }

  void setDisableGlassTransparency(bool value) {
    state = state.copyWith(disableGlassTransparency: value);
    _save();
  }

  void setDisableColoredGlass(bool value) {
    state = state.copyWith(disableColoredGlass: value);
    _save();
  }

  void setDressUpFridays(bool value) {
    state = state.copyWith(dressUpFridays: value);
    _save();
  }

  void setGlassTransparencyLevel(double value) {
    state = state.copyWith(glassTransparencyLevel: value);
    _save();
  }

  void setDisableBackground(bool value) {
    state = state.copyWith(disableBackground: value);
    _save();
  }

  void resetAppearance() {
    state = state.copyWith(
      themePreference: ProfileThemePreference.light,
      appThemeMode: AppThemeMode.noorGlass,
      disableGlassTransparency: false,
      disableColoredGlass: false,
      glassTransparencyLevel: kGlassTransparencyLevelDefault,
      disableBackground: false,
    );
    _save();
  }

  void _load() {
    final data = _store.getJsonMap('settings.profile');
    if (data == null) return;

    ProfileThemePreference theme = state.themePreference;
    final themeName = data['themePreference'] as String?;
    for (final item in ProfileThemePreference.values) {
      if (item.name == themeName) {
        theme = item;
        break;
      }
    }

    AppThemeMode appThemeMode = state.appThemeMode;
    final appThemeModeName = data['appThemeMode'] as String?;
    for (final item in AppThemeMode.values) {
      if (item.name == appThemeModeName) {
        appThemeMode = item;
        break;
      }
    }
    AppPageTransitionStyle pageTransitionStyle = state.pageTransitionStyle;
    final pageTransitionStyleName = data['pageTransitionStyle'] as String?;
    for (final item in AppPageTransitionStyle.values) {
      if (item.name == pageTransitionStyleName) {
        pageTransitionStyle = item;
        break;
      }
    }
    PrayerCalendarMode prayerCalendarMode = state.prayerCalendarMode;
    final prayerCalendarModeName = data['prayerCalendarMode'] as String?;
    for (final item in PrayerCalendarMode.values) {
      if (item.name == prayerCalendarModeName) {
        prayerCalendarMode = item;
        break;
      }
    }

    ProfileAgeRange ageRange = state.ageRange;
    final ageRangeName = data['ageRange'] as String?;
    for (final item in ProfileAgeRange.values) {
      if (item.name == ageRangeName) {
        ageRange = item;
        break;
      }
    }

    KidsUiThemeMode kidsUiThemeMode = state.kidsUiThemeMode;
    final kidsUiThemeModeName = data['kidsUiThemeMode'] as String?;
    for (final item in KidsUiThemeMode.values) {
      if (item.name == kidsUiThemeModeName) {
        kidsUiThemeMode = item;
        break;
      }
    }
    if (kidsUiThemeModeName == null && data.containsKey('kidsModeEnabled')) {
      kidsUiThemeMode = (data['kidsModeEnabled'] as bool? ?? false)
          ? KidsUiThemeMode.on
          : KidsUiThemeMode.off;
    }
    final resolvedKidsMode = resolveKidsUiThemeEnabled(
      ageRange: ageRange,
      mode: kidsUiThemeMode,
    );

    state = state.copyWith(
      themePreference: theme,
      ageRange: ageRange,
      kidsUiThemeMode: kidsUiThemeMode,
      reduceMotion: data['reduceMotion'] as bool? ?? state.reduceMotion,
      pageTransitionStyle: pageTransitionStyle,
      highContrastText:
          data['highContrastText'] as bool? ?? state.highContrastText,
      ramadanModeEnabled:
          data['ramadanModeEnabled'] as bool? ?? state.ramadanModeEnabled,
      lossModeEnabled:
          data['lossModeEnabled'] as bool? ?? state.lossModeEnabled,
      gentleModeEnabled:
          data['gentleModeEnabled'] as bool? ?? state.gentleModeEnabled,
      unwellModeEnabled:
          data['unwellModeEnabled'] as bool? ?? state.unwellModeEnabled,
      kidsModeEnabled: resolvedKidsMode,
      privateTrackingMode:
          data['privateTrackingMode'] as bool? ?? state.privateTrackingMode,
      minimalTrackingMode:
          data['minimalTrackingMode'] as bool? ?? state.minimalTrackingMode,
      hideGrowthVisuals:
          data['hideGrowthVisuals'] as bool? ?? state.hideGrowthVisuals,
      reflectionOnlyMode:
          data['reflectionOnlyMode'] as bool? ?? state.reflectionOnlyMode,
      prayerReminders:
          data['prayerReminders'] as bool? ?? state.prayerReminders,
      prayerReminderFollowUpEnabled:
          data['prayerReminderFollowUpEnabled'] as bool? ??
          state.prayerReminderFollowUpEnabled,
      prayerReminderFollowUpDelayMinutes:
          (data['prayerReminderFollowUpDelayMinutes'] as num?)?.toInt() ??
          state.prayerReminderFollowUpDelayMinutes,
      prayerReminderSnoozeMinutes:
          (data['prayerReminderSnoozeMinutes'] as num?)?.toInt() ??
          state.prayerReminderSnoozeMinutes,
      dhikrReminders: data['dhikrReminders'] as bool? ?? state.dhikrReminders,
      quranReminders: data['quranReminders'] as bool? ?? state.quranReminders,
      reflectionReminders:
          data['reflectionReminders'] as bool? ?? state.reflectionReminders,
      fastingReminders:
          data['fastingReminders'] as bool? ?? state.fastingReminders,
      onThisDayReminders:
          data['onThisDayReminders'] as bool? ?? state.onThisDayReminders,
      moonriseReminders:
          data['moonriseReminders'] as bool? ?? state.moonriseReminders,
      moonsetReminders:
          data['moonsetReminders'] as bool? ?? state.moonsetReminders,
      appThemeMode: appThemeMode,
      prayerCalendarMode: prayerCalendarMode,
      disableGlassTransparency:
          data['disableGlassTransparency'] as bool? ??
          state.disableGlassTransparency,
      disableColoredGlass:
          data['disableColoredGlass'] as bool? ?? state.disableColoredGlass,
      dressUpFridays: data['dressUpFridays'] as bool? ?? state.dressUpFridays,
      glassTransparencyLevel: normalizedGlassTransparencyLevel(
        (data['glassTransparencyLevel'] as num?)?.toDouble() ??
            kGlassTransparencyLevelDefault,
      ),
      disableBackground:
          data['disableBackground'] as bool? ?? state.disableBackground,
      ramadanStartDateIso:
          data['ramadanStartDateIso'] as String? ?? state.ramadanStartDateIso,
      ramadanEndDateIso:
          data['ramadanEndDateIso'] as String? ?? state.ramadanEndDateIso,
    );
  }

  void _save() {
    _store.setJsonMap('settings.profile', {
      'themePreference': state.themePreference.name,
      'ageRange': state.ageRange.name,
      'kidsUiThemeMode': state.kidsUiThemeMode.name,
      'reduceMotion': state.reduceMotion,
      'pageTransitionStyle': state.pageTransitionStyle.name,
      'highContrastText': state.highContrastText,
      'ramadanModeEnabled': state.ramadanModeEnabled,
      'lossModeEnabled': state.lossModeEnabled,
      'gentleModeEnabled': state.gentleModeEnabled,
      'unwellModeEnabled': state.unwellModeEnabled,
      'kidsModeEnabled': state.effectiveKidsUiThemeEnabled,
      'privateTrackingMode': state.privateTrackingMode,
      'minimalTrackingMode': state.minimalTrackingMode,
      'hideGrowthVisuals': state.hideGrowthVisuals,
      'reflectionOnlyMode': state.reflectionOnlyMode,
      'prayerReminders': state.prayerReminders,
      'prayerReminderFollowUpEnabled': state.prayerReminderFollowUpEnabled,
      'prayerReminderFollowUpDelayMinutes':
          state.prayerReminderFollowUpDelayMinutes,
      'prayerReminderSnoozeMinutes': state.prayerReminderSnoozeMinutes,
      'dhikrReminders': state.dhikrReminders,
      'quranReminders': state.quranReminders,
      'reflectionReminders': state.reflectionReminders,
      'fastingReminders': state.fastingReminders,
      'onThisDayReminders': state.onThisDayReminders,
      'moonriseReminders': state.moonriseReminders,
      'moonsetReminders': state.moonsetReminders,
      'appThemeMode': state.appThemeMode.name,
      'prayerCalendarMode': state.prayerCalendarMode.name,
      'disableGlassTransparency': state.disableGlassTransparency,
      'disableColoredGlass': state.disableColoredGlass,
      'dressUpFridays': state.dressUpFridays,
      'glassTransparencyLevel': state.glassTransparencyLevel,
      'disableBackground': state.disableBackground,
      'ramadanStartDateIso': state.ramadanStartDateIso,
      'ramadanEndDateIso': state.ramadanEndDateIso,
    });
  }
}

final profileSettingsProvider =
    StateNotifierProvider<ProfileSettingsNotifier, ProfileSettingsState>(
      (ref) => ProfileSettingsNotifier(ref.watch(localStoreProvider)),
    );

ProfileThemePreference _manualThemePreferenceForMode(AppThemeMode mode) {
  switch (mode) {
    case AppThemeMode.noorGlassDark:
    case AppThemeMode.noGlassDark:
      return ProfileThemePreference.dark;
    default:
      return ProfileThemePreference.light;
  }
}
