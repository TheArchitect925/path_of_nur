# Phase 51 Prompt — Adult Arabic Overview (Calm Self-Guided Dashboard)

PRIMARY OBJECTIVE === BUILDING A CALM, SELF-GUIDED ADULT ARABIC OVERVIEW THAT SURFACES PROGRESS, CONTINUE/REVIEW, AND CLEAR NEXT STEPS USING SHARED FOUNDATIONS

You are working in the existing Flutter codebase for Path of Nūr.

This phase builds on top of:
- shared Arabic alphabet foundation
- shared positional-form foundation
- shared audio manifest
- shared words/phrases foundation
- Adult Arabic letter/word/reading-helper surfaces (Phase 36)
- unified continuity/resume layer (Phase 37)
- shared gentle review layer (Phase 38)
- Arabic search/filter (Phase 41)
- calm progress dashboard foundations (Phase 42)
- shared content authoring framework (Phase 50)

DO NOT rebuild Adult Arabic from scratch. DO NOT break Kids Arabic, tracing, reading, routing, or shared foundations. Build safely on top of the current implementation.

--------------------------------------------------
CORE RULES
--------------------------------------------------
- Audit first before editing
- Preserve all existing Adult Arabic flows, routing, progress, and shared foundations
- Keep UX calm, clean, and self-guided (no gamification noise)
- No grades, rankings, or pressure
- Reuse shared continuity/review/progress signals
- Avoid duplicated logic across pages
- No destructive migrations
- Run analyzer/tests and summarize results

--------------------------------------------------
PHASE OBJECTIVES
--------------------------------------------------

1. Create a dedicated Adult Arabic overview surface
2. Summarize key signals:
   - letters completed
   - words/phrases completed
   - recent activity
   - next recommended step (continue)
   - gentle review suggestion (if applicable)
3. Make it easy for an adult learner to:
   - understand where they are
   - resume immediately
   - choose a simple next action
4. Keep presentation distinct from Kids and parent views
