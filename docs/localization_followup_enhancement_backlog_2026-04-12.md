# Localization Follow-up Enhancement Backlog

1. Completed 2026-04-12: Added a lightweight localization regression test that fails if non-English locale files are still missing keys present in `app_en.arb`.
2. Completed 2026-04-12: Added a focused audit script that reports same-as-English fallback keys by surface group, so future translation passes can target one product area at a time.
3. Completed 2026-04-12: Added a small allowlist for intentional same-as-English product terms, so future audits do not overcount proper nouns like `Hadith` or `Qur’an`.
4. Completed 2026-04-12: Added a `recently_touched_localization_scope.md` tracker for active passes, so we can distinguish new misses from older legacy debt more clearly.
5. Completed 2026-04-12: Added an ICU-placeholder protection helper for machine-assisted translation passes, so `{count}` / `{surah}` / `{path}` style placeholders cannot be translated or dropped before `flutter gen-l10n`.
6. Completed 2026-04-12: Added a tiny audit exception for placeholder-only compositions such as `{reference} • {grade}`, so future reports do not flag structurally neutral strings as untranslated debt.
7. Consider a glossary/term-lock file for stable Islamic terms such as `Qur'an`, `Hadith`, `Salah`, `Dhikr`, `Surah`, `Ayah`, `Dua`, and `Wudu` so future multilingual passes stay more consistent.
