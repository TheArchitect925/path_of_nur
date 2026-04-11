# Quran Exact Ayah Search Runtime Follow-ups

Date: 2026-04-10

## Saved enhancement options

- Add one integration-style reader test that launches a real exact-ayah route and asserts the target ayah is visible with less pump orchestration than the current widget test helper.
- Consider a dedicated reader startup telemetry hook behind debug-only logging so future deep-link regressions can be traced without patching the page again.
- If transliteration should appear on first open without reopening the page, split transliteration hydration from base ayah rendering so the reader can refresh transliteration rows after the exact-jump path has already completed.
- Consider storing a lightweight estimated ayah offset cache per surah after first render to reduce coarse startup scanning for deeper ayah jumps.
