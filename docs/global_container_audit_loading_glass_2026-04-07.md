# Global Container Audit

Date: 2026-04-07
Area: Shared surfaces / app-wide glass consistency

## Goal

- Prefer the loading-screen `Welcome Back` glass treatment globally by reusing `AppHeroGlassShell`.
- Exceptions:
  - Qur'an quote surfaces
  - pills and buttons

## Core shared container inventory

- `PremiumCard`
  - refs: 1056
  - files: 261
  - status: already aligned in practice
  - note: `PremiumCard` renders through `AppLayeredSectionGlassCard`, which already uses `AppHeroGlassShell` with the loading-screen tint, alpha, radius, border, and highlight values

- `AppLayeredSectionGlassCard`
  - refs: 4
  - files: 3
  - status: already aligned exactly
  - note: direct shared bridge onto `AppHeroGlassShell`

- `AppHeroGlassShell`
  - refs: 23
  - files: 19
  - status: canonical target shell
  - note: already used directly on loading, home hero sections, selected Learn/Qur'an cards, bottom nav shell, and some curated hero surfaces

- `NoorGlassCard`
  - refs: 13
  - files: 5
  - status: main global outlier
  - note: this is the remaining shared wrapper that still creates a separate glass treatment path

- `QuranQuoteBlock`
  - refs: 9
  - files: 8
  - status: exception by product rule
  - note: already uses `AppHeroGlassShell`, but should stay independently owned as a sacred quote surface

- `AppLayeredGlassPillButton`
  - refs: 48
  - files: 16
  - status: exception by product rule
  - note: intentionally excluded from global shell unification

- `AppSalahHeroCard`
  - refs: 3
  - files: 2
  - status: mixed
  - note: outer shell already uses `AppHeroGlassShell`, but it still contains custom inner containers and pill-like sub-surfaces

## Main finding

- Most of the app is already very close to the requested global preference because `PremiumCard` is the dominant surface primitive and already resolves through `AppHeroGlassShell`.
- The app does not need a page-by-page rewrite to achieve near-global consistency.
- The real remaining inconsistency is concentrated in:
  - `NoorGlassCard`
  - custom nested `Container` / `DecoratedBox` compositions inside some hero cards
  - a few shell-level or feature-level one-off surfaces

## Outlier summary

### Shared wrapper outlier

- `NoorGlassCard`
  - current usage files:
    - `lib/features/celestial/presentation/widgets/celestial_cycle_card.dart`
    - `lib/features/home/presentation/home_page.dart`
    - `lib/shared/widgets/app_layered_glass_pill_button.dart`
    - `lib/shared/widgets/app_salah_hero_card.dart`
    - `lib/shared/widgets/noor_glass_card.dart`
  - risk:
    - cannot be flipped blindly because it also powers pill/button-adjacent surfaces, which are explicitly exempted

### Already aligned shared path

- `PremiumCard` -> `AppLayeredSectionGlassCard` -> `AppHeroGlassShell`
  - this is already the dominant path across Home, Learn, Journey, Qur'an, Settings, Journal, FAQ, Kids, Arabic, Hadith, Life, World, Games, and many subpages

### One-off nested custom surfaces still worth reviewing later

- `AppSalahHeroCard`
  - outer shell aligned
  - inner stats/location/meta containers are custom

- `CelestialCycleCard`
  - outer shell aligned
  - several inner atmospheric sub-panels still use custom or `NoorGlassCard` layering

- selected Home feature internals
  - outer shell alignment is now much better
  - some inner pills/panel surfaces remain intentionally separate

## Safe rollout recommendation

1. Keep `AppHeroGlassShell` as the canonical target shell.
2. Treat `PremiumCard` as already compliant.
3. Do not globally touch `QuranQuoteBlock`, pills, or button wrappers.
4. Refactor `NoorGlassCard` only for non-pill, non-button use cases, or split it into:
   - a hero-glass section/card path
   - a retained pill/button path
5. After that shared split, review the remaining nested custom inner containers case-by-case instead of forcing every inner panel to look identical.

## Recommendation for implementation order

1. Extract one shared constant/helper for the loading-screen hero shell spec.
2. Migrate non-pill `NoorGlassCard` call sites onto that shared hero-shell path.
3. Audit remaining custom inner containers in:
   - `AppSalahHeroCard`
   - `CelestialCycleCard`
   - Home-specific composite surfaces
4. Run visual QA on Home, Learn, Journey, Qur'an, and Settings after the shared wrapper pass.

## Important caution

- There are 236 files under `lib/features` and `lib/shared/widgets` with direct `Container` / `DecoratedBox` / `BoxDecoration` usage.
- That does not mean 236 pages need manual restyling.
- Many of those are inner layout/building blocks, not primary section containers, so the right approach is shared wrapper consolidation first, then targeted outlier cleanup.
