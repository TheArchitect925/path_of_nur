# Home Glass Preview Islands

Date: 2026-04-01

## Summary

This pass adds a temporary homepage preview section for comparing multiple glass/material directions without changing the global surface system.

The preview is:
- isolated to a dedicated home presentation folder
- inserted through a single homepage widget import
- safe to remove later without affecting route ownership, shared theme architecture, or existing card systems

## Insertion point

- Added below the existing core home content in `HomePage`
- Inserted after the current home learning actions card

## Implementation shape

- New folder:
  - `lib/features/home/presentation/glass_preview/`
- Main entry widget:
  - `HomeGlassStylePreviewSection`
- Local model:
  - `HomeGlassPreviewStyleDefinition`

## Glass variants included

- Warm Glass
- Milky Glass
- Crystal Glass
- Night Glass
- Tinted Glass
- Frosted Glass
- Layered Glass
- Edge-lit Glass
- Adaptive Glass
- Soft Matte Glass
- Dense Sanctuary Glass
- Clear Showcase Glass

Each preview island includes:
- localized style title
- one-line descriptor
- body copy for readability checks
- inner chip/pill
- metadata row
- layered inner panel where appropriate

## Package usage

- The preview uses the existing app-owned `NoorLiquidGlassContainer` wrapper
- That wrapper is backed by `liquid_glass_renderer`
- If the renderer cannot fully render on a platform, the wrapper keeps the preview isolated and fallbacks remain localized to this section only

## Removal safety

To remove later:
1. Remove the `HomeGlassStylePreviewSection` import from `lib/features/home/presentation/home_page.dart`
2. Remove the `const HomeGlassStylePreviewSection()` insertion from `HomePage`
3. Delete `lib/features/home/presentation/glass_preview/`
4. Optionally remove the temporary `homeGlassPreview*` localization keys

No routes, shared surfaces, or global theme files need to be reverted.

## Notes

- This is preview-only UI and not a commitment to app-wide glass adoption
- The current strongest candidates in code are:
  - Milky Glass
  - Dense Sanctuary Glass
  - Warm Glass
- The most useful contrast checks are:
  - Crystal Glass
  - Night Glass
  - Clear Showcase Glass
