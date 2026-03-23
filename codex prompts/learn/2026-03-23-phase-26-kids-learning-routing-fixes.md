# Phase 26 Prompt — Kids Learning Routing Fixes, Destination Page Corrections, and Games/Fun Learning Audit

- [ ] Phase 2

===== PHASE 26 PROMPT — KIDS LEARNING ROUTING FIXES, DESTINATION PAGE CORRECTIONS, AND GAMES/FUN LEARNING AUDIT =====

PRIMARY OBJECTIVE === FIX KIDS LEARNING ISLAND ROUTING SO EACH ENTRY OPENS ITS CORRECT KIDS DESTINATION PAGE, SURFACES THE RIGHT BUILT CONTENT, AND RESOLVES EMPTY/WRONG PAGES FOR KIDS GAMES AND FUN LEARNING

You are working in the existing Flutter codebase for Path of Nūr.

This is a targeted production-ready routing and destination-correction phase for Kids Learning. DO NOT rebuild the Kids Learning system. DO NOT remove existing kids content, kids routes, notes, bookmarks, or progress. Build safely on top of the current implementation.

--------------------------------------------------
CORE RULES
--------------------------------------------------
- Audit first before editing
- Preserve all existing kids learning content, routes, progress, notes, and bookmarks
- Do not delete existing kids stories, kids games, kids learning content, or pages
- Fix routing so each Kids Learning island opens its actual intended destination page
- Reuse existing built pages/content wherever possible
- Keep scope focused on the identified Kids Learning issues
- Do not redesign the whole Kids Learning IA in this phase
- At the end, provide a concise audit summary

--------------------------------------------------
PHASE OBJECTIVES
--------------------------------------------------

1. Fix Kids Games so it opens a real page listing the kids games that already exist

2. Fix the following Kids Learning entries so they no longer fall into the wrong generic Knowledge section or wrong destination:
   - Qur’an for Kids
   - Hadith for Kids
   - Hadith Stories
   - Prophets
   - Kid-Friendly Stories
   - Kids Dua Learning

3. Audit Fun Learning, determine whether:
   - it is missing its proper destination page
   - it should point to existing built content
   - or it should be contained/hidden if it is currently empty and not production-safe

4. Ensure each corrected destination page actually surfaces the right kids content already built

--------------------------------------------------
A. AUDIT (MANDATORY FIRST STEP)
--------------------------------------------------

Audit the current Kids Learning implementation before editing.

Inspect:
- Kids Learning landing page / hub
- all Kids Learning island/card definitions
- tap handlers / callbacks / route helpers used by Kids Learning
- any shared island widget used by Kids Learning
- route definitions and route builders for all affected entries
- Kids Games page and any existing kids games pages/content
- Qur’an for Kids page
- Hadith for Kids page
- Hadith Stories page
- Prophet Stories / Prophets list page for kids
- Kid-Friendly Stories page/content
- Kids Dua Learning page/content
- Fun Learning page/content
- any Browse All Kids Learning or generic Knowledge page these entries may be incorrectly landing in

Audit these questions:
- Which current Kids Learning islands are routing to the wrong generic page?
- Why are they landing in the Knowledge section instead of their real kids destinations?
- Is there a shared fallback route or wrong slug/id reused for multiple islands?
- Do the correct destination pages already exist for each entry?
- Does Kids Games already have a proper content page elsewhere that just is not linked?
- Is Fun Learning truly empty, or is its content present elsewhere but not wired in?
- Which entries are production-safe today and just need routing correction?
- Which entries need a small destination-page cleanup to surface their built content properly?

--------------------------------------------------
B. CREATE A CANONICAL KIDS LEARNING ROUTING MAP
--------------------------------------------------

Build a clear mapping of:

Kids Learning island
-> correct destination page
-> expected built content shown there

For these entries at minimum:
- Kids Games
- Qur’an for Kids
- Hadith for Kids
- Hadith Stories
- Prophets
- Kid-Friendly Stories
- Kids Dua Learning
- Fun Learning

This routing map should drive the implementation.

--------------------------------------------------
C. FIX KIDS GAMES ROUTING
--------------------------------------------------

Kids Games currently goes to an empty page.

Requirements:
- route Kids Games to a page that lists the kids games that already exist
- if such a page already exists, use it
- if the existing page is the correct route but is not surfacing content, fix the content surfacing there
- if no proper aggregator page exists but the games already exist individually, create the smallest clean production-safe listing page using those existing games
- do not invent fake games
- do not leave Kids Games pointing to an empty shell

--------------------------------------------------
D. FIX QUR’AN FOR KIDS ROUTING
--------------------------------------------------

Qur’an for Kids must route directly to the actual Qur’an for Kids experience.

Requirements:
- do not send the user into the generic Knowledge section
- use the existing kids-safe Qur’an page/content already built
- preserve back navigation
- ensure the page actually surfaces the intended kids Qur’an content

--------------------------------------------------
E. FIX HADITH FOR KIDS ROUTING
--------------------------------------------------

Hadith for Kids must route directly to the actual Hadith for Kids experience.

Requirements:
- do not send the user into the generic Knowledge section
- use the existing kids-safe Hadith page/content already built
- preserve back navigation
- ensure the page actually surfaces the intended kids Hadith content

--------------------------------------------------
F. FIX HADITH STORIES ROUTING
--------------------------------------------------

Hadith Stories must route directly to the proper kids Hadith Stories page/content.

Requirements:
- do not send the user into the generic Knowledge section
- use the existing built Hadith Stories destination if present
- ensure the page actually shows the Hadith Stories content and not a parent shell

--------------------------------------------------
G. FIX PROPHETS ROUTING
--------------------------------------------------

Prophets must route directly to the correct kids prophets / prophet stories destination.

Requirements:
- do not send the user into the generic Knowledge section
- use the existing kids prophets page or stories of prophets list page that is intended for Kids Learning
- preserve back navigation and kids-safe content scope

--------------------------------------------------
H. FIX KID-FRIENDLY STORIES ROUTING
--------------------------------------------------

Kid-Friendly Stories must route directly to the proper kids stories destination.

Requirements:
- do not send the user into the generic Knowledge section
- use the existing kids stories page/content already built
- ensure the destination actually contains the intended kid-friendly stories content

--------------------------------------------------
I. FIX KIDS DUA LEARNING ROUTING
--------------------------------------------------

Kids Dua Learning must route directly to the correct kids dua learning experience.

Requirements:
- do not send the user into the generic Knowledge section
- use the existing kids dua page/content if already built
- if the page exists but is weakly surfaced, do the minimum safe cleanup to show the correct kids dua content there

--------------------------------------------------
J. FUN LEARNING AUDIT AND DECISION
--------------------------------------------------

Fun Learning is currently an empty page.

Audit and determine which of these is true:
- the correct destination page exists but is not linked
- the content exists but is not being surfaced
- the page is genuinely missing
- the feature is too incomplete to surface safely

Then choose the safest production-ready action:
- route it to the correct existing content page
- surface existing built content on its current page
- create a small real destination page only if the content already exists and simply needs a proper listing surface
- contain or hide it if it is truly empty and not production-safe

Do not leave Fun Learning as an empty shell.

--------------------------------------------------
K. FIX SHARED ROUTING ROOT CAUSE
--------------------------------------------------

If multiple Kids Learning entries are failing because of one shared bug, fix it at the shared level.

Possible root causes may include:
- shared island callback defaulting to the Knowledge route
- wrong slug/id used across multiple entries
- copy-paste route constants
- parent-page fallback being reused for all kids destinations
- shared widget wiring bug

Requirements:
- centralize the fix where practical
- avoid one-off hacks for each island if a shared cause exists
- keep future regression risk low

--------------------------------------------------
L. DESTINATION PAGE CONTENT VERIFICATION
--------------------------------------------------

After routing is fixed, verify each destination page actually shows its expected built content.

Requirements:
- Kids Games shows existing games
- Qur’an for Kids shows the kids Qur’an experience
- Hadith for Kids shows the kids Hadith experience
- Hadith Stories shows its stories content
- Prophets shows the intended kids prophet content
- Kid-Friendly Stories shows the intended stories content
- Kids Dua Learning shows the intended dua learning content
- Fun Learning is no longer an empty misleading page

If the correct destination exists but the content is hidden behind weak ordering or category logic, do the minimum safe cleanup to surface it properly.

--------------------------------------------------
M. LIGHTWEIGHT KIDS LEARNING CONSISTENCY SWEEP
--------------------------------------------------

After the routing corrections, do a lightweight consistency pass.

Check:
- island labels match their actual destination
- no incorrect Knowledge-section fallbacks remain
- no duplicate or dead taps remain
- destination page titles match the selected island
- visual layout of the Kids Learning landing page remains intact
- no disclosure arrows on island/container surfaces if that rule is already enforced app-wide

Do not do a broad Kids redesign in this phase.

--------------------------------------------------
N. DATA / ROUTE SAFETY
--------------------------------------------------

Preserve:
- existing kids content
- kids learning progress
- notes/bookmarks tied to kids content
- existing destination pages
- route stability where possible

Requirements:
- no destructive migrations
- no content deletion
- no accidental rerouting into adult/general pages
- no broken back navigation
- no loss of kids-safe content scoping

--------------------------------------------------
O. TESTING
--------------------------------------------------

Add or update meaningful tests for:

- Kids Games routes to a non-empty games destination
- Qur’an for Kids routes to the correct kids Qur’an page
- Hadith for Kids routes to the correct kids Hadith page
- Hadith Stories routes to the correct kids Hadith Stories page
- Prophets routes to the correct kids prophets page
- Kid-Friendly Stories routes to the correct kids stories page
- Kids Dua Learning routes to the correct kids dua page
- Fun Learning no longer routes to an empty misleading page
- affected islands no longer fall back into the wrong generic Knowledge section
- existing kids routes still work

Do not add fake tests. Add regression protection that matters.

Run analyzer/tests for changed areas and report clearly.

--------------------------------------------------
DELIVERABLES
--------------------------------------------------

1. Files changed

2. Audit findings
   - current Kids Learning islands found
   - current incorrect route behavior
   - root cause of the generic Knowledge-section fallback
   - status of Kids Games and Fun Learning

3. Canonical island routing map
   - each island
   - final destination page
   - expected built content shown

4. Routing fix summary
   - what was rewired
   - any shared navigation bug fixed
   - any route constants/helpers corrected

5. Destination content summary
   - confirmation that each island now opens the correct built content
   - what was done for Kids Games
   - what was done for Fun Learning

6. Data safety summary
   - confirmation that no kids content/progress/routes were broken

7. Validation
   - analyzer/tests run
   - results

8. FINAL AUDIT
   - what was completed
   - regressions found/fixed
   - any remaining follow-up items
   - technical debt intentionally left for later

--------------------------------------------------
SUCCESS CRITERIA
--------------------------------------------------

- Kids Games opens a real page listing existing kids games
- Qur’an for Kids opens the correct kids Qur’an page
- Hadith for Kids opens the correct kids Hadith page
- Hadith Stories opens the correct kids Hadith Stories page
- Prophets opens the correct kids prophets page
- Kid-Friendly Stories opens the correct kids stories page
- Kids Dua Learning opens the correct kids dua page
- Fun Learning no longer opens an empty misleading page
- Kids Learning entries no longer fall back into the wrong generic Knowledge section
- no kids content, progress, or routes are broken

--------------------------------------------------
DO NOT DO IN THIS PHASE
--------------------------------------------------

Do not:
- rebuild the Kids Learning architecture
- redesign all Kids pages
- delete existing kids content
- route kids entries into adult/general pages
- invent missing content that does not exist
- create unnecessary new pages when correct ones already exist

Stay focused on Kids Learning routing fixes, destination-page correction, Kids Games surfacing, and Fun Learning audit/resolution.

--------------------------------------------------

“And say, ‘My Lord, increase me in knowledge.’” — Qur’an 20:114

===== END PHASE 26 PROMPT =====
