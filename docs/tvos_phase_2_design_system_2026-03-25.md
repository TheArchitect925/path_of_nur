# Phase 2 — Shared Design System and Path of Nūr tvOS Look and Feel

Date: 2026-03-25

## Purpose

Phase 2 turns the current tvOS shell from screen-local styling into a reusable visual system.

This phase establishes:

- reusable tvOS typography tokens
- reusable tvOS surface/card styling
- stronger shared spacing and focus tokens
- a clearer Path of Nūr large-screen visual direction across Home and Qur'an

## What changed

### New shared theme primitives

- `ios/PathOfNurTV/Theme/TVTypography.swift`
  - centralizes hero, section, feature, body, Arabic, chip, and badge typography
- `ios/PathOfNurTV/Theme/TVSurfaceStyles.swift`
  - centralizes card backgrounds, borders, emphasis, and shadow treatment

### Expanded theme tokens

- `ios/PathOfNurTV/Theme/TVTheme.swift`
  - adds richer background mesh colors
  - adds surface stroke/shadow tokens
  - adds more explicit layout spacing and padding tokens
  - refines focus scale/shadow values

### Migrated existing tvOS shell

- Home and Qur'an screens now consume shared typography/surface rules instead of one-off fonts and fills
- focus styling is stronger and more consistent
- cards now share a common premium surface treatment
- the app shell tab tint now follows the tvOS accent token directly

## Product effect

The current tvOS V1 still has the same functional scope:

- Home
- Qur'an

But it now presents those surfaces through a more coherent design language:

- clearer hierarchy at TV distance
- more stable card rhythm
- more premium and calm Path of Nūr presentation
- more reusable styling for future phases

## Why this phase matters

- Future tvOS phases can now add new surfaces without reinventing fonts, surfaces, and focus polish.
- The design language is centralized before the app grows beyond Home and Qur'an.
- This keeps future tvOS work from fragmenting into page-specific styling.

## Verification

- native `PathOfNurTV` target should continue to build after the refactor
- no iOS Flutter surfaces were modified

## Recommended next phase

- Phase 3 — app shell, navigation, focus engine, and route structure

That phase should build on this shared visual system by standardizing remote-first shell behavior and navigation patterns rather than adding more content breadth immediately.
