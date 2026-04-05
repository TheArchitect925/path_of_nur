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
  - now includes `Midnight Manuscript` as a persisted first-class option
  - now also includes `Noor Glass` as a persisted first-class option for a lighter milky frosted-glass appearance
  - now also includes `Noor Glass Dark`, `No Glass`, `No Glass Dark`, `Noor Midnight Manuscript`, and `Noor Kids` as persisted first-class options in the same picker
  - the practical appearance default/reset path now points to `Noor Glass`
  - the older `Classic Default`, `Calm Beautiful`, `Easy Read`, `Dark`, and `Midnight Manuscript` options remain selectable for continuity
  - now uses compact preview tiles with representative mini background/card/accent samples for visible themes
  - now also shows a short appearance-helper line plus concise “best for” helper copy on visible theme tiles so Midnight Manuscript and the other visible themes read more intentionally in settings without changing the picker architecture
- disable glass transparency
- disable background
- reset appearance
- reduce motion
- high contrast text

Appearance implementation notes:

- shared atmospheric background resolution now lives below the existing global wallpaper/background host instead of in page-local theme code
- wallpaper choice remains user-owned; Midnight Manuscript applies tint/gradient treatment on top of the selected wallpaper rather than replacing the wallpaper system
- shared component expression for Midnight Manuscript now also flows through appearance helpers used by nav, chip, segmented-control, button, and input theme states rather than relying on isolated widget-level overrides

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
