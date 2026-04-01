# Liquid Glass Renderer Setup — 2026-03-31

## Summary

The `liquid_glass_renderer` package is now prepared for controlled use in Path of Nūr, but it has **not** been applied to live app containers yet.

This pass focused on safe setup only:

- verifying the dependency is installed
- auditing the current shared surface seam
- adding app-owned wrappers so future adoption does not spread package-specific code across feature pages
- adding runtime safety so unsupported platforms or missing shader support degrade safely

## Current Shared Surface Seam

The main existing shared surface owners are:

- `lib/core/theme/app_surfaces.dart`
- `lib/shared/widgets/premium_card.dart`

Because these are used broadly across the app, this setup pass intentionally did **not** modify them yet.

## New Prepared Integration Layer

Added:

- `lib/shared/widgets/noor_liquid_glass.dart`

This file provides:

- `NoorLiquidGlassMode`
  - `disabled`
  - `fake`
  - `liquid`
- `NoorLiquidGlassPreset`
  - card/panel/pill/island/featureTile/navigationBar
- `NoorLiquidGlassSpec`
  - app-owned config object for future container adoption
- `NoorLiquidGlassCapability`
  - runtime/platform support checks
- `NoorLiquidGlassLayer`
  - shared layer wrapper for efficient future grouped glass usage
- `NoorLiquidGlassContainer`
  - one-off own-layer container wrapper for future incremental rollout
- `NoorLiquidGlassShape`
  - in-layer shape wrapper for future grouped container setups

## Safety Behavior

The wrapper layer now handles:

- unsupported platforms
- missing shader support
- fallback from true liquid glass to fake glass where possible
- full disable when the platform is unsupported

This keeps future rollout safer than importing `liquid_glass_renderer` directly into many pages.

## Why It Was Not Applied Yet

The package documentation explicitly warns that:

- it is experimental
- it performs best on Impeller
- broad production rollout should be measured carefully

So this pass stops at the adapter layer and does not change live surfaces until a controlled application plan is chosen.

## Recommended Future Rollout Order

1. Pilot one high-value surface family with low scroll density.
2. Prefer shared-layer usage for clustered surfaces instead of many own-layer widgets.
3. Use fake glass strategically for lower-priority or dense scrolling areas.
4. Add screenshot/device QA across supported devices before wider rollout.

## Risks

- Overusing own-layer liquid glass on dense pages may cause jank or memory pressure.
- Unsupported platforms still need normal non-glass rendering.
- Broad replacement of `PremiumCard` without staged QA would be risky.

## Next Safe Step

Use the new wrapper layer to pilot a small set of surfaces, likely by:

- adding an opt-in path to `PremiumCard`
- or introducing a targeted container variant for one approved surface family

That should happen only after specific rollout instructions are given.
