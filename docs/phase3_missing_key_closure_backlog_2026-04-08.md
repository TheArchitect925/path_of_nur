# Phase 3 Missing-Key Closure Backlog

Date: 2026-04-08

## Completed in this pass

- Closed the structural localization gap where `401` English-source keys were missing from every non-English locale ARB.
- Closed the additional `116` Tajik-only missing keys.
- Regenerated localization output and confirmed `.dart_tool/untranslated-messages-file.json` is now empty.

## Remaining for Phase 4

- Replace English fallback values in non-English locale files with real translations for live user-facing strings first.
- Prioritize high-traffic surfaces:
  - Home
  - Learn
  - Qur'an
  - Worship
  - Journey
  - onboarding
  - notifications
- Audit placeholder-heavy locale files for same-as-English values and rank by route usage.
- Keep seeded educational content translation in the later content-focused phase rather than mixing it into the UI-quality pass.

## Enhancement Options

- Add a small script/report that tracks same-as-English counts per locale after each localization pass.
- Add a CI/local check that fails when new English keys are added without propagation to all locale ARBs.
- Add a route-priority localization dashboard so fallback cleanup can follow product usage rather than raw key count.
