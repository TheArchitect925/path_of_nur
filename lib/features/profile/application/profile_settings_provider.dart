import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ProfileThemePreference { system, dark, light }

class ProfileSettingsState {
  const ProfileSettingsState({
    required this.themePreference,
    required this.reduceMotion,
    required this.highContrastText,
    required this.ramadanModeEnabled,
    required this.lossModeEnabled,
    required this.gentleModeEnabled,
    required this.privateTrackingMode,
    required this.minimalTrackingMode,
    required this.hideGrowthVisuals,
    required this.reflectionOnlyMode,
    required this.prayerReminders,
    required this.dhikrReminders,
    required this.quranReminders,
    required this.reflectionReminders,
    required this.fastingReminders,
  });

  final ProfileThemePreference themePreference;
  final bool reduceMotion;
  final bool highContrastText;
  final bool ramadanModeEnabled;
  final bool lossModeEnabled;
  final bool gentleModeEnabled;
  final bool privateTrackingMode;
  final bool minimalTrackingMode;
  final bool hideGrowthVisuals;
  final bool reflectionOnlyMode;
  final bool prayerReminders;
  final bool dhikrReminders;
  final bool quranReminders;
  final bool reflectionReminders;
  final bool fastingReminders;

  ProfileSettingsState copyWith({
    ProfileThemePreference? themePreference,
    bool? reduceMotion,
    bool? highContrastText,
    bool? ramadanModeEnabled,
    bool? lossModeEnabled,
    bool? gentleModeEnabled,
    bool? privateTrackingMode,
    bool? minimalTrackingMode,
    bool? hideGrowthVisuals,
    bool? reflectionOnlyMode,
    bool? prayerReminders,
    bool? dhikrReminders,
    bool? quranReminders,
    bool? reflectionReminders,
    bool? fastingReminders,
  }) {
    return ProfileSettingsState(
      themePreference: themePreference ?? this.themePreference,
      reduceMotion: reduceMotion ?? this.reduceMotion,
      highContrastText: highContrastText ?? this.highContrastText,
      ramadanModeEnabled: ramadanModeEnabled ?? this.ramadanModeEnabled,
      lossModeEnabled: lossModeEnabled ?? this.lossModeEnabled,
      gentleModeEnabled: gentleModeEnabled ?? this.gentleModeEnabled,
      privateTrackingMode: privateTrackingMode ?? this.privateTrackingMode,
      minimalTrackingMode: minimalTrackingMode ?? this.minimalTrackingMode,
      hideGrowthVisuals: hideGrowthVisuals ?? this.hideGrowthVisuals,
      reflectionOnlyMode: reflectionOnlyMode ?? this.reflectionOnlyMode,
      prayerReminders: prayerReminders ?? this.prayerReminders,
      dhikrReminders: dhikrReminders ?? this.dhikrReminders,
      quranReminders: quranReminders ?? this.quranReminders,
      reflectionReminders: reflectionReminders ?? this.reflectionReminders,
      fastingReminders: fastingReminders ?? this.fastingReminders,
    );
  }
}

class ProfileSettingsNotifier extends StateNotifier<ProfileSettingsState> {
  ProfileSettingsNotifier()
      : super(
          const ProfileSettingsState(
            themePreference: ProfileThemePreference.system,
            reduceMotion: false,
            highContrastText: false,
            ramadanModeEnabled: false,
            lossModeEnabled: false,
            gentleModeEnabled: true,
            privateTrackingMode: false,
            minimalTrackingMode: false,
            hideGrowthVisuals: false,
            reflectionOnlyMode: false,
            prayerReminders: true,
            dhikrReminders: true,
            quranReminders: false,
            reflectionReminders: false,
            fastingReminders: false,
          ),
        );

  void setThemePreference(ProfileThemePreference value) {
    state = state.copyWith(themePreference: value);
  }

  void setReduceMotion(bool value) {
    state = state.copyWith(reduceMotion: value);
  }

  void setHighContrastText(bool value) {
    state = state.copyWith(highContrastText: value);
  }

  void setRamadanModeEnabled(bool value) {
    state = state.copyWith(ramadanModeEnabled: value);
  }

  void setLossModeEnabled(bool value) {
    state = state.copyWith(lossModeEnabled: value);
  }

  void setGentleModeEnabled(bool value) {
    state = state.copyWith(gentleModeEnabled: value);
  }

  void setPrivateTrackingMode(bool value) {
    state = state.copyWith(privateTrackingMode: value);
  }

  void setMinimalTrackingMode(bool value) {
    state = state.copyWith(minimalTrackingMode: value);
  }

  void setHideGrowthVisuals(bool value) {
    state = state.copyWith(hideGrowthVisuals: value);
  }

  void setReflectionOnlyMode(bool value) {
    state = state.copyWith(reflectionOnlyMode: value);
  }

  void setPrayerReminders(bool value) {
    state = state.copyWith(prayerReminders: value);
  }

  void setDhikrReminders(bool value) {
    state = state.copyWith(dhikrReminders: value);
  }

  void setQuranReminders(bool value) {
    state = state.copyWith(quranReminders: value);
  }

  void setReflectionReminders(bool value) {
    state = state.copyWith(reflectionReminders: value);
  }

  void setFastingReminders(bool value) {
    state = state.copyWith(fastingReminders: value);
  }
}

final profileSettingsProvider =
    StateNotifierProvider<ProfileSettingsNotifier, ProfileSettingsState>(
  (ref) => ProfileSettingsNotifier(),
);
