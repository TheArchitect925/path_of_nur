# Liquid Glass Renderer Backlog — 2026-03-31

## Immediate Next Options

- Add an opt-in `PremiumCard` liquid-glass variant without changing existing default behavior.
- Pilot liquid glass on one low-density surface family before touching scroll-heavy pages.
- Add a small internal demo page or dev-only showcase route for comparing `disabled`, `fake`, and `liquid` modes safely.

## Performance-Safe Rollout Ideas

- Prefer `NoorLiquidGlassLayer` plus `NoorLiquidGlassShape` for grouped card clusters.
- Reserve `NoorLiquidGlassContainer` for isolated hero cards or one-off panels.
- Use `fake` mode for pills, chips, and repeated list content where full liquid rendering may be too expensive.

## QA Backlog

- Validate on iPhone simulator with Impeller-backed rendering.
- Compare frame pacing for:
  - one own-layer card
  - grouped layer with multiple cards
  - fake-glass fallback
- Check readability on:
  - default mode
  - Noor Glass
  - Midnight Manuscript

## Do Not Break

- current `PremiumCard` behavior
- `AppSurfaceTheme` defaults
- shared theme architecture
- route ownership
- existing homepage warm glass pilot

## Enhancement Options

- Add shared presets that map directly to `AppSurfaceVariant`.
- Add an internal feature flag or settings-only debug toggle for liquid-glass QA.
- Add a shared glow policy so interactive cards can opt into `GlassGlow` consistently.
