# Dua Phase 5 Enhancement Backlog

Date: 2026-03-31

## Recommended next enhancements

- Add a dataset validation script that flags:
  - duplicate Arabic text across different IDs
  - same-source overlaps across categories
  - source-type formatting drift
  - empty complete fields
- Add a lightweight `primaryTheme` or `discoveryAliases` field so the app can intentionally support overlapping search without making duplicate entries feel accidental.
- Normalize `sourceRef` style across all seeded non-Qur'anic duas so collection names and numbering patterns match everywhere.
- Review whether high-value duas should expose a `recommendedPlacement` or `featured` flag in the hub for easier onboarding.
- Prepare a translation/export plan for dua titles, summaries, and helper text so this content can move cleanly into localization resources later.

## Product-quality notes

- The remaining `Planned Dua 138-152` entries should not be force-filled until they have clear names and source intent.
- A final scholarly QA pass is still recommended before public release because the collection now includes a much larger Sunnah surface area.
