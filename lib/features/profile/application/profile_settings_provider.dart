import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../domain/profile_age_preferences.dart';
import '../../../shared/persistence/local_store.dart';

enum ProfileThemePreference { system, dark, light }

class ProfileSettingsState {
  const ProfileSettingsState({
    required this.themePreference,
    required this.ageRange,
    required this.kidsUiThemeMode,
    required this.reduceMotion,
    required this.highContrastText,
    required this.ramadanModeEnabled,
    required this.lossModeEnabled,
    required this.gentleModeEnabled,
    required this.kidsModeEnabled,
    required this.privateTrackingMode,
    required this.minimalTrackingMode,
    required this.hideGrowthVisuals,
    required this.reflectionOnlyMode,
    required this.prayerReminders,
    required this.dhikrReminders,
    required this.quranReminders,
    required this.reflectionReminders,
    required this.fastingReminders,
    required this.appThemeMode,
    required this.disableGlassTransparency,
    required this.disableBackground,
    this.ramadanStartDateIso,
    this.ramadanEndDateIso,
  });

  final ProfileThemePreference themePreference;
  final ProfileAgeRange ageRange;
  final KidsUiThemeMode kidsUiThemeMode;
  final bool reduceMotion;
  final bool highContrastText;
  final bool ramadanModeEnabled;
  final bool lossModeEnabled;
  final bool gentleModeEnabled;
  final bool kidsModeEnabled;
  final bool privateTrackingMode;
  final bool minimalTrackingMode;
  final bool hideGrowthVisuals;
  final bool reflectionOnlyMode;
  final bool prayerReminders;
  final bool dhikrReminders;
  final bool quranReminders;
  final bool reflectionReminders;
  final bool fastingReminders;
  final AppThemeMode appThemeMode;
  final bool disableGlassTransparency;
  final bool disableBackground;
  final String? ramadanStartDateIso;
  final String? ramadanEndDateIso;

  bool get effectiveKidsUiThemeEnabled => resolveKidsUiThemeEnabled(
        ageRange: ageRange,
        mode: kidsUiThemeMode,
      );

  ProfileSettingsState copyWith({
    ProfileThemePreference? themePreference,
    ProfileAgeRange? ageRange,
    KidsUiThemeMode? kidsUiThemeMode,
    bool? reduceMotion,
    bool? highContrastText,
    bool? ramadanModeEnabled,
    bool? lossModeEnabled,
    bool? gentleModeEnabled,
    bool? kidsModeEnabled,
    bool? privateTrackingMode,
    bool? minimalTrackingMode,
    bool? hideGrowthVisuals,
    bool? reflectionOnlyMode,
    bool? prayerReminders,
    bool? dhikrReminders,
    bool? quranReminders,
    bool? reflectionReminders,
    bool? fastingReminders,
    AppThemeMode? appThemeMode,
    bool? disableGlassTransparency,
    bool? disableBackground,
    String? ramadanStartDateIso,
    String? ramadanEndDateIso,
  }) {
    return ProfileSettingsState(
      themePreference: themePreference ?? this.themePreference,
      ageRange: ageRange ?? this.ageRange,
      kidsUiThemeMode: kidsUiThemeMode ?? this.kidsUiThemeMode,
      reduceMotion: reduceMotion ?? this.reduceMotion,
      highContrastText: highContrastText ?? this.highContrastText,
      ramadanModeEnabled: ramadanModeEnabled ?? this.ramadanModeEnabled,
      lossModeEnabled: lossModeEnabled ?? this.lossModeEnabled,
      gentleModeEnabled: gentleModeEnabled ?? this.gentleModeEnabled,
      kidsModeEnabled: kidsModeEnabled ?? this.kidsModeEnabled,
      privateTrackingMode: privateTrackingMode ?? this.privateTrackingMode,
      minimalTrackingMode: minimalTrackingMode ?? this.minimalTrackingMode,
      hideGrowthVisuals: hideGrowthVisuals ?? this.hideGrowthVisuals,
      reflectionOnlyMode: reflectionOnlyMode ?? this.reflectionOnlyMode,
      prayerReminders: prayerReminders ?? this.prayerReminders,
      dhikrReminders: dhikrReminders ?? this.dhikrReminders,
      quranReminders: quranReminders ?? this.quranReminders,
      reflectionReminders: reflectionReminders ?? this.reflectionReminders,
      fastingReminders: fastingReminders ?? this.fastingReminders,
      appThemeMode: appThemeMode ?? this.appThemeMode,
      disableGlassTransparency:
          disableGlassTransparency ?? this.disableGlassTransparency,
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
          themePreference: ProfileThemePreference.system,
          ageRange: ProfileAgeRange.adult,
          kidsUiThemeMode: KidsUiThemeMode.auto,
          reduceMotion: false,
          highContrastText: false,
          ramadanModeEnabled: false,
          lossModeEnabled: false,
          gentleModeEnabled: true,
          kidsModeEnabled: false,
          privateTrackingMode: false,
          minimalTrackingMode: false,
          hideGrowthVisuals: false,
          reflectionOnlyMode: false,
          prayerReminders: true,
          dhikrReminders: true,
          quranReminders: false,
          reflectionReminders: false,
          fastingReminders: false,
          appThemeMode: AppThemeMode.defaultMode,
          disableGlassTransparency: false,
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

  void setHighContrastText(bool value) {
    state = state.copyWith(highContrastText: value);
    _save();
  }

  void setRamadanModeEnabled(bool value) {
    state = state.copyWith(
      ramadanModeEnabled: value,
      lossModeEnabled: value ? false : state.lossModeEnabled,
      gentleModeEnabled: value ? false : state.gentleModeEnabled,
    );
    _save();
  }

  void setLossModeEnabled(bool value) {
    state = state.copyWith(
      lossModeEnabled: value,
      ramadanModeEnabled: value ? false : state.ramadanModeEnabled,
      gentleModeEnabled: value ? false : state.gentleModeEnabled,
    );
    _save();
  }

  void setGentleModeEnabled(bool value) {
    state = state.copyWith(
      gentleModeEnabled: value,
      ramadanModeEnabled: value ? false : state.ramadanModeEnabled,
      lossModeEnabled: value ? false : state.lossModeEnabled,
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

  void setAppThemeMode(AppThemeMode mode) {
    state = state.copyWith(appThemeMode: mode);
    _save();
  }

  void setDisableGlassTransparency(bool value) {
    state = state.copyWith(disableGlassTransparency: value);
    _save();
  }

  void setDisableBackground(bool value) {
    state = state.copyWith(disableBackground: value);
    _save();
  }

  void resetAppearance() {
    state = state.copyWith(
      appThemeMode: AppThemeMode.defaultMode,
      disableGlassTransparency: false,
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
    if (appThemeMode == AppThemeMode.calmBeautiful) {
      appThemeMode = AppThemeMode.defaultMode;
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
      kidsUiThemeMode =
          (data['kidsModeEnabled'] as bool? ?? false)
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
      highContrastText:
          data['highContrastText'] as bool? ?? state.highContrastText,
      ramadanModeEnabled:
          data['ramadanModeEnabled'] as bool? ?? state.ramadanModeEnabled,
      lossModeEnabled:
          data['lossModeEnabled'] as bool? ?? state.lossModeEnabled,
      gentleModeEnabled:
          data['gentleModeEnabled'] as bool? ?? state.gentleModeEnabled,
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
      dhikrReminders: data['dhikrReminders'] as bool? ?? state.dhikrReminders,
      quranReminders: data['quranReminders'] as bool? ?? state.quranReminders,
      reflectionReminders:
          data['reflectionReminders'] as bool? ?? state.reflectionReminders,
      fastingReminders:
          data['fastingReminders'] as bool? ?? state.fastingReminders,
      appThemeMode: appThemeMode,
      disableGlassTransparency:
          data['disableGlassTransparency'] as bool? ??
          state.disableGlassTransparency,
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
      'highContrastText': state.highContrastText,
      'ramadanModeEnabled': state.ramadanModeEnabled,
      'lossModeEnabled': state.lossModeEnabled,
      'gentleModeEnabled': state.gentleModeEnabled,
      'kidsModeEnabled': state.effectiveKidsUiThemeEnabled,
      'privateTrackingMode': state.privateTrackingMode,
      'minimalTrackingMode': state.minimalTrackingMode,
      'hideGrowthVisuals': state.hideGrowthVisuals,
      'reflectionOnlyMode': state.reflectionOnlyMode,
      'prayerReminders': state.prayerReminders,
      'dhikrReminders': state.dhikrReminders,
      'quranReminders': state.quranReminders,
      'reflectionReminders': state.reflectionReminders,
      'fastingReminders': state.fastingReminders,
      'appThemeMode': state.appThemeMode.name,
      'disableGlassTransparency': state.disableGlassTransparency,
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
