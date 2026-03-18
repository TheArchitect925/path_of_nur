# Post-final i18n Translation Gap Report

## Summary

Base file: `lib/l10n/app_en.arb`

Common structural issue across non-English locales:
- Placeholder mismatches: `12` per locale
- Mismatched keys:
  - `settingsCurrentProfileSummary`
  - `settingsSyncStatusSummary`
  - `settingsMosqueTimeLabel`
  - `settingsCalculatedTimeLabel`
  - `settingsAdjustmentValueLabel`
  - `settingsEffectiveTimeLabel`
  - `settingsDifferenceValueLabel`
  - `settingsBaseTimeLabel`
  - `settingsFinalTimeLabel`
  - `settingsPrayerAdjustmentEditorBaseCalculatedTime`
  - `settingsPrayerAdjustmentEditorCurrentAdjustment`
  - `settingsPrayerAdjustmentEditorFinalEffectiveTime`

High-risk missing-key groups across locales:
- `notifications*`
- `settings*` / `accountsSync*`
- `prayer*` / `fasting*`
- `growth*`
- `creationExplorer*`
- large `learn*` / `trivia*` / `prophets*` / `quranTeaching*` sets
- `home*` / shell-level newer keys

## Locale-by-locale counts

| Locale | Missing keys | Placeholder mismatches | High-risk release impact |
|---|---:|---:|---|
| `ar` | 2935 | 12 | Critical shell, notifications, prayer, growth, creation explorer, large learning surfaces fall back to English |
| `bn` | 2935 | 12 | Critical shell, notifications, prayer, growth, creation explorer, large learning surfaces fall back to English |
| `de` | 4497 | 12 | Highest risk; even foundational keys like `appTitle` are missing |
| `fa` | 2935 | 12 | Critical shell, notifications, prayer, growth, creation explorer, large learning surfaces fall back to English |
| `fa_AF` | 2936 | 12 | Critical shell, notifications, prayer, growth, creation explorer, large learning surfaces fall back to English |
| `ha` | 2935 | 12 | Critical shell, notifications, prayer, growth, creation explorer, large learning surfaces fall back to English |
| `hi` | 2935 | 12 | Critical shell, notifications, prayer, growth, creation explorer, large learning surfaces fall back to English |
| `id` | 2936 | 12 | Critical shell, notifications, prayer, growth, creation explorer, large learning surfaces fall back to English |
| `ku` | 2936 | 12 | Critical shell, notifications, prayer, growth, creation explorer, large learning surfaces fall back to English |
| `ms` | 2936 | 12 | Critical shell, notifications, prayer, growth, creation explorer, large learning surfaces fall back to English |
| `pa` | 2936 | 12 | Critical shell, notifications, prayer, growth, creation explorer, large learning surfaces fall back to English |
| `ps` | 2936 | 12 | Critical shell, notifications, prayer, growth, creation explorer, large learning surfaces fall back to English |
| `tg` | 2936 | 12 | Critical shell, notifications, prayer, growth, creation explorer, large learning surfaces fall back to English |
| `tr` | 2936 | 12 | Critical shell, notifications, prayer, growth, creation explorer, large learning surfaces fall back to English |
| `ur` | 2936 | 12 | Critical shell, notifications, prayer, growth, creation explorer, large learning surfaces fall back to English |

## Grouped missing-key pressure

Approximate missing-key group counts per non-English locale:
- `notifications`: `49`
- `settings/accounts sync`: `172`
- `prayer/fasting`: `140` to `144`
- `growth`: `197`
- `creationExplorer`: `46`
- `home/shell`: `88` on most locales, `162` on `de`
- `learn/quranTeaching/trivia/prophets/metadata`: `1772` on most locales, `2527` on `de`

## Highest-risk locales

### `de`
- Missing keys: `4497`
- Placeholder mismatches: `12`
- Risk: foundational localization is incomplete enough that a German release is not viable.

### All other non-English locales listed above
- Missing keys: `2935` or `2936`
- Placeholder mismatches: `12`
- Risk: app will frequently fall back to English in major user flows including notifications, settings, prayer, growth, creation explorer, and learning.

## Translation-readiness conclusion

- Translation coverage debt is still severe.
- Even if code-side cleanup were completed, multilingual release is blocked by missing translations and placeholder mismatches.
- The fastest path is:
  1. finish the remaining code micro-pass
  2. repair placeholder mismatches
  3. prioritize translation of shell, notifications, prayer, settings/accounts, growth, creation explorer, and high-traffic learning entry points
