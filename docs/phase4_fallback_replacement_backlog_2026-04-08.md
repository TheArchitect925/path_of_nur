# Phase 4 Fallback Replacement Backlog

Date: 2026-04-08

## Completed in this pass

- Replaced English fallback text for a high-traffic localization slice across all shipped locales.
- Covered:
  - Home `Today's content`
  - Qur'an ayah action labels
  - Qur'an recommendation titles/actions
  - Spiritual moment titles/reasons
  - Theme choice names and descriptions

## Remaining Phase 4 priorities

- Replace same-as-English fallback text for other high-traffic routed surfaces:
  - onboarding
  - Home prayer/support surfaces
  - Learn landing and grouped discovery cards
  - Worship/Qibla search and helper text
  - Journey dashboard summaries
- Prioritize locales with the lowest remaining quality:
  - `ku`
  - `ha`
  - `pa`
  - `ps`
  - `ms`
  - `tg`
- Keep branded product names consistent where translation would reduce clarity:
  - `Noor Kids`
  - `Noor Midnight Manuscript`

## Enhancement Options

- Add a route-priority report that lists same-as-English counts only for strings used by shipped top-level routes.
- Add a locale-quality checklist per feature area so each phase can close one user journey completely.
- Add a script that flags newly added English fallback values on high-traffic keys before release builds.
