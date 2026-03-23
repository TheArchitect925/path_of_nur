# Phase 25 Prompt — Learning Hub Routing Fixes, Page Destination Corrections, and Light IA Cleanup

- [ ] Phase 1

===== PHASE 25 PROMPT — LEARNING HUB ROUTING FIXES, PAGE DESTINATION CORRECTIONS, AND LIGHT IA CLEANUP =====

PRIMARY OBJECTIVE === FIX IDENTIFIED LEARNING HUB PAGE LINKS, ROUTING, DESTINATION CONTENT SURFACING, AND LIGHT INFORMATION ARCHITECTURE CLEANUP

You are working in the existing Flutter codebase for Path of Nūr.

This is a targeted production-ready routing and IA correction phase. DO NOT rebuild the Learning Hub or Learn system from scratch. DO NOT remove existing content, notes, bookmarks, progress, or routes unless explicitly required by the scoped fixes below. Build safely on top of the current implementation.

--------------------------------------------------
CORE RULES
--------------------------------------------------
- Audit first before editing
- Preserve all existing learning content, routes, progress, notes, and bookmarks
- Do not delete real content pages
- Fix routing and page surfacing issues using the existing built content wherever possible
- Keep scope limited to the identified issues in this phase
- Do not turn this into a giant Learn redesign
- If a page already exists, route to it and surface its content properly instead of rebuilding it
- At the end, provide a concise audit summary

--------------------------------------------------
PHASE OBJECTIVES
--------------------------------------------------

1. Remove the unnecessary bottom “Knowledge” section from Foundations

2. Fix broken or missing routing in Qur’an & Hadith so these entries open their correct destination pages and surface their content properly:
   - Qur’an Learning
   - Hadith
   - Divine Life Lessons
   - World & Creation

3. Fix Prophet & Stories routing so:
   - Stories of the Prophets opens the correct Stories of the Prophets page containing the list of prophets

4. Audit Character & Adab placement and move it into a better section if that is the correct IA decision

5. Move Historical Calendar into Tools & Explore

6. Make Arabic & Language route directly to Arabic Learning

--------------------------------------------------
A. AUDIT (MANDATORY FIRST STEP)
--------------------------------------------------

Audit the current implementation before editing.

Inspect:
- Learning Hub main structure
- Foundations page
- Qur’an & Hadith section and its entries
- Prophet & Stories section
- Character & Adab section
- Historical Calendar location and routing
- Tools & Explore section
- Arabic & Language entry and Arabic Learning page
- route definitions and page builders for all affected entries
- any shared category/island widgets or navigation helpers

Audit these questions:
- What is the current routing target for each identified entry?
- Which entries currently do nothing or loop incorrectly?
- Which correct destination pages already exist?
- Do the target pages already contain real built content that just is not surfaced?
- Is the bottom Knowledge section under Foundations redundant or outdated?
- Where does Character & Adab best fit in the current IA based on the existing real structure?
- Does Historical Calendar already have a correct standalone page that can simply be moved under Tools & Explore?
- Does Arabic Learning already exist as the correct destination for Arabic & Language?

--------------------------------------------------
B. REMOVE KNOWLEDGE SECTION FROM FOUNDATIONS
--------------------------------------------------

Remove the bottom Knowledge section from Foundations if it is redundant / not required.

Requirements:
- remove only the unnecessary Foundations bottom portion identified by the user
- do not delete any real reusable content behind it unless it is truly dead and unused, and even then prefer not to delete in this phase
- clean up spacing/layout after removal
- preserve the rest of Foundations structure

--------------------------------------------------
C. FIX QUR’AN & HADITH SECTION ROUTING
--------------------------------------------------

Correct the following entries so they open the right destination pages and those pages surface their real content properly:

1. Qur’an Learning
2. Hadith
3. Divine Life Lessons
4. World & Creation

Requirements:
- each entry must route to its own correct page
- no dead taps
- no looping back to the parent section
- no generic placeholder parent page if a specific destination page already exists
- preserve back navigation
- if the target page exists but content ordering/categorization is weak, do a lightweight safe cleanup so the content is properly ordered and categorized

For Hadith, Divine Life Lessons, and World & Creation:
- ensure the page that opens is the intended page
- ensure its built content is visible, ordered, and categorized cleanly
- do not rebuild the entire content system in this phase

--------------------------------------------------
D. FIX STORIES OF THE PROPHETS ROUTING
--------------------------------------------------

Under Prophet & Stories:
- ensure Stories of the Prophets routes to the correct Stories of the Prophets page
- that page should contain the list of prophets as intended
- it should match the page already accessible through All Knowledge if that is the correct existing destination

Requirements:
- prefer routing to the existing correct page rather than rebuilding a duplicate page
- preserve route stability and back navigation
- make the surfaced entry consistent with the already-working path through All Knowledge

--------------------------------------------------
E. CHARACTER & ADAB IA DECISION
--------------------------------------------------

Audit whether Character & Adab should remain top-level or be moved into a better section.

Requirements:
- do not make an arbitrary move
- inspect the current Learn structure and choose the most logical production-safe placement based on real built content
- if it should move, update the routing / section placement cleanly
- if it should remain top-level, explain clearly why in the final summary

Possible outcomes:
- remains its own section
- moves under a better parent section already present in Learn
- becomes part of a broader relevant section if such a real section already exists

Do not create a giant new IA branch in this phase.

--------------------------------------------------
F. MOVE HISTORICAL CALENDAR INTO TOOLS & EXPLORE
--------------------------------------------------

Move Historical Calendar into Tools & Explore.

Requirements:
- surface Historical Calendar under Tools & Explore
- preserve its existing page and route if already correct
- remove or adjust its old placement if necessary so it is not confusingly duplicated
- preserve content, state, and back navigation

Do not redesign the Historical Calendar page in this phase.

--------------------------------------------------
G. MAKE ARABIC & LANGUAGE GO DIRECTLY TO ARABIC LEARNING
--------------------------------------------------

Update Arabic & Language so it routes directly to Arabic Learning.

Requirements:
- use the existing Arabic Learning destination if it already exists
- avoid unnecessary intermediate or generic pages if a direct route is better
- preserve back navigation
- ensure the user lands in the actual Arabic learning experience and not a placeholder wrapper

--------------------------------------------------
H. LIGHTWEIGHT CONTENT PAGE ORDERING / CATEGORIZATION CLEANUP
--------------------------------------------------

For the pages specifically called out in this phase:
- Hadith
- Divine Life Lessons
- World & Creation
- any other directly affected destination page if needed

Do a lightweight cleanup so the content is:
- ordered sensibly
- categorized clearly
- surfaced as real content, not just raw/unstructured lists

Requirements:
- do not rebuild the full content architecture
- do not author large amounts of new content in this phase
- just ensure the already-built content is properly organized on the destination pages

--------------------------------------------------
I. ROUTING SAFETY SWEEP
--------------------------------------------------

After fixing the identified entries, sweep the affected Learning Hub paths and ensure:
- no broken taps remain
- no islands/cards route to the wrong parent page
- no loops back to the same page unless intentionally Browse All behavior
- back navigation works correctly
- route names remain stable where possible

--------------------------------------------------
J. DATA / ROUTE SAFETY
--------------------------------------------------

Preserve:
- existing learning content
- notes/bookmarks
- progress/completion
- existing destination pages
- existing route stability where possible

Requirements:
- no destructive migrations
- no content deletion
- no accidental rerouting into unrelated or placeholder pages
- no broken back navigation

--------------------------------------------------
K. TESTING
--------------------------------------------------

Add or update meaningful tests for:

- Foundations no longer shows the removed bottom Knowledge section
- Qur’an Learning routes correctly
- Hadith routes correctly and surfaces its content page
- Divine Life Lessons routes correctly and surfaces its content page
- World & Creation routes correctly and surfaces its content page
- Stories of the Prophets routes to the correct prophets list page
- Arabic & Language routes directly to Arabic Learning
- Historical Calendar is surfaced under Tools & Explore correctly
- Character & Adab placement remains correct after the IA decision
- no affected routes loop back incorrectly

Do not add fake tests. Add regression protection that matters.

Run analyzer/tests for changed areas and report clearly.

--------------------------------------------------
DELIVERABLES
--------------------------------------------------

1. Files changed

2. Audit findings
   - current route behavior for each identified entry
   - current incorrect/missing destinations
   - existing correct destination pages found

3. Foundations summary
   - what was removed
   - any content preserved behind the scenes

4. Qur’an & Hadith routing summary
   - final route for Qur’an Learning
   - final route for Hadith
   - final route for Divine Life Lessons
   - final route for World & Creation
   - any lightweight page ordering/categorization cleanup done

5. Prophet & Stories routing summary
   - final route for Stories of the Prophets
   - confirmation that it now opens the correct prophets list page

6. Character & Adab IA summary
   - whether it stayed or moved
   - why

7. Historical Calendar / Tools & Explore summary
   - where it now lives
   - any duplicate placement cleanup

8. Arabic & Language summary
   - final destination route
   - confirmation it opens Arabic Learning directly

9. Data safety summary
   - confirmation that no user data/content/progress/routes were broken

10. Validation
   - analyzer/tests run
   - results

11. FINAL AUDIT
   - what was completed
   - regressions found/fixed
   - remaining follow-up items
   - technical debt intentionally left for later

--------------------------------------------------
SUCCESS CRITERIA
--------------------------------------------------

- Foundations no longer shows the unnecessary Knowledge bottom section
- Qur’an Learning opens its correct page
- Hadith opens its correct page and content is ordered/categorized there
- Divine Life Lessons opens its correct page and content is ordered/categorized there
- World & Creation opens its correct page and content is ordered/categorized there
- Stories of the Prophets opens the correct prophets list page
- Historical Calendar is correctly placed under Tools & Explore
- Arabic & Language opens Arabic Learning directly
- Character & Adab is placed in the most logical section
- no routes loop incorrectly
- no content/progress/routes are broken

--------------------------------------------------
DO NOT DO IN THIS PHASE
--------------------------------------------------

Do not:
- rebuild the Learning Hub from scratch
- redesign the whole Learn IA
- author large new content systems
- delete real pages or data
- create duplicate pages when correct ones already exist

Stay focused on the identified routing fixes, page destination corrections, and light IA cleanup.

--------------------------------------------------

“And say, ‘My Lord, increase me in knowledge.’” — Qur’an 20:114

===== END PHASE 25 PROMPT =====
