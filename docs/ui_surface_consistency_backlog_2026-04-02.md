# UI Surface Consistency Backlog — 2026-04-02

## High
- Do a narrow chart/analytics micro-surface pass in prayer and worship visualizations.
  - Reason: the main card families are unified now, but a few inner chart cells and metric micro-blocks still use local accent decorations.

## Medium
- Tighten `SettingsPage` preview/configuration sub-elements onto shared pill/panel helpers where beneficial.
  - Reason: primary cards are already shared, but some inner preview pieces still own local decoration.
- Add widget tests for shared surface expectations on `PremiumCard`, `SectionHubActionCard`, and `LearnCategoryCard`.
  - Reason: protects the two-family system from quiet regressions.

## Low
- Consider deprecating `AppSurfaceTreatment.homepageWarmGlass` now that the temporary comparison runtime code is removed.
  - Reason: production runtime no longer needs a third general-purpose family.
- Add a small internal audit helper that flags production usage of preview-only treatments.
  - Reason: would make future drift easier to catch quickly.
