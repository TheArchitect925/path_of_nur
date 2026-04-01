# Phase 8 Prompt — Path of Nur Search, Discovery & Indexing Upgrade

```
===== PHASE 8 PROMPT — PATH OF NUR SEARCH, DISCOVERY & INDEXING UPGRADE =====

PRIMARY OBJECTIVE === BUILD A PRODUCTION-READY SEARCH, DISCOVERY, AND INDEXING SYSTEM FOR PATH OF NUR THAT HELPS USERS FIND THE RIGHT LEARNING CONTENT, GUIDED PATHS, AND NEXT STEPS QUICKLY WITHOUT BREAKING ROUTES, CANONICAL OWNERSHIP, PROGRESS, OR EXISTING CONTENT STRUCTURE

You are working in the existing Flutter codebase for “Path of Nūr”.

This pass happens after:
- Learning Hub IA audit
- visible island consolidation
- naming/copy cleanup
- Guided Learning Paths V1
- safe Learn route / alias / canonical ownership consolidation
- deep UX polish & progression clarity
- personalization & path intelligence
- curriculum/content gap audit
- Foundations Path hardening
- Daily Dhikr Path hardening
- Qur’an Beginner soft bridge
- Kids Starter Path hardening
- Stories Path creation

This is now the correct time for search/discovery because the main learning lanes and guided entry points are stronger and safer.

Core rule:
Do not go haywire and remove/delete records, routes, pages, metadata, progress models, path mappings, search contracts, canonical owners, or content for no reason.

This pass should improve:
- findability
- relevance
- confidence in navigation
- beginner discovery
- path entry from search
- related-content flow

without:
- rebuilding the whole app
- breaking canonical `/quran/*`
- breaking kids routes
- breaking guided path progress
- destabilizing metadata
- turning Learn into a technical search engine experience

==================================================
PRODUCT GOAL
==================================================

Users should be able to find the right thing by searching for:
- topic
- goal
- intention
- path
- domain
- audience
- learning type
- difficulty
- practical wording

The system should help answer:
- Where should I start?
- How do I learn prayer?
- Where is the Qur’an beginner path?
- What is good for kids?
- What helps with dhikr?
- What story-based content should I start with?
- What should I do next after this page?

Search should feel calm, helpful, and guided.

==================================================
IMPORTANT PRODUCT DIRECTION
==================================================

This is NOT just “make a search box return titles.”

This phase must support the Path of Nūr model:
- Learn is the front door
- Guided paths are a major discovery layer
- `/quran/*` is canonical Qur’an ownership
- kids route family remains preserved
- stories, worship, character, games, and foundations are discoverable as structured learning lanes
- search results should help users either:
  - open a focused destination
  - or start the right guided path

==================================================
IMPORTANT NON-GOALS
==================================================

DO NOT:
- rewrite the entire content model from scratch
- create a giant black-box ranking engine
- break `/quran/*` canonical ownership
- break kids route family
- break guided path progress
- duplicate content owners
- invent fake metadata just to fill tables
- clutter the UI with too many filters
- create a search experience that feels too technical or enterprise-like

==================================================
YOUR TASK
==================================================

1. AUDIT EXISTING SEARCH / DISCOVERY FIRST
Before editing:
- inspect current Learn search implementations
- inspect Explore/Browse/Discovery surfaces
- inspect any content indexing models or metadata already present
- inspect path definitions and whether paths are searchable
- inspect route metadata, category metadata, and any search helpers
- inspect how current search handles:
  - exact titles
  - tags
  - paths
  - kids content
  - Qur’an content
  - worship/dhikr/salah content
  - stories/character content
- inspect whether search currently lands users on broad hubs vs focused destinations

Document:
- what is already working
- what is weak
- where search is too title-based
- where discovery is shallow
- where hub-heavy results may still overwhelm beginners

2. BUILD A LEARNING SEARCH / DISCOVERY INDEX MODEL
Create or improve a production-ready search/discovery metadata layer.

Suggested concepts:
- SearchableLearningItem
- LearningSearchIndexEntry
- LearningDiscoveryTag
- LearningDomain
- LearningAudience
- LearningDifficulty
- LearningContentType
- DiscoveryIntent
- RelatedContentHint

Each indexable item should support where practical:
- stable id
- title
- subtitle/summary
- route target
- canonical owner
- domain
- topic tags
- audience
- difficulty
- type
- related path ids
- recommended “start here” hint
- optional related domains
- optional priority/weight hint

Content types may include:
- guided path
- path step
- lesson/page
- beginner bridge
- story entry
- quiz/game destination
- practice surface
- reflection
- utility/tool where appropriate
- curated hub only when necessary

Important:
- keep the model additive
- reuse existing metadata when possible
- do not destabilize stable ids or path ownership
- prefer focused searchable items over giant vague hubs

3. MAKE GUIDED PATHS FIRST-CLASS DISCOVERY ITEMS
Search and discovery must treat guided paths as real destinations.

At minimum ensure strong discoverability for:
- Foundations Path
- Salah Path
- Qur’an Beginner Path
- Daily Dhikr Path
- Character Path
- Kids Starter Path
- Stories Path

Requirements:
- searching “start islam” or “basics” can surface Foundations
- searching “how to pray” can surface Salah Path
- searching “start quran” can surface Qur’an Beginner Path
- searching “daily dhikr” can surface Daily Dhikr Path
- searching “kids islam” or “kids arabic” can surface Kids Starter Path
- searching “prophets” or “stories” can surface Stories Path

Path results should not suppress direct lesson/page results entirely.
They should complement them.

4. IMPROVE RELEVANCE BEYOND EXACT TITLES
Search should match:
- topic words
- synonyms
- related concepts
- practical user language
- beginner intent
- path intent

Examples:
- “prayer” should find Salah-related learning, wudu, prayer help, and Salah Path
- “dua” may surface beginner supplication learning and relevant dhikr-related content where appropriate
- “dhikr” should find Daily Dhikr Path and beginner dhikr learning, not just a tool
- “quran” should find canonical Qur’an entry points and the Qur’an Beginner Path
- “stories” should find Prophets/Seerah/Stories Path
- “manners” or “patience” should find Character-related content
- “kids letters” should find kids Arabic/tracing and Kids Starter Path
- “quiz” or “game” should find Games surfaces and reinforcement activities

Do this with safe, explainable matching.
Simple lexical + tag + intent matching is enough.
Do not build a magical opaque ranker.

5. ADD CALM, MINIMAL FILTERS WHERE THEY HELP
Implement a light filter/facet model for search/discovery surfaces where useful.

Suggested filters:
- Domain:
  - Foundations
  - Qur’an
  - Worship
  - Character
  - Stories
  - Games
- Audience:
  - Beginner
  - Kids
  - General
- Type:
  - Path
  - Lesson
  - Practice
  - Reflection
  - Quiz
  - Tool
- Difficulty:
  - Start Here
  - Growing
  - Deeper

Requirements:
- do not clutter the primary Learn landing
- filters should live in the search/discovery flow, not everywhere
- keep the default experience simple
- avoid showing every filter unless it meaningfully narrows results

6. CREATE BETTER RESULT BUCKETING / PRESENTATION
Search results should be grouped intelligently where useful.

Possible result clusters:
- Best next match
- Guided paths
- Lessons and pages
- Kids results
- Related content

Requirements:
- avoid a flat overwhelming wall
- make the top result feel intentional
- preserve calm visual hierarchy
- allow direct launch into route targets safely

7. MAKE DISCOVERY BEGINNER-SAFE
Search should not constantly send beginners into broad multi-purpose hubs unless necessary.

Requirements:
- prefer focused destinations when possible
- if a hub must be used, ensure it is clearly labeled
- prioritize beginner bridges and curated entries where they exist
- Foundations, Qur’an Beginner, Daily Dhikr, and Kids Starter should be especially easy to discover

8. IMPROVE EXPLORE / DISCOVERY SURFACES
Upgrade Explore/Browse so it feels curated, not like a leftover dump.

Possible improvements:
- Start Here section
- Guided Paths section
- Kids section
- Stories section
- Practice & Worship section
- Tools separated lower
- beginner-friendly grouping
- related-content grouping

Important:
- Explore should support discovery
- not compete with the simplified Learn landing
- not become another cluttered second front door

9. ADD RELATED CONTENT / “YOU MAY ALSO WANT” LOGIC
Where practical, add lightweight related discovery for learning destinations and/or search results.

Examples:
- Foundations → Salah Path / Qur’an Beginner Path
- Salah → Daily Dhikr / Worship support
- Daily Dhikr → Character Path
- Stories → Character Path / Qur’an reflection tie-ins
- Kids Arabic → Kids stories / kids duas
- Qur’an Beginner → canonical Qur’an entry / reflection / listening

Keep it:
- subtle
- contextual
- non-spammy
- easy to maintain

10. PROTECT CANONICAL OWNERSHIP
Critical:
- `/quran/*` remains canonical
- search results for Qur’an should route into canonical Qur’an destinations
- Learn/search may recommend Qur’an, but must not create duplicate Qur’an ownership
- kids route family remains preserved and discoverable
- search should respect the ownership model from prior phases

11. PRESERVE GUIDED PATHS / PERSONALIZATION / PROGRESS
Ensure:
- search can safely start paths
- search can safely open current path steps where appropriate
- no breakage to guided path progress
- recommendation/personalization signals stay intact
- search does not create conflicting progress owners

If path-to-route resolution needs centralization for safety, do it cleanly.

12. PRESERVE SEARCH PERFORMANCE
Ensure:
- on-device performance remains smooth
- indexing is lightweight
- result generation is efficient
- no heavy recomputation every frame
- offline-first behavior remains intact
- providers/selectors/memoization are used where appropriate

13. PRESERVE LOCALIZATION
All new user-facing search/discovery text must be localization-ready.

Requirements:
- do not hardcode new user-facing strings if localization exists
- reuse keys where safe
- add only necessary new keys
- update relevant locale files/resources
- preserve current localization structure

At the end, report:
- which keys were added
- which keys were reused
- which locale files were updated

14. ADD OR UPDATE TESTS WHERE PRACTICAL
Where low-risk and useful, add/update tests for:
- index building
- path results appearing for key queries
- canonical Qur’an routing behavior
- kids result safety
- filter behavior
- absence of obvious regressions in search result launching

Do not overbuild a giant test suite, but add meaningful coverage where core discovery logic changes.

15. DOCUMENTATION
Create:
docs/search_discovery_indexing_upgrade_2026-03-31.md

Include:
- executive summary
- audit findings before changes
- search/discovery model changes
- metadata/index structure
- path-aware discovery behavior
- filters/facets added
- result bucketing behavior
- related-content behavior
- beginner-safety choices
- Qur’an ownership notes
- Kids discoverability notes
- performance notes
- localization impact
- test impact
- follow-up opportunities

16. FOLLOW-UP BACKLOG
Create:
docs/search_discovery_backlog_2026-03-31.md

Include:
- synonym expansion improvements
- better summaries/snippets
- analytics-based ranking refinement
- family-aware or profile-aware discovery
- seasonal discovery surfaces
- stronger related-content graph
- path-aware search personalization
- telemetry needs
- do-not-break notes

==================================================
VALIDATION
==================================================

Before finishing, confirm:

1. Search/discovery is improved in a production-ready way.
2. Search can find content beyond exact page titles.
3. Guided paths are first-class searchable results.
4. Minimal filters/facets work where implemented.
5. Search results are grouped/presented clearly.
6. Beginner-safe discovery is improved.
7. Related-content discovery exists where practical.
8. `/quran/*` remains canonical in discovery behavior.
9. kids route family remains safe and discoverable.
10. guided path progress is not broken.
11. personalization signals are not broken.
12. search/indexing performance remains smooth.
13. localization remains intact.
14. analyzer passes on changed files, or remaining issues are clearly explained.

==================================================
DELIVERABLES
==================================================

1. Implement the Search, Discovery & Indexing Upgrade.
2. Create the documentation markdown file.
3. Create the backlog markdown file.
4. Return a concise but thorough summary including:
   - audit findings before changes
   - files changed
   - search/index model added or improved
   - guided path discoverability improvements
   - filters/facets added
   - relevance improvements
   - result bucketing/presentation behavior
   - related-content behavior
   - how `/quran/*` ownership was preserved
   - how Kids was preserved
   - localization keys added/reused
   - performance impact
   - test impact
   - analyzer results
5. At the very end, audit your own implementation and provide one full summary so we can work on fixing this next.

===== END PHASE 8 PROMPT — PATH OF NUR SEARCH, DISCOVERY & INDEXING UPGRADE =====
```
