# ===== PHASE V18 PROMPT — COMPANION SURFACES SAVE / REVISIT / HISTORY LAYER =====

## PRIMARY OBJECTIVE === BUILDING COMPANION SURFACES SAVE / REVISIT / HISTORY LAYER

You are working in the existing Flutter codebase for Path of Nūr.

Goal:
Add a lightweight persistence layer for companion surfaces so users can resume and revisit meaningfully.

Critical safety rule:
Do not create a massive profile/settings framework just for this.
Do not delete or overwrite existing persistence behavior for no reason.
Use existing app persistence patterns wherever practical.

Task type:
Lightweight persistence + continuity enhancement.

Implement:
1. Audit current available persistence patterns in the app.
2. Add a scoped lightweight model for companion surface state such as:
   - last Seerah focus/section
   - selected Character trait
   - recent/saved Daily Wisdom entries
3. Support safe restore behavior where useful.
4. Add subtle UI affordances like:
   - continue exploring
   - recently viewed
   - saved wisdom
5. Keep the implementation local/simple and production-safe.
6. Do not add heavy sync or backend complexity.
7. Add targeted tests for the new state behavior.
8. Run analyzer and relevant tests.

Deliverables:
- persistence audit findings
- scoped state added
- files changed
- tests run
- analyzer result
- what remains intentionally out of scope
