# Quran Reader Search Hotfix Follow-Ups

Date: 2026-04-10
Area: Qur'an reader search UI stability

## Safe enhancement options

- Add one integration-style simulator pass focused on opening the reader search sheet, submitting a query, and stepping next/previous while playback is active.
- If product wants ripples back later, reintroduce them only after the reader search controls are hosted in a longer-lived surface that is not dismissed in the same tap cycle.
- Consider a tiny sheet-open analytics/debug hook during QA builds only, so any future reader-search lifecycle regressions are easier to trace.
- If the reader sheet grows later, move its content into a dedicated small widget owned by the page state so search UI logic stays isolated from the main reader build.

## Notes

- This hotfix addressed a Material ink/reference-box lifecycle problem in transient reader-search controls, not a canonical Quran search engine issue.
- The current safer posture is page-owned modal opening plus no-splash transient controls for the search pill and sheet actions.
