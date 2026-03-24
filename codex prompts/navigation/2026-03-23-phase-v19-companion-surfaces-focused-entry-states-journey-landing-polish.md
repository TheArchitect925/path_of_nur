# ===== PHASE V19 PROMPT — COMPANION SURFACES FOCUSED ENTRY STATES + JOURNEY LANDING POLISH =====

## PRIMARY OBJECTIVE === BUILDING COMPANION SURFACES FOCUSED ENTRY STATES + JOURNEY LANDING POLISH

You are working in the existing Flutter codebase for Path of Nūr.

Goal:
Make Journey-to-companion-surface landings feel intentional and focused.

Critical safety rule:
Do not redesign Journey architecture.
Do not add complicated deep-link state machines.
Only improve landing intent where it is safe and clearly helpful.

Task type:
Entry-state polish + journey handoff refinement.

Implement:
1. Audit how Journey currently lands users into:
   - /learn/seerah
   - /learn/character
   - /learn/daily-wisdom
2. Improve focused entry behavior using clean query-state where useful, such as:
   - focus=hijrah
   - focus=madinah-society
   - focus=mercy
   - focus=gratitude
3. Improve page headers/subtitles/section emphasis when entered from Journey.
4. Ensure the landing feels context-aware but still reusable as a standalone surface.
5. Keep route logic simple and stable.
6. Add/update tests for focused entry behavior if changed.
7. Run analyzer and relevant tests.

Deliverables:
- audit findings
- focused landing improvements
- files changed
- tests run
- analyzer result
- unresolved entry-state gaps
