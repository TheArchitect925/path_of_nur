# Phase 2 Arabic Localization QC Backlog

Date: 2026-03-23

## Completed in this pass

- Revalidated `app_ar.arb` against the current `app_en.arb`.
- Confirmed key parity with no missing or extra keys.
- Fixed 2 concrete placeholder mismatches:
  - `kidsArabicCompletionSubtitle`
  - `kidsArabicReviewQuestionMatchSound`
- Re-ran `flutter gen-l10n` and `flutter analyze` successfully.

## Enhancement options

1. Run a native-speaker Arabic editorial pass on the highest-traffic screens to tighten Modern Standard Arabic tone and button-label brevity.
2. Review remaining English-identical values in `app_ar.arb` and separate intentional carry-over content from strings that still deserve Arabic phrasing.
3. Add an automated placeholder-parity validation step to the localization workflow so translated ARBs cannot drift structurally.
4. Add a small Arabic smoke test pass on core routes to catch obvious fallback copy leaks on high-traffic pages.
