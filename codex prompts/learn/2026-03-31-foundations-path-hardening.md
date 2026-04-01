===== PHASE 7.1 PROMPT — FOUNDATIONS PATH HARDENING =====

PRIMARY OBJECTIVE === HARDEN THE FOUNDATIONS PATH INTO A TRUE BEGINNER-SAFE, GUIDED, STEP-BY-STEP ENTRY INTO ISLAMIC LEARNING WITHOUT BREAKING EXISTING ROUTES, CONTENT OWNERSHIP, OR LEARN ARCHITECTURE

You are working in the existing Flutter codebase for “Path of Nūr”.

This pass is the FIRST execution step after the Phase 7 curriculum audit.

This is a **narrow, high-impact pass**.
Do NOT expand scope beyond Foundations Path.

Core rule:
Do not go haywire and remove/delete records, routes, pages, content, metadata, path ids, search mappings, or canonical ownership for no reason.

==================================================
PRODUCT GOAL
==================================================

The Foundations Path must become:

- the safest place for a complete beginner to start
- calm, clear, and structured
- step-by-step (not hub-first)
- free from overwhelm
- logically progressing into the rest of the app

Right now, the problem is:
- too many hubs
- too many “start here” options
- weak sequencing
- missing soft beginner bridge

This pass should fix that without rebuilding the entire domain.

==================================================
CORE PRINCIPLES
==================================================

- Start small → then expand
- Teach before linking
- Reduce choice early
- Avoid dumping users into large hubs
- Prefer guided steps over broad navigation
- Reuse existing content wherever possible
- Add only minimal new bridge content if required

==================================================
SCOPE FOR THIS PASS
==================================================

ONLY focus on:
- Foundations Path

Do NOT:
- change other paths yet
- restructure Learn IA again
- rewrite Qur’an flows
- change route ownership
- touch search/discovery
- remove legacy content

==================================================
IMPLEMENTATION TASKS
==================================================

A. AUDIT CURRENT FOUNDATIONS PATH IMPLEMENTATION
Before editing:
- locate the Foundations Path definition
- list current steps and route targets
- identify:
  - steps that point to hubs
  - steps that assume prior knowledge
  - duplicate “start here” entry points
  - missing transitions
  - steps that feel too broad

Document:
- current step sequence
- issues per step
- which steps are acceptable vs weak

B. DEFINE A CLEAN BEGINNER FLOW
Redesign the Foundations Path sequence into a clearer progression.

Target structure (conceptual, adapt to actual codebase):

1. Welcome / What is this journey
   - very soft entry
   - what the user will learn
   - no heavy navigation

2. What is Islam (simple intro)
   - short, clear, beginner-friendly

3. Core beliefs (very simplified)
   - no deep theology yet
   - high-level understanding

4. Why we pray / connection to Salah
   - emotional + purpose layer

5. Introduction to Salah (not full deep dive)
   - prepares user for Salah Path

6. Daily connection (intro to Dhikr / Dua)
   - not tool-first
   - meaning-first

7. What next?
   - guide user into:
     - Salah Path OR
     - Qur’an Beginner Path OR
     - Daily Dhikr Path

Important:
- this is a STRUCTURAL target, not a strict template
- adapt based on existing content availability

C. REDUCE HUB-FIRST STEPS
For each current Foundations step:

If it points to:
- a large hub page
- a multi-purpose index
- a browse screen

Then:
- replace with a more focused entry point if available
OR
- wrap it with a guiding step (see section D)

Goal:
- user should not land in a “wall of options” too early

D. ADD ONE TRUE BEGINNER BRIDGE (IF NEEDED)
If there is no suitable existing content for a soft start:

Create ONE small bridge step:
- simple
- calm
- text-first or lightweight content
- explains:
  - what this journey is
  - how to use the app
  - what to expect next

Requirements:
- production-ready
- localization-ready
- not a placeholder
- reusable if possible

Do NOT create multiple new lessons.

E. ENSURE EACH STEP HAS A CLEAR PURPOSE
For each step:
- define what the user should understand after it
- ensure it prepares for the next step

Avoid:
- steps that are just “open this page”
- steps that feel like navigation rather than learning

F. FIX “WHAT NEXT” HANDOFF
The final Foundations step must clearly guide the user forward.

Implement:
- a clear “Next Paths” recommendation
- likely options:
  - Salah Path
  - Qur’an Beginner Path
  - Daily Dhikr Path

Requirements:
- no dead end
- no confusion
- do not auto-start another path silently
- allow user to choose

G. PRESERVE ROUTES & CANONICAL OWNERSHIP
Important:
- do not change route paths
- do not remove routes
- do not break `/quran/*`
- do not create duplicate Qur’an ownership under Learn
- reuse existing route targets safely

H. PRESERVE PATH IDS & PROGRESS
- do not change existing path IDs unless absolutely necessary
- do not break existing user progress
- if steps are reordered, handle mapping carefully
- preserve completed steps where possible

I. LOCALIZATION
All new or updated user-facing text must be localization-ready.

Requirements:
- do not hardcode strings if localization exists
- reuse keys where possible
- add minimal new keys if required
- update locale files properly

At the end, report:
- keys added
- keys reused
- locale files updated

J. KEEP UX CONSISTENT WITH PHASE 5
Ensure:
- progression clarity remains strong
- step highlighting still works
- completion feedback still works
- no UI clutter introduced

K. DOCUMENTATION
Create:
docs/foundations_path_hardening_2026-03-31.md

Include:
- before vs after step structure
- reasoning for each step change
- any new bridge content
- mapping to existing routes
- risks and follow-ups

==================================================
VALIDATION
==================================================

Before finishing, confirm:

1. Foundations Path is now step-by-step and beginner-safe.
2. Early steps do not drop users into large hubs.
3. A soft beginner entry exists.
4. Each step has a clear purpose.
5. The path ends with a clear “what next” transition.
6. Existing routes are preserved.
7. `/quran/*` remains canonical.
8. Path progress is not broken.
9. Localization is intact.
10. UI remains clean and calm.
11. Analyzer passes or issues are clearly explained.

==================================================
DELIVERABLES
==================================================

1. Implement Foundations Path hardening.
2. Create the documentation file.
3. Return a concise summary including:
   - audit findings before changes
   - old vs new step sequence
   - steps replaced or adjusted
   - any new bridge content added
   - how hub-first issues were reduced
   - how “what next” is handled
   - localization keys added/reused
   - analyzer results
4. At the end, audit your own implementation and provide one full summary for the next pass.

===== END PHASE 7.1 PROMPT — FOUNDATIONS PATH HARDENING =====
