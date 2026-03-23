===== PHASE CONTEXT PROMPT — MAIN UNDERSTANDING BEFORE NAVIGATION FIXES =====

PRIMARY OBJECTIVE === BUILDING A CONTROLLED, SAFE NAVIGATION CLEANUP FOR PATH OF NŪR

You are working in the existing Path of Nūr codebase.

This prompt is NOT the implementation prompt.
This is the MAIN UNDERSTANDING / DECISION CONTEXT prompt that must govern all later fix phases.

Read this carefully and treat it as the source of truth for later navigation work.

========================================================
CORE UNDERSTANDING
========================================================

The app is functional, but navigation ownership and flow consistency are messy in a few key areas.

This is NOT a full rebuild.
This is a controlled cleanup.

The goal is:
1. preserve the stable 5-tab shell
2. fix clearly broken routes first
3. clarify ownership before cleanup
4. avoid deleting, collapsing, or repurposing pages too early
5. separate route integrity fixes from product-architecture decisions

The user wants to manually review structure and decisions before broader rewiring happens.

Therefore:
- route integrity comes first
- canonical ownership comes second
- front-door cleanup comes third
- child-mode normalization comes later
- label cleanup comes after ownership is stable
- alias trimming happens last

========================================================
WHAT IS ALREADY UNDERSTOOD
========================================================

The current system is broadly coherent, but these are the main problem areas:

A. QUR’AN
- Qur’an is mostly under `/quran*`
- one confirmed broken route exists for Reflections
- older Learn-owned Qur’an aliases still coexist
- ownership should be clarified as Qur’an-owned, while preserving compatibility

B. LEARN
- Learn has multiple competing front doors
- `/learn` is the strongest canonical candidate
- `/learn/explore` is a useful secondary discovery page
- `/learn/browse` behaves like a live page but is likely only an alias/compatibility path
- journey-related Learn pages overlap and need a later decision

C. KIDS
- Kids flows are functional but fragmented
- child profiles currently bypass the normal Learn landing
- canonical Kids home is not yet fully approved
- do not restructure Kids IA without approval

D. JOURNEY / GARDEN
- Journey home is broadly solid
- Garden is reachable but terminal
- “Browse All” on Journey home is currently a label/destination mismatch
- do not redesign Garden yet; only later add onward actions after approval

E. WORSHIP / DEEP LINKS
- Worship routing is broadly good
- prayer and dhikr deep links are too coarse and should land on their real subpages

========================================================
APPROVED HIGH-LEVEL OWNERSHIP MODEL
========================================================

Unless explicitly changed later, treat this as the canonical ownership direction:

- `/home*` owns Home
- `/worship*` owns Worship
- `/learn*` owns Learn
- `/quran*` owns Qur’an
- `/journey*` owns Journey
- `/settings*` owns Settings/Profile

Important:
- `/quran*` is the sole canonical Qur’an owner
- older Learn-owned Qur’an routes may remain temporarily for compatibility
- compatibility does NOT mean shared ownership

========================================================
APPROVED STABLE DECISIONS
========================================================

These are already safe assumptions for near-term fix work:

1. Keep the 5-tab shell as-is.
2. Keep `/learn` as the strongest canonical Learn front door candidate.
3. Keep `/learn/explore` as a valid secondary discovery page.
4. Treat `/learn/browse` as likely compatibility-only, not a true parallel owner.
5. Add a canonical routed destination for `QuranReflectionsPage` under the Qur’an namespace.
6. `pathofnur://prayer` should resolve to `/worship/prayer`.
7. `pathofnur://dhikr` should resolve to `/worship/dhikr`.
8. Preserve compatibility aliases during transition.
9. Convert aliases to redirects before removal.
10. Do not collapse feature surfaces unless explicitly approved.

========================================================
OPEN DECISIONS — DO NOT AUTO-DECIDE
========================================================

These are NOT approved yet and must not be silently changed:

1. Whether `LearningJourneyIslandHubPage` and `LearningJourneyHomePage` both stay
2. Which exact page becomes the canonical Kids home
3. Whether Qur’an “Memorize” should continue mapping to `quranWordReview`
4. Whether Journey “Browse All” should be relabeled or remapped
5. What onward actions Garden should expose
6. When old Growth/Journey alias families should be fully removed

If later prompts do not explicitly approve one of these, leave them alone.

========================================================
NON-GOALS / DO NOT DO
========================================================

Do NOT:
- delete pages for no reason
- remove legacy routes in the same pass as route rewiring
- merge Learn pages unless explicitly approved
- redesign Kids information architecture without approval
- change child-profile visibility or safety rules without approval
- repurpose UI labels until destination decisions are approved
- broadly rename routes or pages unless explicitly approved
- rebuild unrelated UI
- clean up layout consistency during route-integrity work
- remove compatibility aliases before redirect behavior is in place

========================================================
FIX ORDER THAT MUST BE RESPECTED
========================================================

PHASE A — ROUTE INTEGRITY
- repair broken named routes
- repair broken deep links
- keep everything else stable

PHASE B — CANONICAL OWNERSHIP
- formalize `/quran*` ownership
- formalize Learn canonical front door
- preserve aliases safely

PHASE C — FRONT-DOOR CLEANUP
- distinguish canonical entry pages from secondary discovery surfaces
- reduce parallel front doors

PHASE D — CHILD-FLOW NORMALIZATION
- only after Kids home and child Learn behavior are approved

PHASE E — LABEL / DESTINATION CLEANUP
- only after route ownership is stable

PHASE F — TERMINAL PAGE CLEANUP
- add onward navigation to Garden and similar pages only after approval

PHASE G — ALIAS TRIMMING
- convert live aliases to redirects
- preserve compatibility window
- remove later, not immediately

========================================================
SAFE IMPLEMENTATION GUARDRAILS
========================================================

For any future fix phase:

- audit first before editing
- change only files relevant to the scoped fix
- preserve state/data behavior
- preserve working routes
- keep backward compatibility where practical
- add tests for changed routing behavior
- document what was intentionally not changed
- if a route has unique behavior, do not flatten it without approval
- if an alias is still externally referenced, redirect first before any removal

========================================================
HOW TO THINK ABOUT THIS APP
========================================================

Treat this as:
- a stable shell
- with messy ownership in a few feature families
- requiring controlled navigation hardening
- not a greenfield rewrite

When uncertain:
- prefer preserving behavior
- prefer redirect over deletion
- prefer canonical ownership with compatibility
- prefer review-first over architectural guessing

========================================================
REQUIRED BEHAVIOR IN LATER PROMPTS
========================================================

When later asked to implement fixes:
- obey the approved ownership model
- obey the fix order
- do not widen scope
- do not “clean up” extra things just because they look old
- do not remove records/routes/pages without explicit approval
- clearly separate:
  - what was fixed
  - what was deferred
  - what still needs manual approval

========================================================
FINAL INSTRUCTION
========================================================

Use this understanding as the governing context for all later navigation, routing, ownership, and page-structure work in Path of Nūr.

Do not implement anything from this prompt alone.
This is a context-lock prompt.

===== END =====
