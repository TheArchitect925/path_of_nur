# Phase 7 Prompt — Growth Page Information Architecture Cleanup, Island Routing, And Statistics Expansion

- [ ] Growth Page

===== PHASE 7 PROMPT — GROWTH PAGE INFORMATION ARCHITECTURE CLEANUP, ISLAND ROUTING, AND STATISTICS EXPANSION =====

PRIMARY OBJECTIVE === BUILDING GROWTH PAGE INFORMATION ARCHITECTURE CLEANUP, ISLAND DETAIL PAGES, GARDEN ENTRY, AND STATISTICS EXPANSION

You are working in the existing Flutter codebase for Path of Nūr.

This is a targeted production-ready enhancement phase built on top of the existing Growth area. DO NOT rebuild the whole Growth system. DO NOT remove working user data, progress, XP, drops, rings, garden logic, journey logic, habits, reflections, or spiritual tracking. Build safely on top of the current implementation.

--------------------------------------------------
CORE RULES
--------------------------------------------------
- Audit first before editing
- Preserve existing user progress, stored stats, XP, drops, streaks, journey progression, ocean progress, habits data, reflection data, and spiritual growth data
- Do not delete records, reset counters, or break persistence
- Do not introduce giant redesign churn outside this phase
- Keep the Growth section consistent with the app’s island-based navigation style
- Build on top of what already exists
- If a page already exists, reuse and improve it instead of replacing it blindly
- Keep routing stable and explicit
- No unnecessary package churn
- At the end, provide a concise audit summary

--------------------------------------------------
PHASE OBJECTIVES
--------------------------------------------------

1. Clean up the main Growth page information architecture

2. Ensure these islands have their own proper destination pages with the correct format/content structure inside each page:
   - Today Island
   - Paths Island
   - Habits Island
   - Journey Island
   - Reflection Island
   - Spiritual Island
   - Browse All Island

3. Move these Growth metrics into a new dedicated island called Statistics:
   - Qur’an Reading
   - Times & Reflection
   - Total Adhkar Completed

4. Add and create a Garden Island that opens the Garden page

5. Expand the Statistics page so it also contains:
   - Journey Stats Island
   - Ocean Dashboard

6. Keep the Growth page focused, organized, and aligned with the island-navigation pattern

--------------------------------------------------
A. AUDIT (MANDATORY FIRST STEP)
--------------------------------------------------

Audit the current Growth page and related destination pages before editing.

Inspect:
- current Growth page layout and section ordering
- all current islands/cards on the Growth page
- existing navigation targets for each island
- which islands already have destination pages
- which destination pages are incomplete, placeholder, inconsistent, or missing
- current Garden page existence and route wiring
- current stats cards/sections already present on Growth page
- Journey stats implementation
- Ocean Dashboard implementation
- any shared island/card components used in Growth
- any inconsistent layouts or styling across Growth-related pages

Audit these questions:
- Which islands already exist visually?
- Which ones already navigate somewhere?
- Which pages are full implementations versus shells/placeholders?
- Are multiple islands incorrectly pointing to the same generic page?
- Is Browse All actually useful today or just a catch-all container?
- Where are Qur’an Reading, Times & Reflection, and Total Adhkar Completed currently shown?
- Does a Statistics page already exist in any form?
- Does a Garden page already exist and is it properly routed?
- Are Journey Stats and Ocean Dashboard already implemented elsewhere and just not surfaced correctly?
- Are these pages consistent in background, page scaffolding, spacing, headers, and island behavior?

--------------------------------------------------
B. CLEAN UP MAIN GROWTH PAGE IA
--------------------------------------------------

Refactor the main Growth page so it becomes cleaner and more intentional.

Target islands on the Growth page should clearly include:
- Today
- Paths
- Habits
- Journey
- Reflection
- Spiritual
- Statistics
- Garden
- Browse All

Requirements:
- Use the current island visual system and app styling
- Do not make the page feel overcrowded
- Order the islands in a way that makes sense for daily use and growth tracking
- Ensure each island routes to the correct destination page
- Remove or reduce confusing duplication on the main Growth page

Prefer a clean hierarchy:
- daily focus first
- structured growth tools next
- deeper exploration and dashboards after

Do not create random duplicates of the same content on both the main page and subpages unless there is a clear summary/detail relationship.

--------------------------------------------------
C. BUILD / FIX DESTINATION PAGES FOR EACH GROWTH ISLAND
--------------------------------------------------

Each of these islands should open a proper dedicated page with the correct internal format and content structure:

- Today
- Paths
- Habits
- Journey
- Reflection
- Spiritual
- Browse All

Requirements:
- If the page already exists, improve and align it instead of rebuilding it
- If the page is missing, create it
- If multiple islands currently land on the wrong generic page, fix the routing
- Keep page structures consistent with the app’s design language
- Each page should feel intentional, not like a blank shell with a reused title bar

Each destination page should have:
- proper page header/title
- consistent visual scaffolding
- meaningful summary and deeper sections
- correct navigation behavior
- room for future expansion without needing a rebuild later

Do not invent empty filler content. Reorganize and surface real existing content where possible.

--------------------------------------------------
D. TODAY ISLAND PAGE
--------------------------------------------------

Ensure Today opens a real Today-focused growth page.

The Today page should feel like the user’s daily growth checkpoint and summary.

Audit and surface what already exists that belongs here, such as:
- today’s progress
- today’s goals or rings
- today’s dhikr/salah/learning completion snapshots
- today’s reflections or check-ins where appropriate
- today-specific streak/progress cues

Requirements:
- keep it daily and actionable
- do not overload with lifetime statistics
- make it feel like “what should I focus on today?”

--------------------------------------------------
E. PATHS ISLAND PAGE
--------------------------------------------------

Ensure Paths opens a proper Paths page.

This page should represent structured growth paths, not generic growth content.

Audit what “Paths” currently means in the app and organize accordingly:
- learning paths
- spiritual growth paths
- habit paths if applicable
- guided progression tracks if already modeled

Requirements:
- keep the concept distinct from Journey if they are separate concepts
- avoid mixing Paths and Browse All
- make progression and available paths clear

--------------------------------------------------
F. HABITS ISLAND PAGE
--------------------------------------------------

Ensure Habits opens a proper habits-focused page.

Surface and organize:
- active habits
- habit progress
- streaks
- completion patterns
- setup/manage habits entry points if they already exist

Requirements:
- page should feel operational and habit-focused
- do not bury active habit status
- keep habit tracking consistent with the rest of Growth

--------------------------------------------------
G. JOURNEY ISLAND PAGE
--------------------------------------------------

Ensure Journey opens a proper Journey page.

This page should reflect ongoing journey/progression systems already in the app.

Surface and organize:
- active journey
- progress in journey
- milestones
- journey resume/continue
- related progress summaries if appropriate

Requirements:
- keep it distinct from Paths and Statistics
- highlight the user’s current journey progress clearly
- avoid turning it into a generic dashboard dump

--------------------------------------------------
H. REFLECTION ISLAND PAGE
--------------------------------------------------

Ensure Reflection opens a proper Reflection page.

Surface and organize:
- saved reflections
- reflection prompts if they exist
- recent reflection activity
- meaningful reflection entry points

Requirements:
- keep tone calm and reflective
- do not mix heavily with raw stats
- preserve any note/reflection data and existing routes

--------------------------------------------------
I. SPIRITUAL ISLAND PAGE
--------------------------------------------------

Ensure Spiritual opens a proper Spiritual page.

This page should represent spiritual growth signals and tools, not just generic content.

Audit what already belongs here, such as:
- worship/spiritual consistency indicators
- spiritual routines
- spiritual check-ins
- spiritually meaningful summaries that are not purely academic learning

Requirements:
- distinct from Habits and Reflection, while complementary
- spiritually focused, not cluttered
- align with the overall Path of Nūr growth concept

--------------------------------------------------
J. BROWSE ALL ISLAND PAGE
--------------------------------------------------

Ensure Browse All opens a useful page.

This page should act as a structured explorer/index across the Growth system.

Requirements:
- organize the Growth categories clearly
- provide access to all relevant growth destinations
- do not make it a random dumping ground
- use clear grouping and routing
- make it useful for discovery, not just duplication

--------------------------------------------------
K. CREATE STATISTICS ISLAND ON GROWTH PAGE
--------------------------------------------------

Create a new Statistics island on the main Growth page.

Move these items under Statistics:
- Qur’an Reading
- Times & Reflection
- Total Adhkar Completed

Requirements:
- these should no longer sit awkwardly as disconnected metrics on the main Growth page
- the main page can still show lightweight summary cues if appropriate, but the dedicated destination should be Statistics
- Statistics should feel like a coherent dashboard, not a random metric pile

--------------------------------------------------
L. BUILD / EXPAND STATISTICS PAGE
--------------------------------------------------

The Statistics page should contain:
- Qur’an Reading
- Times & Reflection
- Total Adhkar Completed
- Journey Stats Island
- Ocean Dashboard

Requirements:
- if a Statistics page exists, expand it
- if not, create it cleanly
- organize the page into meaningful sections/islands
- ensure Journey Stats and Ocean Dashboard are clearly surfaced here
- preserve existing data sources and calculations

Statistics page should feel like:
- a deeper dashboard page
- clear summaries and drill-downs
- structured metrics, not clutter

Audit whether “Times & Reflection” needs a label cleanup for clarity based on the real data it contains. Only rename if it materially improves understanding and stays consistent with the product language.

--------------------------------------------------
M. JOURNEY STATS ISLAND
--------------------------------------------------

Ensure the Statistics page includes a Journey Stats island/section.

Surface meaningful journey-related metrics already supported by the data model, such as:
- current journey progress
- milestones reached
- progress counts
- completion summaries
- streak/progression signals if relevant

Requirements:
- do not fabricate stats
- use existing journey data safely
- keep it clearly distinct from Ocean Dashboard

--------------------------------------------------
N. OCEAN DASHBOARD
--------------------------------------------------

Ensure the Statistics page includes the Ocean Dashboard.

Surface the Ocean of Drops concept cleanly using existing or newly-wired data already aligned to the project vision:
- personal drops total
- community ocean progression where supported
- current stage/progress if modeled
- useful summaries related to drop contribution

Requirements:
- do not break the community ocean logic
- do not reset or alter drop totals
- keep the dashboard meaningful and expandable
- if some community data is not yet fully implemented, gracefully surface what exists and clearly structure the page for future growth without fake data

--------------------------------------------------
O. ADD / WIRE GARDEN ISLAND
--------------------------------------------------

Add a Garden island to the main Growth page.

Requirements:
- tapping Garden island must open the Garden page
- reuse the existing Garden page if already present
- if Garden page routing is broken or inconsistent, fix it
- ensure visual consistency between the Growth page and Garden entry

Do not redesign the Garden page in this phase unless a tiny routing-related cleanup is required.

--------------------------------------------------
P. CONSISTENCY SWEEP ACROSS GROWTH PAGES
--------------------------------------------------

Run a consistency sweep across all Growth-related destination pages.

Check and align:
- page background treatment
- header/title treatment
- padding and spacing
- island card styling
- section spacing
- typography hierarchy
- navigation behavior
- use of shared scaffolding components
- safe-area behavior
- scroll behavior
- empty/loading/error states where needed

Requirements:
- do not force unnecessary sameness if some pages need unique emphasis
- but they should clearly feel like part of one Growth system

--------------------------------------------------
Q. DATA SAFETY AND PERSISTENCE
--------------------------------------------------

This phase touches multiple tracked systems. Be careful.

Must preserve:
- XP
- drops
- journey progress
- habit progress
- streaks
- reflections
- spiritual logs
- ocean/community progression
- garden progression
- stats calculations

Requirements:
- no destructive migrations
- no silent resets
- no breaking of legacy stored records
- if new routing or page models are added, keep old persisted data compatible

--------------------------------------------------
R. TESTING
--------------------------------------------------

Add or update meaningful tests for changed areas.

Prioritize:
- Growth page island presence and ordering
- each island routes to the correct page
- Statistics island opens Statistics page
- Garden island opens Garden page
- Statistics page contains:
  - Qur’an Reading
  - Times & Reflection
  - Total Adhkar Completed
  - Journey Stats
  - Ocean Dashboard
- previously existing user data still renders correctly
- no broken navigation due to refactor

Do not add fake tests. Add real regression protection.

Run analyzer/tests for changed areas and report clearly.

--------------------------------------------------
DELIVERABLES
--------------------------------------------------

1. Files changed

2. Audit findings
   - what the Growth page looked like before
   - which destination pages were missing/incomplete/wrongly routed
   - what already existed and was reused

3. Growth page IA summary
   - final island list
   - final order
   - what was moved off the main page into Statistics

4. Destination pages summary
   - Today
   - Paths
   - Habits
   - Journey
   - Reflection
   - Spiritual
   - Browse All
   - Statistics
   - Garden routing

5. Statistics page summary
   - what it includes now
   - how Journey Stats and Ocean Dashboard were integrated

6. Data safety summary
   - confirmation that no progress/stats were lost
   - any model or migration changes

7. Validation
   - analyzer/tests run
   - results

8. FINAL AUDIT
   - what was completed
   - regressions found/fixed
   - what remains for future phases
   - any technical debt intentionally left for later

--------------------------------------------------
SUCCESS CRITERIA
--------------------------------------------------

- Main Growth page is cleaner and island-driven
- Today, Paths, Habits, Journey, Reflection, Spiritual, and Browse All each open the correct dedicated page
- Statistics island exists on the Growth page
- Qur’an Reading, Times & Reflection, and Total Adhkar Completed are grouped under Statistics
- Statistics page includes Journey Stats and Ocean Dashboard
- Garden island exists and opens Garden page
- Routing is correct and consistent
- Existing progress/data is preserved
- Growth-related pages feel like one coherent system

--------------------------------------------------
DO NOT DO IN THIS PHASE
--------------------------------------------------

Do not:
- rebuild the entire Growth system from scratch
- redesign the Garden page wholesale
- change XP/drop formulas
- reset journey or ocean progress
- invent fake dashboard data
- merge Paths and Journey without evidence they are the same concept
- move unrelated app sections into Growth
- do a full visual redesign outside this scope

Stay focused on Growth page cleanup, destination-page correctness, Statistics surfacing, and Garden entry.

--------------------------------------------------

“And that there is not for man except that [good] for which he strives.” — Qur’an 53:39

===== END PHASE 7 PROMPT =====
