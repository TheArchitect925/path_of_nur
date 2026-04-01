# Learn Retirement Planning Backlog

## Purpose

This backlog records which Learn routes and surfaces may become retirement candidates later, what signals to monitor, and what must remain intact before any removal decision is considered.

This file is not permission to delete anything now.

## Safe to keep as compatibility aliases indefinitely if needed

- `/learn/browse` -> `/learn/explore`
- `/learn/hub/quran*` compatibility redirects into `/quran/*`
- `/learn/hub/trivia/*` compatibility redirects into `/learn/quizzes/trivia/*`
- `/learn/hub/salah` and `/learn/section/salah` -> `/learn/salah`

## Retirement candidates to monitor

### Candidate: `/learn/legacy`

- Impact: high
- Risk: high
- Monitor:
  - `legacy_route_opened` for `/learn/legacy`
  - landing library shortcut usage
- Retire only if:
  - 30-day usage remains near-zero across multiple release cycles
  - search/discovery no longer depends on the route
  - no hidden catalog or old journey metadata still requires it
- Not ready yet because:
  - older content and compatibility references may still exist

### Candidate: `/learn/journey-home`

- Impact: medium
- Risk: medium
- Monitor:
  - `legacy_route_opened` for `/learn/journey-home`
- Retire only if:
  - direct opens remain near-zero
  - parity with `/learn/learning-journey` is behaviorally confirmed
  - no saved or shared links still target it materially
- Not ready yet because:
  - UX parity still needs dedicated review

### Candidate: `/learn/learning-journey`

- Impact: medium
- Risk: medium
- Monitor:
  - `legacy_route_opened` for `/learn/learning-journey`
- Retire only if:
  - a replacement entry surface clearly supersedes it
  - guided path and browse behavior are fully covered elsewhere
  - product wants it demoted from visible entry to compatibility-only
- Not ready yet because:
  - it still plays an active role in the learning journey system

### Candidate: `/learn/hub/salah`

- Impact: low
- Risk: low
- Monitor:
  - `compatibility_alias_hit` for `/learn/hub/salah`
  - `compatibility_alias_hit` for `/learn/section/salah`
- Retire only if:
  - alias hits remain at zero for an extended period
  - no old internal navigation helpers still emit the alias

### Candidate: `/learn/hub/trivia*`

- Impact: low
- Risk: low
- Monitor:
  - `compatibility_alias_hit` for the trivia alias family
- Retire only if:
  - zero recent alias hits
  - no legacy links or old prompts/docs still send traffic there

## Compatibility checks required before any retirement

- guided path targets still resolve correctly
- personalization recommendations do not reference the candidate route
- search/discovery metadata no longer launches the candidate route
- any route params are preserved by the replacement path
- no kids flow or Qur'an ownership is affected
- tvOS parity review is completed if a mirrored surface is involved

## Suggested retirement order

1. alias-only routes with canonical replacements already in place
2. old section/hub aliases with no direct surface ownership
3. browse/journey compatibility entries
4. high-risk legacy library surfaces last

## Explicit not-ready-yet candidates

- `/learn/legacy`
- `/learn/journey-home`
- `/learn/learning-journey`
- any Learn-side compatibility layer that still feeds older seeded content or hidden catalog items

## Telemetry and migration notes

- monitor at least multiple release windows before proposing actual retirement
- pair route telemetry with source-surface telemetry so silent internal dependencies are not missed
- document replacement routes in release notes if any future retirement becomes user-visible
- keep canonical `/quran/*` and kids route families out of retirement scope unless a separate dedicated plan exists

## Do-not-break notes

- do not remove aliases that still protect deep links
- do not break persisted progress or route-based saved state
- do not assume low traffic means safe removal without dependency review
- do not retire anything in the same pass that introduces new analytics for it
