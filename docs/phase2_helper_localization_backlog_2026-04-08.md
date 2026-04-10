# Phase 2 Helper Localization Backlog

Date: 2026-04-08

## Completed in this slice

- Centralized localized prayer Madhab labels in the shared prayer model layer.
- Centralized localized prayer calculation method labels in the shared prayer model layer.
- Switched live prayer consumers to the shared localized helpers instead of page-local English labels.

## Recommended next Phase 2 slices

- Audit additional shared helper output in `journey` helpers for date/status/recurrence formatting that may still rely on locale-global fallbacks instead of explicit localized context.
- Review `adhan_options.dart` and adjacent reminder helper surfaces for any remaining direct fallback paths that could bypass localized titles/subtitles.
- Audit trainer/detail pages that still build mixed localized and raw headings from internal lookup keys.
- Continue replacing duplicated page-local helper label functions with shared model/domain extensions where those labels already have ARB coverage.

## Notes

- This slice did not add new translation keys because the required prayer labels already existed in ARB resources.
- The cleanup focused on shared helper ownership, not seeded content or remaining page-level presentation debt.
