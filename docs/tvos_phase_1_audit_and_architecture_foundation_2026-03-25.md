# Phase 1 — tvOS Product Audit and Architecture Foundation

Date: 2026-03-25

## Purpose

Phase 1 establishes the product and architecture foundation for tvOS without expanding end-user scope yet.

This phase is intentionally about:

- auditing current mirrored ownership
- defining the canonical tvOS phase system in code
- defining the parity registry in code
- adding a shared release-policy layer for future tvOS-aware guardrails

This phase is intentionally not about:

- adding more tvOS screens
- porting mobile UI to TV
- broadening tvOS beyond Home + Qur'an

## Current product audit

### Current mirrored surfaces

- Home
  - iOS owner: `HomePage`
  - tvOS state: mirrored in `TVHomeScreen`
  - classification: `tvOS adaptation`
- Qur'an
  - iOS owner: `QuranAppHubPage` plus Qur'an reading/playback surfaces
  - tvOS state: mirrored in `TVQuranScreen`
  - classification: `tvOS adaptation`

### Not yet mirrored

- Learn
- Prayer detail section
- Dhikr
- Kids/family surfaces
- Arabic learning
- Games
- Favorites and saved state
- Offline/caching
- Profiles/session continuity
- tvOS-specific settings

### iOS-only for now

- dense settings flows
- account/sync management
- backup/import/export
- note and journal authoring
- heavy search/typing surfaces

## Architecture decisions from Phase 1

1. tvOS Home and Qur'an remain the only currently mirrored tvOS product surfaces.
2. Mirrored surfaces are classified as `adaptation`, not `direct reuse`, because remote-first interaction changes are expected.
3. tvOS phase sequencing is now codified in shared Dart foundation files so later phases can gate work against the same source of truth.
4. A shared `TVOSReleasePolicy` now exists to expose:
   - current mirrored surfaces
   - future surface backlog
   - route-level parity review checks
5. No mobile behavior was changed in this phase.

## Foundation files added

- `lib/features/tvos/domain/tvos_foundation_models.dart`
- `lib/features/tvos/data/tvos_foundation_registry.dart`
- `lib/features/tvos/application/tvos_release_policy.dart`
- `test/features/tvos/tvos_foundation_registry_test.dart`

## Why this foundation matters

- It gives future phases one stable source of truth for what tvOS mirrors and when.
- It reduces the chance of ad hoc tvOS work drifting away from iOS ownership.
- It makes future parity checks and feature flags easier to add in Phase 21 and Phase 22.
- It keeps iOS untouched while preparing shared architecture hooks early.

## Recommended next phase

- Phase 2 — shared design system and Path of Nūr tvOS look and feel

That phase should build on this foundation by defining reusable tvOS visual primitives and shared presentation rules, not by adding more surface breadth yet.
