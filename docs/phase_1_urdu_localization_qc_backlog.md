# Phase 1 Urdu Localization QC Backlog

Date: 2026-03-23

## Completed in this pass

- Revalidated `app_ur.arb` against the current `app_en.arb`.
- Confirmed key parity with no missing or extra keys.
- Fixed 5 concrete placeholder/structure mismatches that would have made the Urdu file less trustworthy:
  - `worshipPrayerRakatGuideValue`
  - `homePrayerBeginsAt`
  - `kidsArabicCompletionSubtitle`
  - `kidsArabicReviewQuestionMatchSound`
  - `wuduTrainerResumeSubtitle`
- Re-ran `flutter gen-l10n` and `flutter analyze` successfully.

## Enhancement options

1. Run a native-speaker Urdu editorial pass on the highest-traffic screens to tighten tone, especially growth, Learn, and settings surfaces.
2. Review remaining English-identical values in `app_ur.arb` and separate intentional carry-over content from strings that still deserve Urdu phrasing.
3. Add an automated placeholder-parity script to localization QA so future ARB imports cannot reintroduce broken placeholders.
4. Add a locale-specific smoke test that launches a few core routes in Urdu and verifies no obvious fallback copy leaks on high-traffic pages.
