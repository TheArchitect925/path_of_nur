# Homepage Warm Glass Surface Pilot Backlog

Date: 2026-03-31

## Recommended next enhancements

1. Add a shared `panel`-level warm treatment option for the homepage’s nested informational blocks that are still using page-local hardcoded fills, so the dashboard reads even more consistently without touching other tabs.
2. Run a visual QA pass on small phones, large text, and Midnight Manuscript to tune the new warm alpha and border strengths against each background mode.
3. If the homepage pilot is approved, promote `AppSurfaceTreatment.homepageWarmGlass` into a broader shared surface option with an explicit rollout plan for Home first, then Qur'an, then other premium landing pages.
4. Consider a tiny shared helper for warm glass icon capsules so homepage feature headers and quick-action badges can reuse the same inner panel language instead of keeping a few page-local box decorations.
5. Add widget tests around `PremiumCard` and `AppSurfaceTheme.contentColors/resolve` for the new treatment so future theme work cannot silently regress the warm pilot visuals.
