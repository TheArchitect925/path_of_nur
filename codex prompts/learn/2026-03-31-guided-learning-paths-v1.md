===== PHASE 3 PROMPT — GUIDED LEARNING PATHS SYSTEM =====

PRIMARY OBJECTIVE === BUILD A PRODUCTION-READY GUIDED LEARNING PATH SYSTEM FOR PATH OF NUR THAT ORCHESTRATES EXISTING CONTENT INTO CLEAR, RESUMABLE LEARNING JOURNEYS WITHOUT BREAKING CURRENT ROUTES, PAGES, SEARCH, OR CONTENT OWNERSHIP

You are working in the existing Flutter codebase for “Path of Nūr”.

This pass happens after:
- Learning Hub IA audit
- visible island consolidation
- copy / naming / ownership cleanup

This is a real implementation pass.
However, it must remain conservative, route-safe, localization-ready, and production-safe.

Core rule:
Do not go haywire and remove/delete records, routes, pages, content, metadata, search mappings, analytics hooks, rewards hooks, or canonical ownership for no reason.

This phase should NOT rebuild all learning content.
This phase should build a GUIDED PATH LAYER ON TOP OF existing learning content.

==================================================
PRODUCT GOAL
==================================================

The Learn experience should stop feeling like a menu of many choices and start feeling like a guided journey.

Instead of making the user decide from many categories every time, the app should let the user start a meaningful path such as:
- Foundations Path
- Salah Path
- Qur’an Beginner Path
- Daily Dhikr Path
- Character Path
- Kids Starter Path

The path system should:
- guide the user step by step
- reuse existing pages/content where possible
- track progress
- support resume
- connect naturally to existing Learn surfaces
- integrate safely with rewards / XP / Ocean Drops if practical
- remain extensible for future adaptive/personalized learning

==================================================
CRITICAL ARCHITECTURE RULES
==================================================

1. DO NOT DUPLICATE EXISTING CONTENT UNLESS ABSOLUTELY NECESSARY
- Reuse existing pages, lessons, hubs, and route targets whenever possible.
- Prefer orchestration over duplication.
- Build path metadata that points to existing destinations.

2. KEEP CURRENT ROUTES SAFE
Do not remove or break:
- `/learn`
- `/learn/legacy`
- `/learn/journey-home`
- `/learn/learning-journey`
- `/learn/explore`
- `/learn/games`
- `/learn/quizzes`
- `/learn/hub/*`
- `/learn/section/*`
- `/learn/browse`
- kids route family
- `/quran/*`

3. `/quran/*` REMAINS CANONICAL
- The Qur’an path may route into canonical Qur’an surfaces.
- Do not create a second canonical Qur’an system under Learn.

4. KIDS MUST REMAIN PRESERVED
- Kids Starter Path can exist, but must respect existing kids route family and audience-specific surfaces.
- Do not bury or weaken the kids experience.

5. PRESERVE SEARCH / INDEXING / METADATA
- Do not regress search/indexing.
- Keep stable identifiers where possible.
- Add path-layer metadata without breaking existing category metadata.

6. PRESERVE LOCALIZATION
- Any new user-facing copy must be localization-ready.
- No hardcoded user-facing strings if the codebase already uses localization.

==================================================
SCOPE FOR THIS PASS
==================================================

Build a V1 Guided Learning Paths system with:

A. Domain/data layer for learning paths
B. Progress tracking / resume support
C. Learn landing entry point for starting paths
D. Path detail / overview UI
E. Path step navigation and completion behavior
F. Safe routing into existing learning content
G. XP / Ocean Drop integration where easy and safe
H. Controlled rollout with a small set of starter paths

==================================================
REQUIRED V1 PATHS
==================================================

Implement these starter paths first:

1. Foundations Path
Purpose:
- essentials for new or returning users
Typical content:
- basics of Islam
- intro-level worship
- daily duas
- beginner core learning

2. Salah Path
Purpose:
- help users learn and build prayer understanding and practice
Typical content:
- what Salah is
- Wudu
- prayer steps
- common mistakes / prayer help
- practice-related surfaces if available

3. Qur’an Beginner Path
Purpose:
- guide users into reading, listening, reflecting, and/or memorization
Typical content:
- beginner Qur’an entry
- reading/listening
- basic reflection/meaning
- memorization starter if appropriate
Use canonical `/quran/*` surfaces where relevant.

4. Daily Dhikr Path
Purpose:
- help users build dhikr consistency
Typical content:
- intro to dhikr
- beginner adhkar/dhikr surfaces
- habit-oriented daily engagement

5. Character Path
Purpose:
- adab, patience, manners, self-improvement
Typical content:
- character-building lessons
- emotional/spiritual growth
- adab and conduct

6. Kids Starter Path
Purpose:
- simple guided entry for the kids experience
Typical content:
- age-appropriate basics
- Arabic/letters/kids learning
- story-led or beginner modules
Must preserve kids route family.

Important:
If exact content mappings are messy, do a controlled rollout.
It is better to ship 6 working starter paths with good mappings than pretend every subdomain is fully modeled.

==================================================
IMPLEMENTATION TASKS
==================================================

A. AUDIT CURRENT CONTENT TARGETS BEFORE BUILDING
Before editing:
- inspect existing Learn surfaces, route families, and content targets
- identify the safest existing destinations to use for each starter path
- prefer canonical existing pages over creating new duplicate lessons
- document path-to-route mapping clearly

B. BUILD A LEARNING PATH DOMAIN MODEL
Create a production-ready domain/application model for guided paths.

Suggested concepts:
- LearningPath
- LearningPathStep
- LearningPathStepType
- LearningPathProgress
- LearningPathStatus
- LearningPathId
- LearningPathStepId

Each path should support at minimum:
- stable id
- localized title
- localized subtitle/description
- icon/visual metadata if needed
- category/bucket metadata
- ordered steps
- recommended audience if useful
- route target / destination target per step
- completion requirements / completion hints
- optional XP / drops metadata
- optional tags (foundations, salah, quran, kids, etc.)

Each step should support:
- stable id
- title
- optional description
- route target or content target
- type (lesson, reading, reflection, quiz, practice, game, external existing page, etc.)
- completion mode
- optional estimated effort
- optional recommended order info

C. BUILD A SAFE PATH REPOSITORY / SEED SYSTEM
Implement a clean seeded path definition system.
Requirements:
- simple to extend later
- no giant hardcoded mess inside UI widgets
- path definitions should live in appropriate domain/data files
- easy to add more paths later
- easy to remap steps if routes change later

D. BUILD PATH PROGRESS TRACKING
Implement progress tracking for each path.

At minimum track:
- started / not started
- in progress / completed
- completed steps
- last active step
- last updated timestamp
- percentage progress or equivalent derived progress

Requirements:
- persist locally using existing app persistence patterns
- avoid breaking existing learning progress systems
- keep naming and ownership clean
- if existing progress helpers can be reused safely, do so

E. BUILD “START A JOURNEY” / PATH ENTRY UX
Add a guided-path entry surface near the top of `/learn`.

This should feel intentional and calm.
Possible direction:
- a “Start a Journey” section
- featured path cards
- maybe a compact carousel or stacked cards if that suits the app style
- do not clutter the page

Requirements:
- integrate naturally with existing `/learn` landing
- do not overpower “Continue Your Journey”
- preserve the simplified visible island model already established

F. BUILD PATH OVERVIEW / DETAIL UI
Create a path overview screen or equivalent surface that shows:
- path title
- short description
- progress
- ordered steps
- current/next step
- start / continue CTA
- completion state

Requirements:
- match Path of Nūr theme and layout language
- calm, guided, clean
- production-ready styling
- no placeholder visuals

G. BUILD STEP LAUNCH / ROUTE ORCHESTRATION
From a path step, the user should be able to open the existing destination page safely.

Requirements:
- use existing route targets where possible
- respect canonical owners such as `/quran/*`
- preserve route compatibility
- avoid introducing brittle route assumptions
- centralize routing logic if needed so path definitions remain maintainable

H. BUILD COMPLETION BEHAVIOR
Implement a realistic V1 completion model.

Important:
Do NOT overbuild advanced LMS logic.
V1 is allowed to be pragmatic and safe.

Acceptable V1 behavior may include:
- explicit “Mark complete” where automatic completion is not safely detectable
- automatic completion for simple known events if already easy to reuse
- “Continue” advances to next step
- path completes when all required steps are complete

Do not fake complex validation if the app does not already support it reliably.

I. RESUME / CONTINUE LOGIC
Upgrade “Continue Your Journey” logic or integrate with it so guided paths can resume cleanly.

Requirements:
- if user has an active path, surface current next step clearly
- do not break existing resume behavior if it already supports other learning flows
- if needed, merge or prioritize intelligently:
  - active guided path step
  - recent learning content
  - other journey resume states

Document how priority is decided.

J. XP / OCEAN DROP / REWARD INTEGRATION
Where safe and easy to reuse, integrate meaningful actions with existing reward hooks.

Possible V1 approach:
- starting a path may not award anything or may award minimally if existing conventions support that
- completing a step can award XP / progress if easy to reuse
- path completion can award a positive completion state and optionally drops/XP

Important:
- do not invent inflated reward logic
- do not create exploit loops
- align to existing reward patterns where possible
- preserve realism and app balance

K. KIDS PATH SAFETY
Kids Starter Path must:
- remain audience-appropriate
- point into actual kids surfaces
- not replace the kids hub
- not hide the kids route family
- work as a guided entry lane, not a takeover

L. LOCALIZATION
All new user-facing path copy must be localization-ready.

Requirements:
- add necessary translation keys
- reuse existing keys when appropriate
- update relevant locale resources
- preserve current localization structure
- if seeded paths include larger descriptions, structure them cleanly for translation

At the end, report:
- which localization keys were added
- which keys were reused
- which locale files were updated

M. CREATE DOCUMENTATION
Create a markdown implementation note such as:
docs/guided_learning_paths_v1_2026-03-31.md

Include:
- path system overview
- domain model summary
- starter path list
- path-to-route mapping summary
- progress model summary
- reward integration summary
- localization impact
- risks / follow-ups
- future extension recommendations

N. CREATE A FOLLOW-UP BACKLOG
Create a second markdown file such as:
docs/guided_learning_paths_backlog_2026-03-31.md

Include:
- adaptive/personalized paths
- Ramadan / seasonal paths
- advanced automatic completion
- richer progress analytics
- dynamic recommendations
- path difficulty levels
- content gaps discovered during mapping
- route cleanup opportunities for later
- do-not-break notes

==================================================
IMPORTANT V1 NON-GOALS
==================================================

Do NOT do these unless something already trivial exists:
- advanced AI personalization
- dynamic rule engine
- strict learning mastery scoring
- full-blown curriculum engine
- destructive route refactors
- major Qur’an internals rewrite
- deletion of old pages or legacy surfaces
- replacing all existing journey systems in one pass
- giant search/index rewrite

==================================================
VALIDATION
==================================================

Before finishing, confirm:

1. Guided Learning Paths V1 exists in a production-ready form.
2. The six starter paths exist:
   - Foundations
   - Salah
   - Qur’an Beginner
   - Daily Dhikr
   - Character
   - Kids Starter
3. Paths reuse existing content/routes where possible.
4. `/quran/*` remains canonical.
5. Kids remains preserved and discoverable.
6. Path progress persists correctly.
7. Resume / Continue logic works safely.
8. Any reward/XP/drop integration is safe and non-exploitable.
9. Existing routes remain intact.
10. Search/indexing/metadata was not regressed.
11. Localization remains intact.
12. Analyzer passes on changed files, or remaining issues are clearly explained.

==================================================
DELIVERABLES
==================================================

1. Implement Guided Learning Paths V1.
2. Create the documentation markdown file.
3. Create the backlog markdown file.
4. Return a concise but thorough summary including:
   - audit findings before changes
   - files changed
   - domain model added
   - starter paths implemented
   - which existing routes/pages each path uses
   - how progress tracking works
   - how resume works
   - how reward integration works
   - how Qur’an ownership was preserved
   - how Kids was preserved
   - localization keys added/reused
   - analyzer results
5. At the very end, audit your own implementation and provide one full summary so we can work on fixing this next.

===== END PHASE 3 PROMPT — GUIDED LEARNING PATHS SYSTEM =====
