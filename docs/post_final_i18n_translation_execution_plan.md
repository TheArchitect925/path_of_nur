# Translation Execution Plan

## Why I did not auto-translate everything in one pass

The repo still has:
- 2935 to 4497 missing keys per non-English locale
- 12 placeholder mismatches in every non-English locale
- remaining code-side localization debt in older feature surfaces

A blind one-shot translation pass across all locales would be high risk because it would likely:
- produce inconsistent terminology
- break placeholder shapes
- embed low-quality translations in release files
- make QA harder instead of easier

## Safe execution order

1. Finish the remaining code-side localization micro-pass from the audit:
   - Celestial
   - Quran Teaching section/review
   - Learning Salah
   - Hadith landing/review shell
   - Baby Names browse
   - World / Divine Life shells
   - remaining helper-level labels in celestial/salah/growth/dhikr/shared quote helpers

2. Repair placeholder mismatches in all non-English locales:
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

3. Translate missing keys in priority order:
   - shell/home/settings/accounts/prayer/fasting/notifications
   - growth/creation explorer/ocean
   - learning shell + study shell
   - deeper learning feature shells

4. Run multilingual QA for target locales only after steps 1-3.

## Inventory files

- Exact machine-readable gap inventory: `docs/post_final_i18n_gap_inventory.json`
- Verification summary: `docs/post_final_i18n_translation_gap_report.md`

## Recommendation

Use the JSON inventory to drive a scripted or batch-assisted translation workflow per locale, not a manual all-locales single pass.
