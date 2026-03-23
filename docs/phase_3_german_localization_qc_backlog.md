# Phase 3 German Localization QC Backlog

Date: 2026-03-23

## Completed in this pass

- Revalidated `app_de.arb` against the current `app_en.arb`.
- Confirmed key parity with no missing or extra keys.
- Fixed 2 concrete placeholder mismatches:
  - `kidsArabicCompletionSubtitle`
  - `kidsArabicReviewQuestionMatchSound`
- Re-ran `flutter gen-l10n` and `flutter analyze` successfully.

## Enhancement options

1. Run a native German UX/editorial pass on the highest-traffic screens to shorten any remaining long labels and reduce overflow risk further.
2. Review remaining English-identical values in `app_de.arb` and separate intentional carry-over content from strings that still deserve German phrasing.
3. Add an automated placeholder-parity validation step to the localization workflow so translated ARBs cannot drift structurally.
4. Add a small German smoke test pass on core routes to catch obvious fallback copy leaks and layout pressure on longer labels.
