# Global Surface Token Matrix

Date: 2026-04-03

## Purpose

This document defines the shared surface matrix that should drive future visual themes across Path of Nūr.

The goal is:

- future theme work should happen primarily in the shared appearance and surface layers
- page-level QA should be for outliers and exceptions, not the main implementation path
- a future colorway such as `Red`, `Emerald`, or another Noor family should mostly require changing centralized tokens and matrix recipes

## Shared ownership

Runtime ownership lives in:

- `lib/core/theme/app_theme.dart`
- `lib/core/theme/app_surfaces.dart`

Shared consumers already wired into this system include:

- `PremiumCard`
- `NoorGlassCard`
- shared pill/panel/icon treatments that call `AppSurfaceTheme.resolve(...)`

## Current surface families

The runtime matrix currently groups themes into these families:

1. `classic`
   - used by older default / calm / easy-read families
   - preserves the original warm glass language

2. `noor`
   - used by Noor Glass families
   - calmer, creamier, less tinted, more premium, more solid

3. `noGlass`
   - used by non-glass families
   - more opaque, flatter translucency behavior, lower tint influence

4. `midnight`
   - used by midnight manuscript families
   - darker, inkier, stronger contrast, slightly stronger shadow

5. `kids`
   - used by Noor Kids
   - softer warmth, gentler accents, calmer density

## Shared surface roles

These are the current shared runtime roles:

- `card`
- `island`
- `panel`
- `pill`
- `featureTile`
- `navigationBar`

These are the current shared treatments:

- `standard`
- `homepageWarmGlass`
- `denseSanctuary`

## Matrix recipe dimensions

Each family/treatment pair now centrally controls:

- surface alpha delta
- border alpha delta
- surface blend delta
- border blend delta
- milk blend delta
- top highlight delta
- bottom accent delta
- tint alpha delta
- shadow opacity scale

These recipe values are now centralized in `AppSurfaceMatrix` inside:

- `lib/core/theme/app_surfaces.dart`

## What this unlocks

A future theme no longer has to rely only on raw colors.

It can now change:

- how solid or translucent cards feel
- how strong borders feel
- how much accent tint enters the surface
- how milky or diffused the glass/solid body feels
- how bright the top highlight is
- how grounded the bottom edge feels
- how strong surface shadows feel

That means future theme work can be more like:

- choose base palette in `app_theme.dart`
- choose surface family behavior in `app_surfaces.dart`
- then fix only the remaining local outliers

## Current limitation

This does not mean every screen is fully tokenized yet.

There are still local/manual surfaces in parts of the app. The matrix now gives us the correct shared target, but we still need to keep migrating remaining outliers onto the shared surface system.

## Future-theme workflow

For a future global theme:

1. add the new theme mode and base colors in `app_theme.dart`
2. decide which existing surface family it belongs to, or add a new family if behavior really differs
3. tune the matrix recipe for that family
4. visually QA only the remaining local exceptions

## Recommended next technical step

After the current Noor rollout QA, the next architecture step should be:

- define shared semantic surface wrappers for the most common local patterns:
  - `hero utility card`
  - `summary pill`
  - `action pill`
  - `metric tile`
  - `section panel`

That would reduce page-local surface code further and make future theme propagation even more global.
