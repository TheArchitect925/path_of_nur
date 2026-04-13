# Prompt Archive

===== PHASE X PROMPT — HADITH FILTER UX REFINEMENT (RESET + SPACING + ACTIVE SUMMARY) =====

PRIMARY OBJECTIVE === REFINE THE HADITH FILTER UX SO IT FEELS CALMER, CLEARER, AND EASIER TO UNDO WITHOUT REDESIGNING THE PAGE

You are working in the existing Flutter codebase for “Path of Nūr”.

Task type:
Production-ready UX refinement for the shared Hadith browse filter controls.

Background:
The shared Hadith `Narrow this list` control was recently improved by removing the inner nested glass section, leaving the outer card intact. That helped reduce compression and should also slightly reduce render cost.

Now we want the next safe refinement pass:
- add a compact `Reset all` action
- improve vertical spacing/rhythm between the tab row and option chips
- add a small active-filter summary so users can immediately understand what is currently applied

Execution rules:
1. Audit the live implementation first before editing.
2. Do not redesign the global UI.
3. Keep the current page structure and overall visual language intact.
4. Do not reintroduce heavy nested glass surfaces.
5. Preserve localization.
6. Keep this production-ready and maintainable.
7. Do not turn the filter area into a heavy or cluttered control panel.
8. Run analyzer on changed files and summarize results.

Implement the following:

A. Add a compact `Reset all` action
- Add a subtle `Reset all` action inside the top filter card.
- It should be easy to discover but visually lightweight.
- Prefer placing it in the same top area as the filter title/heading if that fits the current layout cleanly.
- The action should reset all active filters and return the page to its default narrowing state.
- Keep behavior deterministic and safe.

B. Improve vertical spacing
- Add a bit more vertical spacing between:
  - the tab row and the option chips
  - chip groups and the following content
  - any stacked rows that currently feel compressed
- Keep the spacing restrained and aligned with the app’s calm visual language.
- Do not create excessive empty space.

C. Add an active-filter summary
- Add a compact summary of the currently active filters inside the same top card.
- Keep it simple and readable.
- Good examples:
  - inline summary text
  - small active chips
  - a lightweight “Showing: …” row
- The summary should help users quickly see what is applied without clutter.
- If no filters are active beyond the default state, keep the summary minimal or hidden.

D. Preserve existing behavior
- Do not change the meaning of the existing filters.
- Do not change sorting/filter logic unless needed for the reset behavior.
- Do not alter navigation into the reader.
- Do not break lazy rendering or summary-first behavior already added in prior phases.

E. Keep this phase scoped
DO implement:
- `Reset all`
- spacing/rhythm improvements
- active-filter summary

DO NOT implement yet:
- bottom sheet picker for large source groups
- major filter architecture changes
- advanced faceted search behavior
- UI redesign

F. Validation
Confirm:
1. `Reset all` restores default filter state correctly
2. active filters are easier to understand at a glance
3. spacing feels less compressed
4. the filter area remains visually calm
5. analyzer passes

Deliverables:
Provide a concise summary with:
- files changed
- where `Reset all` was added
- how active filter summary is shown
- what spacing adjustments were made
- analyzer results

At the very end, include a short audit note on the best next phase after this:
1. bottom sheet for large filter groups
2. stronger mobile chip overflow handling
3. compact sticky filter summary on scroll

===== END =====
