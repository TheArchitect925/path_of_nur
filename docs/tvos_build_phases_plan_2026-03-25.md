# tvOS Build Phases Plan

Date: 2026-03-25

Scope:
- Canonical tvOS app: `ios/PathOfNurTV`
- Current mirrored surfaces in scope:
  - Home
  - Qur'an
- Planning rules:
  - reuse shared logic first
  - preserve iOS behavior
  - build stable foundations before feature breadth
  - optimize for remote-first, family-room usage

## Core execution principles

1. tvOS should mirror product direction, not touch UI.
2. Shared data, playback, localization, and content ownership should stay canonical on the iOS/Flutter side where possible.
3. tvOS-specific code should mostly own:
   - focus navigation
   - shelf composition
   - visual presentation
   - remote control interactions
4. Heavy typing, settings density, and multi-step manual entry should usually stay off tvOS.
5. Every phase should end with a buildable, testable state.

## Parity map

### Direct tvOS reuse

- Shared Qur'an content ownership and canonical route direction
- Shared product taxonomy: Home and Qur'an as mirrored top-level surfaces
- Shared branding, visual tone, and calm hierarchy
- Shared localization source intent for titles, subtitles, and section ownership
- Shared playback domain direction:
  - continue reading
  - reciter selection
  - ayah-first playback model
- Shared prayer prioritization on Home:
  - current prayer
  - next prayer
  - full-day glance

### tvOS adaptation

- Home dashboard layout:
  - convert mobile stacked cards into focusable shelves and summary blocks
- Qur'an hub layout:
  - convert touch grids/chips/search-first tools into browse-first remote-friendly sections
- Playback controls:
  - remote-friendly minimal actions instead of dense mobile controls
- Continue/resume flows:
  - emphasize one clear primary action per screen
- Section navigation:
  - use tabs, rails, and shelves instead of taps on many small controls
- Daily verse / ayah cards:
  - larger text, stronger spacing, fewer simultaneous actions

### tvOS later phase

- Shared live prayer engine instead of seeded prayer data
- Shared continue/resume sync with mobile profile state
- Qur'an bookmarks/notes/reflections browsing on tvOS
- Richer surah browsing and guided-path discovery
- Kids/family handoff surfaces
- Background refresh and stronger playback continuity
- More than Home + Qur'an scope

### iOS only

- Dense settings surfaces
- account management and backup restore flows
- large search-heavy typing surfaces
- rich note/journal creation
- complex reminders configuration
- profile creation/editing
- advanced learning flows that depend on repeated fine-grained touch input

## Phase plan

### Phase 1. Shared foundation and gating

Goal:
- Make tvOS a first-class target in planning and architecture, not just a native sidecar.

Build in this phase:
- tvOS feature flag / release posture constants
- canonical tvOS section manifest for mirrored surfaces
- parity map doc kept in-repo
- compatibility checks that make mirrored-surface reviews explicit when Home or Qur'an ownership changes
- shared localization handoff plan for tvOS-native strings vs Flutter-owned content feeds

Implementation notes:
- prefer small shared manifest/data structures over page-local conditionals
- do not refactor iOS behavior during this phase unless strictly required for shared ownership

Exit criteria:
- one clear source of truth exists for:
  - what tvOS owns now
  - what tvOS mirrors later
  - what is intentionally excluded

### Phase 2. Data and content source convergence

Goal:
- Replace fragile tvOS-local seeded thinking with stable shared source contracts.

Build in this phase:
- shared adapters for Home prayer summary payload
- shared adapters for Qur'an continue-reading payload
- shared adapters for daily verse / featured ayah payload
- shared reciter/playback metadata contract
- section-level fallback policy when shared data is unavailable

Implementation notes:
- keep tvOS-specific mapping thin
- shared repositories remain the source of truth; tvOS consumes stable payloads
- preserve mobile behavior while extracting reusable data contracts

Exit criteria:
- Home and Qur'an tvOS surfaces can be fed by canonical shared payloads, with safe local fallback only where necessary

### Phase 3. Navigation and remote interaction system

Goal:
- Build the reusable tvOS interaction layer before adding more feature depth.

Build in this phase:
- focus map rules for hero, shelves, action cards, and reader rows
- standard remote interaction patterns:
  - primary action
  - back
  - play/pause
  - next/previous selection
- reusable screen shell for:
  - hero
  - summary blocks
  - horizontal shelves
  - split browse/read layouts
- resume-first action model with one dominant CTA per screen

Implementation notes:
- no blind reuse of touch grids, chips, or crowded action clusters
- prefer calm, directional navigation with predictable focus restoration

Exit criteria:
- Home and Qur'an can share a stable remote-first interaction framework

### Phase 4. Home production pass

Goal:
- Make Home feel product-real on Apple TV, not like a mobile card dump.

Build in this phase:
- production Home prayer summary using shared payloads
- current/next prayer emphasis with remote-readable hierarchy
- featured Qur'an continuation shelf
- daily light / verse presentation tuned for distance viewing
- motion/focus polish for shelf transitions and action emphasis

Implementation notes:
- keep family-room usage central:
  - larger type
  - fewer simultaneous choices
  - one-step movement into Qur'an
- avoid typing/search on Home

Exit criteria:
- Home is stable, readable from distance, and clearly useful without a phone

### Phase 5. Qur'an production pass

Goal:
- Make Qur'an the strongest tvOS experience after Home.

Build in this phase:
- continue-reading summary from shared data
- browse-surah shelf/list tuned for remote focus
- ayah reading lane with large readable text
- minimal playback model:
  - play/pause
  - reciter
  - selected ayah context
- safe empty/fallback states when network/audio/shared feeds fail

Implementation notes:
- do not clone the full mobile reader UI
- prefer:
  - browse
  - select
  - listen
  - resume
- leave note-taking, dense study tools, and keyboard-driven search out of the critical path

Exit criteria:
- Qur'an can serve as a real couch-friendly reading/listening surface

### Phase 6. Shared playback and continuity hardening

Goal:
- Remove divergence between mobile playback direction and tvOS playback behavior.

Build in this phase:
- central playback contract alignment with shared Qur'an playback/runtime policy
- consistent reciter metadata
- Bismillah/ayah transition behavior alignment where applicable
- resume continuity and now-playing state hardening
- playback failure and offline fallback handling

Implementation notes:
- refactor shared playback only when mobile behavior is preserved
- tvOS should consume the same product rules, not invent a second playback model

Exit criteria:
- tvOS playback behavior is predictable and aligned with the canonical mobile direction

### Phase 7. TestFlight QA and release hardening

Goal:
- Make the build distributable to internal testers with confidence.

Build in this phase:
- signed archive pass in Xcode
- TestFlight smoke checklist execution
- focus-order QA
- Apple TV audio QA
- icon/top-shelf/rendering QA
- crash/fallback review
- release notes and known-limitations doc for testers

Implementation notes:
- do not expand scope here
- fix reliability and clarity issues only

Exit criteria:
- internal TestFlight build is ready and honest about V1 scope

### Phase 8. Post-V1 expansion

Goal:
- Add breadth only after Home + Qur'an are stable.

Candidates:
- kids/family-friendly shelves
- saved progress continuity with mobile profile state
- simplified bookmarks/reflections browsing
- additional curated learning content that works without typing
- richer Top Shelf personalization

Guardrails:
- no dense settings port
- no account-management port
- no blind migration of iPhone forms/search-heavy tools

## Canonical numbered phase order

Use the exact numbered master list in:

- `docs/tvos_master_phase_index_2026-03-25.md`

The conceptual groupings in this plan map onto that master order as follows:

- foundation:
  - Phase 1
  - Phase 2
  - Phase 3
  - Phase 4
  - Phase 21
  - Phase 22
- core mirrored surfaces:
  - Phase 5
  - Phase 6
  - Phase 7
  - Phase 8
  - Phase 9
- learning and family expansion:
  - Phase 10
  - Phase 11
  - Phase 12
  - Phase 13
  - Phase 14
  - Phase 15
  - Phase 16
- hardening and release:
  - Phase 17
  - Phase 18
  - Phase 19
  - Phase 20
  - Phase 24
  - Phase 25
  - Phase 26
  - Phase 23
  - Phase 27

## What to build first in code

If implementation starts now, the best first slice is still:

1. Add a small tvOS parity/section manifest.
2. Define shared payload contracts for:
   - Home prayer summary
   - Qur'an continue reading
   - daily verse
3. Refactor `ios/PathOfNurTV` to consume those contracts instead of growing more local seed-only ownership.

That gives stable scaffolding early, keeps iOS safe, and prevents the tvOS app from becoming a parallel product silo.
