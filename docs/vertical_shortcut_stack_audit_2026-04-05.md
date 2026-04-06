# Vertical Shortcut Stack Audit

Date: 2026-04-05

## Layout result
- Home shortcut actions now render as a right-aligned vertical stack of compact pills.
- The stack stays visually secondary to the main hero content.
- The trigger pill remains separate beneath the stack.

## Palette strategy
- Qur'an: soft emerald
- Salah: warm amber
- Dhikr: muted plum
- Qibla: soft teal

All four use the same shared pill family and only vary tint/fill/border/foreground colors.

## Implementation direction
- Added a local `_HomeShortcutItem` model for label, icon, action, and color values.
- Kept `AppShortcutPill` as the shared pill widget.
- Mapped the model list into a vertical `Column` with consistent spacing.

## Follow-up options
1. Promote the style model into a shared shortcut style class if the same stack pattern is approved for other pages.
2. Add a subtle open animation once the final stack direction is approved.
3. If long localized labels cause visual imbalance later, introduce a small max-width rule while preserving content-first sizing.
