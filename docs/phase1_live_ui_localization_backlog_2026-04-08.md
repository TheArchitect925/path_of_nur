# Phase 1 Live UI Localization Backlog

Date: 2026-04-08

## Completed in this slice

- Localized the visible `Salah Times` screen shell and tracking labels.
- Localized the main `Baby Names` home and browse screens.
- Localized onboarding progress text.
- Localized the Qur'an reader sources/licensing sheet.

## Recommended next Phase 1 slices

- Localize `baby_name_detail_page.dart` end-to-end.
- Localize `baby_names_meaning_explorer_page.dart`.
- Audit `baby_names_finder_page.dart` and `baby_names_generator_page.dart` for remaining hardcoded English.
- Continue the Qur'an reader pass for any remaining fallback strings such as secondary metadata/fallback labels.
- Re-scan active `presentation/` files for hardcoded English after this slice and prioritize the next highest-traffic pages.

## Notes

- New ARB keys added in this slice were propagated to all locale files with English fallback text for now.
- This was a live-surface cleanup pass only; seeded editorial datasets still need later translation phases.
