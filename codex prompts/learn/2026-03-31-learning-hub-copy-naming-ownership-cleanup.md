===== PHASE 2 PROMPT — LEARNING HUB COPY / NAMING / OWNERSHIP CLEANUP =====

PRIMARY OBJECTIVE === CLEAN UP LEARNING HUB LABELS, TITLES, DESCRIPTIONS, CARD COPY, AND ROUTE-FACING OWNERSHIP LANGUAGE SO THE EXPERIENCE FEELS CONSISTENT, CALM, AND GUIDED WITHOUT BREAKING EXISTING ROUTES OR CONTENT

You are working in the existing Flutter codebase for “Path of Nūr”.

This pass happens after the visible island consolidation audit/implementation work.
This is NOT a destructive route refactor.
This is a production-safe naming and copy cleanup pass.

Read and use these first if they exist:
- docs/learning_hub_ia_audit_2026-03-31.md
- docs/learning_hub_ia_restructure_backlog_2026-03-31.md
- any implementation summary from the prior visible landing consolidation pass

Core rule:
Do not go haywire and remove or delete records, routes, pages, aliases, metadata, search mappings, or content for no reason.

==================================================
GOALS
==================================================

The Learning Hub should feel like one guided system.

Right now, likely problems include:
- inconsistent island names
- overlapping domain labels
- multiple phrases for similar concepts
- route ownership language that implies duplicate systems
- “games / quizzes / trivia / challenges” not feeling unified
- “Qur’an & Hadith” or other grouped labels competing with the simplified top-level model
- older labels like legacy/journey/browse/hub/section all coexisting visibly

This pass should make the visible experience cleaner and more understandable while preserving the underlying architecture.

==================================================
TARGET VISIBLE LANGUAGE MODEL
==================================================

Top:
- Continue Your Journey
- Daily Learning

Main visible islands:
- Foundations
- Qur’an
- Worship
- Character
- Stories
- Games

Secondary:
- Explore All

Guidance:
- Use these as the primary visible user-facing category labels on `/learn`
- Preserve canonical Qur’an ownership under `/quran/*`
- Keep Kids discoverable, but do not let it re-fragment the top-level naming system
- Keep Explore as the place for secondary or cross-cutting surfaces

==================================================
YOUR TASK
==================================================

1. AUDIT CURRENT VISIBLE COPY
Inspect all relevant Learn-facing text used in:
- `/learn` landing
- Learn island cards
- journey landing cards
- category labels
- supporting subtitles/descriptions
- section headers
- CTA labels
- chips/badges if used
- visible cross-links into games, kids, stories, worship, Qur’an, and explore
- any “browse all”, “journey”, “legacy”, “hub”, “section”, or “learning journey” labels that the user still sees

Identify:
- inconsistent names
- overlapping names
- visible labels that imply duplicate ownership
- labels that are too broad, too technical, or too library-like
- labels that compete with the simplified island model

2. DEFINE A CLEAN VISIBLE NAMING SYSTEM
Standardize the visible top-level Learn naming around:
- Foundations
- Qur’an
- Worship
- Character
- Stories
- Games
- Explore All

Create a clear recommendation for each currently visible label:
- keep as-is
- rename
- demote to sublabel
- move into Explore
- keep for compatibility but hide from primary UI

3. CLEAN UP CARD TITLES AND SUBTITLES
For the visible Learn landing and its immediate supporting cards:
- simplify titles
- reduce jargon
- reduce duplicate concept words
- make subtitles short and calm
- keep the tone spiritually warm, simple, and inviting
- avoid clutter and over-explaining
- keep copy production-ready, not placeholder

Examples of direction:
- Foundations → “Start with the essentials”
- Qur’an → “Read, reflect, and grow with the Qur’an”
- Worship → “Build your daily practice”
- Character → “Grow in adab, patience, and self-improvement”
- Stories → “Learn through prophets, seerah, and history”
- Games → “Play, review, and remember”
- Explore All → “Browse tools, notes, and more”

Do not force these exact lines if the codebase already has better-aligned wording, but use this tone and clarity.

4. CLARIFY QUR’AN OWNERSHIP LANGUAGE
Ensure visible Learn copy does not imply that Learn now owns the full Qur’an system if `/quran/*` is canonical.

Requirements:
- the Learn Qur’an island should feel like a guided entry point, not a duplicate owner
- visible labels/subtitles should support this
- avoid copy that suggests there are two separate Qur’an hubs

5. UNIFY GAMES / QUIZZES / TRIVIA LANGUAGE
Audit all visible wording around:
- Games
- Quizzes
- Trivia
- Challenges
- Crossword
- Matching
- Word Search

Create a consistent visible system where:
- Games is the main top-level visible owner
- quizzes/trivia/challenges are subtypes or destinations under Games
- avoid multiple equal-weight visible labels competing on the main Learn surface

6. HANDLE KIDS LANGUAGE CAREFULLY
Kids is real and should remain easy to discover, but should not re-fragment the simplified main island system.

Requirements:
- preserve kids discoverability
- keep kids wording warm and clear
- if Kids remains a featured card/cross-link, make sure its naming fits the simplified Learn language model
- avoid making Kids feel hidden or accidental

7. CLEAN UP LEGACY / JOURNEY / BROWSE LANGUAGE
Audit visible labels like:
- Legacy Learning
- Learning Journey
- Journey Home
- Browse All
- Hub
- Section
- Explore
- Learning Library

Goal:
- reduce how many of these are visible in the primary experience
- keep compatibility if needed under the hood
- align visible naming to the calmer simplified model

8. PRESERVE LOCALIZATION
Any visible text changes must be localization-ready.

Requirements:
- do not hardcode user-facing strings if the project uses localization
- add only necessary localization keys
- reuse existing keys when safe
- update all relevant locale resources used by the project
- preserve current translation structure and loading
- do not break localization wiring

At the end, report:
- which keys were added
- which keys were reused
- which locale files were updated

9. PRESERVE SEARCH / INDEXING / METADATA
Do not break:
- search indexing
- category metadata
- route metadata
- analytics hooks
- lookup keys that depend on existing category identifiers

Visible labels may change, but stable identifiers should remain intact unless absolutely necessary.
If any identifier must change, document it carefully and provide compatibility handling.

10. KEEP ROUTES SAFE
Do not remove:
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

This pass is about naming and visible ownership language, not route deletion.

11. CREATE A SMALL COPY DECISION RECORD
Create a markdown file such as:
docs/learning_hub_copy_cleanup_2026-03-31.md

Include:
- before/after naming decisions
- top-level naming model
- subtitle/copy decisions
- Qur’an ownership wording guidance
- Games wording guidance
- Kids wording guidance
- notes on preserved internal identifiers
- localization impact
- risks/follow-ups

==================================================
VALIDATION
==================================================

Before finishing, confirm:
1. visible top-level Learn language now matches the simplified model
2. card titles/subtitles are calmer and more consistent
3. Qur’an wording does not imply duplicate ownership
4. Games/quizzes/trivia wording is unified
5. Kids remains discoverable
6. legacy/journey/browse wording is reduced in primary UI where appropriate
7. localization is intact
8. search/indexing/metadata was not regressed
9. existing routes remain safe
10. analyzer passes on changed files or remaining issues are clearly explained

==================================================
DELIVERABLES
==================================================

1. Implement the visible copy/naming cleanup.
2. Create the copy decision markdown file.
3. Return a concise but thorough summary with:
   - audit findings
   - before/after naming improvements
   - files changed
   - localization keys added/reused
   - how Qur’an ownership wording was handled
   - how Games wording was unified
   - how Kids remains surfaced
   - analyzer results
4. At the very end, audit your own implementation and provide one full summary so we can use that for the next pass.

===== END PHASE 2 PROMPT — LEARNING HUB COPY / NAMING / OWNERSHIP CLEANUP =====
