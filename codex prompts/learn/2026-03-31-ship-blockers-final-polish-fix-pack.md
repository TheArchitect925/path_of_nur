===== PHASE 12 PROMPT — SHIP BLOCKERS & FINAL POLISH FIX PACK =====

PRIMARY OBJECTIVE === APPLY A FINAL, NARROW, HIGH-CONFIDENCE FIX PACK TO PREPARE THE LEARN SYSTEM FOR LAUNCH BY HARDENING THE CHARACTER PATH, POLISHING THE SALAH PATH ENTRY, AND VALIDATING KEY UX/ACCESSIBILITY FLOWS WITHOUT CHANGING ARCHITECTURE OR BREAKING ANY EXISTING SYSTEMS

You are working in the existing Flutter codebase for “Path of Nūr”.

This pass follows:
- Final Learn system audit (Ready with minor polish)

This is the **last pre-launch pass**.

Core rule:
Do not go haywire and remove/delete records, routes, pages, path IDs, canonical ownership, content systems, or metadata for no reason.

This pass must be:
- narrow
- safe
- high-confidence
- non-destructive

==================================================
SCOPE (STRICT)
==================================================

ONLY:

1. Character Path hardening
2. Salah Path first-step polish
3. Light manual QA fixes (if needed and safe)

DO NOT:
- touch Learn IA
- touch route ownership
- touch search/discovery
- add new features
- expand guided paths broadly
- change canonical `/quran/*`
- change kids architecture

==================================================
TASK 1 — CHARACTER PATH HARDENING
==================================================

Goal:
Make Character Path feel as strong and complete as Foundations and Dhikr.

A. Audit Character Path:
- list steps and route targets
- identify:
  - weak opening step
  - lack of progression
  - missing closure
  - overly abstract content
  - duplicated concept areas

B. Improve Structure:

Target shape:

1. What is good character (simple intro)
2. Core traits (patience, kindness, honesty)
3. Real-life application (practical examples)
4. Reflection step (very important)
5. Reinforcement (optional lightweight)
6. Clear completion meaning
7. What next → Stories or deeper Character

C. Fix Issues:
- reduce overly abstract steps
- ensure steps are grounded and relatable
- avoid jumping across unrelated traits
- add ONE reflection step if missing
- ensure final step has meaning + direction

D. Constraints:
- reuse existing content
- add minimal bridge content if needed
- do not duplicate content
- preserve path ID and progress

==================================================
TASK 2 — SALAH PATH FIRST-STEP POLISH
==================================================

Goal:
Make the FIRST step of Salah Path feel like Foundations quality.

Problem:
First step still feels too “hub-like”

A. Audit first step:
- does it drop into a hub?
- does it assume prior knowledge?
- does it overwhelm?

B. Improve entry:

Replace or wrap first step with:

- soft intro:
  - what Salah is
  - why it matters
  - reassurance for beginners

Then:
- guide into next step cleanly

C. Requirements:
- no heavy rewrite
- no deep restructuring
- minimal change, maximum clarity
- preserve downstream steps

==================================================
TASK 3 — LIGHT QA FIXES (ONLY IF SAFE)
==================================================

Perform a focused QA sweep on `/learn`:

Check:
- child profile flows
- large text / accessibility scaling
- layout breaks
- truncated text
- overflow issues
- spacing inconsistencies
- locale fallback (missing translations showing raw keys)

Fix ONLY:
- small UI bugs
- text overflow
- spacing/alignment issues
- obvious accessibility problems

DO NOT:
- redesign UI
- change layouts significantly

==================================================
CONSTRAINTS
==================================================

- No route changes
- No ownership changes
- No path ID changes
- No search changes
- No analytics changes
- No reward system changes
- No large content additions
- No system rewrites

==================================================
LOCALIZATION
==================================================

- keep all text localization-ready
- reuse keys where possible
- add minimal new keys only if needed

Report:
- keys added
- keys reused
- locale files updated

==================================================
VALIDATION
==================================================

Before finishing, confirm:

1. Character Path is now structured, relatable, and complete.
2. Character Path has a meaningful reflection step.
3. Character Path ends with clear next direction.
4. Salah Path first step is beginner-friendly and not hub-like.
5. No regressions in any guided paths.
6. `/quran/*` remains untouched and canonical.
7. Kids flows remain intact.
8. No route breakage.
9. UI issues (if found) are fixed safely.
10. Localization remains intact.
11. Analyzer passes cleanly.
12. Tests still pass.

==================================================
DELIVERABLES
==================================================

1. Implement Character Path hardening.
2. Implement Salah Path first-step polish.
3. Apply safe QA fixes (if needed).
4. Return summary including:
   - Character Path before vs after
   - Salah first-step improvement
   - QA issues found + fixed
   - files changed
   - localization impact
   - analyzer results
5. Self-audit at the end.

===== END PHASE 12 PROMPT — SHIP BLOCKERS & FINAL POLISH FIX PACK =====
