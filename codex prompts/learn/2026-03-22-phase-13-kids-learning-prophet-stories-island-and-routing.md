# PHASE 13 PROMPT — KIDS LEARNING PROPHET STORIES ISLAND AND ROUTING

PRIMARY OBJECTIVE === BUILDING A PROPHET STORIES ISLAND UNDER KIDS LEADING TO THE KIDS PROPHET STORIES EXPERIENCE

You are working in the existing Flutter codebase for Path of Nūr.

This is a targeted production-ready enhancement phase built on top of the existing Kids Learning and Prophet Stories systems. DO NOT rebuild the Kids section. DO NOT remove existing prophet story content, kids story content, learning routes, or saved progress/state. Build safely on top of the current implementation.

--------------------------------------------------
CORE RULES
--------------------------------------------------
- Audit first before editing
- Preserve all existing kids content, prophet stories, routes, progress, bookmarks, notes, and learning state
- Do not delete or rewrite existing story content
- Do not break current Kids Learning navigation
- Keep the change scoped to adding and wiring the new island cleanly
- Reuse existing kids prophet story pages/content rather than rebuilding them
- Keep the UI consistent with the Kids Learning island pattern already used in the app
- No unnecessary package churn
- At the end, provide a concise audit summary

--------------------------------------------------
PHASE OBJECTIVES
--------------------------------------------------

1. Create a new Prophet Stories island under the Kids Learning section

2. Link that island to the existing kids prophet stories experience

3. Ensure the destination is the correct kids-focused prophet stories page/content, not a generic or adult-facing prophet page

4. Keep the Kids Learning section organized and consistent with the rest of the app

--------------------------------------------------
A. AUDIT (MANDATORY FIRST STEP)
--------------------------------------------------

Audit the current implementation before editing.

Inspect:
- Kids Learning main page / hub
- current kids islands/cards
- current prophet stories pages
- existing kids prophet story content and routes
- whether kids prophet stories already have a dedicated page
- whether current prophet routes mix kids and non-kids content
- any shared island/card components used in Kids Learning

Audit these questions:
- Where should the new Prophet Stories island live in the Kids Learning layout?
- Is there already a dedicated kids prophet stories page?
- If not, which existing route is the safest correct destination for now?
- Are the kids prophet stories currently reachable elsewhere only indirectly?
- Is there any existing story grouping/order that should be preserved?

--------------------------------------------------
B. CREATE PROPHET STORIES ISLAND UNDER KIDS LEARNING
--------------------------------------------------

Add a new island/card in the Kids Learning section titled appropriately for Prophet Stories.

Requirements:
- it should visually match the existing Kids Learning island style
- it should feel like a natural part of the Kids section
- it should not clutter the page
- placement/order should make sense relative to the existing kids islands

Use the current shared island/card design system where possible.

--------------------------------------------------
C. LINK TO THE KIDS PROPHET STORIES EXPERIENCE
--------------------------------------------------

Wire the new Prophet Stories island to the correct kids prophet stories destination.

Requirements:
- route to the kids-focused prophet stories page/content
- do not route to a generic non-kids prophet page unless that is currently the only real destination and it is explicitly filtered/safe for kids
- preserve current navigation and back behavior
- do not create duplicate pages if the correct one already exists

If the existing page needs a light routing adjustment or filtering layer so the island lands in the proper kids experience, do that safely without rebuilding the content system.

--------------------------------------------------
D. ENSURE KIDS-SPECIFIC CONTENT OWNERSHIP
--------------------------------------------------

Make sure this island truly represents the kids prophet stories experience.

Requirements:
- surface the children-focused prophet stories already created
- do not mix in adult-oriented layouts/content if a kids route exists
- preserve story ordering and current content structure where appropriate
- if a shared prophet stories page is reused, ensure the kids entry lands in the kids-filtered view/state

--------------------------------------------------
E. LIGHTWEIGHT KIDS SECTION CONSISTENCY SWEEP
--------------------------------------------------

After adding the island, do a light consistency check on the Kids Learning section.

Check:
- island spacing/order
- route correctness
- wording consistency
- no duplicate prophet-story entry points that confuse the user
- visual consistency with the rest of the kids islands

Do not do a broad Kids redesign in this phase.

--------------------------------------------------
F. DATA / STATE SAFETY
--------------------------------------------------

Preserve:
- existing prophet story content
- any saved progress/state tied to kids stories
- bookmarks/notes if applicable
- existing route names where possible
- existing kids learning functionality

No destructive migrations. No content removal.

--------------------------------------------------
G. TESTING
--------------------------------------------------

Add or update meaningful tests for:

- Prophet Stories island appears under Kids Learning
- tapping it opens the correct kids prophet stories destination
- existing kids learning routes still work
- no duplicate/broken routing is introduced

Do not add fake tests. Add regression protection that matters.

Run analyzer/tests for changed areas and report clearly.

--------------------------------------------------
DELIVERABLES
--------------------------------------------------

1. Files changed

2. Audit findings
   - current Kids Learning structure
   - existing kids prophet stories routing/content
   - chosen destination and why

3. Kids Learning update summary
   - where the Prophet Stories island was added
   - final routing behavior

4. Data safety summary
   - confirmation no kids story content/progress was lost

5. Validation
   - analyzer/tests run
   - results

6. FINAL AUDIT
   - what was completed
   - regressions found/fixed
   - any follow-up items left for later

--------------------------------------------------
SUCCESS CRITERIA
--------------------------------------------------

- a Prophet Stories island exists under Kids Learning
- it routes to the correct kids prophet stories experience
- the Kids Learning section remains clean and consistent
- no existing functionality is broken
- no story content or progress is lost

--------------------------------------------------
DO NOT DO IN THIS PHASE
--------------------------------------------------

Do not:
- rebuild the Kids Learning section
- rewrite prophet story content
- route users into the wrong non-kids experience
- create duplicate story systems unnecessarily
- broaden this into a full kids IA overhaul

Stay focused on adding the Kids Prophet Stories island and wiring it correctly.

--------------------------------------------------

“And We have certainly sent into every nation a messenger.” — Qur’an 16:36

===== END PHASE 13 PROMPT =====
