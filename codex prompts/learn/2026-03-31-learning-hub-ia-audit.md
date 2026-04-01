# Phase Audit — Learning Hub Information Architecture / Islands / Page Mapping

PRIMARY OBJECTIVE === AUDIT THE CURRENT PATH OF NUR LEARNING HUB, MAIN ISLANDS, SUBPAGES, ROUTES, ENTRY POINTS, AND CONTENT GROUPING AGAINST THE TARGET SIMPLIFIED LEARNING STRUCTURE.

You are working in the existing Flutter codebase for “Path of Nūr”.

This is an AUDIT-FIRST PASS.
Do not start with a blind redesign.
Do not delete, collapse, rename, move, or rewrite major structures until the full audit is complete.
Do not remove or break existing pages, routes, deep links, tracking hooks, localization wiring, or navigation aliases without explicitly identifying them first.

Critical safety rules:
- Do not go haywire and remove/delete records, routes, content, pages, or code for no reason.
- Preserve everything that already exists until it has been inventoried and mapped.
- This pass is primarily for discovery, gap analysis, and a safe recommended restructuring plan.
- If light non-destructive helper files are needed for the audit output, that is acceptable.
- No placeholder summaries. Produce a real, thorough audit.

Context:
The Learning Hub has grown and may now feel overwhelming because too many categories and pages appear to have equal weight.
We want to compare the current implementation to a calmer, more guided target structure.

Target proposed structure to audit against:

TOP LEVEL LEARNING HUB EXPERIENCE
1. Continue Your Journey
2. Daily Learning
3. Main Journeys / Main Islands:
   - Foundations
   - Qur’an
   - Worship
   - Character
   - Stories
   - Games
4. Secondary / lower-priority:
   - Explore All

INTENDED GROUPING PHILOSOPHY
- Hide complexity by default
- Reduce the number of equal-weight choices on the main Learning Hub
- Group related content under a smaller number of main journeys
- Preserve already-built content by nesting or re-homing it safely
- Avoid duplicate front doors to the same content
- Prefer guided pathing over flat category overload

Example intended grouping logic:
- Foundations
  - Basics of Islam
  - How to Pray
  - Daily Duas
  - Intro to Qur’an
- Qur’an
  - Reading
  - Tafsir / Meaning
  - Memorization
  - Reflections
- Worship
  - Salah deep dive
  - Dhikr / Adhkar
  - Fasting
  - Zakat / Charity
- Character
  - Adab
  - Manners
  - Self-improvement
  - Emotional / spiritual growth
- Stories
  - Prophets
  - Seerah
  - Islamic history
  - Story-based learning
- Games
  - Quizzes
  - Challenges
  - Crossword / word search / matching
- Explore All
  - Tools
  - Rarely used pages
  - Experimental / lower-priority browse surfaces

YOUR TASK

1. AUDIT THE CURRENT LEARNING HUB
Inspect all relevant files, widgets, models, route definitions, navigation helpers, shell destinations, island cards, section groupings, and page entry points related to:
- Learn / Learning Hub
- Learning journeys
- Qur’an learning pages
- Kids learning
- Arabic / letters / tracing / language learning
- Salah learning / prayer training
- Hadith / dua / reflections / stories / seerah / prophets
- Games / quizzes / challenges
- Explore / browse / category pages
- Any legacy aliases or alternate learning front doors
- Any home page cards or cross-links that route into learning surfaces

2. INVENTORY EVERYTHING
Produce a comprehensive inventory of:
- every current main learning island / category
- every learning-related page
- every known learning route / deep link / alias
- every duplicate entry point to the same destination
- every “hub page” versus “content page”
- every orphaned or weakly connected page
- every category that is only reachable indirectly
- every category/page that appears in multiple places

3. IDENTIFY CURRENT INFORMATION ARCHITECTURE
Determine:
- what the current primary top-level learning choices are
- what the current secondary/subcategory choices are
- which categories are visually competing at the same level
- where the current experience may overwhelm the user
- where the same concept appears under multiple names
- where the hierarchy is unclear or inconsistent

4. MAP CURRENT STRUCTURE AGAINST THE TARGET STRUCTURE
For every current learning page/category, map it to one of:
- Foundations
- Qur’an
- Worship
- Character
- Stories
- Games
- Explore All
- Needs a new bucket
- Unclear / ambiguous / cross-cutting

For each mapping, explain:
- why it belongs there
- whether it should be a main island, subpage, module, or cross-link
- whether it is currently placed well or misplaced

5. FIND GAPS AND COLLISIONS
Explicitly identify:
- duplicate hubs
- duplicate browse surfaces
- inconsistent naming
- pages with overlapping purpose
- routes that suggest one hierarchy while UI suggests another
- content that should be merged conceptually but not deleted physically yet
- places where already-built content may be missed during a future restructure
- pages that do not clearly belong anywhere
- routes that should remain as compatibility aliases even if UI hierarchy changes

6. ASSESS “CLOSENESS” TO THE TARGET
Give a realistic assessment of how close the current implementation already is to the intended model:
- overall percentage estimate
- what is already aligned
- what partially aligns
- what conflicts strongly
- what is missing
- what can be re-grouped without major rewrites
- what likely needs a deeper redesign

7. PROPOSE A SAFE RESTRUCTURE PLAN
After the audit, propose a production-safe restructuring plan in phases.

The plan must:
- preserve all existing pages
- avoid losing any already built content
- avoid route breakage
- avoid destructive moves early
- preserve localization
- preserve existing analytics/progress/reward hooks where possible
- preserve compatibility redirects / aliases where appropriate

The plan should include:
PHASE A: inventory and route safety
PHASE B: main island consolidation
PHASE C: subpage regrouping
PHASE D: explore/browse cleanup
PHASE E: copy and naming cleanup
PHASE F: optional guided path enhancements

8. CREATE AN AUDIT OUTPUT FILE
Create a markdown audit document in the repo docs folder with a clear name such as:
docs/learning_hub_ia_audit_2026-03-31.md

The audit doc must include:
- executive summary
- current-state inventory
- current route inventory
- duplicate/overlap findings
- mapping table: current page -> proposed bucket
- closeness assessment
- risks
- safe phased restructure plan
- recommended final target hierarchy

9. CREATE A FOLLOW-UP IMPLEMENTATION BACKLOG
Also create a second markdown file such as:
docs/learning_hub_ia_restructure_backlog_2026-03-31.md

This should contain:
- specific implementation tasks
- grouped by phase
- risk level
- dependencies
- recommended order
- “do not break” notes
- route compatibility notes
- localization impact notes

10. VALIDATION
Before finishing:
- confirm all relevant learning routes/pages were scanned
- confirm kids and Qur’an-related learning surfaces were included, not just the main Learn page
- confirm duplicate entry points were identified
- confirm no destructive cleanup was performed
- confirm the audit includes enough detail that a future codex pass can implement safely without missing built pages

OUTPUT FORMAT REQUIRED AT THE END
Return a concise but thorough summary with:
1. Audit findings
2. Current main learning islands/pages found
3. Duplicate or overlapping entry points
4. Closeness to proposed structure
5. Biggest risks in restructuring
6. Files created
7. Recommended next implementation pass

IMPORTANT IMPLEMENTATION CONSTRAINTS
- Audit first before editing
- Prefer read-only analysis unless a small helper artifact is needed
- Do not delete existing pages
- Do not remove legacy routes unless explicitly documented and replaced safely
- Do not flatten nuanced content into vague buckets without documenting where it went
- Preserve production readiness
- Preserve theme and app architecture
- Preserve localization readiness
- At the very end, audit your own audit and provide one full summary so we can work on fixing this next

===== END PHASE AUDIT =====
