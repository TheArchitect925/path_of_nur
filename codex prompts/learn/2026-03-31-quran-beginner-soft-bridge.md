===== PHASE 7.3 PROMPT — QUR’AN BEGINNER SOFT BRIDGE =====

PRIMARY OBJECTIVE === ADD A CALM, BEGINNER-FRIENDLY “SOFT ENTRY” INTO THE QUR’AN EXPERIENCE THAT REDUCES INTIMIDATION AND CREATES A SMOOTH HANDOFF INTO CANONICAL `/quran/*` SURFACES WITHOUT DUPLICATING OWNERSHIP OR BREAKING ROUTES

You are working in the existing Flutter codebase for “Path of Nūr”.

This pass follows:
- Phase 7.1 Foundations Path hardening
- Phase 7.2 Daily Dhikr Path hardening

This is a **focused, minimal curriculum enhancement pass**.

Core rule:
Do not go haywire and remove/delete records, routes, pages, Qur’an features, audio systems, playback logic, or canonical ownership for no reason.

==================================================
PRODUCT GOAL
==================================================

Many users hesitate to open the Qur’an because:
- they feel unprepared
- they don’t know where to start
- they feel it’s too complex or too serious to “just begin”

The goal of this phase is to introduce:

👉 a **soft, welcoming entry step**
that:
- removes fear
- sets expectations
- gives permission to start small
- gently guides into real Qur’an usage

WITHOUT:
- duplicating the Qur’an reader system
- creating a second Qur’an hub
- breaking `/quran/*` canonical ownership

==================================================
CORE PRINCIPLES
==================================================

- Emotional safety before depth
- Permission before instruction
- Simplicity before structure
- Gentle guidance before navigation
- Qur’an remains central, not abstracted

==================================================
SCOPE FOR THIS PASS
==================================================

ONLY:
- Qur’an Beginner Path soft bridge

Do NOT:
- rebuild Qur’an reader
- modify playback systems deeply
- restructure `/quran/*`
- change route ownership
- rewrite tafsir or content systems
- touch search/discovery
- modify other paths

==================================================
IMPLEMENTATION TASKS
==================================================

A. AUDIT CURRENT QUR’AN BEGINNER ENTRY

Before editing:
- locate Qur’an Beginner Path definition
- list current steps and route targets

Identify:
- where users are dropped directly into `/quran/*`
- whether the first step feels abrupt
- missing emotional/contextual onboarding
- whether the first interaction assumes familiarity
- whether the path jumps too quickly into reading/memorization

Document:
- current flow
- where the experience feels intimidating or abrupt

==================================================
B. DESIGN THE SOFT BRIDGE STEP

Create ONE lightweight, high-quality entry step.

Purpose:
- reduce hesitation
- explain simply:
  - what the Qur’an is (in a very accessible tone)
  - that it is okay to start small
  - that understanding grows over time
- remove pressure

Tone:
- calm
- welcoming
- non-technical
- non-judgmental

Avoid:
- heavy theology
- long explanations
- academic language
- complex UI

Possible structure:
- short intro
- 1–2 key ideas
- gentle CTA:
  → “Let’s begin”

==================================================
C. ADD THE BRIDGE INTO THE PATH

Update Qur’an Beginner Path so that:

Old:
User → directly enters Qur’an surface

New:
User → Soft Bridge → curated entry into `/quran/*`

Requirements:
- the bridge must be the first step (or immediately after a minimal intro)
- path progression must remain intact
- no duplication of existing steps

==================================================
D. CURATE THE FIRST QUR’AN ENTRY POINT

Do NOT just drop users into a generic Qur’an screen.

Instead:
- choose a calm, appropriate starting entry
- this may be:
  - a short surah
  - a guided reading entry
  - a resume-safe reader entry
  - or an existing curated surface

Requirements:
- must use canonical `/quran/*`
- must not create a parallel Qur’an system under Learn
- must feel intentional, not random

==================================================
E. KEEP QUR’AN OWNERSHIP CANONICAL

Critical:
- `/quran/*` remains the owner
- Learn path only guides into it
- do not replicate reader, tafsir, playback, or navigation under Learn
- avoid any UI or route duplication

==================================================
F. OPTIONAL: ADD A “HOW TO USE THIS” MICRO-HINT

If needed and safe:
- add a very small hint before entering Qur’an

Example:
- “You can read, listen, or just reflect — start at your pace”

Keep it:
- minimal
- non-intrusive

==================================================
G. PRESERVE PROGRESS & PATH STATE

- do not break existing path progress
- handle step insertion carefully
- ensure completed users are not reset
- maintain step IDs where possible
- if new step is added, handle default state safely

==================================================
H. PRESERVE QUR’AN SYSTEM INTEGRITY

Do NOT:
- modify playback controller deeply
- break “follow ayah” logic
- break resume logic
- break mini player
- change audio stack

This phase is about ENTRY, not core Qur’an systems.

==================================================
I. LOCALIZATION

All new text must:
- use localization system
- reuse keys where possible
- add minimal new keys if needed

Report:
- keys added
- keys reused
- locale files updated

==================================================
J. UX CONSISTENCY

Ensure:
- matches Path of Nūr tone
- aligns with Phase 5 UX polish
- not visually heavy
- not a modal overload
- integrates smoothly into path flow

==================================================
K. DOCUMENTATION

Create:
docs/quran_beginner_soft_bridge_2026-03-31.md

Include:
- before vs after flow
- reasoning for bridge
- entry point chosen
- how canonical ownership was preserved
- risks and follow-ups

==================================================
VALIDATION
==================================================

Before finishing, confirm:

1. Qur’an Beginner Path now starts with a soft bridge.
2. Entry no longer feels abrupt.
3. Users are not dropped cold into `/quran/*`.
4. The bridge is simple, calm, and beginner-friendly.
5. Qur’an entry point is curated and intentional.
6. `/quran/*` remains canonical.
7. No duplication of Qur’an systems was introduced.
8. Existing progress is preserved.
9. Localization is intact.
10. Analyzer passes or issues are explained.

==================================================
DELIVERABLES
==================================================

1. Implement Qur’an Beginner soft bridge.
2. Create documentation file.
3. Return summary including:
   - audit findings
   - old vs new flow
   - bridge content added
   - entry point used
   - how abruptness was reduced
   - how ownership was preserved
   - localization impact
   - analyzer results
4. Self-audit at the end.

===== END PHASE 7.3 PROMPT — QUR’AN BEGINNER SOFT BRIDGE =====
