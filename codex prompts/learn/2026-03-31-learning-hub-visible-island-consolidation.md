# Phase 1 Prompt — Learning Hub Visible Island Consolidation

PRIMARY OBJECTIVE === BUILD THE SIMPLIFIED VISIBLE LEARNING HUB LANDING WITHOUT BREAKING EXISTING ROUTES, PAGES, SEARCH, KIDS FLOWS, OR QURAN OWNERSHIP

You are working in the existing Flutter codebase for “Path of Nūr”.

This pass is implementation-focused, but must remain conservative and production-safe.

Read and use these audit artifacts first:
- docs/learning_hub_ia_audit_2026-03-31.md
- docs/learning_hub_ia_restructure_backlog_2026-03-31.md

Core rule:
Do not go haywire and remove or delete records, routes, pages, aliases, content, metadata, or navigation for no reason.

This pass is NOT a broad Learn rewrite.
This pass is ONLY for simplifying the visible `/learn` landing so the user sees a calmer, more guided set of main islands.

==================================================
SCOPE FOR THIS PASS
==================================================

Implement a safer, simplified visible Learn landing that:

TOP SECTION
1. Continue Your Journey
2. Daily Learning

MAIN VISIBLE ISLANDS
3. Foundations
4. Qur’an
5. Worship
6. Character
7. Stories
8. Games

SECONDARY
9. Explore All

Important:
- Keep all existing routes alive
- Keep compatibility aliases intact
- Do not delete legacy pages in this pass
- Do not perform destructive cleanup in this pass
- Do not replatform the whole Learn area
- Do not create a second canonical Qur’an owner inside Learn

==================================================
OWNERSHIP RULES
==================================================

1. `/learn` remains the calm primary learning front door.

2. `/quran/*` remains the canonical Qur’an owner.
   - The visible Qur’an island on `/learn` should route users into the canonical Qur’an experience or the best curated entry point to it.
   - Do not duplicate full Qur’an hub ownership under Learn if `/quran/*` is already the stronger canonical route family.

3. Kids must remain preserved and discoverable.
   - Do not bury or orphan kids flows.
   - Kids can remain a distinct route family and/or featured cross-link.
   - In this pass, if Kids is not one of the six main visible islands, it must still remain visibly discoverable from Learn in a safe and intentional way, such as a featured audience card, cross-link, or Explore entry.
   - Preserve existing kids route family and route reachability.

4. Explore All should absorb secondary and lower-priority top-level clutter such as:
   - FAQ
   - Notes
   - Tools
   - extra browse surfaces
   - lower-priority discovery surfaces
   - legacy/library-style entry points where appropriate

==================================================
IMPLEMENTATION TASKS
==================================================

A. AUDIT CURRENT LEARN LANDING IMPLEMENTATION BEFORE EDITING
- Inspect the current `/learn` landing implementation and related models/widgets.
- Confirm which widgets/cards currently render the top section and visible islands.
- Identify which existing cards can be reused or adapted safely.

B. UPDATE THE VISIBLE `/learn` LANDING HIERARCHY
Refactor the visible Learn landing so the main user-facing structure becomes:

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

C. MAP EXISTING CONTENT INTO THE NEW VISIBLE GROUPING
Use the audit docs to map existing content safely into the new visible grouping.

Expected grouping logic:
- Foundations
  - basics of Islam
  - prayer basics / how to pray
  - daily duas
  - intro-level core learning
- Qur’an
  - route into canonical Qur’an surfaces
  - reading / meaning / memorization / reflections where appropriate
- Worship
  - salah deep dive
  - dhikr / adhkar
  - fasting
  - zakat / charity
  - practice-oriented worship content
- Character
  - adab
  - manners
  - self-improvement
  - spiritual development
  - emotional resilience / character-building content
- Stories
  - prophets
  - seerah
  - Islamic history
  - story-driven learning
- Games
  - quizzes
  - trivia
  - challenges
  - word search / matching / crossword where applicable
- Explore All
  - FAQ
  - Notes
  - Tools
  - legacy browse
  - lower-priority or cross-cutting pages

D. KEEP EXISTING ROUTES SAFE
- Do not remove:
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
- Preserve any aliases or redirects already supporting compatibility.
- If the visible Learn landing changes destination targets, do so carefully and document it.

E. PRESERVE SEARCH / INDEXING / METADATA
- Do not regress Learn search/indexing.
- Preserve category metadata, lookup metadata, and content discoverability.
- If the visual grouping changes but underlying targets remain the same, maintain stable metadata contracts.

F. PRESERVE LOCALIZATION
- Any new or revised user-facing labels must be localization-ready.
- Do not hardcode new user-facing strings if the project uses localization.
- Add only necessary new localization keys.
- Update relevant locale resources only where needed.
- Preserve existing translations.

G. PRESERVE THEME / VISUAL CONSISTENCY
- Keep the calm Path of Nūr look and feel.
- Preserve shared surface patterns, island card styling, and spacing rhythm.
- Keep the landing simpler, not emptier.
- Avoid clutter and equal-weight overload.

H. KIDS DISCOVERABILITY SAFETY
- Ensure kids remains easy to find.
- Do not reduce kids to a hidden dead-end.
- If Kids is moved out of main top-level visible islands, add a safe visible discovery method on `/learn` or a strong Explore placement.
- Document exactly where Kids remains surfaced.

I. DO NOT DO IN THIS PASS
- Do not delete old hub pages
- Do not remove legacy routes
- Do not re-architect the entire Learn route tree
- Do not merge multiple page implementations destructively
- Do not do a giant search rewrite
- Do not refactor unrelated Qur’an internals
- Do not remove notes/tools/history/glossary/family/constellation-type pages
- Do not flatten nuanced features without preserving access

==================================================
VALIDATION
==================================================

Before finishing, confirm:

1. `/learn` now shows the simplified visible hierarchy.
2. Continue Your Journey remains visible.
3. Daily Learning remains visible.
4. Main visible islands are:
   - Foundations
   - Qur’an
   - Worship
   - Character
   - Stories
   - Games
5. Explore All exists and safely absorbs lower-priority clutter.
6. Kids remains discoverable and route-safe.
7. `/quran/*` remains canonical and not duplicated improperly.
8. Existing routes and aliases still resolve safely.
9. Learn search/indexing was not regressed.
10. Localization remains intact.
11. Analyzer passes on changed files or any remaining issues are clearly explained.

==================================================
DELIVERABLES
==================================================

1. Implement the visible Learn landing consolidation.
2. Update only the necessary files.
3. Create a concise implementation summary including:
   - files changed
   - visible grouping changes made
   - where Kids now surfaces
   - how Qur’an ownership was handled
   - what routes were preserved
   - what localization keys were added/updated
   - analyzer results
4. At the very end, audit your own implementation and provide one full summary so we can use that for the next pass.

===== END PHASE 1 PROMPT — LEARNING HUB VISIBLE ISLAND CONSOLIDATION =====
