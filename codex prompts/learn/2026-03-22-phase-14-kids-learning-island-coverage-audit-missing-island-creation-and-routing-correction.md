# PHASE 14 PROMPT — KIDS LEARNING ISLAND COVERAGE AUDIT, MISSING ISLAND CREATION, AND ROUTING CORRECTION

PRIMARY OBJECTIVE === BUILDING COMPLETE KIDS LEARNING ISLAND COVERAGE, CORRECT KIDS CONTENT OWNERSHIP, AND PRODUCTION-SAFE ROUTING ACROSS ALL KIDS STORIES AND LEARNING PAGES

You are working in the existing Flutter codebase for Path of Nūr.

This is a targeted production-ready enhancement phase built on top of the existing Kids Learning system. DO NOT rebuild the whole Kids section. DO NOT remove existing kids stories, kids lesson content, routes, notes, bookmarks, progress, or saved state. Build safely on top of the current implementation.

--------------------------------------------------
CORE RULES
--------------------------------------------------
- Audit first before editing
- Preserve all existing kids content, routes, progress, notes, bookmarks, and learning state
- Do not delete or rewrite story content unless a tiny routing/ownership fix requires safe relocation
- Do not break existing Kids Learning navigation
- Reuse existing kids pages/content wherever possible instead of rebuilding them
- Create missing islands only where the content actually exists or is clearly meant to be live
- Fix wrong routing and duplicate/indirect routing
- Keep the Kids Learning section clean, calm, and consistent with the app’s island design system
- No unnecessary package churn
- At the end, provide a concise audit summary

--------------------------------------------------
PHASE OBJECTIVES
--------------------------------------------------

1. Audit the entire Kids Learning section and all kids stories/pages/content types

2. Ensure all major kids story/content experiences that should be surfaced have the correct islands created under Kids Learning

3. Ensure all Kids Learning islands route to the correct kids-specific destination pages

4. Fix wrong links, indirect links, placeholder routes, duplicate entries, and missing island coverage

5. Leave the Kids Learning section coherent, complete, and production-safe without rebuilding it from scratch

--------------------------------------------------
A. AUDIT (MANDATORY FIRST STEP)
--------------------------------------------------

Audit the full Kids Learning system before editing.

Inspect:
- Kids Learning landing page / hub
- current kids islands/cards
- all kids stories and kids learning pages currently in the codebase
- prophet stories for kids
- Arabic/letters/trace content for kids
- quizzes/games/challenges for kids if present
- any bedtime-story or children-format story pages
- any kids-specific learning routes hidden deeper in the app
- any shared/non-kids pages currently being reused by kids entries
- any placeholder or incomplete kids routes
- any duplicated routing entry points into the same kids destination
- any kids content catalogs or seed files driving these pages

Audit these questions:
- What kids content currently exists in the codebase and is production-safe enough to surface?
- Which kids experiences are already reachable?
- Which kids experiences exist but are not surfaced by a proper Kids Learning island?
- Which islands currently route to the wrong page?
- Which routes go to generic/non-kids pages instead of the correct kids-focused version?
- Which islands/pages are duplicated or confusing?
- Are there missing islands for real kids content already implemented?
- Are there placeholder kids surfaces that should not be surfaced yet?
- What should the canonical Kids Learning island list be based on the real content available right now?

--------------------------------------------------
B. CREATE A CANONICAL KIDS LEARNING ISLAND MAP
--------------------------------------------------

Based on the audit, define the correct production-safe Kids Learning island structure using only real or clearly intended live content.

Create/finalize the canonical island map for Kids Learning, such as whichever of the following are truly supported by the current codebase and content:
- Prophet Stories
- Arabic Letters / Trace Letters
- Kids Arabic Pathways
- Bedtime Stories / Islamic Stories
- Kids Quizzes / Games
- Duas for Kids
- Adab / Manners for Kids
- Salah / Wudu for Kids
- Browse All Kids Learning
- Any other kids-specific content area that is already truly present

Do not invent islands for content that does not meaningfully exist yet.

Requirements:
- the island map should reflect real content ownership
- no fake breadth
- no empty category spam
- no hidden valuable content left unsurfaced if it already exists and belongs here

--------------------------------------------------
C. CREATE MISSING KIDS LEARNING ISLANDS
--------------------------------------------------

Create any missing Kids Learning islands for existing real kids content that should be surfaced.

Requirements:
- match existing island/card styling
- place them in a sensible order
- keep the Kids Learning page uncluttered
- only add islands where there is a clear correct destination
- if necessary, add a Browse All Kids Learning island/entry to hold breadth without overcrowding the main page

Do not create islands that immediately lead to placeholder shells.

--------------------------------------------------
D. FIX ROUTING FOR ALL KIDS ISLANDS
--------------------------------------------------

Ensure every kids island routes correctly.

Requirements:
- each island must open the correct kids-focused destination
- fix any islands that currently point to generic or wrong destinations
- preserve back navigation and route stability
- avoid indirect multi-hop routing where a direct destination is cleaner
- do not create duplicate destination pages unnecessarily

If a shared page is reused by both kids and non-kids flows, make sure the kids entry lands in the correct filtered or kids-safe state.

--------------------------------------------------
E. ENSURE KIDS CONTENT OWNS ITS OWN DESTINATIONS
--------------------------------------------------

Audit whether kids content is currently mixed into adult/general learning pages.

Requirements:
- kids entries should open kids-appropriate destinations
- do not dump users into broad adult-oriented category pages when a kids-specific experience exists
- keep children-format stories, layouts, and navigation distinct where appropriate
- if a page can be safely reused, ensure the kids version is clearly filtered/scoped

This is especially important for:
- Prophet Stories
- Kids stories/bedtime stories
- Arabic tracing/letters
- kids-specific games/quizzes
- duas and manners content for children if present

--------------------------------------------------
F. BROWSE ALL / OVERFLOW STRATEGY FOR KIDS
--------------------------------------------------

If there are too many kids content types to surface cleanly on the main Kids Learning page:
- keep the strongest/highest-value islands on the main page
- use a Browse All Kids Learning destination for the rest

Requirements:
- Browse All should be useful, not a dumping ground
- organize the kids categories clearly
- avoid duplicate confusing entry points
- keep discovery easy for parents/children

Do not overcrowd the main Kids Learning page.

--------------------------------------------------
G. PLACEHOLDER / INCOMPLETE KIDS CONTENT CONTAINMENT
--------------------------------------------------

If the audit finds kids routes/pages that are incomplete, placeholder-backed, or not production-safe:
- do not surface them as first-class islands yet
- either hide them from live entry points or contain them gracefully if the route must remain
- do not leave dead taps or misleading empty shells

Requirements:
- keep the Kids Learning experience trustworthy
- prefer a smaller real kids surface over a larger fake one

--------------------------------------------------
H. LIGHTWEIGHT CONSISTENCY SWEEP FOR KIDS PAGES
--------------------------------------------------

Run a lightweight consistency pass across the surfaced Kids Learning destination pages.

Check:
- page title/header consistency
- background/style consistency
- island spacing/order on the Kids Learning hub
- destination page scaffolding
- no disclosure arrows on islands/containers if that rule is already being enforced app-wide
- wording consistency for kids-facing labels
- no duplicate or conflicting entry labels

Do not do a full kids redesign in this phase.

--------------------------------------------------
I. DATA / STATE SAFETY
--------------------------------------------------

Preserve:
- kids stories content
- kids learning progress
- notes/bookmarks tied to kids content
- current story ordering where meaningful
- current saved state on kids pages
- existing route names where possible

Requirements:
- no destructive migrations
- no user data loss
- no breaking of saved progress or story access

--------------------------------------------------
J. TESTING
--------------------------------------------------

Add or update meaningful tests for:

- Kids Learning shows the correct surfaced islands
- newly added islands appear where expected
- each kids island opens the correct kids destination
- wrong/generic routing regressions are prevented
- hidden placeholder kids content is not surfaced where intended
- existing kids routes still work

Do not add fake tests. Add regression protection that matters.

Run analyzer/tests for changed areas and report clearly.

--------------------------------------------------
DELIVERABLES
--------------------------------------------------

1. Files changed

2. Kids audit findings
   - current Kids Learning structure
   - real kids content found
   - missing island coverage found
   - wrong/duplicate routing found
   - placeholder/incomplete kids content found

3. Canonical Kids Learning island map
   - final island list
   - which islands were added
   - which destinations each one opens

4. Routing summary
   - what routes were fixed
   - which kids pages are now the canonical destinations
   - any shared pages that now open in a kids-scoped way

5. Containment summary
   - which incomplete kids surfaces were intentionally not surfaced
   - any graceful containment added

6. Data safety summary
   - confirmation that no kids content/progress was lost

7. Validation
   - analyzer/tests run
   - results

8. FINAL AUDIT
   - what was completed
   - regressions found/fixed
   - remaining follow-up items
   - any technical debt intentionally left for later

--------------------------------------------------
SUCCESS CRITERIA
--------------------------------------------------

- all major real kids stories/content types have the correct islands created in Kids Learning
- all Kids Learning islands link to the correct kids-focused pages
- wrong or generic routing is corrected
- missing island coverage is fixed for real kids content
- incomplete/placeholder kids content is not misleadingly surfaced
- the Kids Learning section feels organized and production-safe
- no content, progress, or routes are broken

--------------------------------------------------
DO NOT DO IN THIS PHASE
--------------------------------------------------

Do not:
- rebuild the entire Kids Learning architecture
- rewrite kids story content
- create islands for content that does not meaningfully exist
- route kids users into adult/general pages unnecessarily
- clutter the Kids Learning page with too many first-class islands
- broaden this into a full Learn-wide architecture rewrite

Stay focused on Kids Learning island coverage, correct kids routing, and production-safe surfacing of existing kids content.

--------------------------------------------------

“And We made them leaders guiding by Our command.” — Qur’an 21:73

===== END PHASE 14 PROMPT =====
