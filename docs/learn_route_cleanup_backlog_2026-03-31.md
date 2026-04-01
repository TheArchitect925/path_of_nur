# Learn Route Cleanup Backlog

Date: 2026-03-31

## Safe to keep indefinitely as aliases

- `/learn/browse` -> `/learn/explore`
- old Learn-side `/learn/quran/*` compatibility redirects into `/quran/*`
- `/learn/hub/prophets` and `/learn/section/prophets`
- `/learn/hub/quizzes` and `/learn/section/quizzes`
- `/learn/hub/duas` and `/learn/section/duas`

These are low-cost compatibility routes and are unlikely to cause product confusion when hidden from primary UI.

## Candidate retirement routes for a later phase

- `/learn/journey-home`
- `/learn/legacy`
- `/learn/hub/salah`
- `/learn/hub/trivia*`

## Prerequisites before retiring anything

- confirm no important internal widgets still hardcode the old path
- confirm named-route users are already on canonical route names or safe redirected paths
- verify analytics/deep-link traffic on the old URLs
- verify hidden catalog items and old lesson metadata no longer depend on `learnLegacy`
- verify old saved or shared links still land correctly after any proposed retirement

## Telemetry / analytics checks needed

- measure live hits to `/learn/legacy`
- measure live hits to `/learn/journey-home`
- measure live hits to older `/learn/hub/trivia*` and `/learn/hub/salah`
- compare route usage after the newer `/learn` landing and guided paths rollout

## User-facing migration considerations

- keep compatibility redirects in place before removing any alias from visible UI
- avoid changing named routes used by widgets, seeded content, or guided paths unless strictly necessary
- do not retire any route that is still referenced by persisted content metadata until a compatibility layer replaces it

## Do-not-break notes

- `/learn` must remain the primary learning front door
- `/quran/*` must remain canonical
- `/learn/kids/*` must remain safe and discoverable
- guided paths must stay route-safe and continue to resolve their named targets
- search/index metadata must remain stable

## Follow-up cleanup opportunities

- document route ownership inline next to future aliases as they are added
- consider one shared Learn route ownership reference for future audits
- evaluate whether `/learn/journey-home` can eventually redirect to `/learn/learning-journey` after a dedicated UX review
- evaluate whether any remaining hub-style route names should gain cleaner canonical visible paths without breaking internal navigation
