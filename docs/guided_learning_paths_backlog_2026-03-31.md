# Guided Learning Paths Backlog

Date: 2026-03-31

## Phase A — Safety and validation

- Add focused tests for path-state serialization, resume priority, and completion idempotency.
- Verify each seeded route target still resolves after any future Learn or Qur'an route cleanup.
- Add a do-not-break checklist for canonical `/quran/*` handoff and kids-only visibility.

Risk: low
Dependencies: current V1 implementation

## Phase B — Completion improvements

- Reuse trustworthy completion signals from destination surfaces where available.
- Auto-complete simple step types when an existing page already emits a safe completion event.
- Add lightweight "completed from destination" handoff hooks without introducing a second reward system.

Risk: medium
Dependencies: route-owner-specific completion hooks

## Phase C — Personalization and recommendations

- Recommend a starter path from audience/profile state.
- Suggest the next best path after completion.
- Surface path continuity in more owned domains without duplicating hubs.

Risk: medium
Dependencies: current resume state and path metadata

## Phase D — Path content expansion

- Add Ramadan, seerah, hadith, Qur'anic Arabic, and review-focused paths.
- Add intermediate/advanced path variants.
- Fill content gaps where a starter path currently routes to a broad owner surface instead of a narrower lesson node.

Risk: medium
Dependencies: content audits per domain

## Phase E — Search and discoverability

- Decide whether guided paths should appear in Learn search.
- If yes, expose searchable metadata centrally rather than building page-local matching.
- Consider path chips/tags inside Explore All without turning the landing into a directory again.

Risk: low
Dependencies: search/index metadata decision

## Phase F — Analytics and rewards refinement

- Add explicit analytics for path start, step open, step complete, resume, and completion.
- Review reward balance after real usage so repeated path completion cannot distort XP/drop pacing.
- Consider a small completion celebration state that reuses existing reward language.

Risk: medium
Dependencies: product analytics conventions

## Phase G — Route and ownership cleanup opportunities

- Keep current compatibility routes intact until a dedicated migration pass.
- If future restructuring narrows owner surfaces, remap path steps centrally in the seed layer instead of touching UI.
- Preserve `/learn/legacy`, `/learn/journey-home`, `/learn/learning-journey`, kids routes, and `/quran/*` unless a later migration explicitly replaces them safely.

Risk: high if done early
Dependencies: future IA work

## Discovered content gaps

- Some starter steps still point to broad hubs because no narrower route-safe owned step exists yet.
- Character and Dhikr can benefit from deeper route-backed lesson nodes later.
- A path-specific completion event layer does not yet exist across all Learn domains.

## Do-not-break notes

- `/quran/*` stays canonical.
- Kids Starter Path must remain audience-safe and must not replace the kids hub.
- Guided paths must remain an orchestration layer, not a duplicate content system.
- Existing Learn search/indexing and route aliases must stay intact unless a dedicated migration pass replaces them.
