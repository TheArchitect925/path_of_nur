# Phase 27 Prompt — Quizzes & Games Hub Rework, In-Page Category Options, Browse All, and Search

PRIMARY OBJECTIVE === RENAME QUIZZES & CHALLENGES TO QUIZZES & GAMES AND REWORK THE GAMES PAGE SO CATEGORY SECTIONS SHOW THEIR REAL OPTIONS DIRECTLY IN THE PAGE INSTEAD OF BOUNCING TO THIN INTERMEDIATE PAGES

You are working in the existing Flutter codebase for Path of Nūr.

This is a targeted production-ready information architecture and routing cleanup phase for the quizzes/games area. DO NOT rebuild all game features from scratch. DO NOT remove existing quizzes, games, routes, notes, bookmarks, progress, or reward systems. Build safely on top of the current implementation.

--------------------------------------------------
CORE RULES
--------------------------------------------------
- Audit first before editing
- Preserve all existing quiz/game content, routes, progress, XP/reward behavior, notes, and bookmarks
- Do not delete existing game modes or playable content
- Consolidate the hub UX so users can see the available options directly in the Games page
- Avoid unnecessary intermediate pages if they are thin or redundant
- Keep the final structure clean, readable, and production-safe
- Reuse existing playable destinations wherever possible
- No unnecessary package churn
- At the end, provide a concise audit summary

--------------------------------------------------
PHASE OBJECTIVES
--------------------------------------------------

1. Rename Quizzes & Challenges to Quizzes & Games

2. Rework the Games page so the following sections show their options directly in-page instead of routing away to thin category pages:
   - Daily Challenges
   - Knowledge Games
   - Qur’an Games
   - Hadith & Reflection
   - Challenge Modes
   - Growth & Spiritual
   - Game Packs

3. Add a Browse All island/entry that takes the user to all available game options

4. Add Search for the Quizzes & Games section

5. Preserve existing playable routes for the actual games/options

--------------------------------------------------
A. AUDIT (MANDATORY FIRST STEP)
--------------------------------------------------

Audit the current quizzes/games implementation before editing.

Inspect:
- current Learning Hub surfacing for Quizzes & Challenges
- current Games page
- current category pages under games/quizzes
- current route structure for:
  - Daily Challenges
  - Knowledge Games
  - Qur’an Games
  - Hadith & Reflection
  - Challenge Modes
  - Growth & Spiritual
  - Game Packs
- all existing actual game/playable destinations already built
- any search support already present in this section
- any Browse All / explorer page already present
- shared island/card/section widgets used in the Games area

Audit these questions:
- Which current category cards lead to thin intermediate pages?
- Which actual game destinations already exist and should remain the final target?
- Which category pages are redundant if their options are surfaced directly in the Games page?
- What is the safest way to keep the Games page richer without breaking existing routes?
- Is there already a suitable Browse All destination that can be reused?
- Is there already a search model/helper that can be adapted?

--------------------------------------------------
B. RENAME QUIZZES & CHALLENGES TO QUIZZES & GAMES
--------------------------------------------------

Rename the surfaced section/page label from:
- Quizzes & Challenges
to:
- Quizzes & Games

Requirements:
- update visible user-facing labels
- preserve route stability where possible unless route names are purely internal and safe to keep unchanged
- keep wording consistent across hub/page headers/navigation labels
- avoid partial rename inconsistency

--------------------------------------------------
C. REWORK THE GAMES PAGE INTO A CANONICAL HUB
--------------------------------------------------

Make the Games page the canonical discovery hub for quizzes and games.

Instead of category entries immediately routing to their own thin pages, the Games page itself should surface the available options directly in sections.

Target sections on the page:
- Daily Challenges
- Knowledge Games
- Qur’an Games
- Hadith & Reflection
- Challenge Modes
- Growth & Spiritual
- Game Packs
- Browse All
- Search

Requirements:
- keep the page organized and readable
- do not overload with clutter
- use island/section patterns consistent with the app
- preserve clear final navigation into the actual game experiences

--------------------------------------------------
D. DAILY CHALLENGES SECTION
--------------------------------------------------

Daily Challenges should no longer just bounce to its own category page if that page is thin.

Instead, on the Games page, show its available options directly:
- Daily Knowledge Challenge - Today

Requirements:
- surface this option directly under the Daily Challenges section
- tapping the option should go to the real playable/content destination
- if the former Daily Challenges page has additional real value, preserve it only if necessary; otherwise keep the richer in-page surfacing

--------------------------------------------------
E. KNOWLEDGE GAMES SECTION
--------------------------------------------------

Under Knowledge Games, show these options directly in the Games page:
- Crossword Puzzles
- Word Search
- Matching Games

Requirements:
- each option should open its real game destination
- do not bounce the user to a redundant intermediate category page unless absolutely necessary
- preserve existing playable routes

--------------------------------------------------
F. QUR’AN GAMES SECTION
--------------------------------------------------

Under Qur’an Games, show these options directly in the Games page:
- Ayah Completion
- Adult Short Surahs
- Memorization Set
- Daily Ayah Today

Requirements:
- each option should open its real destination
- ensure these labels are consistent with the actual content/features already built
- if some options are not yet fully production-safe, contain them gracefully rather than surfacing dead taps

--------------------------------------------------
G. HADITH & REFLECTION SECTION
--------------------------------------------------

Under Hadith & Reflection, show these options directly in the Games page:
- Hadith Reflection
- Patience & Resilience
- Anger Control
- Family & Respect

Requirements:
- each option should open its real content/game/challenge destination
- if these are currently thin wrappers around real content, simplify the routing
- keep this section clearly distinct from general Knowledge Games

--------------------------------------------------
H. CHALLENGE MODES SECTION
--------------------------------------------------

Under Challenge Modes, show these options directly in the Games page:
- Daily Run
- Review Mode
- Trivia Challenge

Requirements:
- route each option to its real destination
- do not keep a thin challenge-category page if the options can be shown directly here
- ensure labels and content destinations match what actually exists

--------------------------------------------------
I. GROWTH & SPIRITUAL SECTION
--------------------------------------------------

Under Growth & Spiritual, show these options directly in the Games page:
- Spiritual Growth
- Choose Intention
- Daily Reflection
- Theme Focus

Requirements:
- route each option to its real destination
- keep this category distinct from Hadith & Reflection while still spiritually themed
- contain any incomplete option gracefully if necessary instead of dead-tapping

--------------------------------------------------
J. GAME PACKS SECTION
--------------------------------------------------

Under Game Packs, show these options directly in the Games page:
- Adult Foundations
- Prophets
- Duas & Meanings
- Daily Rotation

Requirements:
- route each option to the correct destination
- preserve the concept of packs if already modeled
- do not send users to thin intermediate pages unless the pack page itself adds real value

--------------------------------------------------
K. ADD BROWSE ALL
--------------------------------------------------

Add a Browse All island/entry that takes the user to all available options.

Requirements:
- Browse All should be a real useful explorer/index of all game options
- it may legitimately have its own destination page
- organize all available quizzes/games/challenges clearly there
- do not make it a dumping ground
- preserve existing playable routes from that explorer

--------------------------------------------------
L. ADD SEARCH FOR QUIZZES & GAMES
--------------------------------------------------

Add Search to the Quizzes & Games section.

Requirements:
- search should cover at least:
  - section/category names
  - individual game/challenge names
- optionally include descriptions/tags if already modeled safely
- keep search fast and production-safe
- do not freeze the page on keystroke
- results should route directly to the real destination

This search may live:
- directly on the Games page
- and/or in Browse All
whichever fits the current architecture best

--------------------------------------------------
M. PRESERVE ACTUAL PLAYABLE DESTINATIONS
--------------------------------------------------

This phase is about hub/discovery cleanup, not deleting game features.

Requirements:
- keep existing actual quiz/game routes intact where they are the real playable destination
- only remove or bypass thin redundant intermediate category pages if that improves UX
- do not break progress/reward systems for existing games

--------------------------------------------------
N. LIGHTWEIGHT ROUTING / IA CLEANUP
--------------------------------------------------

After the Games page is reworked, do a lightweight cleanup to ensure:
- no loops back to the same page incorrectly
- category cards do not misroute
- labels match destinations
- thin redundant pages are bypassed where appropriate
- back navigation still feels sane

Do not rebuild the entire Learn IA in this phase.

--------------------------------------------------
O. DATA / ROUTE SAFETY
--------------------------------------------------

Preserve:
- existing quizzes/games content
- progress and rewards
- routes where they represent real playable destinations
- notes/bookmarks if applicable
- existing page scaffolding and localization patterns

Requirements:
- no destructive migrations
- no content deletion
- no loss of progress
- no accidental rerouting into unrelated pages
- no broken back navigation

--------------------------------------------------
P. TESTING
--------------------------------------------------

Add or update meaningful tests for:

- section rename to Quizzes & Games
- Games page now shows in-page sections/options correctly
- Daily Challenges shows Daily Knowledge Challenge - Today
- Knowledge Games shows Crossword Puzzles / Word Search / Matching Games
- Qur’an Games shows Ayah Completion / Adult Short Surahs / Memorization Set / Daily Ayah Today
- Hadith & Reflection shows its listed options
- Challenge Modes shows its listed options
- Growth & Spiritual shows its listed options
- Game Packs shows its listed options
- Browse All opens a real explorer page
- Search finds relevant quiz/game options
- options route to their real destinations
- no redundant incorrect bounce-back routing remains

Do not add fake tests. Add regression protection that matters.

Run analyzer/tests for changed areas and report clearly.

--------------------------------------------------
DELIVERABLES
--------------------------------------------------

1. Files changed

2. Audit findings
   - current Games page structure
   - thin intermediate category pages found
   - real playable destinations found
   - current search/Browse All support found

3. Quizzes & Games hub summary
   - final page structure
   - final in-page sections
   - final option lists shown per section

4. Routing summary
   - which intermediate pages were bypassed
   - which real destinations remained
   - how Browse All works
   - how Search works

5. Data safety summary
   - confirmation that no quiz/game content, routes, progress, or rewards were broken

6. Validation
   - analyzer/tests run
   - results

7. FINAL AUDIT
   - what was completed
   - regressions found/fixed
   - remaining follow-up items
   - technical debt intentionally left for later

--------------------------------------------------
SUCCESS CRITERIA
--------------------------------------------------

- Quizzes & Challenges is renamed to Quizzes & Games
- Games page shows category options directly in-page
- Daily Challenges, Knowledge Games, Qur’an Games, Hadith & Reflection, Challenge Modes, Growth & Spiritual, and Game Packs all show their listed options directly
- Browse All exists and opens a real all-options explorer
- Search exists for the section
- users no longer bounce through thin unnecessary category pages
- actual playable destinations still work
- no content, progress, routes, or rewards are broken

--------------------------------------------------
DO NOT DO IN THIS PHASE
--------------------------------------------------

Do not:
- rebuild all game features from scratch
- redesign the entire Learn hub
- delete existing playable games
- invent new game content not already built
- create dead taps or placeholder entries

Stay focused on renaming the section, consolidating the Games page into a richer hub, adding Browse All and Search, and preserving real playable destinations.

--------------------------------------------------

“And say, ‘My Lord, increase me in knowledge.’” — Qur’an 20:114
