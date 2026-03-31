# Turkish ICU Build Fix Backlog

Date: 2026-03-31

## Follow-up options

1. Run the same standalone-apostrophe ICU scan across all non-English ARB files so future locale edits cannot silently break `flutter gen-l10n`.
2. Repair the remaining Turkish translation-quality debt where English fallback still appears in `app_tr.arb`, especially on newer Learn and Qur'an-learning surfaces.
3. Add a lightweight CI or local validation step that fails on raw standalone apostrophes in ICU-backed ARB values before iOS build time.
