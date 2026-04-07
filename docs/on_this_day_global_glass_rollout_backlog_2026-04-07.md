# On This Day Global Glass Rollout

## Goal

Use the Home "On This Day" card behavior as the Noor Glass default for cards and containers across the app, while keeping pills, buttons, and Qur'an quote surfaces separate.

## Phase 1

- Add a Noor-only global appearance toggle that enables the "On This Day" glass behavior.
- Route shared surface recipes through the warmer hero-glass tint when the toggle is on.
- Make shared Noor card wrappers reuse the same hero-glass shell behavior for non-pill surfaces.
- Keep existing per-surface content padding so dense layouts do not break.

## Phase 2

- Audit custom one-off surfaces that do not flow through shared wrappers, especially bespoke hero panels and nested dashboard cards.
- Normalize those outliers onto the same shell behavior without changing business logic or navigation.
- Re-test scroll-heavy pages for overdraw, nested translucency, and clipping artifacts.

## Phase 3

- Decide whether exact shell padding should also become globally standardized.
- Only do this after page-by-page review because some compact surfaces may need tighter inner spacing than the Home reference card.
- Add targeted visual regression coverage for the highest-risk sections.

## Candidate Follow-Ups

- Review `AppSalahHeroCard` and other custom prayer surfaces for direct container styling that bypasses shared glass helpers.
- Review `CelestialCycleCard` and other astronomy/journey cards for nested opacity or bespoke gradients.
- Audit modal sheets and stacked overlays separately so the new global glass preference does not create compounded translucency.
