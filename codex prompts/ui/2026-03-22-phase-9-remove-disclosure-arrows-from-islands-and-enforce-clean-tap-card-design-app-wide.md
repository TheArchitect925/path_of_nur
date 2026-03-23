# Phase 9 Prompt — Remove Disclosure Arrows From Islands And Enforce Clean Tap Card Design App-Wide

- [ ] Remove Surah arrows

===== PHASE 9 PROMPT — REMOVE DISCLOSURE ARROWS FROM ISLANDS AND ENFORCE CLEAN TAP CARD DESIGN APP-WIDE =====

PRIMARY OBJECTIVE === BUILDING A CLEAN APP-WIDE ISLAND DESIGN SYSTEM WITHOUT DISCLOSURE ARROWS OR OPEN INDICATORS

You are working in the existing Flutter codebase for Path of Nūr.

This is a targeted production-ready UI consistency phase. DO NOT rebuild the app. DO NOT break navigation, routing, taps, semantics, accessibility, or page functionality. Build safely on top of the current implementation.

--------------------------------------------------
CORE RULES
--------------------------------------------------
- Audit first before editing
- Preserve all existing navigation behavior
- Do not remove tap functionality from islands/cards/containers
- Do not remove page destinations or routing
- Do not break accessibility or semantic tap affordances
- Keep scope focused on disclosure-arrow cleanup and app-wide enforcement
- Reuse shared components and design tokens where possible
- Do not create one-off local hacks when a shared fix is the right solution
- At the end, provide a concise audit summary

--------------------------------------------------
PHASE OBJECTIVES
--------------------------------------------------

1. Remove the arrows from the Surah List / Surah Explorer

2. Enforce this app-wide:
   - islands
   - island-like cards
   - tappable containers
   - summary cards
   - section entry containers

They should NOT show:
- chevrons
- arrows
- trailing disclosure indicators
- “open” affordance icons
- similar visual hints that make the UI feel cluttered

3. Keep the design clean and minimal while preserving clear tap behavior

4. Establish a shared enforcement pattern so future islands/containers do not reintroduce arrows

--------------------------------------------------
A. AUDIT (MANDATORY FIRST STEP)
--------------------------------------------------

Audit the current UI implementation before editing.

Inspect:
- Surah List / Surah Explorer item rows
- shared island components
- shared tappable card/container components
- any reusable list tile wrappers
- any shared row builders that automatically inject trailing arrows
- any pages where containers/islands/cards currently show arrows or disclosure icons
- any places where arrows are added conditionally
- any places where the same visual pattern is implemented manually rather than through shared components

Audit these questions:
- Where are arrows currently coming from?
- Are they coming from ListTile trailing widgets, custom row components, or shared card wrappers?
- Which surfaces are true “islands/containers” versus standard text/list rows where different behavior may still be appropriate?
- Is the Surah Explorer using a shared component that also affects other pages?
- What is the safest shared enforcement point to prevent future regressions?

--------------------------------------------------
B. REMOVE ARROWS FROM SURAH LIST / SURAH EXPLORER
--------------------------------------------------

Remove the trailing arrows/chevrons/open indicators from the Surah List / Surah Explorer.

Requirements:
- Surah rows/items must remain fully tappable
- typography, spacing, and tap area should still feel intentional
- do not create awkward empty trailing space where arrows used to be
- keep the row balanced and clean
- preserve current routing/navigation into surah detail/reader

If needed, rebalance:
- spacing
- alignment
- text width
- subtitle/reference placement
- row padding

But do not redesign the full page.

--------------------------------------------------
C. ENFORCE APP-WIDE NO-ARROW RULE FOR ISLANDS / CONTAINERS
--------------------------------------------------

Enforce a design rule across the app:

Islands/containers should never show arrows or other visual indicators that they can be opened.

This includes:
- island cards
- tappable summary containers
- feature-entry containers
- dashboard cards
- destination cards
- explorer containers
- category containers
- resume/continue containers
- list-like island surfaces styled as cards/containers

Requirements:
- remove trailing arrows/chevrons from these surfaces
- preserve tap behavior
- preserve navigation
- preserve semantic meaning and accessibility
- keep the design visually clean and premium

Do NOT rely on manual per-page cleanup alone if there is a shared component or shared pattern that should be corrected centrally.

--------------------------------------------------
D. DEFINE WHAT SHOULD STILL BE ALLOWED
--------------------------------------------------

Be careful not to remove useful icons that are not disclosure arrows.

Allowed if they serve a real content purpose:
- playback controls
- favorite/bookmark/status icons
- badges/counters
- metadata icons
- filter/sort icons
- action buttons
- warning/error indicators
- progress/status visuals

Not allowed for islands/containers:
- generic chevrons
- generic arrows
- trailing “open” indicators
- redundant disclosure affordances

If a surface is not an island/container and is instead a true settings row or system-like preference row where a disclosure pattern is intentionally required, audit carefully before changing it. Only remove arrows where the design rule applies.

--------------------------------------------------
E. SHARED COMPONENT ENFORCEMENT
--------------------------------------------------

Find the best shared enforcement point and implement it cleanly.

Examples may include:
- shared island widget
- shared tappable card
- shared list-entry container
- reusable section tile
- explorer row widget
- custom wrapper around ListTile or InkWell container

Requirements:
- centralize behavior where practical
- reduce future reintroduction risk
- avoid one-off overrides all over the app
- keep the API clean for future developers
- if needed, replace automatic trailing-arrow defaults with explicit opt-in behavior rather than implicit default behavior

Preferred pattern:
- no disclosure arrow by default
- only explicit trailing content when it serves a real product function

--------------------------------------------------
F. VISUAL CLEANUP AFTER ARROW REMOVAL
--------------------------------------------------

After arrows are removed, make sure surfaces still look polished.

Check and adjust where necessary:
- text alignment
- row balance
- spacing consistency
- card padding
- trailing whitespace
- leading/trailing symmetry
- title/subtitle wrapping
- touch target behavior

The result should look intentionally minimalist, not like something was simply deleted.

--------------------------------------------------
G. ACCESSIBILITY / TAP CLARITY
--------------------------------------------------

Even without arrows, tappable surfaces must still feel usable.

Requirements:
- maintain clear tap affordance through layout, card styling, ripple/press feedback, and hierarchy
- keep InkWell/Gesture behavior correct
- preserve semantic button/tap roles where appropriate
- do not reduce touch target size

This phase is about removing visual clutter, not removing usability cues entirely.

--------------------------------------------------
H. REGRESSION SWEEP
--------------------------------------------------

After the shared change, sweep the app for regressions.

Check especially:
- Surah Explorer
- Learning Hub islands
- Growth islands
- Qur’an home entry containers
- Continue/Resume cards
- Browse/Explore cards
- Statistics/Garden cards
- Notes-related cards if styled as tappable containers
- Any page using shared card-entry components

Ensure:
- no arrows remain where they should not
- no layouts are broken
- no destinations stopped working

--------------------------------------------------
I. TESTING
--------------------------------------------------

Add or update meaningful regression protection for the shared behavior.

Prioritize:
- Surah Explorer rows render without trailing arrow
- shared island/container widgets do not render disclosure arrows by default
- tappable destinations still work
- pages using shared island components still render correctly
- no layout overflow caused by the change

Do not add fake tests. Add useful regression protection.

Run analyzer/tests for changed areas and report clearly.

--------------------------------------------------
DELIVERABLES
--------------------------------------------------

1. Files changed

2. Audit findings
   - where arrows were coming from
   - whether the issue was shared or page-local
   - which surfaces were affected

3. Surah Explorer cleanup summary
   - what changed
   - how layout was rebalanced

4. App-wide enforcement summary
   - shared components updated
   - pages/components affected
   - how future regressions are prevented

5. Accessibility / usability summary
   - how tap clarity was preserved without arrows

6. Validation
   - analyzer/tests run
   - results

7. FINAL AUDIT
   - what was completed
   - regressions found/fixed
   - any remaining exceptions kept intentionally
   - any technical debt left for later

--------------------------------------------------
SUCCESS CRITERIA
--------------------------------------------------

- Surah List / Surah Explorer no longer shows arrows
- islands/containers no longer show disclosure arrows app-wide
- navigation/tap behavior still works everywhere
- layout remains clean and balanced
- shared component enforcement is in place
- future arrow regressions are less likely
- the app feels cleaner and more premium

--------------------------------------------------
DO NOT DO IN THIS PHASE
--------------------------------------------------

Do not:
- rebuild page layouts unnecessarily
- remove useful content/status/action icons
- break routing or taps
- remove accessibility semantics
- do a general icon purge unrelated to disclosure arrows
- change unrelated design language in this phase

Stay focused on removing disclosure arrows from islands/containers and enforcing the cleaner design system app-wide.

--------------------------------------------------

“And Allah loves the doers of good.” — Qur’an 3:134

===== END PHASE 9 PROMPT =====
