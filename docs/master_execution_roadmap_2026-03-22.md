# Path of Nūr Master Execution Roadmap

Last updated: 2026-03-22

This document consolidates the recent architecture, kids-system, progression, routing, worship/date, and test-hardening work into one execution-oriented master view.

It does not replace feature-specific backlogs. It identifies:
- what is genuinely strong now
- what is stable but still expandable
- what is partial or asset-dependent
- what legacy paths still exist intentionally
- what the next build phases should be

## A. Master Current State

### Production-ready

- Learner-scoped kids architecture foundation
  - bedtime stories, bedtime learning, Seerah, Kids Arabic, Kids Dua progression/My Day, learner progression, and canonical kids activity logging now share the same learner-scoped direction.
- Shared learner progression gateway
  - XP and Ocean Drops for the newer kids systems now flow through one canonical learner progression layer instead of separate feature-owned writes.
- Canonical kids activity logging
  - meaningful recent activity across bedtime stories, Seerah, Kids Arabic, Kids Dua, and bedtime routines now has one learner-aware source of truth.
- Parent summary architecture
  - the parent dashboard is no longer bedtime-only; it aggregates real cross-feature learner activity and safely falls back when canonical activity is missing.
- Learn route ownership documentation
  - canonical `/learn/explore` vs compatibility aliases and ownership boundaries are now documented, with smoke-test protection for key canonical/alias paths.
- Worship date helper regression protection
  - prayer date formatting and relative/Hijri handling now has focused regression tests.

### Stable but expandable

- Bedtime stories system
  - architecture, learner scoping, player, learning loop, and parent summary are strong. Remaining work is mostly media, richer summaries, and polish.
- Kids stories library
  - the shared story engine now supports prophets, non-prophet stories, and companion-story use cases. The architecture is sound; breadth and media depth are the next steps.
- Seerah journeys
  - the journey model, learner-scoped progress, and companion-story reuse are stable. The current limitation is content depth, not system direction.
- Garden / visual growth
  - the learner-scoped garden is architecturally sound and linked to progression, but still depends on reused art and proxy prayer signals.
- Regression protection for recent kids systems
  - service/provider/widget/integration coverage is now meaningfully better for learner scope, parent summaries, route alignment, and canonical activity handoffs.

### Partially complete

- Learn information architecture
  - route ownership is clearer, but `/learn`, `/learn/legacy`, journey-first discovery, and older hub surfaces still overlap.
- Learning Journey content
  - journey infrastructure exists, but several user-facing journey destinations are still mixed between real content and placeholder/bridge states.
- Parent dashboard richness
  - summary architecture is strong, but it is still lighter for some newer learning domains than for bedtime prophet stories.
- Kids content/media rollout
  - several newer systems are architecturally complete but still rely on transcript/read fallback until real art/audio bundles are added.
- Localization readiness
  - recent systems are localization-ready, but the broader app still has high-traffic English-only or partially localized surfaces.

### Legacy / compatibility still present

- Learn alias routes
  - multiple compatibility routes remain intentionally supported to avoid breaking older deep links and internal navigation.
- Bedtime fallback learner
  - still intentionally exists for households without a child profile.
- Parent dashboard fallback aggregation
  - still falls back to progression-derived bedtime totals or older signals when canonical activity/progression history is absent.
- Global Journey ledgers
  - older surfaces still read formula-based XP or direct Drops in places outside the newer learner progression path.

### Future-ready only

- Bedtime/kids media richness
  - many recent kids surfaces are ready for audio/art bundles but are not truly content-complete yet.
- Dedicated child prayer contributions
  - garden roots/foundation still use a proxy until learner-scoped child prayer data becomes canonical.
- Watch and tvOS release posture
  - real code exists, but release readiness is still not validated.

## B. Completed Recent Wins

- Unified kids learner scoping across the active kids systems.
- Removed the remaining direct Kids Arabic and Kids Dua reward-path drift into old global learning state.
- Added canonical kids activity logging and integrated it into the parent dashboard.
- Expanded the parent dashboard from bedtime-only to broader kids learning aggregation.
- Added a learner-scoped garden on top of the progression system instead of a parallel visual-growth engine.
- Documented canonical Learn route ownership versus aliases.
- Added focused regression tests plus integration-style learner-flow validation.
- Reduced fallback-household drift by aligning Kids Dua fallback learner identity with the bedtime-family fallback identity.

## C. Remaining Gaps

### Architecture

- Remaining formula-based XP and direct Ocean-drop consumers outside the newer learner progression path.
- Learn IA still has overlapping route families and legacy discovery layers.
- Some older feature-local recent-activity arrays still exist alongside the canonical kids activity ledger.

### UX / product

- Parent dashboard still has richer detail for bedtime prophet content than for broader kids domains.
- Garden home/profile previews are not yet surfaced in the main product flow.
- Some kids continue-learning recommendations still rely on lighter heuristics than a richer canonical activity-first strategy.

### Testing

- Kids Dua My Day does not yet have one full end-to-end integration flow that verifies progression + activity + parent summary together.
- Mixed-domain recent-activity ordering across Kids Arabic + Kids Dua + stories is still lightly covered.
- Learning Journey still needs stronger widget and persistence coverage.
- Broader release-smoke coverage across launch-critical app flows is still thinner than ideal.

### Content / assets

- Kids dua narrated audio and segment timing are still incomplete.
- Kids stories / Seerah art and narration are still incomplete.
- Garden still reuses existing milestone/background artwork instead of a dedicated visual pack.
- Some broader learning datasets remain English-first even where UI chrome is localized.

### Platform-specific

- iOS real-device prayer/audio/reminder validation is still pending.
- watch real-device QA remains incomplete.
- tvOS parity validation remains incomplete.

## D. Legacy / Compatibility Items

These remain intentionally:

- Learn aliases such as `/learn/browse`, `/learn/hub/quran`, `/learn/hub/prophets`, and older section routes.
  - Reason: compatibility for existing deep links and older internal navigation.
- Bedtime fallback learner.
  - Reason: supports no-child-profile households without blocking kids features.
- Parent dashboard fallback summaries.
  - Reason: older data may predate the canonical activity/progression layers.
- Legacy Learn hub at `/learn/legacy`.
  - Reason: migration is still underway; removing it now would be riskier than documenting and constraining it.

These should not be expanded in new work unless there is a clear migration plan.

## E. Risk Areas To Monitor

- Learn route and IA drift
  - New work could still accidentally use compatibility aliases instead of canonical destinations.
- Progression truth drift
  - Older Journey XP/Drops consumers can still diverge from the newer learner progression architecture if left un-migrated too long.
- Parent summary drift
  - As more kids domains expand, the parent dashboard can become uneven again unless aggregation tests stay current.
- Canonical activity under-coverage
  - New kids interactions may quietly reintroduce feature-local recent-state shortcuts if they are not wired to the shared activity ledger.
- Content readiness confusion
  - Some systems are architecturally strong but not media-complete; that distinction needs to stay explicit in planning.

## F. Master Prioritized Backlog

### P0 critical

1. Localize high-traffic Settings and accounts/sync surfaces
   - Why: this is a real launch-quality blocker and affects core navigation ownership.
   - Scope: medium
   - Timing: next 1-2 phases

2. Migrate remaining older XP / Ocean-drop consumers to canonical ledgers
   - Why: parallel progression truth is the biggest remaining architecture drift outside kids systems.
   - Scope: medium
   - Timing: next 1-3 phases

3. Finalize Learn ownership and reduce one layer of route overlap
   - Why: Learn remains the most drift-prone area of the repo.
   - Scope: medium
   - Timing: next 1-2 phases

4. Run real-device iOS prayer/audio/reminder QA
   - Why: code quality is improving, but release confidence still depends on hardware validation.
   - Scope: medium
   - Timing: before any release-readiness push

### P1 high-value next

1. End-to-end Kids Dua My Day integration validation
   - Why: it is the most meaningful remaining kids flow not yet covered end-to-end.
   - Scope: small
   - Timing: next phase candidate

2. Broaden parent summary guidance and recent-activity quality
   - Why: the architecture is ready; the next gain is usefulness and clarity.
   - Scope: medium
   - Timing: next 1-3 phases

3. Build home/profile garden previews plus canonical child prayer linkage plan
   - Why: the garden is architecturally strong but still somewhat isolated and partly proxy-driven.
   - Scope: medium
   - Timing: next 2-4 phases

4. Replace the most visible Learning Journey placeholder-backed destinations
   - Why: user-facing mixed quality is a product risk.
   - Scope: medium to large
   - Timing: next 2-4 phases

5. Add real media rollout for V1 kids dua and kids stories priorities
   - Why: content/media readiness is now the main limiter for some otherwise solid systems.
   - Scope: large
   - Timing: once the architecture sweep is stable

### P2 good next

1. Expand Seerah journey content packs and companion-story depth
   - Why: the system is ready and now limited mostly by content breadth.
   - Scope: medium to large
   - Timing: after Learn/kids stabilization priorities

2. Improve mixed-domain recent-activity ordering and continue-learning logic
   - Why: stronger canonical activity use will improve the quality of parent/kids summaries.
   - Scope: medium
   - Timing: after more end-to-end integration coverage

3. Add widget/integration coverage for Learning Journey home and continuation behavior
   - Why: current route/content migration work still lacks enough UI-level protection.
   - Scope: medium
   - Timing: alongside Learn IA cleanup

4. Add dedicated garden art pack and richer calm transitions
   - Why: current garden is structurally good but visually still V1.
   - Scope: large
   - Timing: after the progression and prayer-data side is stable

### P3 later / optional

1. Broaden parent dashboard into richer guidance notes and deeper category summaries
   - Why: useful, but not urgent until more content/assets are live.
   - Scope: medium
   - Timing: later

2. Expand canonical kids activity taxonomy if new domains truly need it
   - Why: avoid overbuilding too early.
   - Scope: small to medium
   - Timing: later

3. Replace remaining reused garden art with a full symbolic layered scene system
   - Why: polish and emotional depth, not architecture-critical.
   - Scope: large
   - Timing: later

## G. Recommended Next Execution Phases

1. Phase next: `Kids Dua My Day end-to-end integration + parent-summary handoff`
   - Add one real completion flow covering activity, progression, parent summary, and sparse-state behavior together.

2. Phase next: `Learn IA consolidation batch`
   - Narrow `/learn` ownership, constrain alias use further, and replace one more layer of overlap/placeholder routing.

3. Phase next: `Global XP / Drops migration sweep outside kids`
   - Finish moving the older Journey formula/direct-award consumers onto canonical ledgers.

4. Phase next: `Settings + Accounts localization hardening`
   - Remove one of the most visible release blockers.

5. Phase next: `Kids media rollout V1`
   - Add real audio/art for the strongest new kids systems once the architecture and validation passes are stable.

## H. Final Execution Roadmap

Recommended build sequence:

1. Protect the remaining highest-value kids flow:
   - Kids Dua My Day integration validation

2. Resolve the biggest cross-cutting architecture seam:
   - Learn IA / route overlap cleanup

3. Resolve the other big cross-cutting seam:
   - canonical XP / Drops migration outside kids

4. Remove the biggest launch-quality UX blocker:
   - settings/accounts localization hardening

5. Deepen production readiness:
   - iOS real-device validation
   - watch/tvOS parity/QA where relevant

6. Convert architecture wins into product richness:
   - kids media rollout
   - garden previews/art polish
   - broader parent guidance

## Cross-reference Backlogs

Use this roadmap with:
- [kids_integration_validation_backlog.md](/Users/shahabmansoor/Developer/path_of_nur/docs/kids_integration_validation_backlog.md)
- [kids_scope_migration_sweep_backlog.md](/Users/shahabmansoor/Developer/path_of_nur/docs/kids_scope_migration_sweep_backlog.md)
- [learn_route_alias_cleanup_backlog.md](/Users/shahabmansoor/Developer/path_of_nur/docs/learn_route_alias_cleanup_backlog.md)
- [garden_visual_growth_backlog.md](/Users/shahabmansoor/Developer/path_of_nur/docs/garden_visual_growth_backlog.md)
- [final_product_audit_backlog.md](/Users/shahabmansoor/Developer/path_of_nur/docs/final_product_audit_backlog.md)
