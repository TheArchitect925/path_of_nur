# Navigation Gap Audit + Legacy Route Normalization Backlog

Date: 2026-03-23

## Completed in V5

- Audited remaining post-V4 Learn and Journey compatibility seams.
- Confirmed active Learn discovery and category routing already prefer canonical route ownership.
- Verified retained Learn alias redirects preserve query parameters to canonical targets.
- Clarified `learnLegacy` as a hidden compatibility surface rather than a live canonical owner.
- Added focused alias-integrity regression coverage.

## Deferred follow-up

- Review whether hidden `learnLegacy` tool links in Learning Journey metadata can be replaced with more specific canonical destinations without changing product meaning.
- Audit hidden Learn catalog items still pointing at `learnLegacy` and decide whether any now merit feature-owned canonical routes.
- Add broader query/path forwarding coverage for remaining non-Learn compatibility layers such as `/growth/*` and `/journey/tracking`.
- Decide whether route-name debt around older ownership naming should be addressed in a later compatibility cleanup phase without breaking `pushNamed` callers.

## Next highest-value navigation cleanup

- A narrow Learn metadata ownership pass:
  - normalize hidden Learning Journey tool links where a canonical feature target is now clearly better
  - keep `learnLegacy` only for genuinely unresolved library-style destinations
