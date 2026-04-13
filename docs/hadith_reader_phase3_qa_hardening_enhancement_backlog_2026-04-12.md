# Hadith Reader QA and Hardening Enhancement Backlog

1. Completed 2026-04-12: Added focused widget tests that tap the source chapter row and subcategory chip so canonical route wiring is covered in addition to formatter tests.
2. Add a lightweight localization regression test that asserts the Hadith reader provenance keys no longer resolve to English fallback in the remaining non-English shipped locales.
3. Completed 2026-04-12: Added a compact-share length budget test matrix so future copy changes do not bloat list-surface shares.
4. Audit follow-up 2026-04-12: Replace the remaining same-as-English Hadith reader continuity/display labels surfaced by the new safety-net script, especially `hadithReaderBackToLane`, `hadithReaderPosition`, `hadithReaderDisplaySettingsTitle`, and `hadithReaderDisplaySettingsSubtitle` in the lower-coverage locales.
