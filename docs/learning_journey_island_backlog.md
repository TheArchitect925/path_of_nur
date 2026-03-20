# Learning Journey Island Backlog

Date: 2026-03-20

## Current state

- The main Learn hub now uses a dedicated `Learning Journey` island entry instead of embedding the Journeys section inline.
- The new island page reuses the lightweight current/recommended journey summary cards.
- The deeper Journey architecture remains intentionally unchanged for now.

## Next safe enhancement options

1. Decide whether `Learning Journey` should eventually replace `/learn/journey-home` as the canonical Journey landing route.

2. Add a dedicated empty-state experience for the Learning Journey island when no active journey or recommendation is available.

3. Decide whether the main Learn hub should also expose a compact `Learning Journey` shortcut dock action or keep Journeys reachable only through the island card.

4. Re-architecture Journeys separately:
   - clarify island -> journey -> stage ownership
   - remove remaining overlap between Learn discovery and Journey-managed content
   - define which journey surfaces stay lightweight and which become curriculum-first

5. Add widget coverage for:
   - Learn hub with the new Learning Journey island card present
   - Learning Journey island page with current journey
   - Learning Journey island page with only recommended journey
   - Learning Journey island page empty state
