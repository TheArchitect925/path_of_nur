# Shortcut Pill Compact Audit

Date: 2026-04-05

## Root cause found
- The shortcut pill was using the shared glass card path through `AppLayeredGlassPill` -> `NoorGlassCard` -> `NoorLiquidGlassContainer`.
- That shared container defaulted to `width: double.infinity`, which forced the pill to expand to available width even when the parent alignment was correct.

## Fix strategy
- Preserved the existing shared pill visual language.
- Added an explicit shared opt-in to disable width expansion for pill-based controls that should hug content.
- Applied that opt-in only to `AppShortcutPill`.
- Kept parent-level right alignment in Home.

## Follow-up options
1. If the expanded shortcut tray should also be even tighter, add a content-width option to the floating shell wrapper used around the expanded group.
2. If other future utility chips should hug content, reuse `expandToWidth: false` through `AppLayeredGlassPillButton` instead of adding page-local hacks.
3. If the final product direction shifts, move the shortcut trigger higher in the page while preserving the same content-width shared pill behavior.
