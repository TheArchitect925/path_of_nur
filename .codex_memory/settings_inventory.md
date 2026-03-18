# Settings Inventory

Last updated: 2026-03-17

## Settings page ownership

Primary settings surface: `lib/features/profile/presentation/settings_page.dart`

Current major sections present in the UI:

## Profile & Personalization

- display name
- address-me-as / brother-sister selection
- special modes:
  - Ramadan mode
  - loss mode
  - gentle mode
  - kids mode
- profile summary page
- what's new
- coming soon
- age range
- kids UI theme mode

## Accounts, Profiles & Sync

- current profile summary
- sync status
- backup & restore
- family learning management entry
- links into `/accounts-sync*`

## Adhan

- enable adhan audio
- regular adhan selection
- Fajr adhan selection
- app-volume toggle
- adhan volume control

## Prayer settings

- location handling:
  - current/device location
  - manual location selection
- calculation method
- madhab
- prayer time mode:
  - calculated times + adjustments
  - fully manual prayer times
- per-prayer adjustments
- reset adjustments
- reset manual times
- stable dynamic island
- stable lock screen widget
- Jumu'ah override
- Jumu'ah time
- prayer notification configuration

## Appearance

- app theme mode
- disable glass transparency
- disable background
- reset appearance
- reduce motion
- high contrast text

## Tracking privacy

- location while using app
- private tracking mode
- minimal tracking mode
- hide growth visuals
- reflection-only mode

## Notifications

- prayer reminders
- dhikr reminders
- Qur'an reminders
- reflection reminders
- fasting reminders

## Language

- locale expansion / language picker
- locale stored in `profile.locale`

## About

- privacy policy
- terms
- support
- attributions & licenses

## Settings state model

Stored in `ProfileSettingsState`:

- `themePreference`
- `ageRange`
- `kidsUiThemeMode`
- `reduceMotion`
- `highContrastText`
- `ramadanModeEnabled`
- `lossModeEnabled`
- `gentleModeEnabled`
- `kidsModeEnabled`
- `privateTrackingMode`
- `minimalTrackingMode`
- `hideGrowthVisuals`
- `reflectionOnlyMode`
- `prayerReminders`
- `dhikrReminders`
- `quranReminders`
- `reflectionReminders`
- `fastingReminders`
- `appThemeMode`
- `disableGlassTransparency`
- `disableBackground`
- Ramadan date range fields

## Continuity notes

- Settings is now the home for profile-related user controls.
- Do not recreate a separate top-level Profile page.
- New personalization/settings work should plug into this surface or its existing subpages.
