# Phase 25C Live Localization Backlog

Date: 2026-03-23

## Completed in Phase 25C

- Removed the old live-surface bridge files for:
  - Qur’an
  - Growth
  - Games hub
- Added the remaining missing ARB-backed keys needed for live Qur’an and Growth surfaces.
- Propagated targeted live-surface keys into the non-English locale resource files so they are now explicitly present there instead of relying only on generated fallback behavior.
- Regenerated localization outputs and validated the touched live surfaces.

## Remaining Follow-up

- Finish translating the newly propagated non-English ARB entries. Phase 25C improved resource coverage, but many locale values still mirror English fallback text.
- Reduce the Wudu localization bridge further by moving the remaining formatted helper strings into generated ARB-backed localization when safe.
- Reduce the Kids Arabic localization bridge further by moving the remaining dynamic lesson/practice helper strings into generated ARB-backed localization when safe.
- Audit secondary/compatibility-only pages for any hardcoded English that was intentionally left out of this live-surface pass.
- Add a small localization integrity test batch for the newly propagated keys so future locale-resource regressions are easier to catch.
