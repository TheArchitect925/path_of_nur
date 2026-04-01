===== PHASE 7.2 PROMPT — DAILY DHIKR PATH HARDENING =====

PRIMARY OBJECTIVE === TRANSFORM THE DAILY DHIKR PATH FROM A TOOL-FIRST FLOW INTO A BEGINNER-FRIENDLY, MEANING-FIRST, HABIT-BUILDING JOURNEY WITHOUT BREAKING EXISTING ROUTES, DHIKR UTILITIES, OR REWARD SYSTEMS

You are working in the existing Flutter codebase for “Path of Nūr”.

This pass follows:
- Phase 7.1 Foundations Path hardening

This is a **focused curriculum hardening pass**.
Do NOT expand scope beyond the Daily Dhikr Path.

Core rule:
Do not go haywire and remove/delete records, routes, pages, dhikr utilities, counters, content, metadata, or reward hooks for no reason.

==================================================
PRODUCT GOAL
==================================================

The Daily Dhikr Path should:
- teach what dhikr is
- explain why it matters
- make it easy to start
- build a habit gradually
- then introduce the dhikr tool naturally

Right now the issue is:
- path feels tool-first
- drops user into dhikr counter/utility too early
- lacks emotional/spiritual framing
- lacks gradual habit-building structure

==================================================
CORE PRINCIPLES
==================================================

- Meaning before mechanics
- Small before large
- Habit before volume
- Guidance before tools
- Calm before complexity

==================================================
SCOPE FOR THIS PASS
==================================================

ONLY:
- Daily Dhikr Path

Do NOT:
- change dhikr utilities deeply
- rebuild the dhikr counter system
- restructure other paths
- change Learn IA
- touch search/discovery
- remove existing dhikr content

==================================================
IMPLEMENTATION TASKS
==================================================

A. AUDIT CURRENT DAILY DHIKR PATH
Before editing:
- locate the Daily Dhikr Path definition
- list current steps and route targets

Identify:
- where the path jumps directly into tools
- steps that lack explanation
- missing beginner framing
- lack of progression (e.g., 0 → full routine)
- steps that feel like utilities, not learning

Document:
- current sequence
- weak vs acceptable steps

B. DEFINE A BETTER DHIKR LEARNING FLOW

Target conceptual structure:

1. What is Dhikr?
   - simple, calming explanation
   - what it means to remember Allah

2. Why Dhikr matters
   - emotional/spiritual value
   - short and relatable

3. Start small (very important)
   - e.g., simple phrases
   - very low barrier
   - no overwhelm

4. First guided practice
   - short dhikr set
   - controlled entry (not full tool exposure)

5. Build a daily habit
   - consistency over quantity
   - simple guidance

6. Introduce Dhikr tool (NOW)
   - explain how to use it
   - connect to habit

7. What next?
   - continue habit
   - link to:
     - Character Path
     - Salah Path
     - deeper Dhikr usage

Important:
- adapt to existing content
- do NOT force new content unless needed

C. REDUCE TOOL-FIRST BEHAVIOR

For any step that:
- opens dhikr counter immediately
- exposes full tool UI early

Adjust so that:
- tool comes AFTER understanding
- first exposure is guided and intentional

If necessary:
- wrap tool entry with a contextual explanation step

D. ADD ONE SMALL BRIDGE IF NEEDED

If current content is insufficient:
Create ONE small bridge step:

Example:
- “Let’s begin with something simple”

Requirements:
- very short
- calming tone
- not a placeholder
- localization-ready

Do NOT create multiple new lessons.

E. ENSURE HABIT PROGRESSION

The path must:
- start very small
- avoid overwhelming numbers
- encourage consistency

Avoid:
- pushing full daily routines too early
- complex setups at the start

F. FIX FINAL HANDOFF

The last step must:
- clearly guide next actions

Examples:
- Continue daily dhikr
- Explore Character Path
- Continue Salah Path

No dead ends.

G. PRESERVE DHIKR TOOL SYSTEM

Important:
- do not modify core dhikr counter logic unless trivial
- do not break existing usage patterns
- do not change reward triggers unless safe

This phase changes HOW users reach the tool, not the tool itself.

H. PRESERVE REWARD / OCEAN INTEGRATION

Where already supported:
- dhikr actions should still contribute to drops/XP
- do not create exploit loops
- do not inflate rewards

I. PRESERVE ROUTES

Do not change:
- dhikr routes
- Learn routes
- path IDs
- route ownership

J. PRESERVE PATH PROGRESS

- do not break existing progress
- handle step reordering carefully
- preserve completed steps where possible

K. LOCALIZATION

All new/updated text must:
- use localization system
- reuse keys if possible
- add minimal new keys if needed

Report:
- keys added
- keys reused
- locale files updated

L. UX CONSISTENCY

Ensure:
- progression clarity remains
- completion feedback still works
- no UI clutter introduced

M. DOCUMENTATION

Create:
docs/daily_dhikr_path_hardening_2026-03-31.md

Include:
- before vs after flow
- step-by-step changes
- how tool-first issue was fixed
- any new bridge step
- habit progression logic
- risks and follow-ups

==================================================
VALIDATION
==================================================

Before finishing, confirm:

1. Daily Dhikr Path is meaning-first, not tool-first.
2. Early steps explain dhikr clearly.
3. User is not overwhelmed early.
4. Dhikr tool appears at the right time.
5. Path builds a simple habit.
6. Final step has clear next direction.
7. Existing dhikr tools remain intact.
8. Rewards/drops still work correctly.
9. Routes are unchanged.
10. Progress is preserved.
11. Localization is intact.
12. Analyzer passes or issues are explained.

==================================================
DELIVERABLES
==================================================

1. Implement Daily Dhikr Path hardening.
2. Create documentation file.
3. Return summary including:
   - audit findings
   - old vs new sequence
   - steps adjusted
   - bridge content added
   - tool-first issue resolution
   - habit progression changes
   - localization impact
   - analyzer results
4. Self-audit at the end.

===== END PHASE 7.2 PROMPT — DAILY DHIKR PATH HARDENING =====
